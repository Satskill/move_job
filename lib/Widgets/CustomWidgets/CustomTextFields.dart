import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:move_job/Data/Variables.dart';
import 'package:move_job/main.dart';

class CustomTextFields {
  withIcon(
    IconData icon,
    TextEditingController controller,
    FocusNode focusNode,
    double width,
    Function stating, {
    bool? showPassword,
    Function? requiredFunction,
    int? index,
    String? label,
    TextStyle? labelStyle,
    String? hint,
    TextInputType? keyboardType,
    String? errorMessage,
    Function? onChanged,
    double? height,
    int? maxLines = 1,
    bool readOnly = false,
  }) {
    return FocusScope(
      onFocusChange: (value) {
        stating();
      },
      child: Column(
        children: [
          Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: const Color.fromRGBO(246, 247, 249, 1),
              border: Border.all(
                width: 2,
                color: errorMessage != null
                    ? Variables.errorAreaRed.withOpacity(0.75)
                    : focusNode.hasFocus
                        ? Variables.textBlack
                        : Colors.grey.withOpacity(0.1),
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  width: screenWidth * 0.04,
                ),
                Expanded(
                  flex: 12,
                  child: TextField(
                    controller: controller,
                    focusNode: focusNode,
                    obscureText: showPassword ?? false,
                    keyboardType: keyboardType,
                    maxLines: maxLines,
                    readOnly: readOnly,
                    onChanged: (value) {
                      if (onChanged != null) {
                        onChanged(value);
                      }
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: label,
                      labelStyle: labelStyle,
                      hintText: hint,
                      floatingLabelStyle: GoogleFonts.openSans(
                        color: errorMessage != null
                            ? Variables.errorAreaRed.withOpacity(0.75)
                            : Variables.textBlack,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: screenWidth * 0.15,
                  child: IconButton(
                    onPressed: () {
                      if (requiredFunction != null) {
                        requiredFunction(index);
                      }
                    },
                    icon: FittedBox(
                      child: Icon(
                        icon,
                        color: errorMessage != null
                            ? Variables.errorAreaRed.withOpacity(0.75)
                            : focusNode.hasFocus
                                ? Variables.textBlack
                                : Colors.black.withOpacity(0.5),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          errorMessage != null
              ? SizedBox(
                  height: screenWidth * 0.035,
                  width: width,
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: screenWidth * 0.025, top: screenWidth * 0.0025),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        errorMessage,
                        style: GoogleFonts.openSans(
                          height: 1,
                          color: Variables.errorAreaRed,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  withOutIcon(
    TextEditingController controller,
    FocusNode focusNode,
    double width,
    double height,
    Function stating, {
    String? label,
    String? hint,
    int? maxLines = 1,
    int? maxLength,
    TextInputType? keyboardType,
    String? errorMessage,
    Function? onChanged,
  }) {
    return FocusScope(
      onFocusChange: (value) {
        stating();
      },
      child: Column(
        children: [
          Container(
            height: maxLines == null ? null : height,
            width: width,
            decoration: BoxDecoration(
              color: const Color.fromRGBO(246, 247, 249, 1),
              border: Border.all(
                width: 2,
                color: errorMessage != null
                    ? Variables.errorAreaRed.withOpacity(0.75)
                    : focusNode.hasFocus
                        ? Variables.textBlack
                        : Colors.grey.withOpacity(0.1),
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: EdgeInsets.only(
                  top: maxLines == null ? screenWidth * 0.01 : 0,
                  bottom: maxLines == null ? screenWidth * 0.01 : 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: screenWidth * 0.04,
                  ),
                  Expanded(
                    flex: 12,
                    child: TextField(
                      controller: controller,
                      focusNode: focusNode,
                      maxLines: maxLines,
                      keyboardType: keyboardType,
                      maxLength: maxLength,
                      onChanged: (value) {
                        if (onChanged != null) {
                          onChanged(value);
                        }
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        labelText: label,
                        hintText: hint,
                        counterText: '',
                        floatingLabelStyle: GoogleFonts.openSans(
                          color: errorMessage != null
                              ? Variables.errorAreaRed.withOpacity(0.75)
                              : Variables.textGrey,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: screenWidth * 0.05,
                  ),
                ],
              ),
            ),
          ),
          errorMessage != null
              ? SizedBox(
                  height: screenWidth * 0.035,
                  width: width,
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: screenWidth * 0.025, top: screenWidth * 0.0025),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        errorMessage,
                        style: GoogleFonts.openSans(
                          height: 1,
                          color: Variables.errorAreaRed,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}

class FocusStateNotifier extends StateNotifier<bool> {
  FocusStateNotifier() : super(false);

  void updateFocus(bool isFocused) {
    state = isFocused;
  }
}

final focusStateProvider =
    StateNotifierProvider<FocusStateNotifier, bool>((ref) {
  return FocusStateNotifier();
});
