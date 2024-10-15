import 'package:flutter/material.dart';

class AppColors {
  // Define the main color for primary swatch
  static const Color primaryColor = Color.fromARGB(255, 251, 164, 38);

  // Other colors used throughout the app
  static const Color accentColor = Color(0xFFFFC107); 
  static const Color backgroundColor = Color.fromARGB(255, 249, 249, 249);
  static const Color buttonColor = Color(0xFFFFC107); 

  // Method to create a MaterialColor from a single Color
  static MaterialColor createMaterialColor(Color color) {
    List<double> strengths = <double>[.05];
    final swatch = <int, Color>{};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    for (var strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    return MaterialColor(color.value, swatch);
  }
}