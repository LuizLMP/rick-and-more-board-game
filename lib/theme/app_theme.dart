import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      scaffoldBackgroundColor: const Color(0xFF24c3d4),
      textTheme: const TextTheme(
        bodyMedium: TextStyle(color: Colors.black87),
        bodyLarge: TextStyle(color: Colors.black87),
        titleMedium: TextStyle(color: Colors.black87),
        titleLarge: TextStyle(color: Colors.black87),
      ),
      appBarTheme: const AppBarTheme(backgroundColor: Colors.white),
      cardTheme: CardTheme(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
