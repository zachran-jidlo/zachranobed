// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'box_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BoxInfo {
  String? get foodBoxId;
  int? get numberOfBoxes;

  /// Create a copy of BoxInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $BoxInfoCopyWith<BoxInfo> get copyWith =>
      _$BoxInfoCopyWithImpl<BoxInfo>(this as BoxInfo, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is BoxInfo &&
            (identical(other.foodBoxId, foodBoxId) ||
                other.foodBoxId == foodBoxId) &&
            (identical(other.numberOfBoxes, numberOfBoxes) ||
                other.numberOfBoxes == numberOfBoxes));
  }

  @override
  int get hashCode => Object.hash(runtimeType, foodBoxId, numberOfBoxes);

  @override
  String toString() {
    return 'BoxInfo(foodBoxId: $foodBoxId, numberOfBoxes: $numberOfBoxes)';
  }
}

/// @nodoc
abstract mixin class $BoxInfoCopyWith<$Res> {
  factory $BoxInfoCopyWith(BoxInfo value, $Res Function(BoxInfo) _then) =
      _$BoxInfoCopyWithImpl;
  @useResult
  $Res call({String? foodBoxId, int? numberOfBoxes});
}

/// @nodoc
class _$BoxInfoCopyWithImpl<$Res> implements $BoxInfoCopyWith<$Res> {
  _$BoxInfoCopyWithImpl(this._self, this._then);

  final BoxInfo _self;
  final $Res Function(BoxInfo) _then;

  /// Create a copy of BoxInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? foodBoxId = freezed,
    Object? numberOfBoxes = freezed,
  }) {
    return _then(_self.copyWith(
      foodBoxId: freezed == foodBoxId
          ? _self.foodBoxId
          : foodBoxId // ignore: cast_nullable_to_non_nullable
              as String?,
      numberOfBoxes: freezed == numberOfBoxes
          ? _self.numberOfBoxes
          : numberOfBoxes // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc

class _BoxInfo implements BoxInfo {
  const _BoxInfo({this.foodBoxId, this.numberOfBoxes});

  @override
  final String? foodBoxId;
  @override
  final int? numberOfBoxes;

  /// Create a copy of BoxInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$BoxInfoCopyWith<_BoxInfo> get copyWith =>
      __$BoxInfoCopyWithImpl<_BoxInfo>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _BoxInfo &&
            (identical(other.foodBoxId, foodBoxId) ||
                other.foodBoxId == foodBoxId) &&
            (identical(other.numberOfBoxes, numberOfBoxes) ||
                other.numberOfBoxes == numberOfBoxes));
  }

  @override
  int get hashCode => Object.hash(runtimeType, foodBoxId, numberOfBoxes);

  @override
  String toString() {
    return 'BoxInfo(foodBoxId: $foodBoxId, numberOfBoxes: $numberOfBoxes)';
  }
}

/// @nodoc
abstract mixin class _$BoxInfoCopyWith<$Res> implements $BoxInfoCopyWith<$Res> {
  factory _$BoxInfoCopyWith(_BoxInfo value, $Res Function(_BoxInfo) _then) =
      __$BoxInfoCopyWithImpl;
  @override
  @useResult
  $Res call({String? foodBoxId, int? numberOfBoxes});
}

/// @nodoc
class __$BoxInfoCopyWithImpl<$Res> implements _$BoxInfoCopyWith<$Res> {
  __$BoxInfoCopyWithImpl(this._self, this._then);

  final _BoxInfo _self;
  final $Res Function(_BoxInfo) _then;

  /// Create a copy of BoxInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? foodBoxId = freezed,
    Object? numberOfBoxes = freezed,
  }) {
    return _then(_BoxInfo(
      foodBoxId: freezed == foodBoxId
          ? _self.foodBoxId
          : foodBoxId // ignore: cast_nullable_to_non_nullable
              as String?,
      numberOfBoxes: freezed == numberOfBoxes
          ? _self.numberOfBoxes
          : numberOfBoxes // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

// dart format on
