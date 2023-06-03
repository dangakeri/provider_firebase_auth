// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:fb_auth/provider/auth/auth_state.dart';
import 'package:fb_auth/repositories/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as fbAuth;

class AuthProvider with ChangeNotifier {
  AuthState _state = AuthState.unknown();
  AuthState get state => _state;
  final AuthRepository authRepository;
  AuthProvider({
    required this.authRepository,
  });
  void update(fbAuth.User? user) {
    if (user != null) {
      _state = _state.copyWith(
        authStatus: AuthStatus.authenticated,
        user: user,
      );
    } else {
      _state = _state.copyWith(authStatus: AuthStatus.unauthenticated);
    }
    print('authState: $_state');
    notifyListeners();
  }

  void signout() async {
    await authRepository.signout();
  }
}
