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
      ),
      itemBuilder: (context, index) {
        int row = index ~/ 9;
        int col = index % 9;
        // bool isSelected = ;

        return Obx(
          () => GestureDetector(
            onTap: () => controller.selectTile(row, col),
            child: Container(
              decoration: BoxDecoration(
                color: (row == controller.selectedRow.value &&
                    col == controller.selectedCol.value) ? Colors.teal.shade200 : Colors.white,
                border: Border.all(color: Colors.black26),
              ),
              child: Center(
                child: Text(
                  controller.grid[row][col] == 0
                      ? ''
                      : controller.grid[row][col].toString(),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal.shade800,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
