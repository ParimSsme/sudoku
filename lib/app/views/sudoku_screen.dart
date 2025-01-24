import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/sudoku_controller.dart';
import '../widgets/number_pad.dart';
import '../widgets/sudoku_grid.dart';
import 'package:confetti/confetti.dart';

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
            actions: [
              // Pause Button
              IconButton(
                onPressed: () {
                  controller.pauseTimer();
                  _showPauseDialog(context, controller);
                },
                icon: const Icon(Icons.pause),
                tooltip: 'Pause',
              ),
            ],
          ),
          body: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Timer Display
                    Obx(() {
                      final minutes = (controller.elapsedTime.value ~/ 60)
                          .toString()
                          .padLeft(2, '0');
                      final seconds = (controller.elapsedTime.value % 60)
                          .toString()
                          .padLeft(2, '0');
                      return Text(
                        'Time Elapsed: $minutes:$seconds',
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      );
                    }),
                    const SizedBox(height: 16),
                    // Sudoku Grid
                    SizedBox(height: 410, child: SudokuGrid()),
                    const SizedBox(height: 16),
                    const Text(
                      "Choose a Number:",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    // Number Pad
                    NumberPad(),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: controller.clearGrid,
                      child: const Text('Clear Grid'),
                    ),
                    const SizedBox(height: 16),
                    // Solve Button
                    ElevatedButton(
                      onPressed: () => _checkSolution(context, controller),
                      child: const Text('Solve'),
                    ),
                  ],
                ),
              ),
              // Confetti Widget
              Obx(() {
                return Offstage(
                  offstage: !controller.showConfetti.value,
                  child: Center(
                    child: ConfettiWidget(
                      confettiController: controller.confettiController,
                      blastDirectionality: BlastDirectionality.explosive,
                      shouldLoop: true,
                      emissionFrequency: 0.05,
                      numberOfParticles: 30,
                      gravity: 0.1,
                    ),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  void _showPauseDialog(BuildContext context, SudokuController controller) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Game Paused'),
          content: const Text('The game is paused. Press Resume to continue.'),
          actions: [
            TextButton(
              onPressed: () {
                controller.resumeTimer();
                Navigator.pop(context);
              },
              child: const Text('Resume'),
            ),
            TextButton(
              onPressed: () {
                controller.resetTimer();
                Navigator.pop(context);
              },
              child: const Text('Restart'),
            ),
          ],
        );
      },
    );
  }

  void _checkSolution(BuildContext context, SudokuController controller) {
    if (!controller.isGridFilled()) {
      _showResultDialog(
        context: context,
        title: 'Failed',
        content: 'The grid is not completely filled.',
      );
    } else if (!controller.isSolutionCorrect()) {
      _showResultDialog(
        context: context,
        title: 'Failed',
        content: 'The solution is incorrect.',
      );
    } else {
      // Trigger confetti and show success dialog
      controller.showConfettiEffect();
      _showResultDialog(
        context: context,
        title: 'Success',
        content: 'Congratulations! The solution is correct.',
        onClose: () => controller.showConfetti(false),
      );
    }
  }

  void _showResultDialog({
    required BuildContext context,
    required String title,
    required String content,
    VoidCallback? onClose,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () {
                if (onClose != null) onClose();
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
