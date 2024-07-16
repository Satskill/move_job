import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class Database {
  Future login() async {
    FutureProvider((ref) async {
      final response = await http.get(
          Uri.parse('https://movejobapp-359e2f13a5e7.herokuapp.com/items'));
      final data = jsonDecode(response.body);
      return data;
    });
  }
}
