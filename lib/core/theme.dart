import 'package:flutter/material.dart';

final ThemeData blueLightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  colorScheme: const ColorScheme.light(
    primary: Color(0xFF2962FF), // Blue 700
    onPrimary: Colors.white,
    primaryContainer: Color(0xFFE3F2FD), // Blue 50
    onPrimaryContainer: Color(0xFF0039CB), // Blue 900
    background: Colors.white,
    onBackground: Color(0xFF212121),
    surface: Colors.white,
    onSurface: Color(0xFF212121),
    secondary: Color(0xFF90CAF9), // Blue 200
    onSecondary: Colors.black,
    outline: Color(0xFFB0BEC5), // Gray 300
  ),
);

final ThemeData blueDarkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  colorScheme: const ColorScheme.dark(
    primary: Color(0xFF82B1FF), // Blue A100
    onPrimary: Color(0xFF0039CB),
    primaryContainer: Color(0xFF0039CB),
    onPrimaryContainer: Color(0xFFE3F2FD),
    background: Color(0xFF121212),
    onBackground: Color(0xFFE3F2FD),
    surface: Color(0xFF1E1E1E),
    onSurface: Color(0xFFE0E0E0),
    secondary: Color(0xFF448AFF), // Blue A200
    onSecondary: Colors.white,
    outline: Color(0xFF90A4AE), // Gray 500
  ),
);
