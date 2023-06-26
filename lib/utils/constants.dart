import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Colors
const Color primaryColor = Color.fromRGBO(6, 188, 193, 1);
const Color secondaryColor = Color.fromRGBO(94, 225, 215, 1);
const Color backgroundColor = Colors.white;

// Custom textstyles
class CustomTextStyles {
  static final TextStyle title = GoogleFonts.workSans(
    textStyle: const TextStyle(
      fontSize: 36,
      fontWeight: FontWeight.w500,
    ),
  );
  static final TextStyle descriptions = GoogleFonts.workSans(
    textStyle: const TextStyle(
      fontSize: 30,
      fontWeight: FontWeight.w500,
    ),
  );

  static final TextStyle button = GoogleFonts.workSans(
    textStyle: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
    ),
  );

  static final TextStyle donation = GoogleFonts.workSans(
    textStyle: const TextStyle(
      fontSize: 14,
      letterSpacing: 0.2,
    ),
  );
}

class AppDimensions {
  static double getDeviceWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }
}
