import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  static const Color background    = Color(0xFF0A0E17);
  static const Color surface       = Color(0xFF111827);
  static const Color surfaceElevated = Color(0xFF1C2537);
  static const Color border        = Color(0xFF1E2D45);

  static const Color accent        = Color(0xFF00D4FF);
  static const Color accentDim     = Color(0xFF0099BB);

  static const Color gainGreen     = Color(0xFF00E676);
  static const Color gainGreenDim  = Color(0xFF1B3A2C);
  static const Color lossRed       = Color(0xFFFF3B5C);
  static const Color lossRedDim    = Color(0xFF3A1B22);
  static const Color neutralGold   = Color(0xFFFFBB33);

  static const Color textPrimary   = Color(0xFFF0F4FF);
  static const Color textSecondary = Color(0xFF8899BB);
  static const Color textMuted     = Color(0xFF445577);

  static const Color dragHandle    = Color(0xFF2A3F5F);
  static const Color reorderHighlight = Color(0xFF1A2840);

  static TextTheme get _textTheme => GoogleFonts.spaceGroteskTextTheme(
        const TextTheme(
          displayLarge: TextStyle(color: textPrimary),
          displayMedium: TextStyle(color: textPrimary),
          headlineLarge: TextStyle(color: textPrimary),
          headlineMedium: TextStyle(color: textPrimary),
          headlineSmall: TextStyle(color: textPrimary),
          titleLarge: TextStyle(color: textPrimary),
          titleMedium: TextStyle(color: textSecondary),
          titleSmall: TextStyle(color: textSecondary),
          bodyLarge: TextStyle(color: textPrimary),
          bodyMedium: TextStyle(color: textSecondary),
          bodySmall: TextStyle(color: textMuted),
          labelLarge: TextStyle(color: textPrimary),
          labelMedium: TextStyle(color: textSecondary),
          labelSmall: TextStyle(color: textMuted),
        ),
      );

  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      colorScheme: const ColorScheme.dark(
        surface: surface,
        primary: accent,
        secondary: gainGreen,
        error: lossRed,
        onSurface: textPrimary,
      ),
      textTheme: _textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.spaceGrotesk(
          color: textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
        ),
        iconTheme: const IconThemeData(color: textPrimary),
      ),
      dividerTheme: const DividerThemeData(
        color: border,
        space: 0,
        thickness: 0.5,
      ),
      iconTheme: const IconThemeData(color: textSecondary, size: 20),
    );
  }
}

extension AppTextStyles on BuildContext {
  TextStyle get symbolStyle => GoogleFonts.spaceGrotesk(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        color: AppTheme.textPrimary,
        letterSpacing: 0.5,
      );

  TextStyle get companyStyle => GoogleFonts.spaceGrotesk(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppTheme.textSecondary,
      );

  TextStyle get priceStyle => GoogleFonts.jetBrainsMono(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: AppTheme.textPrimary,
      );

  TextStyle changeStyle({required bool isPositive}) =>
      GoogleFonts.jetBrainsMono(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: isPositive ? AppTheme.gainGreen : AppTheme.lossRed,
      );
}
