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
    _initializeGrid();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _tileAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  void _initializeGrid() {
    // Sample Sudoku Generator (static for simplicity)
    final List<List<int>> basePuzzle = [
      [5, 3, 0, 0, 7, 0, 0, 0, 0],
      [6, 0, 0, 1, 9, 5, 0, 0, 0],
      [0, 9, 8, 0, 0, 0, 0, 6, 0],
      [8, 0, 0, 0, 6, 0, 0, 0, 3],
      [4, 0, 0, 8, 0, 3, 0, 0, 1],
      [7, 0, 0, 0, 2, 0, 0, 0, 6],
      [0, 6, 0, 0, 0, 0, 2, 8, 0],
      [0, 0, 0, 4, 1, 9, 0, 0, 5],
      [0, 0, 0, 0, 8, 0, 0, 7, 9],
    ];

    setState(() {
      for (int i = 0; i < 9; i++) {
        for (int j = 0; j < 9; j++) {
          grid[i][j] = basePuzzle[i][j];
        }
      }
    });
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
        title: Text('Sudoku Game'),
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
