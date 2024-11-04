// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'food_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$FoodInfo {
  String get id => throw _privateConstructorUsedError; // The UUID identifier
  String? get dishName => throw _privateConstructorUsedError;
  List<String>? get allergens => throw _privateConstructorUsedError;
  FoodCategory? get foodCategory => throw _privateConstructorUsedError;
  int? get foodTemperature => throw _privateConstructorUsedError;
  int? get numberOfServings => throw _privateConstructorUsedError;
  int? get numberOfBoxes => throw _privateConstructorUsedError;
  FoodBoxType? get foodBoxType => throw _privateConstructorUsedError;
  FoodDateTime? get preparedAt => throw _privateConstructorUsedError;
  FoodDateTime? get consumeBy => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $FoodInfoCopyWith<FoodInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FoodInfoCopyWith<$Res> {
  factory $FoodInfoCopyWith(FoodInfo value, $Res Function(FoodInfo) then) =
      _$FoodInfoCopyWithImpl<$Res, FoodInfo>;
  @useResult
  $Res call(
      {String id,
      String? dishName,
      List<String>? allergens,
      FoodCategory? foodCategory,
      int? foodTemperature,
      int? numberOfServings,
      int? numberOfBoxes,
      FoodBoxType? foodBoxType,
      FoodDateTime? preparedAt,
      FoodDateTime? consumeBy});
}

/// @nodoc
class _$FoodInfoCopyWithImpl<$Res, $Val extends FoodInfo>
    implements $FoodInfoCopyWith<$Res> {
  _$FoodInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? dishName = freezed,
    Object? allergens = freezed,
    Object? foodCategory = freezed,
    Object? foodTemperature = freezed,
    Object? numberOfServings = freezed,
    Object? numberOfBoxes = freezed,
    Object? foodBoxType = freezed,
    Object? preparedAt = freezed,
    Object? consumeBy = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      dishName: freezed == dishName
          ? _value.dishName
          : dishName // ignore: cast_nullable_to_non_nullable
              as String?,
      allergens: freezed == allergens
          ? _value.allergens
          : allergens // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      foodCategory: freezed == foodCategory
          ? _value.foodCategory
          : foodCategory // ignore: cast_nullable_to_non_nullable
              as FoodCategory?,
      foodTemperature: freezed == foodTemperature
          ? _value.foodTemperature
          : foodTemperature // ignore: cast_nullable_to_non_nullable
              as int?,
      numberOfServings: freezed == numberOfServings
          ? _value.numberOfServings
          : numberOfServings // ignore: cast_nullable_to_non_nullable
              as int?,
      numberOfBoxes: freezed == numberOfBoxes
          ? _value.numberOfBoxes
          : numberOfBoxes // ignore: cast_nullable_to_non_nullable
              as int?,
      foodBoxType: freezed == foodBoxType
          ? _value.foodBoxType
          : foodBoxType // ignore: cast_nullable_to_non_nullable
              as FoodBoxType?,
      preparedAt: freezed == preparedAt
          ? _value.preparedAt
          : preparedAt // ignore: cast_nullable_to_non_nullable
              as FoodDateTime?,
      consumeBy: freezed == consumeBy
          ? _value.consumeBy
          : consumeBy // ignore: cast_nullable_to_non_nullable
              as FoodDateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FoodInfoImplCopyWith<$Res>
    implements $FoodInfoCopyWith<$Res> {
  factory _$$FoodInfoImplCopyWith(
          _$FoodInfoImpl value, $Res Function(_$FoodInfoImpl) then) =
      __$$FoodInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String? dishName,
      List<String>? allergens,
      FoodCategory? foodCategory,
      int? foodTemperature,
      int? numberOfServings,
      int? numberOfBoxes,
      FoodBoxType? foodBoxType,
      FoodDateTime? preparedAt,
      FoodDateTime? consumeBy});
}

