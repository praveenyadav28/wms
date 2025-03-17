import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StyleText {
  TextStyle abyssinicaSilText(double size, FontWeight weight, color) {
    return GoogleFonts.abyssinicaSil(
      fontSize: size,
      fontWeight: weight,
      color: color,
    );
  }

  TextStyle adlamText(double size, FontWeight weight, color) {
    return GoogleFonts.aDLaMDisplay(
      fontSize: size,
      fontWeight: weight,
      color: color,
    );
  }

  TextStyle sarifProText(double size, FontWeight weight, color) {
    return GoogleFonts.ptSerif(
      fontSize: size,
      fontWeight: weight,
      color: color,
    );
  }

  TextStyle albertsans(double size, FontWeight weight, color) {
    return GoogleFonts.albertSans(
      fontSize: size,
      fontWeight: weight,
      color: color,
    );
  }
}
