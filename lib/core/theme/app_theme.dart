import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_theme.dart';

final ThemeData appThemeData = ThemeData(
  useMaterial3: true,
  unselectedWidgetColor: Colors.red,

  /// Icon Theme Data
  iconTheme: IconThemeData (
    color: AppColors.icon
  ),

  scaffoldBackgroundColor: AppColors.background,

  /// AppBar Theme
  appBarTheme: AppBarTheme(
    color: Colors.transparent,
    elevation: 0,
    titleTextStyle: kMediumTitleStyle,
  ),

  /// Card Theme Data
  cardTheme: const CardTheme(
    color: AppColors.card,
    elevation: 15,
    shadowColor: AppColors.cardShadowColor
  ),

  /// Text Button Theme Data
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      alignment: Alignment.centerLeft,
      textStyle: kTextButtonStyle,
      backgroundColor: AppColors.textButtonBackground,
      iconColor: AppColors.textButtonForeground,
      iconSize: 50,
      foregroundColor: AppColors.textButtonForeground,
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20), // Padding
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8), // Rounded corners
      ),
    ),
  ),

  colorScheme: ColorScheme.fromSeed(
    primary: AppColors.primary,
    onPrimary: AppColors.onPrimary,
    seedColor: AppColors.accent,
    brightness: Brightness.light,
  ),
);
