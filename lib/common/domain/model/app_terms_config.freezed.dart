// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_terms_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AppTermsConfig {
  int get lastVersion;

  /// Create a copy of AppTermsConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AppTermsConfigCopyWith<AppTermsConfig> get copyWith =>
      _$AppTermsConfigCopyWithImpl<AppTermsConfig>(this as AppTermsConfig, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AppTermsConfig &&
            (identical(other.lastVersion, lastVersion) || other.lastVersion == lastVersion));
  }

  @override
  int get hashCode => Object.hash(runtimeType, lastVersion);

  @override
  String toString() {
    return 'AppTermsConfig(lastVersion: $lastVersion)';
  }
}

/// @nodoc
abstract mixin class $AppTermsConfigCopyWith<$Res> {
  factory $AppTermsConfigCopyWith(AppTermsConfig value, $Res Function(AppTermsConfig) _then) =
      _$AppTermsConfigCopyWithImpl;
  @useResult
  $Res call({int lastVersion});
}

/// @nodoc
class _$AppTermsConfigCopyWithImpl<$Res> implements $AppTermsConfigCopyWith<$Res> {
  _$AppTermsConfigCopyWithImpl(this._self, this._then);

  final AppTermsConfig _self;
  final $Res Function(AppTermsConfig) _then;

  /// Create a copy of AppTermsConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? lastVersion = null,
  }) {
    return _then(_self.copyWith(
      lastVersion: null == lastVersion
          ? _self.lastVersion
          : lastVersion // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class $AppTermsConfig implements AppTermsConfig {
  const $AppTermsConfig({required this.lastVersion});

  @override
  final int lastVersion;

  /// Create a copy of AppTermsConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $$AppTermsConfigCopyWith<$AppTermsConfig> get copyWith =>
      _$$AppTermsConfigCopyWithImpl<$AppTermsConfig>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is $AppTermsConfig &&
            (identical(other.lastVersion, lastVersion) || other.lastVersion == lastVersion));
  }

  @override
  int get hashCode => Object.hash(runtimeType, lastVersion);

  @override
  String toString() {
    return 'AppTermsConfig(lastVersion: $lastVersion)';
  }
}

/// @nodoc
abstract mixin class $$AppTermsConfigCopyWith<$Res> implements $AppTermsConfigCopyWith<$Res> {
  factory $$AppTermsConfigCopyWith($AppTermsConfig value, $Res Function($AppTermsConfig) _then) =
      _$$AppTermsConfigCopyWithImpl;
  @override
  @useResult
  $Res call({int lastVersion});
}

/// @nodoc
class _$$AppTermsConfigCopyWithImpl<$Res> implements $$AppTermsConfigCopyWith<$Res> {
  _$$AppTermsConfigCopyWithImpl(this._self, this._then);

  final $AppTermsConfig _self;
  final $Res Function($AppTermsConfig) _then;

  /// Create a copy of AppTermsConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? lastVersion = null,
  }) {
    return _then($AppTermsConfig(
      lastVersion: null == lastVersion
          ? _self.lastVersion
          : lastVersion // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

// dart format on
