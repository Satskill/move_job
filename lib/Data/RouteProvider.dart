import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:move_job/Data/LocationProvider.dart';

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
