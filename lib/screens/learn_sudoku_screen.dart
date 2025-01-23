import 'package:flutter/material.dart';

class LearnSudokuScreen extends StatelessWidget {
  const LearnSudokuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Learn Sudoku'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Learn Sudoku',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'The Rules of Sudoku:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
              SizedBox(height: 8),
              Text(
                '1. Each row must contain the numbers 1 to 9 without repetition.\n'
                    '2. Each column must contain the numbers 1 to 9 without repetition.\n'
                    '3. Each 3x3 subgrid must contain the numbers 1 to 9 without repetition.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 24),
              Text(
                'Example of a Valid Move:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
              SizedBox(height: 8),
              SizedBox(
                height: 200,
                child: GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 9,
                  ),
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
                  itemCount: 81,
                ),
              ),
              SizedBox(height: 24),
              Text(
                'Tips for Beginners:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
              SizedBox(height: 8),
              Text(
                '1. Start with rows, columns, or subgrids that already have many numbers filled in.\n'
                    '2. Use the process of elimination to determine which numbers can go in each cell.\n'
                    '3. Take your time—solving Sudoku is a process of logic and patience!',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}