import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // PCB/Cyber Color Palette - Enhanced Blue Theme
  static const Color deepOffBlack = Color(0xFF0A0A0A);
  static const Color tealAccent = Color(0xFF00FFD4); // Keep for compatibility
  static const Color electricBlue = Color(0xFF0080FF); // Primary blue for neon effects
  static const Color cyanBlue = Color(0xFF00C0FF); // Secondary blue
  static const Color neonBlue = Color(0xFF40E0FF); // Bright neon blue for glow
  static const Color cyanAccent = Color(0xFF00E5FF);
  static const Color limeGreen = Color(0xFF76FF03);
  static const Color lightGray = Color(0xFFE0E0E0);
  static const Color mediumGray = Color(0xFF9E9E9E);
  static const Color darkGray = Color(0xFF2E2E2E);
  static const Color circuitGreen = Color(0xFF4CAF50);
  static const Color warningAmber = Color(0xFFFF9800);
  static const Color errorRed = Color(0xFFF44336);
  
  // Text Colors for Log Levels
  static const Color infoColor = Color(0xFF2196F3);
  static const Color warningColor = Color(0xFFFF9800);
  static const Color errorColor = Color(0xFFF44336);
  static const Color successColor = Color(0xFF76FF03);

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: deepOffBlack,
      
      colorScheme: const ColorScheme.dark(
        primary: tealAccent,
        onPrimary: deepOffBlack,
        secondary: cyanAccent,
        onSecondary: deepOffBlack,
        surface: darkGray,
        onSurface: lightGray,
        background: deepOffBlack,
        onBackground: lightGray,
        error: errorRed,
        onError: lightGray,
      ),
      
      // App Bar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: deepOffBlack,
        foregroundColor: lightGray,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.firaCode(
          color: tealAccent,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      
      // Card Theme
      cardTheme: CardTheme(
        color: darkGray,
        elevation: 4,
        shadowColor: tealAccent.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: tealAccent.withOpacity(0.3),
            width: 1,
          ),
        ),
      ),
      
      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: tealAccent,
          foregroundColor: deepOffBlack,
          elevation: 2,
          shadowColor: tealAccent.withOpacity(0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: GoogleFonts.firaCode(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: cyanAccent,
          textStyle: GoogleFonts.firaCode(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      
      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkGray,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: mediumGray),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: mediumGray),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: tealAccent, width: 2),
        ),
        labelStyle: GoogleFonts.firaCode(
          color: mediumGray,
        ),
        hintStyle: GoogleFonts.firaCode(
          color: mediumGray.withOpacity(0.7),
        ),
      ),
      
      // Dropdown Theme
      dropdownMenuTheme: DropdownMenuThemeData(
        menuStyle: MenuStyle(
          backgroundColor: MaterialStateProperty.all(darkGray),
          elevation: MaterialStateProperty.all(8),
          shadowColor: MaterialStateProperty.all(tealAccent.withOpacity(0.2)),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(color: tealAccent.withOpacity(0.3)),
            ),
          ),
        ),
        textStyle: GoogleFonts.firaCode(
          color: lightGray,
          fontSize: 14,
        ),
      ),
      
      // Progress Indicator Theme
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: tealAccent,
        linearTrackColor: darkGray,
      ),
      
      // Slider Theme
      sliderTheme: SliderThemeData(
        activeTrackColor: tealAccent,
        inactiveTrackColor: darkGray,
        thumbColor: tealAccent,
        overlayColor: tealAccent.withOpacity(0.2),
        valueIndicatorColor: tealAccent,
        valueIndicatorTextStyle: GoogleFonts.firaCode(
          color: deepOffBlack,
          fontSize: 12,
        ),
      ),
      
      // ExpansionTile Theme
      expansionTileTheme: const ExpansionTileThemeData(
        backgroundColor: darkGray,
        collapsedBackgroundColor: darkGray,
        iconColor: tealAccent,
        collapsedIconColor: mediumGray,
        textColor: lightGray,
        collapsedTextColor: lightGray,
      ),
      
      // Text Theme
      textTheme: GoogleFonts.firaCodeTextTheme().copyWith(
        displayLarge: GoogleFonts.firaCode(
          color: lightGray,
          fontSize: 32,
          fontWeight: FontWeight.w300,
        ),
        displayMedium: GoogleFonts.firaCode(
          color: lightGray,
          fontSize: 28,
          fontWeight: FontWeight.w400,
        ),
        displaySmall: GoogleFonts.firaCode(
          color: lightGray,
          fontSize: 24,
          fontWeight: FontWeight.w400,
        ),
        headlineLarge: GoogleFonts.firaCode(
          color: tealAccent,
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
        headlineMedium: GoogleFonts.firaCode(
          color: tealAccent,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
        headlineSmall: GoogleFonts.firaCode(
          color: tealAccent,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        bodyLarge: GoogleFonts.firaCode(
          color: lightGray,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        bodyMedium: GoogleFonts.firaCode(
          color: lightGray,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        bodySmall: GoogleFonts.firaCode(
          color: mediumGray,
          fontSize: 11,
          fontWeight: FontWeight.w400,
        ),
        labelLarge: GoogleFonts.firaCode(
          color: lightGray,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        labelMedium: GoogleFonts.firaCode(
          color: lightGray,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        labelSmall: GoogleFonts.firaCode(
          color: mediumGray,
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
      
      // Icon Theme
      iconTheme: const IconThemeData(
        color: tealAccent,
        size: 24,
      ),
    );
  }
}