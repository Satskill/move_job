import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:move_job/Data/UserState.dart';
import 'package:move_job/Widgets/AuthWidgets/AuthPage.dart';
import 'package:move_job/Widgets/AuthWidgets/Register/RegisterPage.dart';
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
    final userState = ref.watch(userProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Login',
          style: GoogleFonts.openSans(
            fontSize: screenWidth * 0.04,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (userState.isLoading)
              const Center(
                child: CircularProgressIndicator(),
              ),
            if (userState.error != null)
              Text(userState.error!, style: TextStyle(color: Colors.red)),
            if (userState.user != null) Text('Welcome, ${userState.user}!'),
            CustomTextFields().withOutIcon(
              textFieldController[0],
              textFieldFocus[0],
              screenWidth * 0.9,
              screenWidth * 0.12,
              () {},
              hint: 'Email',
            ),
            CustomTextFields().withIcon(
              Icons.password,
              textFieldController[1],
              textFieldFocus[1],
              screenWidth * 0.9,
              () {},
              hint: 'Şifre',
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                ref.read(userProvider.notifier).login(
                      textFieldController[0].text,
                      textFieldController[1].text,
                    );
              },
              child: Text('Giriş Yap'),
            ),
            ElevatedButton(
              onPressed: () {
                ref
                    .read(authWidgetProvider.notifier)
                    .updateWidget(RegisterPage());
              },
              child: Text('Kayıt Ol'),
            ),
          ],
        ),
      ),
    );
  }
}
