import 'package:clerk_auth/clerk_auth.dart' as clerk;
import 'package:clerk_flutter/clerk_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/config/auth_config.dart';
import '../../../../core/config/clerk_config.dart';

class ClerkAuthService {
  ClerkAuthService(this._authState);

  final ClerkAuthState _authState;

  bool get isSignedIn => _authState.isSignedIn;

  clerk.User? get currentUser => _authState.user;

  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String fullName,
  }) async {
    _ensureConfigured();
    debugPrint(
      '[auth][signup] creating Clerk account for email=${email.trim()}',
    );

    final names = _splitName(fullName);
    final strategy = _authState.env.supportsEmailCode
        ? clerk.Strategy.emailCode
        : clerk.Strategy.password;

    await _authState.resetClient();
    await _authState.attemptSignUp(
      strategy: strategy,
      emailAddress: email.trim(),
      password: password,
      passwordConfirmation: password,
      firstName: names.firstName,
      lastName: names.lastName,
      legalAccepted: true,
    );

    if (_authState.isSignedIn) return;

    final signUp = _authState.signUp;
    if (signUp?.isVerifying(clerk.Strategy.emailCode) == true ||
        signUp?.unverified(clerk.Field.emailAddress) == true) {
      throw const ClerkEmailVerificationRequired();
    }

    throw ClerkAuthFailure(
      'Account created, but Clerk needs one more verification step.',
    );
  }

  Future<void> verifyEmailCode({required String code}) async {
    _ensureConfigured();
    debugPrint('[auth][email_verify] verifying code');

    await _authState.attemptSignUp(
      strategy: clerk.Strategy.emailCode,
      code: code.trim(),
    );

    if (!_authState.isSignedIn) {
      throw ClerkEmailVerificationFailure(
        'Please check the verification code and try again.',
      );
    }
  }

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    _ensureConfigured();
    debugPrint('[auth][email_login] attempting sign-in email=${email.trim()}');

    await _authState.resetClient();
    await _authState.attemptSignIn(
      strategy: clerk.Strategy.password,
      identifier: email.trim(),
      password: password,
    );

    if (!_authState.isSignedIn) {
      throw ClerkEmailLoginFailure('Invalid email or password.');
    }
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    _ensureConfigured();
    final redirectUri = clerkRedirectUriFor(
      context,
      clerk.Strategy.oauthGoogle,
    );
    debugPrint('[auth][google] starting Clerk OAuth redirect=$redirectUri');

    try {
      await _authState.resetClient();
      await _authState.oauthSignIn(
        strategy: clerk.Strategy.oauthGoogle,
        redirect: redirectUri,
      );

      final verificationUrl = _authState
          .client
          .signIn
          ?.firstFactorVerification
          ?.externalVerificationRedirectUrl;
      if (verificationUrl == null || verificationUrl.trim().isEmpty) {
        throw ClerkGoogleAuthFailure(
          'Google sign-in could not start. Check the Clerk Google connection and redirect URL.',
        );
      }

      final launched = await launchUrl(
        Uri.parse(verificationUrl),
        mode: LaunchMode.externalApplication,
      );
      if (!launched) {
        throw ClerkGoogleAuthFailure(
          'Could not open the browser for Google sign-in.',
        );
      }

      debugPrint('[auth][google] browser launched');
    } on clerk.ClerkError catch (error) {
      debugPrint('[auth][google] Clerk OAuth failed error=$error');
      throw ClerkGoogleAuthFailure(
        'Google sign-in failed. Check the Clerk Google connection and redirect URL.',
      );
    } catch (error) {
      debugPrint('[auth][google] unexpected OAuth failure error=$error');
      if (error is ClerkGoogleAuthFailure) {
        rethrow;
      }
      throw ClerkGoogleAuthFailure(
        'Google sign-in failed. Check the Clerk Google connection and redirect URL.',
      );
    }
  }

  Future<void> signOut() async {
    await _authState.signOut();
  }

  Future<void> syncOnboardingProfileToClerk({
    String? fullName,
    required DateTime birthday,
    required String gender,
    required String country,
    required Set<String> selectedInterests,
  }) async {
    if (!_authState.isSignedIn) return;

    final names = _splitName(fullName ?? '');
    await _authState.updateUser(
      firstName: names.firstName,
      lastName: names.lastName,
      metadata: {
        'birthday': birthday.toIso8601String(),
        'gender': gender,
        'country': country,
        'selectedInterests': selectedInterests.toList(),
      },
    );
  }

  void _ensureConfigured() {
    if (!isClerkConfigured) {
      throw ClerkAuthFailure(
        'Clerk is not configured. Run with --dart-define=CLERK_PUBLISHABLE_KEY=your_key_here.',
      );
    }
  }

  _NameParts _splitName(String fullName) {
    final parts = fullName.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) {
      return const _NameParts(firstName: null, lastName: null);
    }

    if (parts.length == 1) {
      return _NameParts(firstName: parts.first, lastName: null);
    }

    return _NameParts(
      firstName: parts.first,
      lastName: parts.skip(1).join(' '),
    );
  }
}

