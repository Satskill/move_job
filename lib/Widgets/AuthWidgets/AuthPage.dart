import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:move_job/Widgets/AuthWidgets/LogIn/LoginPage.dart';
import 'package:move_job/main.dart';

final authWidgetProvider =
    StateNotifierProvider<AuthWidgetNotifier, Widget>((ref) {
  return AuthWidgetNotifier();
});

class AuthPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myWidget = ref.watch(authWidgetProvider);

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
      body: myWidget,
    );
  }
}

class AuthWidgetNotifier extends StateNotifier<Widget> {
  AuthWidgetNotifier() : super(LoginPage());

  void updateWidget(Widget newWidget) {
    state = newWidget;
  }
}
