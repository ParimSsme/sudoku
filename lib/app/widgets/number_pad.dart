import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';
import '../controllers/sudoku_controller.dart';

class NumberPad extends GetView<SudokuController> {
  const NumberPad({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: 8,
      children: [
        // First row with 5 buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            return _buildNumberButton(index + 1);
          }),
        ),

        // Second row with 4 buttons, centered
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(4, (index) {
            return _buildNumberButton(6 + index);
          }),
        ),
      ],
    );
  }

  // Helper method to build a single button
  Widget _buildNumberButton(int number) {
    return Obx(
      () => GestureDetector(
        onTap: controller.isGameOver.value ? null : () => controller.updateTile(number),
        child: Container(
          width: 60, // Fixed width for uniform button size
          height: 60,
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppColors.border,
                width: 2,
              )),
          child: Center(
            child: Text(
              number.toString(),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
