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
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

BoxMovement _$BoxMovementFromJson(Map<String, dynamic> json) {
  return _BoxMovement.fromJson(json);
}

/// @nodoc
mixin _$BoxMovement {
  String? get senderId => throw _privateConstructorUsedError;
  String? get recipientId => throw _privateConstructorUsedError;
  String? get boxType => throw _privateConstructorUsedError;
  int? get numberOfBoxes => throw _privateConstructorUsedError;
  String? get weekNumber => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime? get date => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BoxMovementCopyWith<BoxMovement> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BoxMovementCopyWith<$Res> {
  factory $BoxMovementCopyWith(
          BoxMovement value, $Res Function(BoxMovement) then) =
      _$BoxMovementCopyWithImpl<$Res, BoxMovement>;
  @useResult
  $Res call(
      {String? senderId,
      String? recipientId,
      String? boxType,
      int? numberOfBoxes,
      String? weekNumber,
      @TimestampConverter() DateTime? date});
}

/// @nodoc
class _$BoxMovementCopyWithImpl<$Res, $Val extends BoxMovement>
    implements $BoxMovementCopyWith<$Res> {
  _$BoxMovementCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? senderId = freezed,
    Object? recipientId = freezed,
    Object? boxType = freezed,
    Object? numberOfBoxes = freezed,
    Object? weekNumber = freezed,
    Object? date = freezed,
  }) {
    return _then(_value.copyWith(
      senderId: freezed == senderId
          ? _value.senderId
          : senderId // ignore: cast_nullable_to_non_nullable
              as String?,
      recipientId: freezed == recipientId
          ? _value.recipientId
          : recipientId // ignore: cast_nullable_to_non_nullable
              as String?,
      boxType: freezed == boxType
          ? _value.boxType
          : boxType // ignore: cast_nullable_to_non_nullable
              as String?,
      numberOfBoxes: freezed == numberOfBoxes
          ? _value.numberOfBoxes
          : numberOfBoxes // ignore: cast_nullable_to_non_nullable
              as int?,
      weekNumber: freezed == weekNumber
          ? _value.weekNumber
          : weekNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      date: freezed == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime?,
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
  $Res call(
      {String? senderId,
      String? recipientId,
      String? boxType,
      int? numberOfBoxes,
      String? weekNumber,
      @TimestampConverter() DateTime? date});
}

/// @nodoc
class __$$BoxMovementImplCopyWithImpl<$Res>
    extends _$BoxMovementCopyWithImpl<$Res, _$BoxMovementImpl>
    implements _$$BoxMovementImplCopyWith<$Res> {
  __$$BoxMovementImplCopyWithImpl(
      _$BoxMovementImpl _value, $Res Function(_$BoxMovementImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? senderId = freezed,
    Object? recipientId = freezed,
    Object? boxType = freezed,
    Object? numberOfBoxes = freezed,
    Object? weekNumber = freezed,
    Object? date = freezed,
  }) {
    return _then(_$BoxMovementImpl(
      senderId: freezed == senderId
          ? _value.senderId
          : senderId // ignore: cast_nullable_to_non_nullable
              as String?,
      recipientId: freezed == recipientId
          ? _value.recipientId
          : recipientId // ignore: cast_nullable_to_non_nullable
              as String?,
      boxType: freezed == boxType
          ? _value.boxType
          : boxType // ignore: cast_nullable_to_non_nullable
              as String?,
      numberOfBoxes: freezed == numberOfBoxes
          ? _value.numberOfBoxes
          : numberOfBoxes // ignore: cast_nullable_to_non_nullable
              as int?,
      weekNumber: freezed == weekNumber
          ? _value.weekNumber
          : weekNumber // ignore: cast_nullable_to_non_nullable
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
class _$BoxMovementImpl implements _BoxMovement {
  const _$BoxMovementImpl(
      {this.senderId,
      this.recipientId,
      this.boxType,
      this.numberOfBoxes,
      this.weekNumber,
      @TimestampConverter() this.date});

  factory _$BoxMovementImpl.fromJson(Map<String, dynamic> json) =>
      _$$BoxMovementImplFromJson(json);

  @override
  final String? senderId;
  @override
  final String? recipientId;
  @override
  final String? boxType;
  @override
  final int? numberOfBoxes;
  @override
  final String? weekNumber;
  @override
  @TimestampConverter()
  final DateTime? date;

  @override
  String toString() {
    return 'BoxMovement(senderId: $senderId, recipientId: $recipientId, boxType: $boxType, numberOfBoxes: $numberOfBoxes, weekNumber: $weekNumber, date: $date)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BoxMovementImpl &&
            (identical(other.senderId, senderId) ||
                other.senderId == senderId) &&
            (identical(other.recipientId, recipientId) ||
                other.recipientId == recipientId) &&
            (identical(other.boxType, boxType) || other.boxType == boxType) &&
            (identical(other.numberOfBoxes, numberOfBoxes) ||
                other.numberOfBoxes == numberOfBoxes) &&
            (identical(other.weekNumber, weekNumber) ||
                other.weekNumber == weekNumber) &&
            (identical(other.date, date) || other.date == date));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, senderId, recipientId, boxType,
      numberOfBoxes, weekNumber, date);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BoxMovementImplCopyWith<_$BoxMovementImpl> get copyWith =>
      __$$BoxMovementImplCopyWithImpl<_$BoxMovementImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BoxMovementImplToJson(
      this,
    );
  }
}

abstract class _BoxMovement implements BoxMovement {
  const factory _BoxMovement(
      {final String? senderId,
      final String? recipientId,
      final String? boxType,
      final int? numberOfBoxes,
      final String? weekNumber,
      @TimestampConverter() final DateTime? date}) = _$BoxMovementImpl;

  factory _BoxMovement.fromJson(Map<String, dynamic> json) =
      _$BoxMovementImpl.fromJson;

  @override
  String? get senderId;
  @override
  String? get recipientId;
  @override
  String? get boxType;
  @override
  int? get numberOfBoxes;
  @override
  String? get weekNumber;
  @override
  @TimestampConverter()
  DateTime? get date;
  @override
  @JsonKey(ignore: true)
  _$$BoxMovementImplCopyWith<_$BoxMovementImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
