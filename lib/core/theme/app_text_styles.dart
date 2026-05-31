import 'package:flutter/material.dart';

class AppTextStyles {
  AppTextStyles._();

  static const TextTheme textTheme = TextTheme(
    displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w700, height: 1.2),
    displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, height: 1.2),
    headlineLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, height: 1.3),
    headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, height: 1.3),
    titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
    titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
    titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
    bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, height: 1.5),
    bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, height: 1.5),
    bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, height: 1.4),
    labelLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    labelMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
    labelSmall: TextStyle(fontSize: 11, fontWeight: FontWeight.w400),
  );

  // Shortcuts
  static const TextStyle titleLarge = TextStyle(fontSize: 18, fontWeight: FontWeight.w600);
  static const TextStyle labelLarge = TextStyle(fontSize: 16, fontWeight: FontWeight.w600);
  static const TextStyle labelSmall = TextStyle(fontSize: 11, fontWeight: FontWeight.w400);
}
