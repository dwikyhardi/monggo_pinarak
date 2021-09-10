import 'package:flutter/material.dart';

class ColorPalette {
  static const Color primaryColor = red;
  static const Color primaryColorLight = redLight;
  static const Color primaryColorDark = redDark;
  static const Color secondaryColor = blue;
  static const Color secondaryColorLight = blueLight;
  static const Color secondaryColorDark = blueDark;
  static const Color red = Color(0xFFbd2024);
  static const Color redLight = Color(0xFFf6584d);
  static const Color redDark = Color(0xFF850000);
  static const Color blue = Color(0xFF20bdb5);
  static const Color blueLight = Color(0xFF67f0e7);
  static const Color blueDark = Color(0xFF008c85);

  static MaterialColor getPrimarySwatch() {
    List strengths = <double>[.05];
    final swatch = <int, Color>{};
    final int r = primaryColor.red,
        g = primaryColor.green,
        b = primaryColor.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    strengths.forEach((strength) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    });
    return MaterialColor(primaryColor.value, swatch);
  }
}
