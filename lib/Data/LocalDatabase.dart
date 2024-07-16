import 'package:hive/hive.dart';

class LocalDatabase {
  Future userInsertDB(Map<String, dynamic> data) async {
    final collection = Hive.box('User');
    await collection.put('data', data);
  }

  Future userGetInfos() async {
    final collection = Hive.box('User');
    return await collection.get('data');
  }

  Future userDeleteDB() async {
    final collection = Hive.box('User');
    await collection.clear();
  }
}
