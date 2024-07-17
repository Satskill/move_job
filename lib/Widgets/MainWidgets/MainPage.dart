import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:move_job/Data/UserState.dart';
import 'package:move_job/Widgets/MainWidgets/DeliveryGuyPage/DeliveryGuyPage.dart';
import 'package:move_job/main.dart';

class MainPage extends ConsumerWidget {
  MainPage({super.key});
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userProvider);

    return Scaffold(
      body: Column(
        children: [
          if (userState.isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
          if (userState.error != null)
            Text(userState.error!, style: TextStyle(color: Colors.red)),
          if (userState.user != null)
            MapTrackingPage(
              destination: LatLng(38.4, 27.1),
            ),
          MapTrackingPage(
            destination: LatLng(38.4, 27.1),
          )
        ],
      ),
    );
  }
}
