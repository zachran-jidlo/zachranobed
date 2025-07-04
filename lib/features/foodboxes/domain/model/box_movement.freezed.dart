// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'box_movement.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BoxMovement {
  FoodBoxType get type;
  int get count;
  DateTime get date;

  /// Create a copy of BoxMovement
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $BoxMovementCopyWith<BoxMovement> get copyWith =>
      _$BoxMovementCopyWithImpl<BoxMovement>(this as BoxMovement, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is BoxMovement &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.count, count) || other.count == count) &&
            (identical(other.date, date) || other.date == date));
  }

  @override
  int get hashCode => Object.hash(runtimeType, type, count, date);

  @override
  String toString() {
    return 'BoxMovement(type: $type, count: $count, date: $date)';
  }
}

/// @nodoc
abstract mixin class $BoxMovementCopyWith<$Res> {
  factory $BoxMovementCopyWith(
          BoxMovement value, $Res Function(BoxMovement) _then) =
      _$BoxMovementCopyWithImpl;
  @useResult
  $Res call({FoodBoxType type, int count, DateTime date});
}

/// @nodoc
class _$BoxMovementCopyWithImpl<$Res> implements $BoxMovementCopyWith<$Res> {
  _$BoxMovementCopyWithImpl(this._self, this._then);

  final BoxMovement _self;
  final $Res Function(BoxMovement) _then;

  /// Create a copy of BoxMovement
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? count = null,
    Object? date = null,
  }) {
    return _then(_self.copyWith(
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as FoodBoxType,
      count: null == count
          ? _self.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
      date: null == date
          ? _self.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc

class _BoxMovement implements BoxMovement {
  const _BoxMovement(
      {required this.type, required this.count, required this.date});

  @override
  final FoodBoxType type;
  @override
  final int count;
  @override
  final DateTime date;

  /// Create a copy of BoxMovement
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$BoxMovementCopyWith<_BoxMovement> get copyWith =>
      __$BoxMovementCopyWithImpl<_BoxMovement>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _BoxMovement &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.count, count) || other.count == count) &&
            (identical(other.date, date) || other.date == date));
  }

  @override
  int get hashCode => Object.hash(runtimeType, type, count, date);

  @override
  String toString() {
    return 'BoxMovement(type: $type, count: $count, date: $date)';
  }
}

/// @nodoc
abstract mixin class _$BoxMovementCopyWith<$Res>
    implements $BoxMovementCopyWith<$Res> {
  factory _$BoxMovementCopyWith(
          _BoxMovement value, $Res Function(_BoxMovement) _then) =
      __$BoxMovementCopyWithImpl;
  @override
  @useResult
  $Res call({FoodBoxType type, int count, DateTime date});
}

/// @nodoc
class __$BoxMovementCopyWithImpl<$Res> implements _$BoxMovementCopyWith<$Res> {
  __$BoxMovementCopyWithImpl(this._self, this._then);

  final _BoxMovement _self;
  final $Res Function(_BoxMovement) _then;

  /// Create a copy of BoxMovement
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? type = null,
    Object? count = null,
    Object? date = null,
  }) {
    return _then(_BoxMovement(
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as FoodBoxType,
      count: null == count
          ? _self.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
      date: null == date
          ? _self.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

// dart format on
