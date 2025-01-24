import 'package:get/get.dart';
import '../controllers/sudoku_controller.dart';

class SudokuBinding extends Bindings {
  final SudokuScreenType screenType;

  // Pass the screen type to the binding
  SudokuBinding({required this.screenType});

  @override
  void dependencies() {
    Get.lazyPut(() => SudokuController(screenType: screenType));
  }
}
