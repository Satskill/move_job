import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:move_job/Widgets/CustomWidgets/Messages.dart';

class LocationNotifier extends StateNotifier<LatLng> {
  LocationNotifier() : super(LatLng(38.41, 27.12)) {
    _startTracking();
  }

  StreamSubscription<Position>? _positionStream;

  void _startTracking() {
    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    ).listen((Position position) {
      state = LatLng(position.latitude, position.longitude);
    });
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    super.dispose();
  }
}

final locationProvider = StateNotifierProvider<LocationNotifier, LatLng>((ref) {
  return LocationNotifier();
});

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
