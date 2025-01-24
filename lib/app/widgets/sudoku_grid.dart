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
        int row = index ~/ 9; // Row index
        int col = index % 9;  // Column index

        return GestureDetector(
          onTap: () => controller.selectTile(row, col),
          child: Obx(() {
            bool isSelected = row == controller.selectedRow.value && col == controller.selectedCol.value;
            bool isInSelectedRow = row == controller.selectedRow.value;
            bool isInSelectedCol = col == controller.selectedCol.value;

            return Container(
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.indigo.withOpacity(controller.tileAnimation.value)
                    : (isInSelectedRow || isInSelectedCol)
                    ? Colors.indigo.withOpacity(0.2)
                    : Colors.white,
                border: Border.all(
                  color: isSelected
                      ? Colors.indigo
                      : Colors.grey,
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
            );
          }),
        );
      },
    );
  }
}
