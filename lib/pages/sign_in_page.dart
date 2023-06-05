import 'package:flutter/material.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});
  static const String routeName = '/signin';

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        children: [
          Text('Sign in'),
        ],
      ),
    );
  }
}
