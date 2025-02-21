// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'offered_food.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$OfferedFood {
  String get id => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;
  String get dishName => throw _privateConstructorUsedError;
  String get foodCategory => throw _privateConstructorUsedError;
  FoodCategoryType? get foodCategoryType => throw _privateConstructorUsedError;
  int? get foodTemperature => throw _privateConstructorUsedError;
  List<String> get allergens => throw _privateConstructorUsedError;
  int? get numberOfServings => throw _privateConstructorUsedError;
  String? get boxType => throw _privateConstructorUsedError;
  FoodDateTime? get preparedAt => throw _privateConstructorUsedError;
  FoodDateTime get consumeBy => throw _privateConstructorUsedError;
  String get donorId => throw _privateConstructorUsedError;
  String get recipientId => throw _privateConstructorUsedError;
  int? get numberOfBoxes => throw _privateConstructorUsedError;
  int? get numberOfPackages => throw _privateConstructorUsedError;

  /// Create a copy of OfferedFood
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OfferedFoodCopyWith<OfferedFood> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OfferedFoodCopyWith<$Res> {
  factory $OfferedFoodCopyWith(
          OfferedFood value, $Res Function(OfferedFood) then) =
      _$OfferedFoodCopyWithImpl<$Res, OfferedFood>;
  @useResult
  $Res call(
      {String id,
      DateTime date,
      String dishName,
      String foodCategory,
      FoodCategoryType? foodCategoryType,
      int? foodTemperature,
      List<String> allergens,
      int? numberOfServings,
      String? boxType,
      FoodDateTime? preparedAt,
      FoodDateTime consumeBy,
      String donorId,
      String recipientId,
      int? numberOfBoxes,
      int? numberOfPackages});
}

/// @nodoc
class _$OfferedFoodCopyWithImpl<$Res, $Val extends OfferedFood>
    implements $OfferedFoodCopyWith<$Res> {
  _$OfferedFoodCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OfferedFood
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? date = null,
    Object? dishName = null,
    Object? foodCategory = null,
    Object? foodCategoryType = freezed,
    Object? foodTemperature = freezed,
    Object? allergens = null,
    Object? numberOfServings = freezed,
    Object? boxType = freezed,
    Object? preparedAt = freezed,
    Object? consumeBy = null,
    Object? donorId = null,
    Object? recipientId = null,
    Object? numberOfBoxes = freezed,
    Object? numberOfPackages = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      dishName: null == dishName
          ? _value.dishName
          : dishName // ignore: cast_nullable_to_non_nullable
              as String,
      foodCategory: null == foodCategory
          ? _value.foodCategory
          : foodCategory // ignore: cast_nullable_to_non_nullable
              as String,
      foodCategoryType: freezed == foodCategoryType
          ? _value.foodCategoryType
          : foodCategoryType // ignore: cast_nullable_to_non_nullable
              as FoodCategoryType?,
      foodTemperature: freezed == foodTemperature
          ? _value.foodTemperature
          : foodTemperature // ignore: cast_nullable_to_non_nullable
              as int?,
      allergens: null == allergens
          ? _value.allergens
          : allergens // ignore: cast_nullable_to_non_nullable
              as List<String>,
      numberOfServings: freezed == numberOfServings
          ? _value.numberOfServings
          : numberOfServings // ignore: cast_nullable_to_non_nullable
              as int?,
      boxType: freezed == boxType
          ? _value.boxType
          : boxType // ignore: cast_nullable_to_non_nullable
              as String?,
      preparedAt: freezed == preparedAt
          ? _value.preparedAt
          : preparedAt // ignore: cast_nullable_to_non_nullable
              as FoodDateTime?,
      consumeBy: null == consumeBy
          ? _value.consumeBy
          : consumeBy // ignore: cast_nullable_to_non_nullable
              as FoodDateTime,
      donorId: null == donorId
          ? _value.donorId
          : donorId // ignore: cast_nullable_to_non_nullable
              as String,
      recipientId: null == recipientId
          ? _value.recipientId
          : recipientId // ignore: cast_nullable_to_non_nullable
              as String,
      numberOfBoxes: freezed == numberOfBoxes
          ? _value.numberOfBoxes
          : numberOfBoxes // ignore: cast_nullable_to_non_nullable
              as int?,
      numberOfPackages: freezed == numberOfPackages
          ? _value.numberOfPackages
          : numberOfPackages // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OfferedFoodImplCopyWith<$Res>
    implements $OfferedFoodCopyWith<$Res> {
  factory _$$OfferedFoodImplCopyWith(
          _$OfferedFoodImpl value, $Res Function(_$OfferedFoodImpl) then) =
      __$$OfferedFoodImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      DateTime date,
      String dishName,
      String foodCategory,
      FoodCategoryType? foodCategoryType,
      int? foodTemperature,
      List<String> allergens,
      int? numberOfServings,
      String? boxType,
      FoodDateTime? preparedAt,
      FoodDateTime consumeBy,
      String donorId,
      String recipientId,
      int? numberOfBoxes,
      int? numberOfPackages});
}

