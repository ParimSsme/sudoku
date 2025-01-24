import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sudoku/app/views/home_screen.dart';
import 'package:sudoku/app/views/play_sudoku_screen.dart';
import 'app/bindings/sudoku_binding.dart';

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
      initialBinding: SudokuBinding(),
      home: const PlaySudokuScreen(),
    );
  }
}

