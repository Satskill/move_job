import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:move_job/Data/Variables.dart';
import 'package:move_job/main.dart';

class CustomAppBar {
  authAppBar(String title) {
    return AppBar(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
      backgroundColor: Variables.generalRed.withOpacity(0.8),
      automaticallyImplyLeading: false,
      centerTitle: true,
      scrolledUnderElevation: 0,
      title: Text(
        title,
        style: GoogleFonts.openSans(
          fontSize: screenWidth * 0.04,
          fontWeight: FontWeight.w500,
          color: Variables.whiteBG,
        ),
      ),
    );
  }

  logOutAppBar(String title, Function requiredFunction) {
    return AppBar(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
      backgroundColor: Variables.generalRed.withOpacity(0.8),
      automaticallyImplyLeading: false,
      centerTitle: true,
      scrolledUnderElevation: 0,
      title: Text(
        title,
        style: GoogleFonts.openSans(
          fontSize: screenWidth * 0.04,
          fontWeight: FontWeight.w500,
          color: Variables.whiteBG,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            requiredFunction();
          },
          icon: const Icon(
            Icons.logout,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
