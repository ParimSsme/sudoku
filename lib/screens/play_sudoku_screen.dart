import 'package:flutter/material.dart';

class PlaySudokuScreen extends StatefulWidget {
  const PlaySudokuScreen({super.key});

  @override
  State<PlaySudokuScreen> createState() => _PlaySudokuScreenState();
}

class _PlaySudokuScreenState extends State<PlaySudokuScreen> {
  // 9x9 grid for Sudoku puzzle input
  List<List<int>> grid = List.generate(9, (_) => List.generate(9, (_) => 0));

  int selectedRow = -1;
  int selectedCol = -1;

  // Backtracking algorithm to solve the puzzle
  bool _solveSudoku(List<List<int>> board) {
    for (int row = 0; row < 9; row++) {
      for (int col = 0; col < 9; col++) {
        if (board[row][col] == 0) {
          for (int num = 1; num <= 9; num++) {
            if (_isValid(board, row, col, num)) {
              board[row][col] = num;
              if (_solveSudoku(board)) {
                return true;
              }
              board[row][col] = 0;
            }
          }
          return false; // No valid number found
        }
      }
    }
    return true; // Puzzle solved
  }

  // Check if placing `num` at (row, col) is valid
  bool _isValid(List<List<int>> board, int row, int col, int num) {
    for (int i = 0; i < 9; i++) {
      if (board[row][i] == num || board[i][col] == num) {
        return false;
      }
    }
    int startRow = (row ~/ 3) * 3;
    int startCol = (col ~/ 3) * 3;
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (board[startRow + i][startCol + j] == num) {
          return false;
        }
      }
    }
    return true;
  }

  void _solvePuzzle() {
    setState(() {
      _solveSudoku(grid);
    });
  }

  void _clearGrid() {
    setState(() {
      grid = List.generate(9, (_) => List.generate(9, (_) => 0));
      selectedRow = -1;
      selectedCol = -1;
    });
  }

  void _selectTile(int row, int col) {
    setState(() {
      selectedRow = row;
      selectedCol = col;
    });
  }

  void _updateTile(int number) {
    if (selectedRow >= 0 && selectedCol >= 0) {
      setState(() {
        grid[selectedRow][selectedCol] = number;
      });
    }
  }

  Widget _buildGrid() {
    return GridView.builder(
      shrinkWrap: true,
      itemCount: 81,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 9,
      ),
      itemBuilder: (context, index) {
        int row = index ~/ 9;
        int col = index % 9;
        bool isSelected = (row == selectedRow && col == selectedCol);

        return GestureDetector(
          onTap: () => _selectTile(row, col),
          child: Container(
            decoration: BoxDecoration(
              color: isSelected ? Colors.teal.shade200 : Colors.white,
              border: Border.all(color: Colors.black26),
            ),
            child: Center(
              child: Text(
                grid[row][col] == 0 ? '' : grid[row][col].toString(),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal.shade800,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNumberPad() {
    return GridView.builder(
      shrinkWrap: true,
      itemCount: 9,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemBuilder: (context, index) {
        int number = index + 1;

        return GestureDetector(
          onTap: () => _updateTile(number),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.teal,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                number.toString(),
                style: const TextStyle(
                  fontSize: 20,
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Solve Sudoku'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: _buildGrid(),
            ),
            const SizedBox(height: 16),
            Text(
              'Select a number:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: _buildNumberPad(),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: _solvePuzzle,
                  child: Text('Solve'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 24,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: _clearGrid,
                  child: Text('Clear'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 24,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}