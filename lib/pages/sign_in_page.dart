import 'package:fb_auth/models/custom_error.dart';
import 'package:fb_auth/pages/sign_up_page.dart';
import 'package:fb_auth/provider/signin/signin_provider.dart';
import 'package:fb_auth/provider/signin/signin_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:validators/validators.dart';

import '../utils/error_dialog.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});
  static const String routeName = '/signin';

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formkey = GlobalKey<FormState>();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  String? _email, _password;
  void submit() async {
    setState(() {
      _autovalidateMode = AutovalidateMode.always;
    });
    final form = _formkey.currentState;
    if (form == null || !form.validate()) return;
    print('email: $_email, password: $_password');
    try {
      await context
          .read<SignInProvider>()
          .signIn(email: _email!, password: _password!);
    } on CustomError catch (e) {
      errorDialog(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final signInState = context.watch<SignInProvider>().state;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Form(
            key: _formkey,
            autovalidateMode: _autovalidateMode,
            child: ListView(
              shrinkWrap: true,
              children: [
                Image.asset(
                  'assets/flutter_logo.png',
                  width: 250,
                  height: 250,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    filled: true,
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                  ),
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Email required';
                    }

                    if (!isEmail(value.trim())) {
                      return 'Enter a valid email';
                    }
                    return null;
                  },
                  onSaved: (String? value) {
                    _email = value;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  obscureText: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    filled: true,
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock),
                  ),
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'password required';
                    }
                    if (value.trim().length < 6) {
                      return 'Password must be at least 6 characters long';
                    }
                    return null;
                  },
                  onSaved: (String? value) {
                    _password = value;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: signInState.signInStatus == SignInStatus.submitting
                      ? null
                      : submit,
                  style: ElevatedButton.styleFrom(
                    textStyle: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  child: Text(
                    signInState.signInStatus == SignInStatus.submitting
                        ? 'Loading...'
                        : 'Sign in',
                  ),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: signInState.signInStatus == SignInStatus.submitting
                      ? null
                      : () {
                          Navigator.pushNamed(context, SignUpPage.routeName);
                        },
                  style: TextButton.styleFrom(
                    textStyle: const TextStyle(
                      fontSize: 20,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  child: const Text('Not a member? Sign up'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
