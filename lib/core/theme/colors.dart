import 'package:flutter/material.dart';

class AppColors {
  static final ColorScheme blueLightTheme = ColorScheme.fromSeed(
    seedColor: const Color(0xFF2962FF),
    onPrimary: Colors.white,
    primaryContainer: const Color(0xFFE3F2FD),
    onPrimaryContainer: const Color(0xFF0039CB),
    surface: Colors.white,
    secondary: const Color(0xFF90CAF9),
    onSecondary: Colors.black,
    outline: const Color(0xFFB0BEC5),
    shadow: Colors.black26,
  );

  static final ColorScheme blueDarkTheme = ColorScheme.fromSeed(
    brightness: Brightness.dark,
    seedColor: const Color(0xFF82B1FF),
    onPrimary: const Color(0xFF0039CB),
    primaryContainer: const Color(0xFF0039CB),
    onPrimaryContainer: const Color(0xFFE3F2FD),
    surface: const Color(0xFF121212),
    secondary: const Color(0xFFE0E0E0),
    onSecondary: Colors.white,
    outline: const Color(0xFF90A4AE),
    shadow: Colors.black26,
  );
}
