import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fb_auth/pages/home_page.dart';
import 'package:fb_auth/pages/sign_in_page.dart';
import 'package:fb_auth/pages/sign_up_page.dart';
import 'package:fb_auth/pages/splash_page.dart';
import 'package:fb_auth/provider/auth/auth_provider.dart';
import 'package:fb_auth/provider/signin/signin_provider.dart';
import 'package:fb_auth/repositories/auth_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart' as fbAuth;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthRepository>(
          create: (context) => AuthRepository(
            firebaseFirestore: FirebaseFirestore.instance,
            firebaseAuth: fbAuth.FirebaseAuth.instance,
          ),
        ),
        StreamProvider<fbAuth.User?>(
          create: (context) => context.read<AuthRepository>().user,
          initialData: null,
        ),
        ChangeNotifierProxyProvider(
          create: (context) =>
              AuthProvider(authRepository: context.read<AuthRepository>()),
          update: (
            BuildContext context,
            fbAuth.User? userStream,
            AuthProvider? authProvider,
          ) =>
              authProvider!..update(userStream),
        ),
        ChangeNotifierProvider<SignInProvider>(
          create: (context) => SignInProvider(
            authRepository: context.read<AuthRepository>(),
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurpleAccent),
        ),
        home: const SplashPage(),
        routes: {
          SignUpPage.routeName: (context) => const SignUpPage(),
          SignInPage.routeName: (context) => const SignInPage(),
          HomePage.routeName: (context) => const HomePage(),
        },
      ),
    );
  }
}
