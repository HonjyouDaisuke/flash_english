import 'package:flutter/material.dart';

class AppTheme {
  static final light = ThemeData(
    brightness: Brightness.light,
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xFF0D47A1),
      onPrimary: Colors.white,
      secondary: Color(0xFF81D4FA),
      onSecondary: Colors.black,
      tertiary: Color(0xFF66BB6A),
      onTertiary: Colors.white,
      surface: Color(0xFFB3E5FC),
      onSurface: Color(0xFF0D47A1),
      error: Color(0xFFEF5350),
      onError: Colors.white,
    ),
    scaffoldBackgroundColor: const Color(0xFFE1F5FE),
  );
  static final dark = ThemeData(
    brightness: Brightness.dark,
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xFF03A9F4),
      onPrimary: Colors.black,
      secondary: Color(0xFF29B6F6),
      onSecondary: Colors.black,
      tertiary: Color(0xFF388E3C),
      onTertiary: Colors.white,
      surface: Color(0xFF1E1E1E),
      onSurface: Color(0xFFE0F7FA),
      error: Color(0xFFD32F2F),
      onError: Colors.white,
    ),
    scaffoldBackgroundColor: const Color(0xFF121212),
  );
}
