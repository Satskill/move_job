// map_tracking_page.dart
import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:move_job/Data/Variables.dart';
import 'package:move_job/Widgets/CustomWidgets/CustomButtons.dart';
import 'package:move_job/main.dart';

final openMapProvider = StateNotifierProvider<OpenMapNotifier, bool>((ref) {
  return OpenMapNotifier();
});

class OpenMapNotifier extends StateNotifier<bool> {
  OpenMapNotifier() : super(false);

  void updateMap(bool open) {
    state = open;
  }
}

class MapTrackingPage extends ConsumerStatefulWidget {
  final data;

  MapTrackingPage({required this.data, super.key});

  @override
  _MapTrackingPageState createState() => _MapTrackingPageState();
}

class _MapTrackingPageState extends ConsumerState<MapTrackingPage> {
  late final MapController mapController;

  @override
  void initState() {
    super.initState();
    mapController = MapController();
  }

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    log(widget.data.toString());
    final currentPosition = ref.watch(locationProvider);
    final routeAsyncValue = ref.watch(
      routeProvider(
        LatLng(
          double.parse(widget.data['lat'].toString()),
          double.parse(widget.data['lng'].toString()),
        ),
      ),
    );
    final openMap = ref.watch(openMapProvider);

    return Scaffold(
      body: Column(
        children: [
          if (openMap)
            SizedBox(
              height: screenWidth,
              width: screenWidth,
              child: FlutterMap(
                mapController: mapController,
                options: MapOptions(
                  initialCenter: currentPosition,
                  initialZoom: 15.0,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                    subdomains: const ['a', 'b', 'c'],
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        width: 80.0,
                        height: 80.0,
                        point: currentPosition,
                        child: const Icon(
                          Icons.person,
                          color: Colors.red,
                          size: 40.0,
                        ),
                      ),
                      Marker(
                        width: 80.0,
                        height: 80.0,
                        point: LatLng(
                          double.parse(widget.data['lat'].toString()),
                          double.parse(widget.data['lng'].toString()),
                        ),
                        child: const Icon(
                          Icons.location_on,
                          color: Colors.green,
                          size: 40.0,
                        ),
                      ),
                    ],
                  ),
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: routeAsyncValue.maybeWhen(
                          data: (route) => route,
                          orElse: () => [],
                        ),
                        strokeWidth: 4.0,
                        color: Colors.blue,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          CustomButtons().general(
            openMap ? 'Bitir' : 'Başla',
            () {
              ref.read(openMapProvider.notifier).updateMap(!openMap);
            },
            screenWidth * 0.9,
            Variables.generalRed,
          ),
        ],
      ),
    );
  }
}

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

final routeProvider =
    FutureProvider.family<List<LatLng>, LatLng>((ref, destination) async {
  final start = ref.read(locationProvider);
  final response = await http.get(Uri.parse(
      'https://api.openrouteservice.org/v2/directions/driving-car?api_key=5b3ce3597851110001cf6248d80c16dbe00746b18069c510b9c950af&start=${start.longitude},${start.latitude}&end=${destination.longitude},${destination.latitude}'));

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    final List<LatLng> route =
        (data['features'][0]['geometry']['coordinates'] as List)
            .map((coords) => LatLng(coords[1], coords[0]))
            .toList();
    return route;
  } else {
    throw Exception('Failed to load route');
  }
});
