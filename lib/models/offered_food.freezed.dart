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
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

OfferedFood _$OfferedFoodFromJson(Map<String, dynamic> json) {
  return _OfferedFood.fromJson(json);
}

/// @nodoc
mixin _$OfferedFood {
  String? get id => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime? get date => throw _privateConstructorUsedError;
  int? get dateTimestamp => throw _privateConstructorUsedError;
  String? get dishName => throw _privateConstructorUsedError;
  String? get foodCategory => throw _privateConstructorUsedError;
  List<String>? get allergens => throw _privateConstructorUsedError;
  int? get numberOfServings => throw _privateConstructorUsedError;
  String? get boxType => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime? get consumeBy => throw _privateConstructorUsedError;
  int? get consumeByTimestamp => throw _privateConstructorUsedError;
  String? get weekNumber => throw _privateConstructorUsedError;
  String? get donorId => throw _privateConstructorUsedError;
  String? get recipientId => throw _privateConstructorUsedError;
  int? get numberOfBoxes => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
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
      {String? id,
      @TimestampConverter() DateTime? date,
      int? dateTimestamp,
      String? dishName,
      String? foodCategory,
      List<String>? allergens,
      int? numberOfServings,
      String? boxType,
      @TimestampConverter() DateTime? consumeBy,
      int? consumeByTimestamp,
      String? weekNumber,
      String? donorId,
      String? recipientId,
      int? numberOfBoxes});
}

/// @nodoc
class _$OfferedFoodCopyWithImpl<$Res, $Val extends OfferedFood>
    implements $OfferedFoodCopyWith<$Res> {
  _$OfferedFoodCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? date = freezed,
    Object? dateTimestamp = freezed,
    Object? dishName = freezed,
    Object? foodCategory = freezed,
    Object? allergens = freezed,
    Object? numberOfServings = freezed,
    Object? boxType = freezed,
    Object? consumeBy = freezed,
    Object? consumeByTimestamp = freezed,
    Object? weekNumber = freezed,
    Object? donorId = freezed,
    Object? recipientId = freezed,
    Object? numberOfBoxes = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      date: freezed == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      dateTimestamp: freezed == dateTimestamp
          ? _value.dateTimestamp
          : dateTimestamp // ignore: cast_nullable_to_non_nullable
              as int?,
      dishName: freezed == dishName
          ? _value.dishName
          : dishName // ignore: cast_nullable_to_non_nullable
              as String?,
      foodCategory: freezed == foodCategory
          ? _value.foodCategory
          : foodCategory // ignore: cast_nullable_to_non_nullable
              as String?,
      allergens: freezed == allergens
          ? _value.allergens
          : allergens // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      numberOfServings: freezed == numberOfServings
          ? _value.numberOfServings
          : numberOfServings // ignore: cast_nullable_to_non_nullable
              as int?,
      boxType: freezed == boxType
          ? _value.boxType
          : boxType // ignore: cast_nullable_to_non_nullable
              as String?,
      consumeBy: freezed == consumeBy
          ? _value.consumeBy
          : consumeBy // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      consumeByTimestamp: freezed == consumeByTimestamp
          ? _value.consumeByTimestamp
          : consumeByTimestamp // ignore: cast_nullable_to_non_nullable
              as int?,
      weekNumber: freezed == weekNumber
          ? _value.weekNumber
          : weekNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      donorId: freezed == donorId
          ? _value.donorId
          : donorId // ignore: cast_nullable_to_non_nullable
              as String?,
      recipientId: freezed == recipientId
          ? _value.recipientId
          : recipientId // ignore: cast_nullable_to_non_nullable
              as String?,
      numberOfBoxes: freezed == numberOfBoxes
          ? _value.numberOfBoxes
          : numberOfBoxes // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_OfferedFoodCopyWith<$Res>
    implements $OfferedFoodCopyWith<$Res> {
  factory _$$_OfferedFoodCopyWith(
          _$_OfferedFood value, $Res Function(_$_OfferedFood) then) =
      __$$_OfferedFoodCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? id,
      @TimestampConverter() DateTime? date,
      int? dateTimestamp,
      String? dishName,
      String? foodCategory,
      List<String>? allergens,
      int? numberOfServings,
      String? boxType,
      @TimestampConverter() DateTime? consumeBy,
      int? consumeByTimestamp,
      String? weekNumber,
      String? donorId,
      String? recipientId,
      int? numberOfBoxes});
}

