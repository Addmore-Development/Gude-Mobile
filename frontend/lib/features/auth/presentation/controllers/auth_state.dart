import 'package:flutter_riverpod/flutter_riverpod.dart';

// ── Auth Status ─────────────────────────────────────────
enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

// ── Auth State ──────────────────────────────────────────
class AuthState {
  final AuthStatus status;
  final String? errorMessage;

  const AuthState({
    this.status = AuthStatus.unauthenticated,
    this.errorMessage,
  });

  AuthState copyWith({AuthStatus? status, String? errorMessage}) {
    return AuthState(
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }

  bool get isLoading => status == AuthStatus.loading;
  bool get isAuthenticated => status == AuthStatus.authenticated;
  bool get hasError => status == AuthStatus.error;
}

// ── Auth Notifier (Mock — replace with Firebase after flutterfire configure) ─
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState());

  Future<bool> signUp({required String email, required String password, required String fullName}) async {
    state = state.copyWith(status: AuthStatus.loading);
    await Future.delayed(const Duration(milliseconds: 1200));
    state = state.copyWith(status: AuthStatus.authenticated);
    return true;
  }

  Future<bool> login({required String email, required String password}) async {
    state = state.copyWith(status: AuthStatus.loading);
    await Future.delayed(const Duration(milliseconds: 1200));
    if (password.length < 8) {
      state = state.copyWith(status: AuthStatus.error, errorMessage: 'Password must be at least 8 characters');
      return false;
    }
    state = state.copyWith(status: AuthStatus.authenticated);
    return true;
  }

  Future<bool> sendPasswordReset(String email) async {
    state = state.copyWith(status: AuthStatus.loading);
    await Future.delayed(const Duration(milliseconds: 900));
    state = state.copyWith(status: AuthStatus.unauthenticated);
    return true;
  }

  Future<void> signOut() async {
    state = const AuthState(status: AuthStatus.unauthenticated);
  }
}

// ── Provider ────────────────────────────────────────────
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});