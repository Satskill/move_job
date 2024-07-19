import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DeliveryState {
  final List? data;
  final bool isLoading;
  final String? error;

  DeliveryState({
    this.data,
    this.isLoading = false,
    this.error,
  });

  DeliveryState copyWith({
    List? data,
    bool? isLoading,
    String? error,
  }) {
    return DeliveryState(
      data: data ?? this.data,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class DeliveryNotifier extends StateNotifier<DeliveryState> {
  DeliveryNotifier() : super(DeliveryState(isLoading: true));

  Future<void> allDeliveries() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await http.get(
        Uri.parse('https://movejobapp-359e2f13a5e7.herokuapp.com/deliveries'),
      );

      log(response.body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        state = state.copyWith(data: data, isLoading: false);
      } else {
        state = state.copyWith(error: 'Veri Tabanı Hatası', isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(error: 'Bağlantı Hatası', isLoading: false);
    }
  }

  Future<void> myDeliveries(String email) async {
    log(email);
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await http.post(
        Uri.parse('https://movejobapp-359e2f13a5e7.herokuapp.com/mydeliveries'),
        body: {
          'email': email,
        },
      );

      log(response.body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        state = state.copyWith(data: data, isLoading: false);
      } else {
        state = state.copyWith(error: 'Veri Tabanı Hatası', isLoading: false);
      }
    } catch (e) {
      log(e.toString());
      state = state.copyWith(error: 'Bağlantı Hatası', isLoading: false);
    }
  }

  Future<void> addDeliveries(String email, String name, String surname,
      double lat, double lng, String address, List items) async {
    log('helelelele');
    state = state.copyWith(isLoading: true, error: null);
    log('belelelelebbbbbbbbbbbbb');
    try {
      final response = await http.post(
        Uri.parse(
            'https://movejobapp-359e2f13a5e7.herokuapp.com/adddeliveries'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'name': name,
          'surname': surname,
          'lat': lat,
          'lng': lng,
          'address': address,
          'isDelivered': false,
          'items': items,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        state = state.copyWith(data: data['deliveries'], isLoading: false);
      } else {
        state = state.copyWith(error: 'Veri Tabanı Hatası', isLoading: false);
      }
    } catch (e) {
      log(e.toString());
      state = state.copyWith(error: 'Bağlantı Hatası', isLoading: false);
    }
  }

  Future<void> deliver(int id, int deliverer) async {
    log('bbbbbbbbbbbbbbbbbbbbbbb');

    try {
      final response = await http.post(
        Uri.parse('https://movejobapp-359e2f13a5e7.herokuapp.com/deliver'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'id': id,
          'isDelivered': true,
          'deliverer': deliverer,
        }),
      );

      log(response.body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        state = state.copyWith(data: data['data'], isLoading: false);
      } else {
        state = state.copyWith(error: 'Veri Tabanı Hatası', isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(error: 'Bağlantı Hatası', isLoading: false);
    }
  }

  void logout() {
    state = DeliveryState();
  }
}

final deliveryProvider =
    StateNotifierProvider<DeliveryNotifier, DeliveryState>((ref) {
  return DeliveryNotifier();
});