class ClerkEmailVerificationRequired implements Exception {
  const ClerkEmailVerificationRequired();
}

class ClerkEmailVerificationFailure implements Exception {
  ClerkEmailVerificationFailure(this.message);

  final String message;
}

class ClerkEmailLoginFailure implements Exception {
  ClerkEmailLoginFailure(this.message);

  final String message;
}

class ClerkGoogleAuthFailure implements Exception {
  ClerkGoogleAuthFailure(this.message);

  final String message;
}

class ClerkAuthFailure implements Exception {
  ClerkAuthFailure(this.message);

  final String message;
}

enum AuthErrorFlow { generic, signup, emailLogin, emailVerification, google }

String friendlyClerkError(
  Object error, {
  AuthErrorFlow flow = AuthErrorFlow.generic,
}) {
  debugPrint('Clerk auth error: $error');

  if (error is ClerkAuthFailure) return error.message;
  if (error is ClerkEmailLoginFailure) return error.message;
  if (error is ClerkGoogleAuthFailure) return error.message;
  if (error is ClerkEmailVerificationRequired) {
    return 'Check your email for the verification code.';
  }
  if (error is ClerkEmailVerificationFailure) {
    return error.message;
  }
  if (error is clerk.ClerkError) {
    return _friendlyMessage(error.toString(), flow: flow);
  }

  return _friendlyMessage(error.toString(), flow: flow);
}

String _friendlyMessage(String raw, {required AuthErrorFlow flow}) {
  final message = raw.toLowerCase();

  if (flow == AuthErrorFlow.google) {
    if (message.contains('network') || message.contains('socket')) {
      return 'Please check your connection and try again.';
    }
    if (message.contains('cancel')) {
      return 'Google sign-in was cancelled.';
    }
    if (message.contains('browser') || message.contains('launch')) {
      return 'Could not open the browser for Google sign-in.';
    }
    return 'Google sign-in failed. Check the Clerk Google connection and redirect URL.';
  }
  if (flow == AuthErrorFlow.emailVerification) {
    return 'Please check the verification code and try again.';
  }
  if (flow == AuthErrorFlow.emailLogin &&
      (message.contains('identifier') ||
          message.contains('not found') ||
          message.contains('password') ||
          message.contains('invalid'))) {
    return 'Invalid email or password.';
  }
  if (message.contains('invalid') && message.contains('email')) {
    return 'Please enter a valid email address.';
  }
  if (message.contains('password') && message.contains('incorrect')) {
    return 'That password does not look right.';
  }
  if (message.contains('identifier') || message.contains('not found')) {
    return 'We could not find an account with those details.';
  }
  if (message.contains('already') || message.contains('exists')) {
    return 'An account with this email already exists. Try logging in.';
  }
  if (message.contains('password')) {
    return 'Please use a stronger password.';
  }
  if (message.contains('network') || message.contains('socket')) {
    return 'Please check your connection and try again.';
  }
  if (message.contains('verification') || message.contains('code')) {
    return flow == AuthErrorFlow.signup
        ? 'Check your email for the verification code.'
        : 'Something went wrong with authentication. Please try again.';
  }

  return 'Something went wrong with authentication. Please try again.';
}

class _NameParts {
  const _NameParts({required this.firstName, required this.lastName});

  final String? firstName;
  final String? lastName;
}
