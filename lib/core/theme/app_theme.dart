import 'package:flutter/material.dart';

class NaraesColors {
  static const Color primaryBlue = Color(0xFF3E77BC);
  static const Color background = Color(0xFFF4F8FC);
  static const Color darkText = Color(0xFF1E293B);
  static const Color greyText = Color(0xFF64748B);
  static const Color mutedIcon = Color(0xFF94A3B8);
  static const Color border = Color(0xFFE2E8F0);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color navSurface = Color(0xFFFCFDFE);
}

class NaraesTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: NaraesColors.primaryBlue,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: NaraesColors.background,
      fontFamily: 'Inter',
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      appBarTheme: const AppBarTheme(
        backgroundColor: NaraesColors.primaryBlue,
        foregroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
    );
  }
}
