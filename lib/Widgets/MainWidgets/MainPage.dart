import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:move_job/Widgets/MainWidgets/CustomerPage/CustomerPage.dart';
import 'package:move_job/Widgets/MainWidgets/DeliveryGuyPage/Deliveries.dart';
import 'package:move_job/main.dart';

class MainPage extends ConsumerWidget {
  MainPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: userState.user!['usertype'] == 'delivery'
          ? Deliveries()
          : CustomerPage(),
    );
  }
}
