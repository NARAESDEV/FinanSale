import 'package:flutter/material.dart';

class NaraesColors {
  // Light palette
  static const Color primaryBlue = Color(0xFF3E77BC);
  static const Color background = Color(0xFFF4F8FC);
  static const Color darkText = Color(0xFF1E293B);
  static const Color greyText = Color(0xFF64748B);
  static const Color mutedIcon = Color(0xFF94A3B8);
  static const Color border = Color(0xFFE2E8F0);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color navSurface = Color(0xFFFCFDFE);

  // Dark palette — GitHub Dark / Linear / Notion inspired
  static const Color darkPrimary = Color(0xFF5B9CFF);
  static const Color darkBackground = Color(0xFF0F172A);
  static const Color darkSurface = Color(0xFF1E293B);
  static const Color darkBorder = Color(0xFF334155);
  static const Color darkTextPrimary = Color(0xFFF8FAFC);
  static const Color darkTextSecondary = Color(0xFFCBD5E1);
  static const Color darkMutedIcon = Color(0xFF64748B);
  static const Color darkNavSurface = Color(0xFF1E293B);
}

class NaraesTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: NaraesColors.primaryBlue,
        brightness: Brightness.light,
        surface: NaraesColors.surface,
      ),
      scaffoldBackgroundColor: NaraesColors.background,
      fontFamily: 'Inter',
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      cardColor: NaraesColors.surface,
      dividerColor: NaraesColors.border,
      appBarTheme: const AppBarTheme(
        backgroundColor: NaraesColors.primaryBlue,
        foregroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        fillColor: const Color(0xFFF9FCFF),
        filled: true,
        hintStyle: const TextStyle(color: NaraesColors.greyText),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: NaraesColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: NaraesColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: NaraesColors.primaryBlue,
            width: 1.5,
          ),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    const colorScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: NaraesColors.darkPrimary,
      onPrimary: Colors.white,
      secondary: NaraesColors.darkTextSecondary,
      onSecondary: NaraesColors.darkBackground,
      error: Color(0xFFEF4444),
      onError: Colors.white,
      surface: NaraesColors.darkSurface,
      onSurface: NaraesColors.darkTextPrimary,
      surfaceContainerHighest: Color(0xFF2D3F55),
      outline: NaraesColors.darkBorder,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: NaraesColors.darkBackground,
      fontFamily: 'Inter',
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      cardColor: NaraesColors.darkSurface,
      dividerColor: NaraesColors.darkBorder,
      dialogTheme: const DialogThemeData(
        backgroundColor: NaraesColors.darkSurface,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF3E77BC),
        foregroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        fillColor: const Color(0xFF0F172A),
        filled: true,
        hintStyle: const TextStyle(color: NaraesColors.darkMutedIcon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: NaraesColors.darkBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: NaraesColors.darkBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: NaraesColors.darkPrimary,
            width: 1.5,
          ),
        ),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: NaraesColors.darkTextPrimary),
        bodyMedium: TextStyle(color: NaraesColors.darkTextPrimary),
        bodySmall: TextStyle(color: NaraesColors.darkTextSecondary),
        titleLarge: TextStyle(color: NaraesColors.darkTextPrimary),
        titleMedium: TextStyle(color: NaraesColors.darkTextPrimary),
        titleSmall: TextStyle(color: NaraesColors.darkTextSecondary),
        labelLarge: TextStyle(color: NaraesColors.darkTextPrimary),
        labelMedium: TextStyle(color: NaraesColors.darkTextSecondary),
        labelSmall: TextStyle(color: NaraesColors.darkTextSecondary),
      ),
      listTileTheme: const ListTileThemeData(
        textColor: NaraesColors.darkTextPrimary,
        iconColor: NaraesColors.darkTextSecondary,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? NaraesColors.darkPrimary
              : NaraesColors.darkMutedIcon,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? NaraesColors.darkPrimary.withValues(alpha: 0.3)
              : NaraesColors.darkBorder,
        ),
      ),
    );
  }
}
