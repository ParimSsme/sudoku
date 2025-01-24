import 'package:get/get.dart';
import '../../core/routes/app_routes.dart';

class HomeController extends GetxController {

  void navigateToPlaySudoku() => Get.toNamed(AppRoutes.playSudoku);

  void navigateToSolveSudoku() => Get.toNamed(AppRoutes.solveSudoku);

  void navigateToLearnSudoku() => Get.toNamed(AppRoutes.learnSudoku);

}
