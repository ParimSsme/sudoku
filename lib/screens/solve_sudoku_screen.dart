import 'package:flutter/material.dart';

import 'dart:math';
import 'package:flutter/material.dart';

class SolveSudokuScreen extends StatefulWidget {
  const SolveSudokuScreen({super.key});

  @override
  State<SolveSudokuScreen> createState() => _SolveSudokuScreenState();
}

class _SolveSudokuScreenState extends State<SolveSudokuScreen>
    with SingleTickerProviderStateMixin {
  final List<List<int>> grid = List.generate(9, (_) => List.generate(9, (_) => 0));
  final List<List<int>> solutionGrid = List.generate(9, (_) => List.generate(9, (_) => 0));
  int selectedRow = -1;
  int selectedCol = -1;

  late AnimationController _controller;
  late Animation<double> _tileAnimation;

  @override
  void initState() {
    super.initState();
    _generateDynamicPuzzle();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _tileAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  /// Generates a new dynamic puzzle and stores it in `grid`
  void _generateDynamicPuzzle() {
    List<List<int>> basePuzzle = _generateBasePuzzle();
    _shuffleSudoku(basePuzzle);
    _removeNumbersForPuzzle(basePuzzle, 40); // Remove 40 cells for the puzzle

    setState(() {
      for (int i = 0; i < 9; i++) {
        for (int j = 0; j < 9; j++) {
          grid[i][j] = basePuzzle[i][j];
          solutionGrid[i][j] = basePuzzle[i][j]; // Store the solution
        }
      }
    });
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

  /// Shuffles rows, columns, and numbers to create a randomized Sudoku puzzle
  void _shuffleSudoku(List<List<int>> grid) {
    Random rand = Random();

    // Shuffle numbers within the grid
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
        List<int> newRow = List.generate(9, (i) => grid[row][i]);
        for (int i = 0; i < 3; i++) {
          newRow[startCol + i] = grid[row][startCol + cols[i]];
        }
        grid[row] = newRow;
      }
    }
  }

  /// Removes a given number of cells from the grid to create the puzzle
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

  void _selectTile(int row, int col) {
    setState(() {
      selectedRow = row;
      selectedCol = col;
    });
  }

  void _updateTile(int value) {
    if (selectedRow >= 0 && selectedCol >= 0) {
      setState(() {
        grid[selectedRow][selectedCol] = value;
        _controller.reset();
        _controller.forward();
      });
    }
  }

  Widget _buildGridTile(int row, int col) {
    bool isSelected = (row == selectedRow && col == selectedCol);

    return GestureDetector(
      onTap: () => _selectTile(row, col),
      child: AnimatedBuilder(
        animation: _tileAnimation,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              color: isSelected
                  ? Colors.indigo.withOpacity(_tileAnimation.value)
                  : Colors.white,
              border: Border.all(
                color: isSelected ? Colors.indigo : Colors.grey,
                width: 1,
              ),
            ),
            child: Center(
              child: Text(
                grid[row][col] == 0 ? '' : grid[row][col].toString(),
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSudokuGrid() {
    return GridView.builder(
      shrinkWrap: true,
      itemCount: 81,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 9,
        childAspectRatio: 1.0,
        mainAxisSpacing: 2,
        crossAxisSpacing: 2,
      ),
      itemBuilder: (context, index) {
        int row = index ~/ 9;
        int col = index % 9;
        return _buildGridTile(row, col);
      },
    );
  }

  Widget _buildNumberPad() {
    return GridView.builder(
      shrinkWrap: true,
      itemCount: 9,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1.0,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => _updateTile(index + 1),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.indigo,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                (index + 1).toString(),
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dynamic Sudoku'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(child: _buildSudokuGrid()),
            SizedBox(height: 16),
            Text(
              "Choose a Number:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Expanded(child: _buildNumberPad()),
          ],
        ),
      ),
    );
  }
}
