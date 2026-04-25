import 'package:clerk_auth/clerk_auth.dart' as clerk;
import 'package:clerk_flutter/clerk_flutter.dart';
import 'package:flutter/widgets.dart';

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

    await _authState.attemptSignUp(
      strategy: clerk.Strategy.emailCode,
      code: code.trim(),
    );

    if (!_authState.isSignedIn) {
      throw ClerkAuthFailure('That code did not finish verification.');
    }
  }

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    _ensureConfigured();

    await _authState.resetClient();
    await _authState.attemptSignIn(
      strategy: clerk.Strategy.password,
      identifier: email.trim(),
      password: password,
    );

    if (!_authState.isSignedIn) {
      throw ClerkAuthFailure('We could not finish signing you in.');
    }
  }

  Future<void> signInWithGoogle([BuildContext? context]) async {
    _ensureConfigured();
    _ensureGoogleOauthConfigured();

    if (context == null) {
      throw ClerkAuthFailure(
        'Google sign-in needs Clerk OAuth setup to finish in-app.',
      );
    }

    if (!_authState.env.oauthStrategies.contains(clerk.Strategy.oauthGoogle)) {
      throw ClerkAuthFailure(
        'Enable Google OAuth in your Clerk dashboard for this app.',
      );
    }

    await _authState.ssoSignIn(context, clerk.Strategy.oauthGoogle);
    if (!_authState.isSignedIn) {
      throw ClerkAuthFailure(
        'Google sign-in did not finish. Check the Clerk Google OAuth setup.',
      );
    }
  }

  Future<void> signOut() async {
    await _authState.signOut();
  }

  Future<void> syncOnboardingProfileToClerk({
    required DateTime birthday,
    required String gender,
    required String country,
    required Set<String> selectedInterests,
  }) async {
    if (!_authState.isSignedIn) return;

    await _authState.updateUser(
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

  void _ensureGoogleOauthConfigured() {
    if (!isClerkGoogleOauthConfigured) {
      throw ClerkAuthFailure(
        'Google OAuth is not configured for Clerk in this app yet.',
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

class ClerkAuthFailure implements Exception {
  ClerkAuthFailure(this.message);

  final String message;
}

String friendlyClerkError(Object error) {
  debugPrint('Clerk auth error: $error');

  if (error is ClerkAuthFailure) return error.message;
  if (error is ClerkEmailVerificationRequired) {
    return 'Check your email for the verification code.';
  }
  if (error is clerk.ClerkError) {
    return _friendlyMessage(error.toString());
  }

  return _friendlyMessage(error.toString());
}

String _friendlyMessage(String raw) {
  final message = raw.toLowerCase();

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
    return 'Please check the verification code and try again.';
  }

  return 'Something went wrong with authentication. Please try again.';
}

class _NameParts {
  const _NameParts({required this.firstName, required this.lastName});

  final String? firstName;
  final String? lastName;
}
