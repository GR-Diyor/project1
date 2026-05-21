import 'package:flutter/material.dart';

class AppTheme {
  static const Color bg = Color(0xFFFBFAF5);
  static const Color text = Color(0xFF333333);
  static const Color foreground = text;
  static const Color muted = Color(0xFF6F7D75);

  static const Color dark = Color(0xFF0B3F2D);
  static const Color dark2 = Color(0xFF134F3A);

  static const Color green = Color(0xFF126347);
  static const Color green2 = Color(0xFF1D7656);

  static const Color gold = Color(0xFFD89A22);
  static const Color gold2 = Color(0xFFB87F16);

  static const Color card = Color(0xFFFFFFFF);
  static const Color soft = Color(0xFFF4F0E8);
  static const Color line = Color(0xFFE5DAC6);
  static const Color red = Color(0xFFD51F1F);

  static const Color okSoft = Color(0xFFDFF4EB);
  static const Color waitSoft = Color(0xFFFFF1D4);
  static const Color badSoft = Color(0xFFEDE9DF);

  static const String fontDefault = 'Inter';
  static const String fontScript = 'GreatVibes';
  static const String fontElegant = 'CrimsonText';
  static const String fontIcon = 'DejaVuSans';

  static TextStyle font({
    required double size,
    Color color = text,
    FontWeight weight = FontWeight.w400,
    String style = 'default',
    double letterSpacing = 0,
    double? height,
  }) {
    String family;
    FontWeight w = weight;
    switch (style) {
      case 'script':
        family = fontScript;
        w = FontWeight.w400;
        break;
      case 'elegant':
        family = fontElegant;
        w = FontWeight.w400;
        break;
      case 'icon':
        family = fontIcon;
        w = FontWeight.w400;
        break;
      default:
        family = fontDefault;
    }
    return TextStyle(
      fontFamily: family,
      fontSize: size,
      color: color,
      fontWeight: w,
      letterSpacing: letterSpacing,
      height: height,
    );
  }

  static ThemeData materialTheme() {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: bg,
      fontFamily: fontDefault,
      colorScheme: ColorScheme.fromSeed(
        seedColor: green,
        primary: green,
        secondary: gold,
        surface: card,
        error: red,
      ),
      textTheme: const TextTheme().apply(bodyColor: text, displayColor: text),
    );
  }
}
