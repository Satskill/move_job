import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:move_job/Data/UserState.dart';
import 'package:move_job/Data/Variables.dart';
import 'package:move_job/Widgets/AuthWidgets/AuthPage.dart';
import 'package:move_job/Widgets/AuthWidgets/CustomPaint.dart';
import 'package:move_job/Widgets/AuthWidgets/LogIn/LoginPage.dart';
import 'package:move_job/Widgets/CustomWidgets/CustomButtons.dart';
import 'package:move_job/Widgets/CustomWidgets/CustomTextFields.dart';
import 'package:move_job/main.dart';

class RegisterPage extends ConsumerWidget {
  RegisterPage({super.key});
  final List<TextEditingController> textFieldController = List.generate(
    4,
    (index) => TextEditingController(),
  );
  final List<FocusNode> textFieldFocus = List.generate(
    4,
    (index) => FocusNode(),
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final radioState = ref.watch(radioProvider);
    final radioNotifier = ref.read(radioProvider.notifier);

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: CustomPaint(
        painter: DottedBackgroundPainter(),
        child: SingleChildScrollView(
          child: SizedBox(
            height: screenHeight,
            child: Center(
              child: SizedBox(
                height: screenWidth * 1.6,
                width: screenWidth,
                child: SizedBox(
                  width: screenWidth * 1.2,
                  child: userState.isLoading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              'Kayıt Ol',
                              style: GoogleFonts.openSans(
                                fontSize: screenWidth * 0.044,
                                fontWeight: FontWeight.w500,
                                color: Variables.generalRed,
                              ),
                            ),
                            if (userState.error != null)
                              Text(
                                userState.error!,
                                style: GoogleFonts.openSans(
                                  color: Variables.errorAreaRed,
                                ),
                              ),
                            SizedBox(
                              height: screenWidth,
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
                                    height: screenWidth * 0.05,
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
                                        CustomTextFields().withOutIcon(
                                          textFieldController[1],
                                          textFieldFocus[1],
                                          screenWidth * 0.9,
                                          screenWidth * 0.15,
                                          () {},
                                          hint: 'Şifre',
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: screenWidth * 0.05,
                                  ),
                                  SizedBox(
                                    width: screenWidth * 0.9,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'İsim',
                                          style: GoogleFonts.openSans(
                                            color: Variables.textGrey,
                                            fontSize: screenWidth * 0.04,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        CustomTextFields().withOutIcon(
                                          textFieldController[2],
                                          textFieldFocus[2],
                                          screenWidth * 0.9,
                                          screenWidth * 0.15,
                                          () {},
                                          hint: 'İsim',
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: screenWidth * 0.05,
                                  ),
                                  SizedBox(
                                    width: screenWidth * 0.9,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Soyisim',
                                          style: GoogleFonts.openSans(
                                            color: Variables.textGrey,
                                            fontSize: screenWidth * 0.04,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        CustomTextFields().withOutIcon(
                                          textFieldController[3],
                                          textFieldFocus[3],
                                          screenWidth * 0.9,
                                          screenWidth * 0.15,
                                          () {},
                                          hint: 'Soyisim',
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: screenWidth * 0.12,
                              width: screenWidth * 0.9,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: RadioListTile(
                                      value: 0,
                                      groupValue: radioState.selectedRadio,
                                      onChanged: (value) {
                                        if (value != null) {
                                          radioNotifier.updateRadio(value);
                                        }
                                      },
                                      activeColor: Variables.lightRed,
                                      title: Text(
                                        'Kullanıcı',
                                        style: GoogleFonts.openSans(
                                          fontSize: screenWidth * 0.04,
                                          color: Variables.textBlack,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: RadioListTile(
                                      value: 1,
                                      groupValue: radioState.selectedRadio,
                                      onChanged: (value) {
                                        if (value != null) {
                                          radioNotifier.updateRadio(value);
                                        }
                                      },
                                      activeColor: Variables.lightRed,
                                      title: Text(
                                        'Kargocu',
                                        style: GoogleFonts.openSans(
                                          fontSize: screenWidth * 0.04,
                                          color: Variables.textBlack,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: screenWidth * 0.33,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  CustomButtons().general(
                                    'Kayıt Ol',
                                    () {
                                      ref.read(userProvider.notifier).register(
                                          textFieldController[0].text,
                                          textFieldController[1].text,
                                          textFieldController[2].text,
                                          textFieldController[3].text,
                                          radioState.selectedRadio == 0
                                              ? 'user'
                                              : 'delivery');
                                    },
                                    screenWidth * 0.8,
                                    Variables.generalRed.withOpacity(0.8),
                                  ),
                                  CustomButtons().doYouHave(
                                    'Üye Misiniz ? ',
                                    'Giriş Yap',
                                    () {
                                      ref
                                          .read(authWidgetProvider.notifier)
                                          .updateWidget(LoginPage());
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
      ),
    );
  }
}

class RadioState {
  final int selectedRadio;

  RadioState({required this.selectedRadio});

  RadioState copyWith({int? selectedRadio}) {
    return RadioState(
      selectedRadio: selectedRadio ?? this.selectedRadio,
    );
  }
}

class RadioNotifier extends StateNotifier<RadioState> {
  RadioNotifier()
      : super(RadioState(
          selectedRadio: 0,
        ));

  void updateRadio(int value) {
    state = state.copyWith(selectedRadio: value);
  }
}

final radioProvider = StateNotifierProvider<RadioNotifier, RadioState>((ref) {
  return RadioNotifier();
});
