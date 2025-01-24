import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/sudoku_controller.dart';

class SudokuGrid extends GetView<SudokuController> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      itemCount: 81,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 9,
        mainAxisSpacing: 2,
        crossAxisSpacing: 2,
      ),
      itemBuilder: (context, index) {
        int row = index ~/ 9;
        int col = index % 9;

        return GestureDetector(
          onTap: () => controller.selectTile(row, col),
          child: AnimatedBuilder(
            animation: controller.tileAnimation,
            builder: (context, child) {
              return Obx(() => Container(
                decoration: BoxDecoration(
                  color: row == controller.selectedRow.value && col == controller.selectedCol.value
                      ? Colors.indigo.withOpacity(controller.tileAnimation.value)
                      : Colors.white,
                  border: Border.all(
                    color: row == controller.selectedRow.value && col == controller.selectedCol.value ? Colors.indigo : Colors.grey,
                  ),
                ),
                child: Center(
                  child: Text(
                    controller.grid[row][col] == 0
                        ? ''
                        : controller.grid[row][col].toString(),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),);
            },
          ),
        );
      },
    );
  }
}
