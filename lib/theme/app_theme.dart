import 'package:flutter/material.dart';

class AppTheme {
  // PCB/Cyber-Tech Color Palette
  static const Color deepOffBlack = Color(0xFF0A0A0A);
  static const Color tealCyan = Color(0xFF00D4AA);
  static const Color limeGreen = Color(0xFF39FF14);
  static const Color lightGray = Color(0xFFE0E0E0);
  static const Color white = Color(0xFFFFFFFF);
  static const Color darkGray = Color(0xFF1A1A1A);
  static const Color mediumGray = Color(0xFF2A2A2A);
  static const Color cardGray = Color(0xFF121212);
  
  // Status colors
  static const Color errorRed = Color(0xFFFF3366);
  static const Color warningOrange = Color(0xFFFF9500);
  static const Color infoBlue = Color(0xFF0099FF);

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      
      // Color scheme
      colorScheme: const ColorScheme.dark(
        background: deepOffBlack,
        surface: cardGray,
        primary: tealCyan,
        secondary: limeGreen,
        onBackground: lightGray,
        onSurface: lightGray,
        onPrimary: deepOffBlack,
        onSecondary: deepOffBlack,
        error: errorRed,
      ),
      
      // Scaffold
      scaffoldBackgroundColor: deepOffBlack,
      
      // App Bar
      appBarTheme: const AppBarTheme(
        backgroundColor: deepOffBlack,
        foregroundColor: lightGray,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: lightGray,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: 'monospace',
        ),
      ),
      
      // Cards
      cardTheme: CardTheme(
        color: cardGray,
        elevation: 8,
        shadowColor: tealCyan.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: tealCyan.withOpacity(0.3),
            width: 1,
          ),
        ),
      ),
      
      // Buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: tealCyan,
          foregroundColor: deepOffBlack,
          elevation: 4,
          shadowColor: tealCyan.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontFamily: 'monospace',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: tealCyan,
          side: const BorderSide(color: tealCyan, width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontFamily: 'monospace',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      
      // Text Theme
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: lightGray,
          fontSize: 32,
          fontWeight: FontWeight.bold,
          fontFamily: 'monospace',
        ),
        headlineMedium: TextStyle(
          color: lightGray,
          fontSize: 24,
          fontWeight: FontWeight.bold,
          fontFamily: 'monospace',
        ),
        headlineSmall: TextStyle(
          color: lightGray,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: 'monospace',
        ),
        bodyLarge: TextStyle(
          color: lightGray,
          fontSize: 16,
          fontFamily: 'monospace',
        ),
        bodyMedium: TextStyle(
          color: lightGray,
          fontSize: 14,
          fontFamily: 'monospace',
        ),
        bodySmall: TextStyle(
          color: lightGray,
          fontSize: 12,
          fontFamily: 'monospace',
        ),
        labelLarge: TextStyle(
          color: lightGray,
          fontSize: 14,
          fontWeight: FontWeight.bold,
          fontFamily: 'monospace',
        ),
      ),
      
      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: mediumGray,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: tealCyan.withOpacity(0.5)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: tealCyan.withOpacity(0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: tealCyan, width: 2),
        ),
        labelStyle: const TextStyle(
          color: lightGray,
          fontFamily: 'monospace',
        ),
        hintStyle: TextStyle(
          color: lightGray.withOpacity(0.6),
          fontFamily: 'monospace',
        ),
      ),
      
      // Progress Indicator
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: tealCyan,
        linearTrackColor: mediumGray,
      ),
      
      // Dropdown
      dropdownMenuTheme: DropdownMenuThemeData(
        textStyle: const TextStyle(
          color: lightGray,
          fontFamily: 'monospace',
        ),
        menuStyle: MenuStyle(
          backgroundColor: MaterialStateProperty.all(cardGray),
          surfaceTintColor: MaterialStateProperty.all(tealCyan),
        ),
      ),
      
      // Slider
      sliderTheme: SliderThemeData(
        activeTrackColor: tealCyan,
        inactiveTrackColor: mediumGray,
        thumbColor: tealCyan,
        overlayColor: tealCyan.withOpacity(0.2),
        valueIndicatorColor: tealCyan,
        valueIndicatorTextStyle: const TextStyle(
          color: deepOffBlack,
          fontFamily: 'monospace',
          fontWeight: FontWeight.bold,
        ),
      ),
      
      // Expansion Tile
      expansionTileTheme: ExpansionTileThemeData(
        backgroundColor: cardGray,
        collapsedBackgroundColor: cardGray,
        textColor: lightGray,
        collapsedTextColor: lightGray,
        iconColor: tealCyan,
        collapsedIconColor: tealCyan,
        childrenPadding: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: tealCyan.withOpacity(0.3)),
        ),
        collapsedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: tealCyan.withOpacity(0.3)),
        ),
      ),
    );
  }
  
  // Console text styles for different log levels
  static TextStyle get consoleTextStyle {
    return const TextStyle(
      fontFamily: 'monospace',
      fontSize: 12,
      color: lightGray,
      height: 1.2,
    );
  }
  
  static TextStyle get consoleInfoStyle {
    return consoleTextStyle.copyWith(color: infoBlue);
  }
  
  static TextStyle get consoleWarningStyle {
    return consoleTextStyle.copyWith(color: warningOrange);
  }
  
  static TextStyle get consoleErrorStyle {
    return consoleTextStyle.copyWith(color: errorRed);
  }
  
  static TextStyle get consoleSuccessStyle {
    return consoleTextStyle.copyWith(color: limeGreen);
  }
  
  // PCB circuit pattern decoration
  static BoxDecoration get pcbDecoration {
    return BoxDecoration(
      border: Border.all(
        color: tealCyan.withOpacity(0.3),
        width: 1,
      ),
      borderRadius: BorderRadius.circular(8),
      gradient: LinearGradient(
        colors: [
          deepOffBlack,
          cardGray.withOpacity(0.5),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      boxShadow: [
        BoxShadow(
          color: tealCyan.withOpacity(0.1),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }
  
  // Glow effect for active buttons
  static BoxDecoration get glowDecoration {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      boxShadow: [
        BoxShadow(
          color: tealCyan.withOpacity(0.3),
          blurRadius: 12,
          spreadRadius: 2,
        ),
      ],
    );
  }
}