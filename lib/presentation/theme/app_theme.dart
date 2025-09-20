import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Custom color scheme
  static const Color primaryColor = Color(0xFF5A4E3C);
  static const Color backgroundColor = Color(0xFFFCF9F2);
  
  // Additional colors for the app
  static const Color primaryDark = Color(0xFF3D342A);
  static const Color primaryLight = Color(0xFF7A6E5C);
  static const Color surfaceVariant = Color(0xFFF5F1E8);
  static const Color onSurface = Color(0xFF2C2419);
  
  // Button specific colors
  static const Color readMoreButtonColor = Color(0xFF8D7C63);
  static const Color listenToAudioButtonColor = Color(0xFF5A4E3C);
  static const Color buttonTextColor = Color(0xFFFCF9F2);
  static const Color bodyTextColor = Color(0xFF25221E);
  
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
          brightness: Brightness.light,
          surface: backgroundColor,
          onSurface: const Color(0xFF1A1612), // Dark text on light background
        ),
        scaffoldBackgroundColor: backgroundColor,
        textTheme: _textTheme,
      );
      
  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
          brightness: Brightness.dark,
          onSurface: const Color(0xFF1A1612), // Keep dark text even in dark mode
        ),
        scaffoldBackgroundColor: backgroundColor, // Use the same warm cream background
        textTheme: _textTheme,
      );

  static TextTheme get _textTheme => TextTheme(
    // Display styles - using Roboto Serif for headings and display text
    displayLarge: GoogleFonts.robotoSlab(
      fontSize: 57,
      fontWeight: FontWeight.w400,
      letterSpacing: -0.25,
    ),
    displayMedium: GoogleFonts.robotoSlab(
      fontSize: 45,
      fontWeight: FontWeight.w400,
    ),
    displaySmall: GoogleFonts.robotoSlab(
      fontSize: 36,
      fontWeight: FontWeight.w400,
    ),
    
    // Headline styles - using Roboto Serif for section headings
    headlineLarge: GoogleFonts.robotoSlab(
      fontSize: 32,
      fontWeight: FontWeight.w600,
    ),
    headlineMedium: GoogleFonts.robotoSlab(
      fontSize: 28,
      fontWeight: FontWeight.w600,
    ),
    headlineSmall: GoogleFonts.robotoSlab(
      fontSize: 24,
      fontWeight: FontWeight.w600,
    ),
    
    // Title styles - using Roboto Serif for card titles and section headers
    titleLarge: GoogleFonts.robotoSlab(
      fontSize: 22,
      fontWeight: FontWeight.w500,
    ),
    titleMedium: GoogleFonts.robotoSlab(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.15,
    ),
    titleSmall: GoogleFonts.robotoSlab(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
    ),
    
    // Body styles - using Public Sans for body text and content
    bodyLarge: GoogleFonts.publicSans(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.5,
    ),
    bodyMedium: GoogleFonts.publicSans(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
    ),
    bodySmall: GoogleFonts.publicSans(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.4,
    ),
    
    // Label styles - using Public Sans for buttons and labels
    labelLarge: GoogleFonts.publicSans(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
    ),
    labelMedium: GoogleFonts.publicSans(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
    ),
    labelSmall: GoogleFonts.publicSans(
      fontSize: 11,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
    ),
  );

  // Custom button text style for Read More and Listen to Audio buttons
  static TextStyle get buttonTextStyle => GoogleFonts.publicSans(
    fontSize: 17,
    fontWeight: FontWeight.w500, // Medium weight
    color: buttonTextColor,
  );

  // Custom body text style
  static TextStyle get customBodyText => GoogleFonts.publicSans(
    fontSize: 15,
    fontWeight: FontWeight.w400, // Regular weight
    color: bodyTextColor,
  );
}
