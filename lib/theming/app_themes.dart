import 'package:flutter/material.dart';

abstract class AppThemes {
  static final darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.deepPurpleAccent,
      brightness: Brightness.dark,
      primary: Colors.deepPurpleAccent,
      onPrimary: Colors.white,
      secondary: Colors.purpleAccent,
      onSecondary: Colors.white,
      error: Colors.red,
      onError: Colors.white,
      surface: Colors.black,
      onSurface: Colors.white,
      tertiary: Colors.deepPurpleAccent,
      onTertiary: Colors.white,
      surfaceTint: Colors.deepPurpleAccent,
    ),
    appBarTheme: const AppBarTheme(
      color: Colors.deepPurple,
      foregroundColor: Colors.white,
      shadowColor: Colors.deepPurple,
      surfaceTintColor: Colors.deepPurple,
      elevation: 0,
    ),
  );

  static final lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.deepPurpleAccent,
      brightness: Brightness.light,
      primary: Colors.deepPurpleAccent,
      onPrimary: Colors.black,
      secondary: Colors.purpleAccent,
      onSecondary: Colors.black,
      error: Colors.red,
      onError: Colors.white,
      surface: Colors.white,
      onSurface: Colors.black,
      tertiary: Colors.deepPurpleAccent,
      onTertiary: Colors.white,
      surfaceTint: Colors.deepPurpleAccent,
    ),
    appBarTheme: const AppBarTheme(
      color: Colors.deepPurple,
      foregroundColor: Colors.white,
      shadowColor: Colors.deepPurple,
      surfaceTintColor: Colors.deepPurple,
      elevation: 0,
    ),
  );
}
