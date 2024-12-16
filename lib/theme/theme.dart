import 'package:flutter/material.dart';
import 'package:real_estate_app/theme/app_color.dart';

class ThemeDataStyle {
  static ThemeData light = ThemeData(
    useMaterial3: true,
    colorScheme:
    ColorScheme.light(
      primary: AppColor.backgroundColorPrimary,
      secondary: AppColor.backgroundColorSecondary,
      primaryContainer: AppColor.backgroundColorPrimary,
      secondaryContainer: AppColor.backgroundColorSecondary,
    ),
    scaffoldBackgroundColor: AppColor.backgroundColorSecondary,
    cardColor: AppColor.backgroundColorPrimary,
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColor.backgroundColorPrimary,
      selectedItemColor: AppColor.backgroundColorDarkSecondary,
      unselectedItemColor: AppColor.backgroundColorDarkTertiary,
    ),
    textTheme: TextTheme(
        titleLarge: TextStyle(color: AppColor.textColorSecondary),
        titleMedium: TextStyle(color: AppColor.backgroundColorSecondary)),
    appBarTheme:
        AppBarTheme(backgroundColor: AppColor.backgroundColorSecondary),
  );

  static ThemeData dark = ThemeData(
    useMaterial3: true,
    colorScheme:
        ColorScheme.light(
      primary: AppColor.backgroundColorDarkPrimary,
      secondary: AppColor.backgroundColorDarkSecondary,
      primaryContainer: AppColor.backgroundColorDarkPrimary,
      secondaryContainer: AppColor.backgroundColorDarkSecondary,
    ),
    scaffoldBackgroundColor: AppColor.backgroundColorDarkSecondary,
    cardColor: AppColor.backgroundColorDarkPrimary,
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColor.backgroundColorDarkPrimary,
      selectedItemColor: AppColor.backgroundColorSecondary,
      unselectedItemColor: AppColor.backgroundColorTertiary,
    ),
    textTheme: TextTheme(
      titleLarge: TextStyle(color: AppColor.textColorDarkSecondary),
      titleMedium: TextStyle(color: AppColor.backgroundColorDarkPrimary),
    ),
    appBarTheme:
        AppBarTheme(backgroundColor: AppColor.backgroundColorDarkSecondary),
  );
}