/// @nodoc
class __$$_OfferedFoodCopyWithImpl<$Res>
    extends _$OfferedFoodCopyWithImpl<$Res, _$_OfferedFood>
    implements _$$_OfferedFoodCopyWith<$Res> {
  __$$_OfferedFoodCopyWithImpl(
      _$_OfferedFood _value, $Res Function(_$_OfferedFood) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? date = freezed,
    Object? dateTimestamp = freezed,
    Object? dishName = freezed,
    Object? foodCategory = freezed,
    Object? allergens = freezed,
    Object? numberOfServings = freezed,
    Object? boxType = freezed,
    Object? consumeBy = freezed,
    Object? consumeByTimestamp = freezed,
    Object? weekNumber = freezed,
    Object? donorId = freezed,
    Object? recipientId = freezed,
    Object? numberOfBoxes = freezed,
  }) {
    return _then(_$_OfferedFood(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      date: freezed == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      dateTimestamp: freezed == dateTimestamp
          ? _value.dateTimestamp
          : dateTimestamp // ignore: cast_nullable_to_non_nullable
              as int?,
      dishName: freezed == dishName
          ? _value.dishName
          : dishName // ignore: cast_nullable_to_non_nullable
              as String?,
      foodCategory: freezed == foodCategory
          ? _value.foodCategory
          : foodCategory // ignore: cast_nullable_to_non_nullable
              as String?,
      allergens: freezed == allergens
          ? _value._allergens
          : allergens // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      numberOfServings: freezed == numberOfServings
          ? _value.numberOfServings
          : numberOfServings // ignore: cast_nullable_to_non_nullable
              as int?,
      boxType: freezed == boxType
          ? _value.boxType
          : boxType // ignore: cast_nullable_to_non_nullable
              as String?,
      consumeBy: freezed == consumeBy
          ? _value.consumeBy
          : consumeBy // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      consumeByTimestamp: freezed == consumeByTimestamp
          ? _value.consumeByTimestamp
          : consumeByTimestamp // ignore: cast_nullable_to_non_nullable
              as int?,
      weekNumber: freezed == weekNumber
          ? _value.weekNumber
          : weekNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      donorId: freezed == donorId
          ? _value.donorId
          : donorId // ignore: cast_nullable_to_non_nullable
              as String?,
      recipientId: freezed == recipientId
          ? _value.recipientId
          : recipientId // ignore: cast_nullable_to_non_nullable
              as String?,
      numberOfBoxes: freezed == numberOfBoxes
          ? _value.numberOfBoxes
          : numberOfBoxes // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_OfferedFood implements _OfferedFood {
  const _$_OfferedFood(
      {this.id,
      @TimestampConverter() this.date,
      this.dateTimestamp,
      this.dishName,
      this.foodCategory,
      final List<String>? allergens,
      this.numberOfServings,
      this.boxType,
      @TimestampConverter() this.consumeBy,
      this.consumeByTimestamp,
      this.weekNumber,
      this.donorId,
      this.recipientId,
      this.numberOfBoxes})
      : _allergens = allergens;

  factory _$_OfferedFood.fromJson(Map<String, dynamic> json) =>
      _$$_OfferedFoodFromJson(json);

  @override
  final String? id;
  @override
  @TimestampConverter()
  final DateTime? date;
  @override
  final int? dateTimestamp;
  @override
  final String? dishName;
  @override
  final String? foodCategory;
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
  final int? numberOfServings;
  @override
  final String? boxType;
  @override
  @TimestampConverter()
  final DateTime? consumeBy;
  @override
  final int? consumeByTimestamp;
  @override
  final String? weekNumber;
  @override
  final String? donorId;
  @override
  final String? recipientId;
  @override
  final int? numberOfBoxes;

  @override
  String toString() {
    return 'OfferedFood(id: $id, date: $date, dateTimestamp: $dateTimestamp, dishName: $dishName, foodCategory: $foodCategory, allergens: $allergens, numberOfServings: $numberOfServings, boxType: $boxType, consumeBy: $consumeBy, consumeByTimestamp: $consumeByTimestamp, weekNumber: $weekNumber, donorId: $donorId, recipientId: $recipientId, numberOfBoxes: $numberOfBoxes)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_OfferedFood &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.dateTimestamp, dateTimestamp) ||
                other.dateTimestamp == dateTimestamp) &&
            (identical(other.dishName, dishName) ||
                other.dishName == dishName) &&
            (identical(other.foodCategory, foodCategory) ||
                other.foodCategory == foodCategory) &&
            const DeepCollectionEquality()
                .equals(other._allergens, _allergens) &&
            (identical(other.numberOfServings, numberOfServings) ||
                other.numberOfServings == numberOfServings) &&
            (identical(other.boxType, boxType) || other.boxType == boxType) &&
            (identical(other.consumeBy, consumeBy) ||
                other.consumeBy == consumeBy) &&
            (identical(other.consumeByTimestamp, consumeByTimestamp) ||
                other.consumeByTimestamp == consumeByTimestamp) &&
            (identical(other.weekNumber, weekNumber) ||
                other.weekNumber == weekNumber) &&
            (identical(other.donorId, donorId) || other.donorId == donorId) &&
            (identical(other.recipientId, recipientId) ||
                other.recipientId == recipientId) &&
            (identical(other.numberOfBoxes, numberOfBoxes) ||
                other.numberOfBoxes == numberOfBoxes));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      date,
      dateTimestamp,
      dishName,
      foodCategory,
      const DeepCollectionEquality().hash(_allergens),
      numberOfServings,
      boxType,
      consumeBy,
      consumeByTimestamp,
      weekNumber,
      donorId,
      recipientId,
      numberOfBoxes);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_OfferedFoodCopyWith<_$_OfferedFood> get copyWith =>
      __$$_OfferedFoodCopyWithImpl<_$_OfferedFood>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_OfferedFoodToJson(
      this,
    );
  }
}