/// @nodoc
class __$$OfferedFoodImplCopyWithImpl<$Res>
    extends _$OfferedFoodCopyWithImpl<$Res, _$OfferedFoodImpl>
    implements _$$OfferedFoodImplCopyWith<$Res> {
  __$$OfferedFoodImplCopyWithImpl(
      _$OfferedFoodImpl _value, $Res Function(_$OfferedFoodImpl) _then)
      : super(_value, _then);

  /// Create a copy of OfferedFood
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? date = null,
    Object? dishName = null,
    Object? foodCategory = null,
    Object? foodCategoryType = freezed,
    Object? foodTemperature = freezed,
    Object? allergens = null,
    Object? numberOfServings = freezed,
    Object? boxType = freezed,
    Object? preparedAt = freezed,
    Object? consumeBy = null,
    Object? donorId = null,
    Object? recipientId = null,
    Object? numberOfBoxes = freezed,
    Object? numberOfPackages = freezed,
  }) {
    return _then(_$OfferedFoodImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      dishName: null == dishName
          ? _value.dishName
          : dishName // ignore: cast_nullable_to_non_nullable
              as String,
      foodCategory: null == foodCategory
          ? _value.foodCategory
          : foodCategory // ignore: cast_nullable_to_non_nullable
              as String,
      foodCategoryType: freezed == foodCategoryType
          ? _value.foodCategoryType
          : foodCategoryType // ignore: cast_nullable_to_non_nullable
              as FoodCategoryType?,
      foodTemperature: freezed == foodTemperature
          ? _value.foodTemperature
          : foodTemperature // ignore: cast_nullable_to_non_nullable
              as int?,
      allergens: null == allergens
          ? _value._allergens
          : allergens // ignore: cast_nullable_to_non_nullable
              as List<String>,
      numberOfServings: freezed == numberOfServings
          ? _value.numberOfServings
          : numberOfServings // ignore: cast_nullable_to_non_nullable
              as int?,
      boxType: freezed == boxType
          ? _value.boxType
          : boxType // ignore: cast_nullable_to_non_nullable
              as String?,
      preparedAt: freezed == preparedAt
          ? _value.preparedAt
          : preparedAt // ignore: cast_nullable_to_non_nullable
              as FoodDateTime?,
      consumeBy: null == consumeBy
          ? _value.consumeBy
          : consumeBy // ignore: cast_nullable_to_non_nullable
              as FoodDateTime,
      donorId: null == donorId
          ? _value.donorId
          : donorId // ignore: cast_nullable_to_non_nullable
              as String,
      recipientId: null == recipientId
          ? _value.recipientId
          : recipientId // ignore: cast_nullable_to_non_nullable
              as String,
      numberOfBoxes: freezed == numberOfBoxes
          ? _value.numberOfBoxes
          : numberOfBoxes // ignore: cast_nullable_to_non_nullable
              as int?,
      numberOfPackages: freezed == numberOfPackages
          ? _value.numberOfPackages
          : numberOfPackages // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc

class _$OfferedFoodImpl implements _OfferedFood {
  const _$OfferedFoodImpl(
      {required this.id,
      required this.date,
      required this.dishName,
      required this.foodCategory,
      required this.foodCategoryType,
      required this.foodTemperature,
      required final List<String> allergens,
      required this.numberOfServings,
      required this.boxType,
      required this.preparedAt,
      required this.consumeBy,
      required this.donorId,
      required this.recipientId,
      required this.numberOfBoxes,
      required this.numberOfPackages})
      : _allergens = allergens;

  @override
  final String id;
  @override
  final DateTime date;
  @override
  final String dishName;
  @override
  final String foodCategory;
  @override
  final FoodCategoryType? foodCategoryType;
  @override
  final int? foodTemperature;
  final List<String> _allergens;
  @override
  List<String> get allergens {
    if (_allergens is EqualUnmodifiableListView) return _allergens;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_allergens);
  }

  @override
  final int? numberOfServings;
  @override
  final String? boxType;
  @override
  final FoodDateTime? preparedAt;
  @override
  final FoodDateTime consumeBy;
  @override
  final String donorId;
  @override
  final String recipientId;
  @override
  final int? numberOfBoxes;
  @override
  final int? numberOfPackages;

  @override
  String toString() {
    return 'OfferedFood(id: $id, date: $date, dishName: $dishName, foodCategory: $foodCategory, foodCategoryType: $foodCategoryType, foodTemperature: $foodTemperature, allergens: $allergens, numberOfServings: $numberOfServings, boxType: $boxType, preparedAt: $preparedAt, consumeBy: $consumeBy, donorId: $donorId, recipientId: $recipientId, numberOfBoxes: $numberOfBoxes, numberOfPackages: $numberOfPackages)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OfferedFoodImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.dishName, dishName) ||
                other.dishName == dishName) &&
            (identical(other.foodCategory, foodCategory) ||
                other.foodCategory == foodCategory) &&
            (identical(other.foodCategoryType, foodCategoryType) ||
                other.foodCategoryType == foodCategoryType) &&
            (identical(other.foodTemperature, foodTemperature) ||
                other.foodTemperature == foodTemperature) &&
            const DeepCollectionEquality()
                .equals(other._allergens, _allergens) &&
            (identical(other.numberOfServings, numberOfServings) ||
                other.numberOfServings == numberOfServings) &&
            (identical(other.boxType, boxType) || other.boxType == boxType) &&
            (identical(other.preparedAt, preparedAt) ||
                other.preparedAt == preparedAt) &&
            (identical(other.consumeBy, consumeBy) ||
                other.consumeBy == consumeBy) &&
            (identical(other.donorId, donorId) || other.donorId == donorId) &&
            (identical(other.recipientId, recipientId) ||
                other.recipientId == recipientId) &&
            (identical(other.numberOfBoxes, numberOfBoxes) ||
                other.numberOfBoxes == numberOfBoxes) &&
            (identical(other.numberOfPackages, numberOfPackages) ||
                other.numberOfPackages == numberOfPackages));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      date,
      dishName,
      foodCategory,
      foodCategoryType,
      foodTemperature,
      const DeepCollectionEquality().hash(_allergens),
      numberOfServings,
      boxType,
      preparedAt,
      consumeBy,
      donorId,
      recipientId,
      numberOfBoxes,
      numberOfPackages);

  /// Create a copy of OfferedFood
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OfferedFoodImplCopyWith<_$OfferedFoodImpl> get copyWith =>
      __$$OfferedFoodImplCopyWithImpl<_$OfferedFoodImpl>(this, _$identity);
}

