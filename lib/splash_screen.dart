import 'dart:async';
import 'package:flutter/material.dart';

import 'authentication/login_screen.dart';

// ignore: use_key_in_widget_constructors
class SplashScreen extends StatelessWidget {
  static const String routeName = 'splash-screen';

  @override
  Widget build(BuildContext context) {
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
    });
    return Scaffold(
      body: Image.asset(
        'assets/SplashScreen.png',
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      ),
    );
  }
}
