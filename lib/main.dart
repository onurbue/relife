import 'package:flutter/material.dart';
import 'package:relife/utils/constants.dart';
import 'package:relife/views/Backend/backend.dart';
import 'package:relife/views/HomePage/homepage.dart';
import 'package:relife/views/start.dart';

void main() {
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          iconTheme: IconThemeData(
            color: primaryColor,
          ),
        ),
      ),
      title: 'ReLife',
      home: const InitialPage(),
      //home: Dashboard(),
    );
  }
}
