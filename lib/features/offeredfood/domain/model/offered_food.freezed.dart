// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'offered_food.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OfferedFood {
  String get id;
  DateTime get date;
  String get dishName;
  String get foodCategory;
  FoodCategoryType? get foodCategoryType;
  int? get foodTemperature;
  List<String> get allergens;
  int? get numberOfServings;
  int? get numberOfPackages;
  FoodDateTime? get preparedAt;
  FoodDateTime get consumeBy;
  String get donorId;
  String get recipientId;

  /// Create a copy of OfferedFood
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $OfferedFoodCopyWith<OfferedFood> get copyWith =>
      _$OfferedFoodCopyWithImpl<OfferedFood>(this as OfferedFood, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is OfferedFood &&
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
            const DeepCollectionEquality().equals(other.allergens, allergens) &&
            (identical(other.numberOfServings, numberOfServings) ||
                other.numberOfServings == numberOfServings) &&
            (identical(other.numberOfPackages, numberOfPackages) ||
                other.numberOfPackages == numberOfPackages) &&
            (identical(other.preparedAt, preparedAt) ||
                other.preparedAt == preparedAt) &&
            (identical(other.consumeBy, consumeBy) ||
                other.consumeBy == consumeBy) &&
            (identical(other.donorId, donorId) || other.donorId == donorId) &&
            (identical(other.recipientId, recipientId) ||
                other.recipientId == recipientId));
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
      const DeepCollectionEquality().hash(allergens),
      numberOfServings,
      numberOfPackages,
      preparedAt,
      consumeBy,
      donorId,
      recipientId);

  @override
  String toString() {
    return 'OfferedFood(id: $id, date: $date, dishName: $dishName, foodCategory: $foodCategory, foodCategoryType: $foodCategoryType, foodTemperature: $foodTemperature, allergens: $allergens, numberOfServings: $numberOfServings, numberOfPackages: $numberOfPackages, preparedAt: $preparedAt, consumeBy: $consumeBy, donorId: $donorId, recipientId: $recipientId)';
  }
}

/// @nodoc
abstract mixin class $OfferedFoodCopyWith<$Res> {
  factory $OfferedFoodCopyWith(
          OfferedFood value, $Res Function(OfferedFood) _then) =
      _$OfferedFoodCopyWithImpl;
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
      int? numberOfPackages,
      FoodDateTime? preparedAt,
      FoodDateTime consumeBy,
      String donorId,
      String recipientId});
}

/// @nodoc
class _$OfferedFoodCopyWithImpl<$Res> implements $OfferedFoodCopyWith<$Res> {
  _$OfferedFoodCopyWithImpl(this._self, this._then);

  final OfferedFood _self;
  final $Res Function(OfferedFood) _then;

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
    Object? numberOfPackages = freezed,
    Object? preparedAt = freezed,
    Object? consumeBy = null,
    Object? donorId = null,
    Object? recipientId = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _self.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      dishName: null == dishName
          ? _self.dishName
          : dishName // ignore: cast_nullable_to_non_nullable
              as String,
      foodCategory: null == foodCategory
          ? _self.foodCategory
          : foodCategory // ignore: cast_nullable_to_non_nullable
              as String,
      foodCategoryType: freezed == foodCategoryType
          ? _self.foodCategoryType
          : foodCategoryType // ignore: cast_nullable_to_non_nullable
              as FoodCategoryType?,
      foodTemperature: freezed == foodTemperature
          ? _self.foodTemperature
          : foodTemperature // ignore: cast_nullable_to_non_nullable
              as int?,
      allergens: null == allergens
          ? _self.allergens
          : allergens // ignore: cast_nullable_to_non_nullable
              as List<String>,
      numberOfServings: freezed == numberOfServings
          ? _self.numberOfServings
          : numberOfServings // ignore: cast_nullable_to_non_nullable
              as int?,
      numberOfPackages: freezed == numberOfPackages
          ? _self.numberOfPackages
          : numberOfPackages // ignore: cast_nullable_to_non_nullable
              as int?,
      preparedAt: freezed == preparedAt
          ? _self.preparedAt
          : preparedAt // ignore: cast_nullable_to_non_nullable
              as FoodDateTime?,
      consumeBy: null == consumeBy
          ? _self.consumeBy
          : consumeBy // ignore: cast_nullable_to_non_nullable
              as FoodDateTime,
      donorId: null == donorId
          ? _self.donorId
          : donorId // ignore: cast_nullable_to_non_nullable
              as String,
      recipientId: null == recipientId
          ? _self.recipientId
          : recipientId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _OfferedFood implements OfferedFood {
  const _OfferedFood(
      {required this.id,
      required this.date,
      required this.dishName,
      required this.foodCategory,
      required this.foodCategoryType,
      required this.foodTemperature,
      required final List<String> allergens,
      required this.numberOfServings,
      required this.numberOfPackages,
      required this.preparedAt,
      required this.consumeBy,
      required this.donorId,
      required this.recipientId})
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
  final int? numberOfPackages;
  @override
  final FoodDateTime? preparedAt;
  @override
  final FoodDateTime consumeBy;
  @override
  final String donorId;
  @override
  final String recipientId;

  /// Create a copy of OfferedFood
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$OfferedFoodCopyWith<_OfferedFood> get copyWith =>
      __$OfferedFoodCopyWithImpl<_OfferedFood>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _OfferedFood &&
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
            (identical(other.numberOfPackages, numberOfPackages) ||
                other.numberOfPackages == numberOfPackages) &&
            (identical(other.preparedAt, preparedAt) ||
                other.preparedAt == preparedAt) &&
            (identical(other.consumeBy, consumeBy) ||
                other.consumeBy == consumeBy) &&
            (identical(other.donorId, donorId) || other.donorId == donorId) &&
            (identical(other.recipientId, recipientId) ||
                other.recipientId == recipientId));
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
      numberOfPackages,
      preparedAt,
      consumeBy,
      donorId,
      recipientId);

  @override
  String toString() {
    return 'OfferedFood(id: $id, date: $date, dishName: $dishName, foodCategory: $foodCategory, foodCategoryType: $foodCategoryType, foodTemperature: $foodTemperature, allergens: $allergens, numberOfServings: $numberOfServings, numberOfPackages: $numberOfPackages, preparedAt: $preparedAt, consumeBy: $consumeBy, donorId: $donorId, recipientId: $recipientId)';
  }
}

