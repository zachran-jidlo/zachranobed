// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AppConfig {
  String get minimumAppVersion;

  /// Create a copy of AppConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AppConfigCopyWith<AppConfig> get copyWith =>
      _$AppConfigCopyWithImpl<AppConfig>(this as AppConfig, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AppConfig &&
            (identical(other.minimumAppVersion, minimumAppVersion) ||
                other.minimumAppVersion == minimumAppVersion));
  }

  @override
  int get hashCode => Object.hash(runtimeType, minimumAppVersion);

  @override
  String toString() {
    return 'AppConfig(minimumAppVersion: $minimumAppVersion)';
  }
}

/// @nodoc
abstract mixin class $AppConfigCopyWith<$Res> {
  factory $AppConfigCopyWith(AppConfig value, $Res Function(AppConfig) _then) =
      _$AppConfigCopyWithImpl;
  @useResult
  $Res call({String minimumAppVersion});
}

/// @nodoc
class _$AppConfigCopyWithImpl<$Res> implements $AppConfigCopyWith<$Res> {
  _$AppConfigCopyWithImpl(this._self, this._then);

  final AppConfig _self;
  final $Res Function(AppConfig) _then;

  /// Create a copy of AppConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? minimumAppVersion = null,
  }) {
    return _then(_self.copyWith(
      minimumAppVersion: null == minimumAppVersion
          ? _self.minimumAppVersion
          : minimumAppVersion // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class $AppConfig implements AppConfig {
  const $AppConfig({required this.minimumAppVersion});

  @override
  final String minimumAppVersion;

  /// Create a copy of AppConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $$AppConfigCopyWith<$AppConfig> get copyWith =>
      _$$AppConfigCopyWithImpl<$AppConfig>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is $AppConfig &&
            (identical(other.minimumAppVersion, minimumAppVersion) ||
                other.minimumAppVersion == minimumAppVersion));
  }

  @override
  int get hashCode => Object.hash(runtimeType, minimumAppVersion);

  @override
  String toString() {
    return 'AppConfig(minimumAppVersion: $minimumAppVersion)';
  }
}

/// @nodoc
abstract mixin class $$AppConfigCopyWith<$Res>
    implements $AppConfigCopyWith<$Res> {
  factory $$AppConfigCopyWith(
          $AppConfig value, $Res Function($AppConfig) _then) =
      _$$AppConfigCopyWithImpl;
  @override
  @useResult
  $Res call({String minimumAppVersion});
}

/// @nodoc
class _$$AppConfigCopyWithImpl<$Res> implements $$AppConfigCopyWith<$Res> {
  _$$AppConfigCopyWithImpl(this._self, this._then);

  final $AppConfig _self;
  final $Res Function($AppConfig) _then;

  /// Create a copy of AppConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? minimumAppVersion = null,
  }) {
    return _then($AppConfig(
      minimumAppVersion: null == minimumAppVersion
          ? _self.minimumAppVersion
          : minimumAppVersion // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
