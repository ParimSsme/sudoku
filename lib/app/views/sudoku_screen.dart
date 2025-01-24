import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/sudoku_controller.dart';
import '../widgets/number_pad.dart';
import '../widgets/sudoku_grid.dart';

class SudokuScreen extends StatelessWidget {
  final SudokuScreenType screenType;

  const SudokuScreen({super.key, required this.screenType});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SudokuController>(
      init: SudokuController(screenType: screenType),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: Text(screenType == SudokuScreenType.solve
                ? 'Solve Sudoku'
                : 'Play Sudoku'),
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Sudoku grid
                Expanded(child: SudokuGrid()),
                const SizedBox(height: 16),
                const Text(
                  "Choose a Number:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                // Number pad
                Expanded(child: NumberPad()),
                if (screenType == SudokuScreenType.solve)
                  ElevatedButton(
                    onPressed: controller.clearGrid,
                    child: const Text('Clear Grid'),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
