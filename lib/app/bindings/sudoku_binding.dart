import 'package:get/get.dart';
import '../controllers/sudoku_controller.dart';

class SudokuBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SudokuController());
  }
}
