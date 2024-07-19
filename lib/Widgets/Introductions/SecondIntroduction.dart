import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:move_job/Data/Variables.dart';
import 'package:move_job/main.dart';

class SecondIntroduction extends StatelessWidget {
  const SecondIntroduction({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: Container(),
        ),
        Expanded(
          flex: 12,
          child: SizedBox(
            width: screenWidth * 0.80,
            child: Padding(
              padding: EdgeInsets.only(right: screenWidth * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 100,
                    child: _textArea(
                      '  Güvenli',
                      GoogleFonts.nunito(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: screenWidth * 0.20,
                        height: 1,
                      ),
                      secondText: '\n  Kargo Denetimi',
                      secondStyle: GoogleFonts.nunito(
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        fontSize: screenWidth * 0.20,
                        height: 1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Container(),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(left: screenWidth * 0.1),
            child: Container(
                height: 2,
                width: screenWidth * 0.25,
                color: Variables.generalRed),
          ),
        ),
        Expanded(
          flex: 3,
          child: Container(),
        ),
        Expanded(
          flex: 9,
          child: Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(
              width: screenWidth * 0.80,
              child: _textArea(
                """Kargo Güvenliği
Bizim için çok önemlidir.""",
                GoogleFonts.nunito(
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 21,
          child: Container(),
        ),
      ],
    );
  }

  _textArea(String text, TextStyle style,
      {String? secondText,
      TextStyle? secondStyle,
      String? thirdText,
      TextStyle? thirdStyle}) {
    return FittedBox(
      child: RichText(
        textAlign: TextAlign.left,
        text: TextSpan(
          text: text,
          style: style,
          children: [
            TextSpan(text: secondText, style: secondStyle),
            TextSpan(text: thirdText, style: thirdStyle),
          ],
        ),
      ),
    );
  }
}