abstract class _OfferedFood implements OfferedFood {
  const factory _OfferedFood(
      {required final String id,
      required final DateTime date,
      required final String dishName,
      required final String foodCategory,
      required final FoodCategoryType? foodCategoryType,
      required final int? foodTemperature,
      required final List<String> allergens,
      required final int? numberOfServings,
      required final String? boxType,
      required final FoodDateTime? preparedAt,
      required final FoodDateTime consumeBy,
      required final String donorId,
      required final String recipientId,
      required final int? numberOfBoxes,
      required final int? numberOfPackages}) = _$OfferedFoodImpl;

  @override
  String get id;
  @override
  DateTime get date;
  @override
  String get dishName;
  @override
  String get foodCategory;
  @override
  FoodCategoryType? get foodCategoryType;
  @override
  int? get foodTemperature;
  @override
  List<String> get allergens;
  @override
  int? get numberOfServings;
  @override
  String? get boxType;
  @override
  FoodDateTime? get preparedAt;
  @override
  FoodDateTime get consumeBy;
  @override
  String get donorId;
  @override
  String get recipientId;
  @override
  int? get numberOfBoxes;
  @override
  int? get numberOfPackages;

  /// Create a copy of OfferedFood
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OfferedFoodImplCopyWith<_$OfferedFoodImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
