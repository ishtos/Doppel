import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  static const _seed = Color(0xFF1A237E);
  static const _secondary = Color(0xFFFF8F00);
  static const _tertiary = Color(0xFF00695C);
  static const _error = Color(0xFFB71C1C);

  static ThemeData light() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _seed,
      secondary: _secondary,
      tertiary: _tertiary,
      surface: Colors.white,
      error: _error,
    );

    final notoSans = GoogleFonts.notoSansJpTextTheme();

    return ThemeData(
      colorScheme: colorScheme,
      scaffoldBackgroundColor: const Color(0xFFF5F5F7),
      useMaterial3: true,
      textTheme: notoSans.copyWith(
        displayLarge: GoogleFonts.notoSansJp(
          fontSize: 36,
          fontWeight: FontWeight.w700,
        ),
        displayMedium: GoogleFonts.notoSansJp(
          fontSize: 24,
          fontWeight: FontWeight.w700,
        ),
        titleLarge: GoogleFonts.notoSansJp(
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
        titleMedium: GoogleFonts.notoSansJp(
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
        titleSmall: GoogleFonts.notoSansJp(
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
        bodyLarge: GoogleFonts.notoSansJp(
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        bodyMedium: GoogleFonts.notoSansJp(
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        bodySmall: GoogleFonts.notoSansJp(
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        labelLarge: GoogleFonts.ibmPlexMono(
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        indicatorColor: colorScheme.primary.withValues(alpha: 0.12),
      ),
    );
  }

  static ThemeData dark() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _seed,
      brightness: Brightness.dark,
      secondary: _secondary,
      tertiary: _tertiary,
      error: _error,
    );

    return ThemeData(
      colorScheme: colorScheme,
      useMaterial3: true,
      textTheme: GoogleFonts.notoSansJpTextTheme(
        ThemeData(brightness: Brightness.dark).textTheme,
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
