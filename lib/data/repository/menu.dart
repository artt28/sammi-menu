import 'package:firebase_database/firebase_database.dart';
import '../models/menu.dart';
import 'dart:convert';


class MenuService {
  final _database = FirebaseDatabase.instance.ref();

  Stream<List<Menu>> getMenus() {
    return _database.child('Menu').onValue.map((event) {
      final menuMap = event.snapshot.value as Map<dynamic, dynamic>?; // <-- Change here
      if (menuMap != null) {
        final decodedMap = menuMap.map((key, value) => MapEntry(key.toString(), json.decode(json.encode(value))));
        return decodedMap.values
            .map((json) => Menu.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        return [];
      }
    });
  }
}
