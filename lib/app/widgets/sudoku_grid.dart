import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';
import '../controllers/sudoku_controller.dart';

class SudokuGrid extends GetView<SudokuController> {
  const SudokuGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      padding: const EdgeInsets.all(1.0),
      child: GridView.builder(
        shrinkWrap: true,
        itemCount: 81,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 9, // 9 tiles per row
          mainAxisSpacing: 0,
          crossAxisSpacing: 0,
        ),
        itemBuilder: (context, index) {
          int row = index ~/ 9; // Row index
          int col = index % 9; // Column index

          return GestureDetector(
            onTap: () => controller.selectTile(row, col),
            child: Obx(() {
              bool isSelected = row == controller.selectedRow.value && col == controller.selectedCol.value;
              bool isInSelectedRow = row == controller.selectedRow.value;
              bool isInSelectedCol = col == controller.selectedCol.value;
              bool isInSelectedRowOrCol = isInSelectedRow || isInSelectedCol;

              return Container(
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.background
                      : isInSelectedRowOrCol
                      ? const Color(0x806d80a1) // Highlight for row/col
                      : Colors.white,
                  border: Border(
                    top: BorderSide(
                      color: AppColors.background,
                      width: row % 3 == 0 ? 3.5 : 1, // Thicker top border for subgrids
                    ),
                    left: BorderSide(
                      color: AppColors.background,
                      width: col % 3 == 0 ? 3.5 : 1, // Thicker left border for subgrids
                    ),
                    bottom: BorderSide(
                      color: AppColors.background,
                      width: (row + 1) % 3 == 0 ? 3.5 : 1, // Thicker bottom border for subgrids
                    ),
                    right: BorderSide(
                      color: AppColors.background,
                      width: (col + 1) % 3 == 0 ? 3.5 : 1, // Thicker right border for subgrids
                    ),
                  ),
                ),
                child: Center(
                  child: Text(
                    controller.grid[row][col] == 0
                        ? ''
                        : controller.grid[row][col].toString(),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: isSelected
                          ? Colors.white
                          : isInSelectedRowOrCol
                          ? Colors.black
                          : Colors.black,
                    ),
                  ),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}
