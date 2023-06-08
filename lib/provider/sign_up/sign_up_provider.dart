import 'package:fb_auth/models/custom_error.dart';

import 'package:fb_auth/repositories/auth_repository.dart';
import 'package:flutter/widgets.dart';

import 'sign_up_state.dart';

class SignUpProvider with ChangeNotifier {
  SignUpState _state = SignUpState.initial();
  SignUpState get state => _state;
  final AuthRepository authRepository;
  SignUpProvider({
    required this.authRepository,
  });
  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    _state = _state.copyWith(signUpStatus: SignUpStatus.submitting);
    notifyListeners();
    try {
      await authRepository.signup(name: name, email: email, password: password);
    } on CustomError catch (e) {
      _state = _state.copyWith(signUpStatus: SignUpStatus.error, error: e);
      notifyListeners();
      rethrow;
    }
  }
}
