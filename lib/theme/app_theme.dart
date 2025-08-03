import 'package:flutter/material.dart';

class AppTheme {
  // Light Theme Colors
  static const Color _lightPrimary = Colors.lightBlue;
  static const Color _lightAccent = Colors.lightBlueAccent;
  static const Color _lightBackground = Color.fromARGB(255, 230, 230, 230);
  static const Color _lightTextbox = Color.fromARGB(255, 240, 240, 240);
  static const Color _lightCard = Colors.white;
  static const Color _lightText = Colors.black87;
  static const Color _lightHint = Colors.black38;
  static const Color _lightDisabled = Colors.grey;
  static const Color _lightError = Colors.redAccent;

  // Dark Theme Colors
  static const Color _darkPrimary = Colors.lightBlue;
  static const Color _darkAccent = Colors.lightBlueAccent;
  static const Color _darkBackground = Color.fromARGB(255, 60, 60, 60);
  static const Color _darkTextbox = Color.fromARGB(255, 55, 55, 55);
  static const Color _darkCard = Color.fromARGB(255, 50, 50, 50);
  static const Color _darkText = Color(0xFFE0E0E0);
  static const Color _darkHint = Color(0xFFB0BEC5);
  static const Color _darkDisabled = Color(0xFF616161);
  static const Color _darkError = Color(0xFFEF5350);

  static ThemeData light = ThemeData(
    brightness: Brightness.light,
    primaryColor: _lightPrimary,
    colorScheme: ColorScheme.light(
      primary: _lightPrimary,
      secondary: _lightAccent,
      surface: _lightBackground,
      error: _lightError,
    ),
    scaffoldBackgroundColor: _lightBackground,
    cardColor: _lightCard,
    textTheme: const TextTheme(
      displayMedium: TextStyle(
        fontSize: 64,
        fontWeight: FontWeight.bold,
        color: _lightPrimary,
      ),
      titleMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: _lightText,
      ),
      bodyLarge: TextStyle(fontSize: 16, color: _lightText),
      bodyMedium: TextStyle(fontSize: 16, color: _lightText),
      titleSmall: TextStyle(fontSize: 18, color: _lightText),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: _lightDisabled),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: _lightPrimary, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      filled: true,
      fillColor: _lightTextbox,
      hintStyle: const TextStyle(color: _lightHint),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
    cardTheme: CardThemeData(
      color: _lightCard,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _lightPrimary,
        foregroundColor: Colors.white,
        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      ),
    ),
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: _lightPrimary,
      contentTextStyle: TextStyle(color: Colors.white, fontSize: 16),
    ),
    dividerTheme: const DividerThemeData(
      color: _lightDisabled,
      thickness: 1,
      space: 32,
    ),
    disabledColor: _lightDisabled,
  );

  static ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    primaryColor: _darkPrimary,
    colorScheme: ColorScheme.dark(
      primary: _darkPrimary,
      secondary: _darkAccent,
      surface: _darkBackground,
      error: _darkError,
    ),
    scaffoldBackgroundColor: _darkBackground,
    cardColor: _darkCard,
    textTheme: const TextTheme(
      displayMedium: TextStyle(
        fontSize: 64,
        fontWeight: FontWeight.bold,
        color: _darkPrimary,
      ),
      titleMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: _darkText,
      ),
      bodyLarge: TextStyle(fontSize: 16, color: _darkText),
      bodyMedium: TextStyle(fontSize: 16, color: _darkText),
      titleSmall: TextStyle(fontSize: 18, color: _darkText),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: _darkDisabled),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: _darkPrimary, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      filled: true,
      fillColor: _darkTextbox,
      hintStyle: const TextStyle(color: _darkHint),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
    cardTheme: CardThemeData(
      color: _darkCard,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 2,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _darkPrimary,
        foregroundColor: _darkText,
        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      ),
    ),
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: _darkPrimary,
      contentTextStyle: TextStyle(color: Colors.black, fontSize: 16),
    ),
    dividerTheme: const DividerThemeData(
      color: _darkDisabled,
      thickness: 1,
      space: 32,
    ),
    disabledColor: _darkDisabled,
  );
}
