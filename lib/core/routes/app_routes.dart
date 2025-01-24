import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:sudoku/app/views/home_screen.dart';
import 'package:sudoku/app/views/learn_sudoku_screen.dart';
import '../../app/bindings/sudoku_binding.dart';
import '../../app/controllers/sudoku_controller.dart';
import '../../app/views/sudoku_screen.dart';

class AppRoutes {
  static const String home = '/home';
  static const String playSudoku = '/play_sudoku';
  static const String solveSudoku = '/solve_sudoku';
  static const String learnSudoku = '/learn_sudoku';

  static List<GetPage> routes = [
    GetPage(
      name: home,
      page: () => const HomeScreen(),
    ),
    GetPage(
      name: playSudoku,
      page: () => const SudokuScreen(screenType: SudokuScreenType.play),
      binding: SudokuBinding(screenType: SudokuScreenType.play),
    ),
    GetPage(
      name: solveSudoku,
      page: () => const SudokuScreen(screenType: SudokuScreenType.solve),
      binding: SudokuBinding(screenType: SudokuScreenType.solve),
    ),
    GetPage(
      name: learnSudoku,
      page: () => const LearnSudokuScreen(),
    ),
  ];
}
