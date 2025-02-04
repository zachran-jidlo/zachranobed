// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'box_movement.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$BoxMovement {
  FoodBoxType get type => throw _privateConstructorUsedError;
  int get count => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;

  /// Create a copy of BoxMovement
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BoxMovementCopyWith<BoxMovement> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BoxMovementCopyWith<$Res> {
  factory $BoxMovementCopyWith(
          BoxMovement value, $Res Function(BoxMovement) then) =
      _$BoxMovementCopyWithImpl<$Res, BoxMovement>;
  @useResult
  $Res call({FoodBoxType type, int count, DateTime date});
}

/// @nodoc
class _$BoxMovementCopyWithImpl<$Res, $Val extends BoxMovement>
    implements $BoxMovementCopyWith<$Res> {
  _$BoxMovementCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BoxMovement
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? count = null,
    Object? date = null,
  }) {
    return _then(_value.copyWith(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as FoodBoxType,
      count: null == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BoxMovementImplCopyWith<$Res>
    implements $BoxMovementCopyWith<$Res> {
  factory _$$BoxMovementImplCopyWith(
          _$BoxMovementImpl value, $Res Function(_$BoxMovementImpl) then) =
      __$$BoxMovementImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({FoodBoxType type, int count, DateTime date});
}

/// @nodoc
class __$$BoxMovementImplCopyWithImpl<$Res>
    extends _$BoxMovementCopyWithImpl<$Res, _$BoxMovementImpl>
    implements _$$BoxMovementImplCopyWith<$Res> {
  __$$BoxMovementImplCopyWithImpl(
      _$BoxMovementImpl _value, $Res Function(_$BoxMovementImpl) _then)
      : super(_value, _then);

  /// Create a copy of BoxMovement
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? count = null,
    Object? date = null,
  }) {
    return _then(_$BoxMovementImpl(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as FoodBoxType,
      count: null == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc

class _$BoxMovementImpl implements _BoxMovement {
  const _$BoxMovementImpl(
      {required this.type, required this.count, required this.date});

  @override
  final FoodBoxType type;
  @override
  final int count;
  @override
  final DateTime date;

  @override
  String toString() {
    return 'BoxMovement(type: $type, count: $count, date: $date)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BoxMovementImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.count, count) || other.count == count) &&
            (identical(other.date, date) || other.date == date));
  }

  @override
  int get hashCode => Object.hash(runtimeType, type, count, date);

  /// Create a copy of BoxMovement
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BoxMovementImplCopyWith<_$BoxMovementImpl> get copyWith =>
      __$$BoxMovementImplCopyWithImpl<_$BoxMovementImpl>(this, _$identity);
}

abstract class _BoxMovement implements BoxMovement {
  const factory _BoxMovement(
      {required final FoodBoxType type,
      required final int count,
      required final DateTime date}) = _$BoxMovementImpl;

  @override
  FoodBoxType get type;
  @override
  int get count;
  @override
  DateTime get date;

  /// Create a copy of BoxMovement
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BoxMovementImplCopyWith<_$BoxMovementImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
