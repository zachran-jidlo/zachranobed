// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'box_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$BoxInfo {
  String? get foodBoxId => throw _privateConstructorUsedError;
  int? get numberOfBoxes => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $BoxInfoCopyWith<BoxInfo> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BoxInfoCopyWith<$Res> {
  factory $BoxInfoCopyWith(BoxInfo value, $Res Function(BoxInfo) then) =
      _$BoxInfoCopyWithImpl<$Res, BoxInfo>;
  @useResult
  $Res call({String? foodBoxId, int? numberOfBoxes});
}

/// @nodoc
class _$BoxInfoCopyWithImpl<$Res, $Val extends BoxInfo>
    implements $BoxInfoCopyWith<$Res> {
  _$BoxInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? foodBoxId = freezed,
    Object? numberOfBoxes = freezed,
  }) {
    return _then(_value.copyWith(
      foodBoxId: freezed == foodBoxId
          ? _value.foodBoxId
          : foodBoxId // ignore: cast_nullable_to_non_nullable
              as String?,
      numberOfBoxes: freezed == numberOfBoxes
          ? _value.numberOfBoxes
          : numberOfBoxes // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BoxInfoImplCopyWith<$Res> implements $BoxInfoCopyWith<$Res> {
  factory _$$BoxInfoImplCopyWith(
          _$BoxInfoImpl value, $Res Function(_$BoxInfoImpl) then) =
      __$$BoxInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? foodBoxId, int? numberOfBoxes});
}

/// @nodoc
class __$$BoxInfoImplCopyWithImpl<$Res>
    extends _$BoxInfoCopyWithImpl<$Res, _$BoxInfoImpl>
    implements _$$BoxInfoImplCopyWith<$Res> {
  __$$BoxInfoImplCopyWithImpl(
      _$BoxInfoImpl _value, $Res Function(_$BoxInfoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? foodBoxId = freezed,
    Object? numberOfBoxes = freezed,
  }) {
    return _then(_$BoxInfoImpl(
      foodBoxId: freezed == foodBoxId
          ? _value.foodBoxId
          : foodBoxId // ignore: cast_nullable_to_non_nullable
              as String?,
      numberOfBoxes: freezed == numberOfBoxes
          ? _value.numberOfBoxes
          : numberOfBoxes // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc

class _$BoxInfoImpl implements _BoxInfo {
  const _$BoxInfoImpl({this.foodBoxId, this.numberOfBoxes});

  @override
  final String? foodBoxId;
  @override
  final int? numberOfBoxes;

  @override
  String toString() {
    return 'BoxInfo(foodBoxId: $foodBoxId, numberOfBoxes: $numberOfBoxes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BoxInfoImpl &&
            (identical(other.foodBoxId, foodBoxId) ||
                other.foodBoxId == foodBoxId) &&
            (identical(other.numberOfBoxes, numberOfBoxes) ||
                other.numberOfBoxes == numberOfBoxes));
  }

  @override
  int get hashCode => Object.hash(runtimeType, foodBoxId, numberOfBoxes);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BoxInfoImplCopyWith<_$BoxInfoImpl> get copyWith =>
      __$$BoxInfoImplCopyWithImpl<_$BoxInfoImpl>(this, _$identity);
}

abstract class _BoxInfo implements BoxInfo {
  const factory _BoxInfo({final String? foodBoxId, final int? numberOfBoxes}) =
      _$BoxInfoImpl;

  @override
  String? get foodBoxId;
  @override
  int? get numberOfBoxes;
  @override
  @JsonKey(ignore: true)
  _$$BoxInfoImplCopyWith<_$BoxInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