/// @nodoc
class __$$FoodInfoImplCopyWithImpl<$Res>
    extends _$FoodInfoCopyWithImpl<$Res, _$FoodInfoImpl>
    implements _$$FoodInfoImplCopyWith<$Res> {
  __$$FoodInfoImplCopyWithImpl(
      _$FoodInfoImpl _value, $Res Function(_$FoodInfoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? dishName = freezed,
    Object? allergens = freezed,
    Object? foodCategory = freezed,
    Object? foodTemperature = freezed,
    Object? numberOfServings = freezed,
    Object? numberOfBoxes = freezed,
    Object? foodBoxType = freezed,
    Object? preparedAt = freezed,
    Object? consumeBy = freezed,
  }) {
    return _then(_$FoodInfoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      dishName: freezed == dishName
          ? _value.dishName
          : dishName // ignore: cast_nullable_to_non_nullable
              as String?,
      allergens: freezed == allergens
          ? _value._allergens
          : allergens // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      foodCategory: freezed == foodCategory
          ? _value.foodCategory
          : foodCategory // ignore: cast_nullable_to_non_nullable
              as FoodCategory?,
      foodTemperature: freezed == foodTemperature
          ? _value.foodTemperature
          : foodTemperature // ignore: cast_nullable_to_non_nullable
              as int?,
      numberOfServings: freezed == numberOfServings
          ? _value.numberOfServings
          : numberOfServings // ignore: cast_nullable_to_non_nullable
              as int?,
      numberOfBoxes: freezed == numberOfBoxes
          ? _value.numberOfBoxes
          : numberOfBoxes // ignore: cast_nullable_to_non_nullable
              as int?,
      foodBoxType: freezed == foodBoxType
          ? _value.foodBoxType
          : foodBoxType // ignore: cast_nullable_to_non_nullable
              as FoodBoxType?,
      preparedAt: freezed == preparedAt
          ? _value.preparedAt
          : preparedAt // ignore: cast_nullable_to_non_nullable
              as FoodDateTime?,
      consumeBy: freezed == consumeBy
          ? _value.consumeBy
          : consumeBy // ignore: cast_nullable_to_non_nullable
              as FoodDateTime?,
    ));
  }
}

/// @nodoc

class _$FoodInfoImpl implements _FoodInfo {
  const _$FoodInfoImpl(
      {required this.id,
      this.dishName,
      final List<String>? allergens,
      this.foodCategory,
      this.foodTemperature,
      this.numberOfServings,
      this.numberOfBoxes,
      this.foodBoxType,
      this.preparedAt,
      this.consumeBy})
      : _allergens = allergens;

  @override
  final String id;
// The UUID identifier
  @override
  final String? dishName;
  final List<String>? _allergens;
  @override
  List<String>? get allergens {
    final value = _allergens;
    if (value == null) return null;
    if (_allergens is EqualUnmodifiableListView) return _allergens;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final FoodCategory? foodCategory;
  @override
  final int? foodTemperature;
  @override
  final int? numberOfServings;
  @override
  final int? numberOfBoxes;
  @override
  final FoodBoxType? foodBoxType;
  @override
  final FoodDateTime? preparedAt;
  @override
  final FoodDateTime? consumeBy;

  @override
  String toString() {
    return 'FoodInfo(id: $id, dishName: $dishName, allergens: $allergens, foodCategory: $foodCategory, foodTemperature: $foodTemperature, numberOfServings: $numberOfServings, numberOfBoxes: $numberOfBoxes, foodBoxType: $foodBoxType, preparedAt: $preparedAt, consumeBy: $consumeBy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FoodInfoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.dishName, dishName) ||
                other.dishName == dishName) &&
            const DeepCollectionEquality()
                .equals(other._allergens, _allergens) &&
            (identical(other.foodCategory, foodCategory) ||
                other.foodCategory == foodCategory) &&
            (identical(other.foodTemperature, foodTemperature) ||
                other.foodTemperature == foodTemperature) &&
            (identical(other.numberOfServings, numberOfServings) ||
                other.numberOfServings == numberOfServings) &&
            (identical(other.numberOfBoxes, numberOfBoxes) ||
                other.numberOfBoxes == numberOfBoxes) &&
            (identical(other.foodBoxType, foodBoxType) ||
                other.foodBoxType == foodBoxType) &&
            (identical(other.preparedAt, preparedAt) ||
                other.preparedAt == preparedAt) &&
            (identical(other.consumeBy, consumeBy) ||
                other.consumeBy == consumeBy));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      dishName,
      const DeepCollectionEquality().hash(_allergens),
      foodCategory,
      foodTemperature,
      numberOfServings,
      numberOfBoxes,
      foodBoxType,
      preparedAt,
      consumeBy);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FoodInfoImplCopyWith<_$FoodInfoImpl> get copyWith =>
      __$$FoodInfoImplCopyWithImpl<_$FoodInfoImpl>(this, _$identity);
}

abstract class _FoodInfo implements FoodInfo {
  const factory _FoodInfo(
      {required final String id,
      final String? dishName,
      final List<String>? allergens,
      final FoodCategory? foodCategory,
      final int? foodTemperature,
      final int? numberOfServings,
      final int? numberOfBoxes,
      final FoodBoxType? foodBoxType,
      final FoodDateTime? preparedAt,
      final FoodDateTime? consumeBy}) = _$FoodInfoImpl;

  @override
  String get id;
  @override // The UUID identifier
  String? get dishName;
  @override
  List<String>? get allergens;
  @override
  FoodCategory? get foodCategory;
  @override
  int? get foodTemperature;
  @override
  int? get numberOfServings;
  @override
  int? get numberOfBoxes;
  @override
  FoodBoxType? get foodBoxType;
  @override
  FoodDateTime? get preparedAt;
  @override
  FoodDateTime? get consumeBy;
  @override
  @JsonKey(ignore: true)
  _$$FoodInfoImplCopyWith<_$FoodInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
