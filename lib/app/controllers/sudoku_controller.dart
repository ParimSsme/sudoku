import 'package:confetti/confetti.dart';
import 'package:get/get.dart';

class SudokuController extends GetxController {
  // Sudoku grid
  var grid = List.generate(9, (_) => List.generate(9, (_) => 0)).obs;

  // Selected cell
  var selectedRow = (-1).obs;
  var selectedCol = (-1).obs;

  // Confetti controller
  late ConfettiController confettiController;

  @override
  void onInit() {
    confettiController = ConfettiController(duration: const Duration(seconds: 3));
    super.onInit();
  }

  @override
  void onClose() {
    confettiController.dispose();
    super.onClose();
  }

  // Select a grid tile
  void selectTile(int row, int col) {
    selectedRow.value = row;
    selectedCol.value = col;
  }

  // Update the value of a grid tile
  void updateTile(int number) {
    if (selectedRow.value >= 0 && selectedCol.value >= 0) {
      grid[selectedRow.value][selectedCol.value] = number;
      grid.refresh();
    }
  }

  // Check if the grid is fully filled
  bool isGridFilled() {
    for (var row in grid) {
      if (row.contains(0)) return false;
    }
    return true;
  }

  // Check if the Sudoku rules are satisfied
  bool isSudokuSolved() {
    for (int row = 0; row < 9; row++) {
      for (int col = 0; col < 9; col++) {
        int num = grid[row][col];
        grid[row][col] = 0; // Temporarily remove the number for validation
        if (!_isValid(row, col, num)) {
          grid[row][col] = num; // Restore the number
          return false;
        }
        grid[row][col] = num; // Restore the number
      }
    }
    return true;
  }

  // Validate if a number can be placed at the given position
  bool _isValid(int row, int col, int num) {
    for (int i = 0; i < 9; i++) {
      if (grid[row][i] == num || grid[i][col] == num) {
        return false;
      }
    }
    int startRow = (row ~/ 3) * 3;
    int startCol = (col ~/ 3) * 3;
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (grid[startRow + i][startCol + j] == num) {
          return false;
        }
      }
    }
    return true;
  }

  // Validate Sudoku and show appropriate feedback
  void validateSudoku() {
    if (isGridFilled()) {
      if (isSudokuSolved()) {
        confettiController.play();
        Get.defaultDialog(
          title: 'Congratulations!',
          middleText: 'You successfully solved the Sudoku puzzle! 🎉',
          textConfirm: 'OK',
          onConfirm: () => Get.back(),
        );
      } else {
        Get.snackbar(
          'Invalid Sudoku',
          'The Sudoku puzzle is incorrect. Try again!',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } else {
      Get.snackbar(
        'Incomplete Grid',
        'Please fill all the tiles before validating!',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Clear the grid
  void clearGrid() {
    grid.value = List.generate(9, (_) => List.generate(9, (_) => 0));
    selectedRow.value = -1;
    selectedCol.value = -1;
  }
}
