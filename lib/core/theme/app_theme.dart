import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const ink = Color(0xFF05070A);
  static const panel = Color(0xFF0D1117);
  static const panelAlt = Color(0xFF111827);
  static const neon = Color(0xFF42FF9E);
  static const cyan = Color(0xFF22D3EE);
  static const magenta = Color(0xFFFF4FD8);
  static const amber = Color(0xFFFBBF24);
  static const danger = Color(0xFFFF5C7A);

  static ThemeData dark() {
    final textTheme = GoogleFonts.spaceMonoTextTheme(
      ThemeData.dark().textTheme,
    );

    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: ink,
      colorScheme: const ColorScheme.dark(
        primary: neon,
        secondary: cyan,
        tertiary: magenta,
        surface: panel,
        error: danger,
      ),
      textTheme: textTheme.apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
      ),
      useMaterial3: true,
      cardTheme: CardThemeData(
        color: panel.withValues(alpha: 0.86),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: neon.withValues(alpha: 0.16)),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: neon,
          foregroundColor: ink,
          textStyle: const TextStyle(fontWeight: FontWeight.w800),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: panelAlt,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: neon.withValues(alpha: 0.25)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: neon.withValues(alpha: 0.18)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: neon, width: 1.4),
        ),
      ),
    );
  }
}
