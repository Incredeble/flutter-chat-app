import 'package:flutter/material.dart';
import 'package:mate_rate/forgot_password.dart';
import 'login.dart';
import 'register.dart';
import 'home.dart';
import 'forgot_password.dart';
import 'pswdReset.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
      initialRoute: LoginScreen.id,
      routes: {
        LoginScreen.id: (context) => LoginScreen(),
        RegisterScreen.id: (context) => RegisterScreen(),
        HomeScreen.id: (context) => HomeScreen(),
        ForgotScreen.id: (context) => ForgotScreen(),
        PasswordScreen.id: (context) => PasswordScreen(),
      },
    );
  }
}
