import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/sudoku_controller.dart';
import '../widgets/confetti_widget.dart';
import '../widgets/number_pad.dart';
import '../widgets/sudoku_grid.dart';


class PlaySudokuScreen extends GetView<SudokuController> {
  const PlaySudokuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Solve Sudoku'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Expanded(
                  child: SudokuGrid(),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Select a number:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: NumberPad(),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: controller.validateSudoku,
                      child: const Text('Validate'),
                    ),
                    ElevatedButton(
                      onPressed: controller.clearGrid,
                      child: const Text('Clear'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          ConfettiDisplay(),
        ],
      ),
    );
  }
}
