import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sudoku/app/views/home_screen.dart';
import 'core/theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sudoku Solver',
      theme: appThemeData,
      home: const HomeScreen(),
    );
  }
}

