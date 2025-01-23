import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart'; // Add this dependency to pubspec.yaml

void main() => runApp(SudokuApp());

class SudokuApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Animated Sudoku App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: SudokuPage(),
    );
  }
}

class SudokuPage extends StatefulWidget {
  @override
  _SudokuPageState createState() => _SudokuPageState();
}

class _SudokuPageState extends State<SudokuPage> with SingleTickerProviderStateMixin {
  // Pre-filled Sudoku puzzle
  final List<List<int?>> puzzle = [
    [5, 3, null, null, 7, null, null, null, null],
    [6, null, null, 1, 9, 5, null, null, null],
    [null, 9, 8, null, null, null, null, 6, null],
    [8, null, null, null, 6, null, null, null, 3],
    [4, null, null, 8, null, 3, null, null, 1],
    [7, null, null, null, 2, null, null, null, 6],
    [null, 6, null, null, null, null, 2, 8, null],
    [null, null, null, 4, 1, 9, null, null, 5],
    [null, null, null, null, 8, null, null, 7, 9],
  ];

  // Current state of the Sudoku grid
  late List<List<int?>> grid;
  late AnimationController _successAnimationController;

  @override
  void initState() {
    super.initState();
    // Copy puzzle to grid
    grid = List.generate(
      9,
          (i) => List<int?>.from(puzzle[i]),
    );

    // Initialize success animation controller
    _successAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
  }

  @override
  void dispose() {
    _successAnimationController.dispose();
    super.dispose();
  }

  // Check if the solution is valid
  bool isValidSolution() {
    for (int i = 0; i < 9; i++) {
      if (!_isValidRow(i) || !_isValidColumn(i) || !_isValidBox(i)) {
        return false;
      }
    }
    return true;
  }

  bool _isValidRow(int row) {
    final values = <int>{};
    for (int col = 0; col < 9; col++) {
      final val = grid[row][col];
      if (val != null && !values.add(val)) return false;
    }
    return true;
  }

  bool _isValidColumn(int col) {
    final values = <int>{};
    for (int row = 0; row < 9; row++) {
      final val = grid[row][col];
      if (val != null && !values.add(val)) return false;
    }
    return true;
  }

  bool _isValidBox(int box) {
    final values = <int>{};
    final startRow = (box ~/ 3) * 3;
    final startCol = (box % 3) * 3;
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        final val = grid[startRow + i][startCol + j];
        if (val != null && !values.add(val)) return false;
      }
    }
    return true;
  }

  // Build Sudoku grid
  Widget _buildGrid() {
    return Column(
      children: List.generate(9, (row) {
        return Row(
          children: List.generate(9, (col) {
            final value = grid[row][col];
            final isEditable = puzzle[row][col] == null;

            return Expanded(
              child: GestureDetector(
                onTap: isEditable
                    ? () {
                  _showNumberPicker(row, col);
                }
                    : null,
                child: Animate(
                  effects: const [
                    ScaleEffect(), // Add a subtle scale effect when grid rebuilds
                  ],
                  child: Container(
                    margin: EdgeInsets.all(1),
                    height: 40,
                    color: isEditable ? Colors.white : Colors.grey[300],
                    alignment: Alignment.center,
                    child: Text(
                      value?.toString() ?? '',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ),
            );
          }),
        );
      }),
    );
  }

  // Number picker dialog
  void _showNumberPicker(int row, int col) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Pick a Number'),
          content: Wrap(
            children: List.generate(9, (i) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    grid[row][col] = i + 1;
                  });
                  Navigator.of(context).pop();
                },
                child: Animate(
                  effects: const [
                    FadeEffect(), // Add a fade effect for picking numbers
                  ],
                  child: Container(
                    margin: EdgeInsets.all(5),
                    width: 40,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${i + 1}',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
              );
            }),
          ),
        );
      },
    );
  }

  // Show success animation
  void _showSuccessAnimation() {
    showDialog(
      context: context,
      builder: (context) {
        _successAnimationController.reset();
        _successAnimationController.forward();
        return Center(
          child: ScaleTransition(
            scale: _successAnimationController,
            child: Icon(Icons.star, size: 100, color: Colors.yellow),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Animated Sudoku')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(child: _buildGrid()),
            ElevatedButton(
              onPressed: () {
                final isValid = isValidSolution();
                if (isValid) {
                  _showSuccessAnimation();
                } else {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Invalid Solution'),
                        content: Text('Please check your solution.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text('OK'),
                          )
                        ],
                      );
                    },
                  );
                }
              },
              child: Text('Validate Solution'),
            ),
          ],
        ),
      ),
    );
  }
}

