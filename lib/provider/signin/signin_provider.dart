import 'package:fb_auth/models/custom_error.dart';
import 'package:fb_auth/provider/signin/signin_state.dart';
import 'package:fb_auth/repositories/auth_repository.dart';
import 'package:flutter/widgets.dart';

class SignInProvider with ChangeNotifier {
  SignInState _state = SignInState.initial();
  SignInState get state => _state;
  final AuthRepository authRepository;
  SignInProvider({
    required this.authRepository,
  });
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    _state = _state.copyWith(signInStatus: SignInStatus.submitting);
    notifyListeners();
    try {
      await authRepository.signin(
        email: email,
        password: password,
      );
    } on CustomError catch (e) {
      _state = _state.copyWith(signInStatus: SignInStatus.error, error: e);
      notifyListeners();
      rethrow;
    }
  }
}
