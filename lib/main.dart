import 'package:flutter/material.dart';
import 'package:relife/views/HomePage/homepage.dart';
import 'package:relife/views/Login/login_page.dart';
import 'package:relife/views/RecoverPassword/recover_password.dart';

void main() {
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'ReLife',
      // home: HomePage(),
      home: LoginPage(),
      //home: RecoverPassword(),
    );
  }
}
