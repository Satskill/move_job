import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:move_job/Data/UserState.dart';
import 'package:move_job/Data/Variables.dart';
import 'package:move_job/Widgets/AuthWidgets/AuthPage.dart';
import 'package:move_job/Widgets/AuthWidgets/CustomPaint.dart';
import 'package:move_job/Widgets/AuthWidgets/Register/RegisterPage.dart';
import 'package:move_job/Widgets/CustomWidgets/CustomAppBar.dart';
import 'package:move_job/Widgets/CustomWidgets/CustomButtons.dart';
import 'package:move_job/Widgets/CustomWidgets/CustomTextFields.dart';
import 'package:move_job/main.dart';

class LoginPage extends ConsumerWidget {
  final List<TextEditingController> textFieldController = List.generate(
    2,
    (index) => TextEditingController(),
  );
  final List<FocusNode> textFieldFocus = List.generate(
    2,
    (index) => FocusNode(),
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: CustomAppBar().authAppBar('Giriş Yap'),
      extendBodyBehindAppBar: true,
      body: CustomPaint(
        painter: DottedBackgroundPainter(),
        child: SingleChildScrollView(
          child: SizedBox(
            height: screenHeight,
            width: screenWidth,
            child: Center(
              child: SizedBox(
                height: screenWidth,
                width: screenWidth,
                child: userState.isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          if (userState.error != null)
                            Text(
                              userState.error!,
                              style: GoogleFonts.openSans(
                                color: Variables.errorAreaRed,
                              ),
                            ),
                          Expanded(
                            flex: 2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: screenWidth * 0.9,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Email',
                                        style: GoogleFonts.openSans(
                                          color: Variables.textGrey,
                                          fontSize: screenWidth * 0.04,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      CustomTextFields().withOutIcon(
                                        textFieldController[0],
                                        textFieldFocus[0],
                                        screenWidth * 0.9,
                                        screenWidth * 0.15,
                                        () {},
                                        hint: 'Email',
                                        keyboardType:
                                            TextInputType.emailAddress,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: screenWidth * 0.075,
                                ),
                                SizedBox(
                                  width: screenWidth * 0.9,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Şifre',
                                        style: GoogleFonts.openSans(
                                          color: Variables.textGrey,
                                          fontSize: screenWidth * 0.04,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      CustomTextFields().withIcon(
                                        Icons.visibility,
                                        textFieldController[1],
                                        textFieldFocus[1],
                                        screenWidth * 0.9,
                                        () {},
                                        hint: 'Şifre',
                                        height: screenWidth * 0.15,
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                CustomButtons().general(
                                  'Giriş Yap',
                                  () {
                                    ref.read(userProvider.notifier).login(
                                          textFieldController[0].text,
                                          textFieldController[1].text,
                                        );
                                  },
                                  screenWidth * 0.8,
                                  Variables.generalRed.withOpacity(0.8),
                                ),
                                CustomButtons().doYouHave(
                                  'Üye Değil Misiniz ? ',
                                  'Kayıt Ol',
                                  () {
                                    ref
                                        .read(authWidgetProvider.notifier)
                                        .updateWidget(RegisterPage());
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
