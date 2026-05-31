import 'package:flutter/material.dart';

/// Paleta de colores de la app.
/// Cambia primary/secondary según tu marca.
class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF1A73E8);
  static const Color secondary = Color(0xFF03DAC6);
  static const Color error = Color(0xFFE53935);
  static const Color success = Color(0xFF43A047);
  static const Color warning = Color(0xFFFB8C00);

  // Surface
  static const Color surfaceLight = Color(0xFFFAFAFA);
  static const Color surfaceDark = Color(0xFF1C1C1E);

  // Text
  static const Color textPrimaryLight = Color(0xFF111111);
  static const Color textPrimaryDark = Color(0xFFF5F5F5);
  static const Color textSecondaryLight = Color(0xFF757575);
  static const Color textSecondaryDark = Color(0xFFAAAAAA);
}
