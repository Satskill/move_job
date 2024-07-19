import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:move_job/Data/Variables.dart';
import 'package:move_job/main.dart';

class CustomButtons {
  general(String text, Function requiredFunction, double width, Color color,
      {FontWeight? fontWeight}) {
    return ElevatedButton(
      onPressed: () {
        requiredFunction();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        fixedSize: Size(
          width,
          screenWidth * 0.12,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(
        text,
        style: GoogleFonts.openSans(
          fontSize: screenWidth * 0.044,
          color: Colors.white,
          fontWeight: fontWeight ?? FontWeight.w400,
        ),
      ),
    );
  }

  addingButton(String text, Function requiredFunction) {
    return ElevatedButton(
      onPressed: () {
        requiredFunction();
      },
      style: ElevatedButton.styleFrom(
        fixedSize: Size(
          screenWidth * 0.7,
          screenWidth * 0.12,
        ),
        backgroundColor: Variables.lightRed,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            height: screenWidth * 0.12,
            width: screenWidth * 0.15,
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
          SizedBox(
            height: screenWidth * 0.12,
            width: screenWidth * 0.4,
            child: Center(
              child: Text(
                text,
                style: GoogleFonts.openSans(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  doYouHave(String text, String mainText, Function requiredFunction) {
    return MaterialButton(
      onPressed: () {
        requiredFunction();
      },
      child: RichText(
        text: TextSpan(
          text: text,
          style: GoogleFonts.openSans(
            fontSize: screenWidth * 0.038,
            color: Variables.textGrey,
            fontWeight: FontWeight.w400,
          ),
          children: [
            TextSpan(
              text: mainText,
              style: GoogleFonts.openSans(
                color: Variables.generalRed,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
