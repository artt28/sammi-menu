import 'package:firebase_database/firebase_database.dart';
import '../models/menu.dart';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart'; // <-- 추가

class MenuService {
  final _database = FirebaseDatabase.instance.ref();
  final FirebaseAuth _auth = FirebaseAuth.instance; // <-- 추가

  Stream<List<Menu>> getMenus() async* {
    User? user = _auth.currentUser; // <-- 추가
    if (user == null) {
      yield []; // 인증되지 않은 경우 빈 리스트 반환
      return;
    }

    yield* _database.child('Menu').onValue.map((event) {
      final menuMap = event.snapshot.value as Map<dynamic, dynamic>?; // <-- 변경
      if (menuMap != null) {
        final decodedMap = menuMap.map((key, value) =>
            MapEntry(key.toString(), json.decode(json.encode(value))));

        // 데이터 확인을 위한 로그 제거
        // print('Fetched Menu Data: $decodedMap'); // <-- 제거

        return decodedMap.values
            .map((json) => Menu.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        // 로그 제거
        // print('No data found at Menu path.'); // <-- 제거
        return [];
      }
    });
  }
}
