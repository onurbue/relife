import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

AppBar customAppBar() {
  return AppBar(
    backgroundColor: Colors.white,
    title: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RichText(
          text: TextSpan(
            text: 'Re',
            style: GoogleFonts.workSans(
              textStyle: const TextStyle(
                color: Colors.black,
                fontSize: 36,
                fontWeight: FontWeight.w100,
              ),
            ),
          ),
        ),
        RichText(
          text: TextSpan(
            text: 'Life',
            style: GoogleFonts.workSans(
              textStyle: const TextStyle(
                color: Colors.black,
                fontSize: 36,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
