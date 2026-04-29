import 'package:clerk_auth/clerk_auth.dart' as clerk;
import 'package:clerk_flutter/clerk_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'clerk_user_profile_seed.dart';
import '../data/services/clerk_auth_service.dart';

final clerkAuthStateProvider = Provider<ClerkAuthState?>((ref) => null);

final clerkAuthServiceProvider =
    Provider.family<ClerkAuthService, ClerkAuthState>((ref, authState) {
      return ClerkAuthService(authState);
    });

final authSessionProvider =
    Provider.family<AuthSessionSnapshot, ClerkAuthState>((ref, authState) {
      return AuthSessionSnapshot(
        isSignedIn: authState.isSignedIn,
        user: authState.user,
      );
    });

final currentUserProvider = Provider.family<clerk.User?, ClerkAuthState>((
  ref,
  authState,
) {
  return _resolveClerkUser(authState);
});

final currentClerkUserProvider = Provider<clerk.User?>((ref) {
  final authState = ref.watch(clerkAuthStateProvider);
  final user = authState == null ? null : _resolveClerkUser(authState);
  debugPrint(
    '[auth] currentClerkUserProvider isSignedIn=${authState?.isSignedIn} directUser=${authState?.user?.id ?? ''} sessions=${authState?.client.sessions.length ?? 0} resolvedUser=${user?.id ?? ''}',
  );
  return user;
}, dependencies: [clerkAuthStateProvider]);

final currentUserProfileSeedProvider = Provider<ClerkUserProfileSeed?>((ref) {
  final user = ref.watch(currentClerkUserProvider);
  if (user == null) return null;
  return deriveClerkUserProfileSeed(user);
}, dependencies: [currentClerkUserProvider]);

final currentUserIdProvider = Provider<String?>(
  (ref) {
    final directUserId = ref.watch(currentClerkUserProvider)?.id;
    if (directUserId != null && directUserId.trim().isNotEmpty) {
      debugPrint(
        '[auth] currentUserIdProvider resolved from user=$directUserId',
      );
      return directUserId;
    }

    final authState = ref.watch(clerkAuthStateProvider);
    final sessionUserIds =
        authState?.client.userIds.toList(growable: false) ?? const <String>[];
    if (sessionUserIds.isNotEmpty) {
      final fallbackUserId = sessionUserIds.first.trim();
      if (fallbackUserId.isNotEmpty) {
        debugPrint(
          '[auth] currentUserIdProvider recovered from client.userIds=$fallbackUserId',
        );
        return fallbackUserId;
      }
    }

    debugPrint(
      '[auth] currentUserIdProvider unresolved isSignedIn=${authState?.isSignedIn} sessions=${authState?.client.sessions.length ?? 0}',
    );
    return null;
  },
  dependencies: [
    currentClerkUserProvider,
    clerkAuthStateProvider,
    currentUserProfileSeedProvider,
  ],
);

final currentUserEmailProvider = Provider<String?>((ref) {
  return ref.watch(currentUserProfileSeedProvider)?.email;
}, dependencies: [currentUserProfileSeedProvider]);

final authActionProvider =
    StateNotifierProvider.autoDispose<AuthActionController, AuthActionState>((
      ref,
    ) {
      return AuthActionController();
    });

class AuthSessionSnapshot {
  const AuthSessionSnapshot({required this.isSignedIn, required this.user});

  final bool isSignedIn;
  final clerk.User? user;
}

class AuthActionState {
  const AuthActionState({
    this.emailLoginLoading = false,
    this.signupLoading = false,
    this.googleLoading = false,
    this.verificationLoading = false,
    this.emailLoginError,
    this.signupError,
    this.googleError,
    this.verificationError,
  });

  final bool emailLoginLoading;
  final bool signupLoading;
  final bool googleLoading;
  final bool verificationLoading;
  final String? emailLoginError;
  final String? signupError;
  final String? googleError;
  final String? verificationError;

  bool get isLoading =>
      emailLoginLoading ||
      signupLoading ||
      googleLoading ||
      verificationLoading;
  String? get error =>
      googleError ?? verificationError ?? emailLoginError ?? signupError;

  AuthActionState copyWith({
    bool? emailLoginLoading,
    bool? signupLoading,
    bool? googleLoading,
    bool? verificationLoading,
    String? emailLoginError,
    String? signupError,
    String? googleError,
    String? verificationError,
  }) {
    return AuthActionState(
      emailLoginLoading: emailLoginLoading ?? this.emailLoginLoading,
      signupLoading: signupLoading ?? this.signupLoading,
      googleLoading: googleLoading ?? this.googleLoading,
      verificationLoading: verificationLoading ?? this.verificationLoading,
      emailLoginError: emailLoginError ?? this.emailLoginError,
      signupError: signupError ?? this.signupError,
      googleError: googleError ?? this.googleError,
      verificationError: verificationError ?? this.verificationError,
    );
  }
}

class AuthActionController extends StateNotifier<AuthActionState> {
  AuthActionController() : super(const AuthActionState());

  Future<bool> run(Future<void> Function() action) async {
    if (state.isLoading) return false;

    state = const AuthActionState(signupLoading: true);
    try {
      await action();
      state = const AuthActionState();
      return true;
    } catch (error) {
      state = AuthActionState(
        signupError: friendlyClerkError(error, flow: AuthErrorFlow.generic),
      );
      return false;
    }
  }

  Future<bool> runGoogle(Future<void> Function() action) async {
    if (state.isLoading) return false;
    state = const AuthActionState(googleLoading: true);
    try {
      await action();
      state = const AuthActionState();
      return true;
    } catch (error) {
      state = AuthActionState(
        googleError: friendlyClerkError(error, flow: AuthErrorFlow.google),
      );
      return false;
    }
  }

  Future<bool> runEmailLogin(Future<void> Function() action) async {
    if (state.isLoading) return false;
    state = const AuthActionState(emailLoginLoading: true);
    try {
      await action();
      state = const AuthActionState();
      return true;
    } catch (error) {
      state = AuthActionState(
        emailLoginError: friendlyClerkError(
          error,
          flow: AuthErrorFlow.emailLogin,
        ),
      );
      return false;
    }
  }

  Future<bool> runSignup(Future<void> Function() action) async {
    if (state.isLoading) return false;
    state = const AuthActionState(signupLoading: true);
    try {
      await action();
      state = const AuthActionState();
      return true;
    } catch (error) {
      state = AuthActionState(
        signupError: friendlyClerkError(error, flow: AuthErrorFlow.signup),
      );
      return false;
    }
  }

  Future<bool> runVerification(Future<void> Function() action) async {
    if (state.isLoading) return false;
    state = const AuthActionState(verificationLoading: true);
    try {
      await action();
      state = const AuthActionState();
      return true;
    } catch (error) {
      state = AuthActionState(
        verificationError: friendlyClerkError(
          error,
          flow: AuthErrorFlow.emailVerification,
        ),
      );
      return false;
    }
  }

  void clearError() {
    state = const AuthActionState();
  }
}

clerk.User? _resolveClerkUser(ClerkAuthState authState) {
  final direct = authState.user;
  if (direct != null) {
    return direct;
  }

  final clientUser = authState.client.user;
  if (clientUser != null) {
    return clientUser;
  }

  for (final session in authState.client.sessions) {
    return session.user;
  }

  return null;
}
