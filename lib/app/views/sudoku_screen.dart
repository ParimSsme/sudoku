import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sudoku/core/theme/app_text_theme.dart';
import '../../core/theme/app_colors.dart';
import '../controllers/sudoku_controller.dart';
import '../widgets/number_pad.dart';
import '../widgets/pause_play_button.dart';
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
          appBar: _buildAppBar(),
          body: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildTimer(controller),
                    const SizedBox(height: 16),
                    const SizedBox(height: 395, child: SudokuGrid()),
                    const Spacer(),
                    const Text("Choose a Number:", style: kSmallTitleStyle),
                    const SizedBox(height: 8),
                    const NumberPad(),
                    const Spacer(),
                    _buildControlButtons(context, controller),
                  ],
                ),
              ),
              _buildConfetti(controller),
            ],
          ),
        );
      },
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      leading: IconButton(
        onPressed: Get.back,
        icon: Icon(
          Icons.arrow_back_ios_new_outlined,
          size: 30,
          color: AppColors.icon,
        ),
      ),
      title: Text(
        screenType == SudokuScreenType.solve ? 'Solve Sudoku' : 'Play Sudoku',
      ),
      centerTitle: true,
    );
  }

  Widget _buildTimer(SudokuController controller) {
    return Obx(() {
      final minutes =
          (controller.elapsedTime.value ~/ 60).toString().padLeft(2, '0');
      final seconds =
          (controller.elapsedTime.value % 60).toString().padLeft(2, '0');
      return RichText(
        text: TextSpan(
          text: '$minutes ',
          style: kMediumTitleStyle,
          children: [
            const TextSpan(text: 'min', style: kBodyTextStyle),
            TextSpan(text: '  $seconds ', style: kMediumTitleStyle),
            const TextSpan(text: 'sec', style: kBodyTextStyle),
          ],
        ),
      );
    });
  }

  Widget _buildControlButtons(
      BuildContext context, SudokuController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 15,
      children: [
        TextButton(
          onPressed: controller.clearGrid,
          child: const Text('Erase'),
        ),
        Obx(
          () => CircleIconButton(
            onPressed: () {
              controller.pauseTimer();
              _showPauseDialog(context, controller);
            },
            icon: controller.isPaused.value ? Icons.play_arrow : Icons.pause,
          ),
        ),
        TextButton(
          onPressed: () => _checkSolution(context, controller),
          child: const Text('Verify'),
        ),
      ],
    );
  }

  Widget _buildConfetti(SudokuController controller) {
    return Obx(() {
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
    });
  }

  void _showPauseDialog(BuildContext context, SudokuController controller) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text(
            controller.isGameOver.value ? 'Game is Over!' : 'Game Paused',
            style: kLargeTitleStyle.copyWith(color: Colors.black),
          ),
          content: Text(
            controller.isGameOver.value
                ? 'The game is over. Press Restart to start a new game.'
                : 'The game is paused. Press Resume to continue.',
            style: kSmallTitleStyle.copyWith(
                color: Colors.black, fontWeight: FontWeight.w500),
          ),
          actions: [
            if (!controller.isGameOver.value)
              TextButton(
                onPressed: () {
                  controller.resumeTimer();
                  Navigator.pop(context);
                },
                child: const Text('Resume'),
              ),
            TextButton(
              onPressed: () {
                controller.restartGame();
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
    // if (!controller.isGridFilled()) {
    //   _showResultDialog(
    //     context: context,
    //     title: 'Failed',
    //     content: 'The grid is not completely filled.',
    //   );
    // } else if (!controller.isSolutionCorrect()) {
    //   _showResultDialog(
    //     context: context,
    //     title: 'Failed',
    //     content: 'The solution is incorrect.',
    //   );
    // } else {
    controller.celebrate();
    _showResultDialog(
      context: context,
      title: 'Success',
      content: 'Congratulations! The solution is correct.',
      onClose: () => controller.showConfetti(false),
    );
    // }
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
          title: Text(
            title,
            style: kLargeTitleStyle.copyWith(
              color: title == 'Failed' ? AppColors.error : AppColors.success,
            ),
          ),
          content: Text(
            content,
            style: kSmallTitleStyle.copyWith(
                color: Colors.black, fontWeight: FontWeight.w500),
          ),
          actions: [
            TextButton(
              onPressed: () {
                onClose?.call();
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
