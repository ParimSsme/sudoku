import 'package:flutter/material.dart';
import 'package:sudoku/core/theme/app_text_theme.dart';

class LearnSudokuScreen extends StatelessWidget {
  const LearnSudokuScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8,
              children: [
                Text(
                  'Learn Sudoku',
                  style: kMediumTitleStyle,
                ),
                const SizedBox(height: 5),
                _buildSectionTitle('The Rules of Sudoku:'),
                _buildBodyText(
                  '1. Each row must contain the numbers 1 to 9 without repetition.\n'
                      '2. Each column must contain the numbers 1 to 9 without repetition.\n'
                      '3. Each 3x3 subgrid must contain the numbers 1 to 9 without repetition.',
                ),
                const SizedBox(height: 20),
                _buildSectionTitle('Example of a Valid Move:'),
                _buildExampleGrid(),
                const SizedBox(height: 20),
                _buildSectionTitle('Tips for Beginners:'),
                _buildBodyText(
                  '1. Start with rows, columns, or subgrids that already have many numbers filled in.\n'
                      '2. Use the process of elimination to determine which numbers can go in each cell.\n'
                      '3. Take your time—solving Sudoku is a process of logic and patience!',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.teal,
      ),
    );
  }

  Widget _buildBodyText(String content) {
    return Text(
      content,
      style: kBodyTextStyle,
    );
  }

  Widget _buildExampleGrid() {
    return SizedBox(
      height: 200,
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 9,
        ),
        itemCount: 81,
        itemBuilder: (context, index) {
          int row = index ~/ 9;
          int col = index % 9;
          bool isExampleMove = (row == 0 && col == 2);

          return Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              color: isExampleMove ? Colors.teal.shade100 : Colors.white,
            ),
            child: Center(
              child: Text(
                (row == 0 && col == 0)
                    ? '5'
                    : (row == 0 && col == 1)
                    ? '3'
                    : (row == 0 && col == 2)
                    ? '4'
                    : '',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isExampleMove ? Colors.teal : Colors.black,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
