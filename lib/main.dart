import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:move_job/Data/Database.dart';
import 'package:move_job/Data/LocalDatabase.dart';
import 'package:move_job/Data/LocationFetch.dart';
import 'package:move_job/Data/UserState.dart';
import 'package:move_job/Routes/Routes.dart';
import 'package:move_job/Widgets/AuthWidgets/AuthPage.dart';
import 'package:move_job/Widgets/MainWidgets/MainPage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:workmanager/workmanager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  HttpOverrides.global = MyHttpOverrides();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: true,
  );
  Workmanager().registerPeriodicTask(
    "1",
    "locationTask",
    frequency: Duration(minutes: 15),
  );

  Hive.init((await getApplicationDocumentsDirectory()).path);

  await Hive.openBox('User');

  userState = userState.copyWith(user: await LocalDatabase().userGetInfos());

  runApp(const ProviderScope(child: MainApp()));
}

late double screenHeight;
late double screenWidth;

UserState userState = UserState();

late Map? userInfo;

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: Routes.routes,
      home: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);

            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
              FocusScope.of(context).requestFocus(FocusNode());
            }
          },
          child: const Home()),
    );
  }
}

final activityProvider = Database().login();

class Home extends ConsumerWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: Consumer(
          builder: (context, ref, _) {
            final userState = ref.watch(userProvider);

            return Scaffold(
              body: Center(
                child: userState.user != null ? MainPage() : MainPage(),
              ),
            );
          },
        ),
      ),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
