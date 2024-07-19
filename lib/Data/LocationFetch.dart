import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:move_job/Widgets/CustomWidgets/Messages.dart';
import 'package:workmanager/workmanager.dart';

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    return Future.value(true);
  });
}

Future<Position?> requestLocationPermission(BuildContext context) async {
  LocationPermission permissions = await Geolocator.requestPermission();
  if (permissions != LocationPermission.deniedForever &&
      permissions != LocationPermission.denied) {
    return await Geolocator.getCurrentPosition();
  } else {
    if (context.mounted) {
      Messages().askingMessage(
          'Uygulamayı kullanabilmeniz için izin vermeniz gerekmektedir. Şimdi konum izni vermek ister misinzi?',
          'İzin Gerekli', () {
        Geolocator.openLocationSettings().then((value) {
          Navigator.pop(context);
        });
      }, context);
    }
    return null;
  }
}
