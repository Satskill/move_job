// map_tracking_page.dart
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:move_job/main.dart';

class MapTrackingPage extends ConsumerStatefulWidget {
  final LatLng destination;

  MapTrackingPage({required this.destination});

  @override
  _MapTrackingPageState createState() => _MapTrackingPageState();
}

class _MapTrackingPageState extends ConsumerState<MapTrackingPage> {
  MapController _mapController = MapController();

  @override
  Widget build(BuildContext context) {
    final currentPosition = ref.watch(locationProvider);
    final routeAsyncValue = ref.watch(routeProvider(widget.destination));

    return SizedBox(
      height: 400,
      width: screenWidth,
      child: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: currentPosition,
          initialZoom: 15.0,
        ),
        children: [
          TileLayer(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c'],
          ),
          MarkerLayer(
            markers: [
              Marker(
                width: 80.0,
                height: 80.0,
                point: currentPosition,
                child: Container(
                  child: Icon(
                    Icons.location_on,
                    color: Colors.red,
                    size: 40.0,
                  ),
                ),
              ),
              Marker(
                width: 80.0,
                height: 80.0,
                point: widget.destination,
                child: Container(
                  child: Icon(
                    Icons.flag,
                    color: Colors.green,
                    size: 40.0,
                  ),
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
