import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:move_job/Data/UserState.dart';
import 'package:move_job/Widgets/AuthWidgets/AuthPage.dart';
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
      body: SingleChildScrollView(
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
              Icons.visibility,
              textFieldController[1],
              textFieldFocus[1],
              screenWidth * 0.9,
              () {},
              hint: 'Şifre',
            ),
            CustomTextFields().withOutIcon(
              textFieldController[2],
              textFieldFocus[2],
              screenWidth * 0.9,
              screenWidth * 0.12,
              () {},
              hint: 'İsim',
            ),
            CustomTextFields().withOutIcon(
              textFieldController[3],
              textFieldFocus[3],
              screenWidth * 0.9,
              screenWidth * 0.12,
              () {},
              hint: 'Soyisim',
            ),
            ElevatedButton(
              onPressed: () {
                ref.read(userProvider.notifier).register(
                    textFieldController[0].text,
                    textFieldController[1].text,
                    textFieldController[2].text,
                    textFieldController[3].text,
                    'delivery');
              },
              child: Text('Kayıt Ol'),
            ),
            ElevatedButton(
              onPressed: () {
                ref
                    .read(authWidgetProvider.notifier)
                    .updateWidget(RegisterPage());
              },
              child: Text('Giriş Yap'),
            ),
          ],
        ),
      ),
    );
  }
}
