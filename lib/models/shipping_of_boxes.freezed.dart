// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shipping_of_boxes.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

ShippingOfBoxes _$ShippingOfBoxesFromJson(Map<String, dynamic> json) {
  return _ShippingOfBoxes.fromJson(json);
}

/// @nodoc
mixin _$ShippingOfBoxes {
  String? get charityId => throw _privateConstructorUsedError;
  String? get canteenId => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime? get date => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ShippingOfBoxesCopyWith<ShippingOfBoxes> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ShippingOfBoxesCopyWith<$Res> {
  factory $ShippingOfBoxesCopyWith(
          ShippingOfBoxes value, $Res Function(ShippingOfBoxes) then) =
      _$ShippingOfBoxesCopyWithImpl<$Res, ShippingOfBoxes>;
  @useResult
  $Res call(
      {String? charityId,
      String? canteenId,
      @TimestampConverter() DateTime? date});
}

/// @nodoc
class _$ShippingOfBoxesCopyWithImpl<$Res, $Val extends ShippingOfBoxes>
    implements $ShippingOfBoxesCopyWith<$Res> {
  _$ShippingOfBoxesCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? charityId = freezed,
    Object? canteenId = freezed,
    Object? date = freezed,
  }) {
    return _then(_value.copyWith(
      charityId: freezed == charityId
          ? _value.charityId
          : charityId // ignore: cast_nullable_to_non_nullable
              as String?,
      canteenId: freezed == canteenId
          ? _value.canteenId
          : canteenId // ignore: cast_nullable_to_non_nullable
              as String?,
      date: freezed == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_ShippingOfBoxesCopyWith<$Res>
    implements $ShippingOfBoxesCopyWith<$Res> {
  factory _$$_ShippingOfBoxesCopyWith(
          _$_ShippingOfBoxes value, $Res Function(_$_ShippingOfBoxes) then) =
      __$$_ShippingOfBoxesCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? charityId,
      String? canteenId,
      @TimestampConverter() DateTime? date});
}

/// @nodoc
class __$$_ShippingOfBoxesCopyWithImpl<$Res>
    extends _$ShippingOfBoxesCopyWithImpl<$Res, _$_ShippingOfBoxes>
    implements _$$_ShippingOfBoxesCopyWith<$Res> {
  __$$_ShippingOfBoxesCopyWithImpl(
      _$_ShippingOfBoxes _value, $Res Function(_$_ShippingOfBoxes) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? charityId = freezed,
    Object? canteenId = freezed,
    Object? date = freezed,
  }) {
    return _then(_$_ShippingOfBoxes(
      charityId: freezed == charityId
          ? _value.charityId
          : charityId // ignore: cast_nullable_to_non_nullable
              as String?,
      canteenId: freezed == canteenId
          ? _value.canteenId
          : canteenId // ignore: cast_nullable_to_non_nullable
              as String?,
      date: freezed == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_ShippingOfBoxes implements _ShippingOfBoxes {
  const _$_ShippingOfBoxes(
      {this.charityId, this.canteenId, @TimestampConverter() this.date});

  factory _$_ShippingOfBoxes.fromJson(Map<String, dynamic> json) =>
      _$$_ShippingOfBoxesFromJson(json);

  @override
  final String? charityId;
  @override
  final String? canteenId;
  @override
  @TimestampConverter()
  final DateTime? date;

  @override
  String toString() {
    return 'ShippingOfBoxes(charityId: $charityId, canteenId: $canteenId, date: $date)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ShippingOfBoxes &&
            (identical(other.charityId, charityId) ||
                other.charityId == charityId) &&
            (identical(other.canteenId, canteenId) ||
                other.canteenId == canteenId) &&
            (identical(other.date, date) || other.date == date));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, charityId, canteenId, date);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ShippingOfBoxesCopyWith<_$_ShippingOfBoxes> get copyWith =>
      __$$_ShippingOfBoxesCopyWithImpl<_$_ShippingOfBoxes>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ShippingOfBoxesToJson(
      this,
    );
  }
}

abstract class _ShippingOfBoxes implements ShippingOfBoxes {
  const factory _ShippingOfBoxes(
      {final String? charityId,
      final String? canteenId,
      @TimestampConverter() final DateTime? date}) = _$_ShippingOfBoxes;

  factory _ShippingOfBoxes.fromJson(Map<String, dynamic> json) =
      _$_ShippingOfBoxes.fromJson;

  @override
  String? get charityId;
  @override
  String? get canteenId;
  @override
  @TimestampConverter()
  DateTime? get date;
  @override
  @JsonKey(ignore: true)
  _$$_ShippingOfBoxesCopyWith<_$_ShippingOfBoxes> get copyWith =>
      throw _privateConstructorUsedError;
}
