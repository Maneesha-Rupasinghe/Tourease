import 'package:flutter/material.dart';
import 'package:tourease/utils/theme/text_theme.dart';

class AppTheme {

  AppTheme._();

  static ThemeData lightTheme = ThemeData(
      brightness: Brightness.light,

      primarySwatch: const MaterialColor(
          0xFFff3300,
          <int, Color>{
            50: Color(0x1Aff3300),
            100: Color(0x33ff3300),
            200: Color(0x40ff3300),
            300: Color(0x66ff3300),
            400: Color(0x80ff3300),
            500: Color(0xFFff3300),
            600: Color(0x99ff3300),
            700: Color(0xB3ff3300),
            800: Color(0xCCff3300),
            900: Color(0xE6ff3300),
          }
      ),

      textTheme: ThemeText.lightTheme
  );

  static ThemeData darkTheme = ThemeData(
      brightness: Brightness.dark,

      primarySwatch: const MaterialColor(
          0xFFff3300,
          <int, Color>{
            50: Color(0x1Aff3300),
            100: Color(0x33ff3300),
            200: Color(0x40ff3300),
            300: Color(0x66ff3300),
            400: Color(0x80ff3300),
            500: Color(0xFFff3300),
            600: Color(0x99ff3300),
            700: Color(0xB3ff3300),
            800: Color(0xCCff3300),
            900: Color(0xE6ff3300),
          }
      ),

      textTheme: ThemeText.darkTheme
  );
}