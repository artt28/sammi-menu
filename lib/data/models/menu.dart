import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'menu.freezed.dart';
part 'menu.g.dart';

@freezed
class Menu with _$Menu {
  @HiveType(typeId: 0, adapterName: 'MenuAdapter') // Improved naming
  const factory Menu({
    @JsonKey(name: '_id')
    @HiveField(0) required String id,
    @HiveField(1) required String menuType,  // Improved naming
    @HiveField(2) required Map<String, String> name,
    @HiveField(3) required int price,
    @HiveField(4) required Map<String, String> description,
    @HiveField(5) required String imageUrl,
    @HiveField(6) @Default(true) bool valid, // Use @Default for better handling
  }) = _Menu;

  factory Menu.fromJson(Map<String, dynamic> json) => _$MenuFromJson(json);
}
