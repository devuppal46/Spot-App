import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Spot's single accent colour: a warm vermilion, like a festival marigold.
const spotAccent = Color(0xFFE4572E);

/// Spacing scale used across the app, so screens line up with each other.
abstract final class Gap {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 16.0;
  static const lg = 24.0;
  static const xl = 32.0;
}

ThemeData buildSpotTheme(Brightness brightness) {
  final isDark = brightness == Brightness.dark;
  final colors =
      ColorScheme.fromSeed(
        seedColor: spotAccent,
        brightness: brightness,
      ).copyWith(
        primary: spotAccent,
        onPrimary: Colors.white,
        surface: isDark ? const Color(0xFF16130F) : const Color(0xFFFBF8F3),
      );

  final body = GoogleFonts.dmSansTextTheme(
    ThemeData(brightness: brightness).textTheme,
  );
  final display = GoogleFonts.frauncesTextTheme(body);
  final textTheme = body.copyWith(
    displaySmall: display.displaySmall?.copyWith(fontWeight: FontWeight.w600),
    headlineMedium: display.headlineMedium?.copyWith(
      fontWeight: FontWeight.w600,
    ),
    headlineSmall: display.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
    titleLarge: display.titleLarge?.copyWith(fontWeight: FontWeight.w600),
  );

  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme: colors,
    scaffoldBackgroundColor: colors.surface,
    textTheme: textTheme,
    appBarTheme: AppBarTheme(
      backgroundColor: colors.surface,
      foregroundColor: colors.onSurface,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleTextStyle: textTheme.titleLarge?.copyWith(color: colors.onSurface),
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      color: isDark ? const Color(0xFF221E19) : Colors.white,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: colors.outlineVariant.withValues(alpha: 0.5)),
      ),
    ),
    chipTheme: ChipThemeData(
      shape: const StadiumBorder(),
      side: BorderSide(color: colors.outlineVariant),
      labelStyle: textTheme.labelLarge,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(0, 52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(0, 52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: isDark ? const Color(0xFF221E19) : Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: colors.outlineVariant),
      ),
    ),
    snackBarTheme: const SnackBarThemeData(behavior: SnackBarBehavior.floating),
  );
}
