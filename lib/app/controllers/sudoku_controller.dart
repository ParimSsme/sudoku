import 'package:get/get.dart';
import 'dart:math';
import 'package:flutter/material.dart';

import 'dart:math';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum SudokuScreenType { play, solve }

class SudokuController extends GetxController with SingleGetTickerProviderMixin {
  // Sudoku grid
  final grid = List.generate(9, (_) => List.generate(9, (_) => 0)).obs;
  final solutionGrid = List.generate(9, (_) => List.generate(9, (_) => 0)).obs;

  // Selected cell
  var selectedRow = (-1).obs;
  var selectedCol = (-1).obs;

  // Animation
  late AnimationController animationController;
  late Animation<double> tileAnimation;

  // Confetti controller
  late ConfettiController confettiController;

  final SudokuScreenType screenType;

  SudokuController({required this.screenType});

  @override
  void onInit() {
    super.onInit();

    // Generate dynamic puzzle for "Solve" mode
    if (screenType == SudokuScreenType.solve) {
      _generateDynamicPuzzle();
    }

    // Initialize animation
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    tileAnimation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeInOut,
    );

    // Initialize confetti controller
    confettiController = ConfettiController(duration: const Duration(seconds: 3));
  }

  @override
  void onClose() {
    animationController.dispose();
    confettiController.dispose();
    super.onClose();
  }

  /// Generates a new dynamic puzzle
  void _generateDynamicPuzzle() {
    List<List<int>> basePuzzle = _generateBasePuzzle();
    _shuffleSudoku(basePuzzle);
    _removeNumbersForPuzzle(basePuzzle, 40); // Remove 40 cells for the puzzle

    grid.value = List.from(basePuzzle);
    solutionGrid.value = List.from(basePuzzle);
  }

  /// Generates a valid base Sudoku grid
  List<List<int>> _generateBasePuzzle() {
    List<List<int>> baseGrid = List.generate(9, (_) => List.generate(9, (_) => 0));
    List<int> nums = List.generate(9, (i) => i + 1);
    int boxSize = 3;

    for (int row = 0; row < 9; row++) {
      for (int col = 0; col < 9; col++) {
        baseGrid[row][col] = nums[(boxSize * (row % boxSize) + row ~/ boxSize + col) % 9];
      }
    }
    return baseGrid;
  }

  /// Shuffles rows, columns, and numbers
  void _shuffleSudoku(List<List<int>> grid) {
    Random rand = Random();

    // Shuffle numbers
    List<int> numShuffle = List.generate(9, (i) => i + 1)..shuffle(rand);
    for (int i = 0; i < 9; i++) {
      for (int j = 0; j < 9; j++) {
        grid[i][j] = numShuffle[grid[i][j] - 1];
      }
    }

    // Shuffle rows within each box
    for (int box = 0; box < 3; box++) {
      int startRow = box * 3;
      List<int> rows = [0, 1, 2]..shuffle(rand);
      for (int i = 0; i < 3; i++) {
        grid[startRow + i] = List.from(grid[startRow + rows[i]]);
      }
    }

    // Shuffle columns within each box
    for (int box = 0; box < 3; box++) {
      int startCol = box * 3;
      List<int> cols = [0, 1, 2]..shuffle(rand);
      for (int row = 0; row < 9; row++) {
        List<int> newRow = List.from(grid[row]);
        for (int i = 0; i < 3; i++) {
          newRow[startCol + i] = grid[row][startCol + cols[i]];
        }
        grid[row] = newRow;
      }
    }
  }

  /// Removes numbers from the grid
  void _removeNumbersForPuzzle(List<List<int>> grid, int emptyCells) {
    Random rand = Random();
    int removed = 0;

    while (removed < emptyCells) {
      int row = rand.nextInt(9);
      int col = rand.nextInt(9);

      if (grid[row][col] != 0) {
        grid[row][col] = 0;
        removed++;
      }
    }
  }

  // Select a grid tile
  void selectTile(int row, int col) {
    selectedRow.value = row;
    selectedCol.value = col;
  }

  // Update the value of a grid tile
  void updateTile(int value) {
    if (selectedRow.value >= 0 && selectedCol.value >= 0) {
      grid[selectedRow.value][selectedCol.value] = value;
      grid.refresh();

      // Trigger animation
      animationController.reset();
      animationController.forward();
    }
  }

  // Celebrate with confetti
  void celebrate() {
    confettiController.play();
  }

  // Clear the grid (only for "Solve" mode)
  void clearGrid() {
    if (screenType == SudokuScreenType.solve) {
      grid.value = List.generate(9, (_) => List.generate(9, (_) => 0));
      selectedRow.value = -1;
      selectedCol.value = -1;
    }
  }
}