abstract class _OfferedFood implements OfferedFood {
  const factory _OfferedFood(
      {final String? id,
      @TimestampConverter() final DateTime? date,
      final int? dateTimestamp,
      final String? dishName,
      final String? foodCategory,
      final List<String>? allergens,
      final int? numberOfServings,
      final String? boxType,
      @TimestampConverter() final DateTime? consumeBy,
      final int? consumeByTimestamp,
      final String? weekNumber,
      final String? donorId,
      final String? recipientId,
      final int? numberOfBoxes}) = _$_OfferedFood;

  factory _OfferedFood.fromJson(Map<String, dynamic> json) =
      _$_OfferedFood.fromJson;

  @override
  String? get id;
  @override
  @TimestampConverter()
  DateTime? get date;
  @override
  int? get dateTimestamp;
  @override
  String? get dishName;
  @override
  String? get foodCategory;
  @override
  List<String>? get allergens;
  @override
  int? get numberOfServings;
  @override
  String? get boxType;
  @override
  @TimestampConverter()
  DateTime? get consumeBy;
  @override
  int? get consumeByTimestamp;
  @override
  String? get weekNumber;
  @override
  String? get donorId;
  @override
  String? get recipientId;
  @override
  int? get numberOfBoxes;
  @override
  @JsonKey(ignore: true)
  _$$_OfferedFoodCopyWith<_$_OfferedFood> get copyWith =>
      throw _privateConstructorUsedError;
}
