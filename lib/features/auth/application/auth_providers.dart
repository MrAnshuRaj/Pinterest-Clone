import 'package:clerk_auth/clerk_auth.dart' as clerk;
import 'package:clerk_flutter/clerk_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/services/clerk_auth_service.dart';

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
  return authState.user;
});

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
  const AuthActionState({this.isLoading = false, this.error});

  final bool isLoading;
  final String? error;

  AuthActionState copyWith({bool? isLoading, String? error}) {
    return AuthActionState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class AuthActionController extends StateNotifier<AuthActionState> {
  AuthActionController() : super(const AuthActionState());

  Future<bool> run(Future<void> Function() action) async {
    if (state.isLoading) return false;

    state = const AuthActionState(isLoading: true);
    try {
      await action();
      state = const AuthActionState();
      return true;
    } catch (error) {
      state = AuthActionState(error: friendlyClerkError(error));
      return false;
    }
  }

  void clearError() {
    state = const AuthActionState();
  }
}
