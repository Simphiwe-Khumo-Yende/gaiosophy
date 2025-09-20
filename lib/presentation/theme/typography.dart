import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Typography extension to provide easy access to font styles throughout the app
extension AppTypography on BuildContext {
  TextTheme get textTheme => Theme.of(this).textTheme;
  
  // Primary font helpers (Roboto Serif) - for headings, titles, and emphasis
  TextStyle get primaryDisplayLarge => textTheme.displayLarge!;
  TextStyle get primaryDisplayMedium => textTheme.displayMedium!;
  TextStyle get primaryDisplaySmall => textTheme.displaySmall!;
  
  TextStyle get primaryHeadlineLarge => textTheme.headlineLarge!;
  TextStyle get primaryHeadlineMedium => textTheme.headlineMedium!;
  TextStyle get primaryHeadlineSmall => textTheme.headlineSmall!;
  
  TextStyle get primaryTitleLarge => textTheme.titleLarge!;
  TextStyle get primaryTitleMedium => textTheme.titleMedium!;
  TextStyle get primaryTitleSmall => textTheme.titleSmall!;
  
  // Secondary font helpers (Public Sans) - for body text and UI elements
  TextStyle get secondaryBodyLarge => textTheme.bodyLarge!;
  TextStyle get secondaryBodyMedium => textTheme.bodyMedium!;
  TextStyle get secondaryBodySmall => textTheme.bodySmall!;
  
  TextStyle get secondaryLabelLarge => textTheme.labelLarge!;
  TextStyle get secondaryLabelMedium => textTheme.labelMedium!;
  TextStyle get secondaryLabelSmall => textTheme.labelSmall!;
  
  // Quick access to font families for custom styles
  static String get primaryFontFamily => GoogleFonts.robotoSlab().fontFamily!;
  static String get secondaryFontFamily => GoogleFonts.publicSans().fontFamily!;
  
  // Custom style builders
  TextStyle primaryFont({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? letterSpacing,
    double? height,
  }) {
    return GoogleFonts.robotoSlab(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
      height: height ?? 1.1, // Default reduced line height from 1.3 to 1.1
    );
  }

  TextStyle secondaryFont({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? letterSpacing,
    double? height,
  }) {
    return GoogleFonts.publicSans(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
      height: height ?? 1.1, // Default reduced line height from 1.3 to 1.1
    );
  }
}
