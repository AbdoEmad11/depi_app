import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/auth_service.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthService _authService;

  AuthCubit(this._authService) : super(AuthInitial()) {
    // Listen to auth state changes
    _authService.authStateChanges.listen((user) {
      if (user != null) {
        emit(AuthAuthenticated(userId: user.uid, email: user.email ?? ''));
      } else {
        emit(AuthUnauthenticated());
      }
    });
  }

  // Sign up
  Future<void> signUp(String email, String password) async {
    try {
      emit(AuthLoading());
      await _authService.signUpWithEmailAndPassword(email, password);
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  // Sign in
  Future<void> signIn(String email, String password) async {
    try {
      emit(AuthLoading());
      await _authService.signInWithEmailAndPassword(email, password);
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _authService.signOut();
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }
}