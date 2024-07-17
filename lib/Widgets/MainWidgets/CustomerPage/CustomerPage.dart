import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

final dataProvider =
    FutureProvider.autoDispose.family<String, String>((ref, param) async {
  final response =
      await http.get(Uri.parse('https://api.example.com/data/$param'));
  if (response.statusCode == 200) {
    return response.body;
  } else {
    throw Exception('Failed to load data');
  }
});

class CustomerPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final futureAsyncValue = ref.watch(dataProvider('example'));

    return Column(
      children: [
        ElevatedButton(onPressed: () {}, child: Text('Yeni Kargo')),
        futureAsyncValue.when(
          loading: () => CircularProgressIndicator(),
          error: (error, stackTrace) => Text('Error: $error'),
          data: (data) => Text('Data: $data'),
        ),
      ],
    );
  }
}
