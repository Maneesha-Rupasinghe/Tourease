import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeText {

  static TextTheme lightTheme = TextTheme(
    headline6: GoogleFonts.montserrat(color: Colors.black87,fontWeight: FontWeight.bold),
    bodyText1: GoogleFonts.montserrat(color: Colors.black87),
  );

  static TextTheme darkTheme = TextTheme(
    headline6: GoogleFonts.montserrat(color: Colors.white70,fontWeight: FontWeight.bold),
    bodyText1: GoogleFonts.montserrat(color: Colors.white70),
  );
}