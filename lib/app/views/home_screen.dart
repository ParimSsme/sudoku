import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sudoku/core/assets/app_icon_assets.dart';
import 'package:sudoku/core/theme/app_text_theme.dart';
import '../../core/theme/app_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../controllers/home_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.put(HomeController());

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 20,
          children: [
            _buildLogo(),
            _buildTitle(),
            const SizedBox(height: 30),
            _buildMenuButton(
              label: 'Play Sudoku',
              icon: const Icon(Icons.play_arrow),
              onPressed: controller.navigateToPlaySudoku,
            ),
            _buildMenuButton(
              label: 'Solve a Sudoku',
              icon: const Icon(Icons.play_arrow),
              onPressed: controller.navigateToSolveSudoku,
            ),
            _buildMenuButton(
              label: 'Learn Sudoku',
              icon: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: SvgPicture.asset(
                  AppIconAssets.learn,
                  height: 50,
                  width: 50,
                  colorFilter: const ColorFilter.mode(
                    AppColors.textButtonForeground,
                    BlendMode.srcATop,
                  ),
                ),
              ),
              onPressed: controller.navigateToLearnSudoku,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return SvgPicture.asset(
      AppIconAssets.logo,
      height: 180,
    );
  }

  Widget _buildTitle() {
    return Text(
      'Welcome to Sudoku!',
      style: kLargeTitleStyle,
      textAlign: TextAlign.center,
    );
  }

  Widget _buildMenuButton({
    required String label,
    required Widget icon,
    required VoidCallback onPressed,
  }) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: icon,
      label: Text(label),
    );
  }
}

