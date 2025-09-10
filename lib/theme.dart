import 'package:flutter/material.dart';

class AppTheme {
  // PCB/Cyber-tech Color Palette
  static const Color deepOffBlack = Color(0xFF0A0A0A);
  static const Color primaryAccent = Color(0xFF00BCD4); // Teal/Cyan
  static const Color secondaryAccent = Color(0xFF76FF03); // Lime Green
  static const Color offWhite = Color(0xFFE0E0E0);
  static const Color lightGrey = Color(0xFFBDBDBD);
  static const Color darkGrey = Color(0xFF424242);
  
  // Status Colors
  static const Color infoColor = Colors.white;
  static const Color warningColor = Color(0xFFFFC107);
  static const Color errorColor = Color(0xFFFF5252);
  static const Color successColor = secondaryAccent;

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primarySwatch: Colors.cyan,
      primaryColor: primaryAccent,
      colorScheme: const ColorScheme.dark(
        primary: primaryAccent,
        secondary: secondaryAccent,
        surface: Color(0xFF1A1A1A),
        background: deepOffBlack,
        onPrimary: deepOffBlack,
        onSecondary: deepOffBlack,
        onSurface: offWhite,
        onBackground: offWhite,
        error: errorColor,
      ),
      
      // Background and scaffolding
      scaffoldBackgroundColor: deepOffBlack,
      canvasColor: deepOffBlack,
      
      // App bar theme
      appBarTheme: const AppBarTheme(
        backgroundColor: deepOffBlack,
        foregroundColor: offWhite,
        elevation: 0,
        centerTitle: true,
      ),
      
      // Card theme with PCB-style borders
      cardTheme: CardTheme(
        color: const Color(0xFF1A1A1A),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: primaryAccent.withOpacity(0.3),
            width: 1,
          ),
        ),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      ),
      
      // Button themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryAccent,
          foregroundColor: deepOffBlack,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      
      // Text button theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryAccent,
        ),
      ),
      
      // Icon button theme
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: offWhite,
          hoverColor: primaryAccent.withOpacity(0.1),
        ),
      ),
      
      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF1A1A1A),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: darkGrey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: darkGrey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryAccent, width: 2),
        ),
        labelStyle: const TextStyle(color: lightGrey),
        hintStyle: TextStyle(color: lightGrey.withOpacity(0.7)),
      ),
      
      // Dropdown theme
      dropdownMenuTheme: DropdownMenuThemeData(
        menuStyle: MenuStyle(
          backgroundColor: MaterialStateProperty.all(const Color(0xFF1A1A1A)),
          side: MaterialStateProperty.all(
            BorderSide(color: primaryAccent.withOpacity(0.3)),
          ),
        ),
      ),
      
      // Progress indicator theme
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: primaryAccent,
        linearTrackColor: Color(0xFF2A2A2A),
      ),
      
      // Expansion tile theme
      expansionTileTheme: const ExpansionTileThemeData(
        backgroundColor: Color(0xFF1A1A1A),
        collapsedBackgroundColor: Color(0xFF1A1A1A),
        textColor: offWhite,
        collapsedTextColor: offWhite,
        iconColor: primaryAccent,
        collapsedIconColor: primaryAccent,
      ),
      
      // Slider theme
      sliderTheme: SliderThemeData(
        activeTrackColor: primaryAccent,
        inactiveTrackColor: darkGrey,
        thumbColor: primaryAccent,
        overlayColor: primaryAccent.withOpacity(0.1),
        valueIndicatorColor: primaryAccent,
        valueIndicatorTextStyle: const TextStyle(
          color: deepOffBlack,
          fontWeight: FontWeight.bold,
        ),
      ),
      
      // Text theme with technical fonts
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontFamily: 'IBMPlexMono',
          color: offWhite,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: TextStyle(
          fontFamily: 'IBMPlexMono',
          color: offWhite,
          fontWeight: FontWeight.w600,
        ),
        displaySmall: TextStyle(
          fontFamily: 'IBMPlexMono',
          color: offWhite,
          fontWeight: FontWeight.w500,
        ),
        headlineLarge: TextStyle(
          fontFamily: 'IBMPlexMono',
          color: offWhite,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          fontFamily: 'IBMPlexMono',
          color: offWhite,
          fontWeight: FontWeight.w600,
        ),
        headlineSmall: TextStyle(
          fontFamily: 'IBMPlexMono',
          color: offWhite,
          fontWeight: FontWeight.w500,
        ),
        titleLarge: TextStyle(
          fontFamily: 'IBMPlexMono',
          color: offWhite,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: TextStyle(
          fontFamily: 'FiraCode',
          color: offWhite,
          fontWeight: FontWeight.w500,
        ),
        titleSmall: TextStyle(
          fontFamily: 'FiraCode',
          color: lightGrey,
          fontWeight: FontWeight.w500,
        ),
        bodyLarge: TextStyle(
          fontFamily: 'FiraCode',
          color: offWhite,
        ),
        bodyMedium: TextStyle(
          fontFamily: 'FiraCode',
          color: offWhite,
        ),
        bodySmall: TextStyle(
          fontFamily: 'FiraCode',
          color: lightGrey,
        ),
        labelLarge: TextStyle(
          fontFamily: 'FiraCode',
          color: offWhite,
          fontWeight: FontWeight.w500,
        ),
        labelMedium: TextStyle(
          fontFamily: 'FiraCode',
          color: lightGrey,
        ),
        labelSmall: TextStyle(
          fontFamily: 'FiraCode',
          color: lightGrey,
          fontSize: 12,
        ),
      ),
      
      // List tile theme
      listTileTheme: const ListTileThemeData(
        textColor: offWhite,
        iconColor: primaryAccent,
      ),
      
      // Divider theme
      dividerTheme: DividerThemeData(
        color: primaryAccent.withOpacity(0.2),
        thickness: 1,
      ),
    );
  }

  // Custom decorations for PCB-style borders
  static BoxDecoration get pcbBorderDecoration {
    return BoxDecoration(
      color: const Color(0xFF1A1A1A),
      border: Border.all(
        color: primaryAccent.withOpacity(0.3),
        width: 1,
      ),
      borderRadius: BorderRadius.circular(8),
    );
  }

  static BoxDecoration get glowBorderDecoration {
    return BoxDecoration(
      color: const Color(0xFF1A1A1A),
      border: Border.all(
        color: primaryAccent,
        width: 2,
      ),
      borderRadius: BorderRadius.circular(8),
      boxShadow: [
        BoxShadow(
          color: primaryAccent.withOpacity(0.3),
          blurRadius: 8,
          spreadRadius: 2,
        ),
      ],
    );
  }
}