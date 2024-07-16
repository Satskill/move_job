import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:move_job/Data/LocalDatabase.dart';

class UserState {
  final Map? user;
  final bool isLoading;
  final String? error;

  UserState({
    this.user,
    this.isLoading = false,
    this.error,
  });

  UserState copyWith({
    Map? user,
    bool? isLoading,
    String? error,
  }) {
    return UserState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class UserNotifier extends StateNotifier<UserState> {
  UserNotifier() : super(UserState(isLoading: true)) {
    loadUser();
  }

  Future<void> loadUser() async {
    try {
      var user = await LocalDatabase().userGetInfos();
      state = state.copyWith(user: user, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await http.post(
        Uri.parse('https://movejobapp-359e2f13a5e7.herokuapp.com/login'),
        body: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        state = state.copyWith(user: data['user'], isLoading: false);
      } else {
        state = state.copyWith(error: 'Login failed', isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(error: 'Connection failed', isLoading: false);
    }
  }

  Future<void> register(String email, String password, String name,
      String surname, String userType) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await http.post(
        Uri.parse('https://movejobapp-359e2f13a5e7.herokuapp.com/login'),
        body: {
          'email': email,
          'password': password,
          'name': name,
          'surname': surname,
          'userType': userType,
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        state = state.copyWith(user: data['user'], isLoading: false);
      } else {
        state = state.copyWith(error: 'Login failed', isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(error: 'Connection failed', isLoading: false);
    }
  }

  void logout() {
    state = UserState();
  }
}

final userProvider = StateNotifierProvider<UserNotifier, UserState>((ref) {
  return UserNotifier();
});
