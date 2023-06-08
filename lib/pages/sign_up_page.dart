import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:validators/validators.dart';

import '../models/custom_error.dart';
import '../provider/sign_up/sign_up_provider.dart';
import '../provider/sign_up/sign_up_state.dart';
import '../utils/error_dialog.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});
  static const String routeName = '/signup';

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formkey = GlobalKey<FormState>();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  String? _email, _password, _name;
  final passwordController = TextEditingController();
  void submit() async {
    setState(() {
      _autovalidateMode = AutovalidateMode.always;
    });
    final form = _formkey.currentState;
    if (form == null || !form.validate()) return;
    form.save();
    print('name: $_name, email: $_email, password: $_password');
    try {
      await context
          .read<SignUpProvider>()
          .signUp(name: _name!, email: _email!, password: _password!);
    } on CustomError catch (e) {
      errorDialog(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final signUpState = context.watch<SignUpProvider>().state;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Form(
            key: _formkey,
            autovalidateMode: _autovalidateMode,
            child: ListView(
              reverse: true,
              shrinkWrap: true,
              children: [
                const SizedBox(height: 30),
                Image.asset(
                  'assets/flutter.png',
                  width: 250,
                  height: 250,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  // keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    filled: true,
                    labelText: 'Name',
                    prefixIcon: Icon(Icons.account_box),
                  ),
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Name required';
                    }

                    if (value.trim().length < 3) {
                      return 'Name must be atleast 3 characters long';
                    }
                    return null;
                  },
                  onSaved: (String? value) {
                    _name = value;
                  },
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
                  controller: passwordController,
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
                TextFormField(
                  obscureText: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    filled: true,
                    labelText: 'Confirm Password',
                    prefixIcon: Icon(Icons.lock),
                  ),
                  validator: (String? value) {
                    if (passwordController.text != value) {
                      return 'password does not match';
                    }
                    return null;
                  },
                ),
                ElevatedButton(
                  onPressed: signUpState.signUpStatus == SignUpStatus.submitting
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
                    signUpState.signUpStatus == SignUpStatus.submitting
                        ? 'Loading...'
                        : 'Sign up',
                  ),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: signUpState.signUpStatus == SignUpStatus.submitting
                      ? null
                      : () {
                          Navigator.pop(context);
                        },
                  style: TextButton.styleFrom(
                    textStyle: const TextStyle(
                      fontSize: 20,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  child: const Text('Already a member? Sign in'),
                )
              ].reversed.toList(),
            ),
          ),
        ),
      ),
    );
  }
}
