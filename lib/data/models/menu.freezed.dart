// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'menu.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Menu _$MenuFromJson(Map<String, dynamic> json) {
  return _Menu.fromJson(json);
}

/// @nodoc
mixin _$Menu {
  @JsonKey(name: '_id')
  @HiveField(0)
  String get id => throw _privateConstructorUsedError;
  @HiveField(1)
  String get menuType => throw _privateConstructorUsedError; // Improved naming
  @HiveField(2)
  Map<String, String> get name => throw _privateConstructorUsedError;
  @HiveField(3)
  int get price => throw _privateConstructorUsedError;
  @HiveField(4)
  Map<String, String> get description => throw _privateConstructorUsedError;
  @HiveField(5)
  String get imageUrl => throw _privateConstructorUsedError;
  @HiveField(6)
  bool get valid => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MenuCopyWith<Menu> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MenuCopyWith<$Res> {
  factory $MenuCopyWith(Menu value, $Res Function(Menu) then) =
      _$MenuCopyWithImpl<$Res, Menu>;
  @useResult
  $Res call(
      {@JsonKey(name: '_id') @HiveField(0) String id,
      @HiveField(1) String menuType,
      @HiveField(2) Map<String, String> name,
      @HiveField(3) int price,
      @HiveField(4) Map<String, String> description,
      @HiveField(5) String imageUrl,
      @HiveField(6) bool valid});
}

/// @nodoc
class _$MenuCopyWithImpl<$Res, $Val extends Menu>
    implements $MenuCopyWith<$Res> {
  _$MenuCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? menuType = null,
    Object? name = null,
    Object? price = null,
    Object? description = null,
    Object? imageUrl = null,
    Object? valid = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      menuType: null == menuType
          ? _value.menuType
          : menuType // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as int,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
      imageUrl: null == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      valid: null == valid
          ? _value.valid
          : valid // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MenuImplCopyWith<$Res> implements $MenuCopyWith<$Res> {
  factory _$$MenuImplCopyWith(
          _$MenuImpl value, $Res Function(_$MenuImpl) then) =
      __$$MenuImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: '_id') @HiveField(0) String id,
      @HiveField(1) String menuType,
      @HiveField(2) Map<String, String> name,
      @HiveField(3) int price,
      @HiveField(4) Map<String, String> description,
      @HiveField(5) String imageUrl,
      @HiveField(6) bool valid});
}

/// @nodoc
class __$$MenuImplCopyWithImpl<$Res>
    extends _$MenuCopyWithImpl<$Res, _$MenuImpl>
    implements _$$MenuImplCopyWith<$Res> {
  __$$MenuImplCopyWithImpl(_$MenuImpl _value, $Res Function(_$MenuImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? menuType = null,
    Object? name = null,
    Object? price = null,
    Object? description = null,
    Object? imageUrl = null,
    Object? valid = null,
  }) {
    return _then(_$MenuImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      menuType: null == menuType
          ? _value.menuType
          : menuType // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value._name
          : name // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as int,
      description: null == description
          ? _value._description
          : description // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
      imageUrl: null == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      valid: null == valid
          ? _value.valid
          : valid // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
@HiveType(typeId: 0, adapterName: 'MenuAdapter')
class _$MenuImpl implements _Menu {
  const _$MenuImpl(
      {@JsonKey(name: '_id') @HiveField(0) required this.id,
      @HiveField(1) required this.menuType,
      @HiveField(2) required final Map<String, String> name,
      @HiveField(3) required this.price,
      @HiveField(4) required final Map<String, String> description,
      @HiveField(5) required this.imageUrl,
      @HiveField(6) this.valid = true})
      : _name = name,
        _description = description;

  factory _$MenuImpl.fromJson(Map<String, dynamic> json) =>
      _$$MenuImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  @HiveField(0)
  final String id;
  @override
  @HiveField(1)
  final String menuType;
// Improved naming
  final Map<String, String> _name;
// Improved naming
  @override
  @HiveField(2)
  Map<String, String> get name {
    if (_name is EqualUnmodifiableMapView) return _name;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_name);
  }

  @override
  @HiveField(3)
  final int price;
  final Map<String, String> _description;
  @override
  @HiveField(4)
  Map<String, String> get description {
    if (_description is EqualUnmodifiableMapView) return _description;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_description);
  }

  @override
  @HiveField(5)
  final String imageUrl;
  @override
  @JsonKey()
  @HiveField(6)
  final bool valid;

  @override
  String toString() {
    return 'Menu(id: $id, menuType: $menuType, name: $name, price: $price, description: $description, imageUrl: $imageUrl, valid: $valid)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MenuImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.menuType, menuType) ||
                other.menuType == menuType) &&
            const DeepCollectionEquality().equals(other._name, _name) &&
            (identical(other.price, price) || other.price == price) &&
            const DeepCollectionEquality()
                .equals(other._description, _description) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.valid, valid) || other.valid == valid));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      menuType,
      const DeepCollectionEquality().hash(_name),
      price,
      const DeepCollectionEquality().hash(_description),
      imageUrl,
      valid);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MenuImplCopyWith<_$MenuImpl> get copyWith =>
      __$$MenuImplCopyWithImpl<_$MenuImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MenuImplToJson(
      this,
    );
  }
}

abstract class _Menu implements Menu {
  const factory _Menu(
      {@JsonKey(name: '_id') @HiveField(0) required final String id,
      @HiveField(1) required final String menuType,
      @HiveField(2) required final Map<String, String> name,
      @HiveField(3) required final int price,
      @HiveField(4) required final Map<String, String> description,
      @HiveField(5) required final String imageUrl,
      @HiveField(6) final bool valid}) = _$MenuImpl;

  factory _Menu.fromJson(Map<String, dynamic> json) = _$MenuImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  @HiveField(0)
  String get id;
  @override
  @HiveField(1)
  String get menuType;
  @override // Improved naming
  @HiveField(2)
  Map<String, String> get name;
  @override
  @HiveField(3)
  int get price;
  @override
  @HiveField(4)
  Map<String, String> get description;
  @override
  @HiveField(5)
  String get imageUrl;
  @override
  @HiveField(6)
  bool get valid;
  @override
  @JsonKey(ignore: true)
  _$$MenuImplCopyWith<_$MenuImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
