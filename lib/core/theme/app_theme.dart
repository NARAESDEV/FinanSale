import 'package:flutter/material.dart';

class NaraesColors {
  static const Color primaryBlue = Color(0xFF3E77BC);
  static const Color background = Color(0xFFF9FCFF);
  static const Color darkText = Color(0xFF1E293B);
  static const Color greyText = Color(0xFF64748B);
}

class NaraesTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: NaraesColors.primaryBlue),
      scaffoldBackgroundColor: NaraesColors.background,
      fontFamily: 'Inter', // Asegúrate de agregarla en pubspec.yaml después
    );
  }
}
