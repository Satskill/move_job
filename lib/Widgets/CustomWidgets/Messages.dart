import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:move_job/Data/Variables.dart';
import 'package:move_job/main.dart';

class Messages {
  bottomErrorPop(BuildContext context, String errorMessage) {
    SnackBar snackBar = SnackBar(
      content: Text(
        errorMessage,
        style: GoogleFonts.nunito(
          fontSize: screenWidth * 0.042,
          color: Variables.generalRed,
          fontWeight: FontWeight.w600,
        ),
      ),
      backgroundColor: Colors.white,
    );

    if (context.mounted) {
      try {
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } catch (e) {}
    }
  }

  infoMessage(String info, String title, BuildContext context) {
    showGeneralDialog(
      context: context,
      pageBuilder: (context, animation, secondaryAnimation) {
        return AlertDialog(
          title: Text(
            title,
            style: GoogleFonts.nunito(
              fontWeight: FontWeight.w500,
              color: Variables.textBlack,
            ),
          ),
          content: Text(
            info,
            style: GoogleFonts.nunito(
              fontSize: screenWidth * 0.038,
              fontWeight: FontWeight.w500,
              color: Variables.textBlack,
            ),
          ),
          actions: [
            MaterialButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: FittedBox(
                child: Text(
                  'Tamam',
                  style: GoogleFonts.nunito(
                    fontWeight: FontWeight.w400,
                    color: Variables.textBlack,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  askingMessage(String info, String title, Function requiredFunction,
      BuildContext context) {
    showGeneralDialog(
      context: context,
      pageBuilder: (context, animation, secondaryAnimation) {
        return AlertDialog(
          title: Text(
            title,
            style: GoogleFonts.nunito(
              fontWeight: FontWeight.w500,
              color: Variables.textBlack,
            ),
          ),
          content: Text(
            info,
            style: GoogleFonts.nunito(
              fontSize: screenWidth * 0.038,
              fontWeight: FontWeight.w500,
              color: Variables.textBlack,
            ),
          ),
          actions: [
            MaterialButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: FittedBox(
                child: Text(
                  'Hayır',
                  style: GoogleFonts.nunito(
                    fontWeight: FontWeight.w400,
                    color: Variables.textBlack,
                  ),
                ),
              ),
            ),
            MaterialButton(
              onPressed: () async {
                requiredFunction();
              },
              child: FittedBox(
                child: Text(
                  'Evet',
                  style: GoogleFonts.nunito(
                    fontWeight: FontWeight.w400,
                    color: Variables.textBlack,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