/// @nodoc
abstract mixin class _$OfferedFoodCopyWith<$Res>
    implements $OfferedFoodCopyWith<$Res> {
  factory _$OfferedFoodCopyWith(
          _OfferedFood value, $Res Function(_OfferedFood) _then) =
      __$OfferedFoodCopyWithImpl;
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
      int? numberOfPackages,
      FoodDateTime? preparedAt,
      FoodDateTime consumeBy,
      String donorId,
      String recipientId});
}

/// @nodoc
class __$OfferedFoodCopyWithImpl<$Res> implements _$OfferedFoodCopyWith<$Res> {
  __$OfferedFoodCopyWithImpl(this._self, this._then);

  final _OfferedFood _self;
  final $Res Function(_OfferedFood) _then;

  /// Create a copy of OfferedFood
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? date = null,
    Object? dishName = null,
    Object? foodCategory = null,
    Object? foodCategoryType = freezed,
    Object? foodTemperature = freezed,
    Object? allergens = null,
    Object? numberOfServings = freezed,
    Object? numberOfPackages = freezed,
    Object? preparedAt = freezed,
    Object? consumeBy = null,
    Object? donorId = null,
    Object? recipientId = null,
  }) {
    return _then(_OfferedFood(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _self.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      dishName: null == dishName
          ? _self.dishName
          : dishName // ignore: cast_nullable_to_non_nullable
              as String,
      foodCategory: null == foodCategory
          ? _self.foodCategory
          : foodCategory // ignore: cast_nullable_to_non_nullable
              as String,
      foodCategoryType: freezed == foodCategoryType
          ? _self.foodCategoryType
          : foodCategoryType // ignore: cast_nullable_to_non_nullable
              as FoodCategoryType?,
      foodTemperature: freezed == foodTemperature
          ? _self.foodTemperature
          : foodTemperature // ignore: cast_nullable_to_non_nullable
              as int?,
      allergens: null == allergens
          ? _self._allergens
          : allergens // ignore: cast_nullable_to_non_nullable
              as List<String>,
      numberOfServings: freezed == numberOfServings
          ? _self.numberOfServings
          : numberOfServings // ignore: cast_nullable_to_non_nullable
              as int?,
      numberOfPackages: freezed == numberOfPackages
          ? _self.numberOfPackages
          : numberOfPackages // ignore: cast_nullable_to_non_nullable
              as int?,
      preparedAt: freezed == preparedAt
          ? _self.preparedAt
          : preparedAt // ignore: cast_nullable_to_non_nullable
              as FoodDateTime?,
      consumeBy: null == consumeBy
          ? _self.consumeBy
          : consumeBy // ignore: cast_nullable_to_non_nullable
              as FoodDateTime,
      donorId: null == donorId
          ? _self.donorId
          : donorId // ignore: cast_nullable_to_non_nullable
              as String,
      recipientId: null == recipientId
          ? _self.recipientId
          : recipientId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
