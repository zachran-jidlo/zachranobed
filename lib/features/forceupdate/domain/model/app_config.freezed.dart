// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AppConfig {
  String get minimumAppVersion => throw _privateConstructorUsedError;

  /// Create a copy of AppConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AppConfigCopyWith<AppConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppConfigCopyWith<$Res> {
  factory $AppConfigCopyWith(AppConfig value, $Res Function(AppConfig) then) =
      _$AppConfigCopyWithImpl<$Res, AppConfig>;
  @useResult
  $Res call({String minimumAppVersion});
}

/// @nodoc
class _$AppConfigCopyWithImpl<$Res, $Val extends AppConfig>
    implements $AppConfigCopyWith<$Res> {
  _$AppConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AppConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? minimumAppVersion = null,
  }) {
    return _then(_value.copyWith(
      minimumAppVersion: null == minimumAppVersion
          ? _value.minimumAppVersion
          : minimumAppVersion // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$$AppConfigImplCopyWith<$Res>
    implements $AppConfigCopyWith<$Res> {
  factory _$$$AppConfigImplCopyWith(
          _$$AppConfigImpl value, $Res Function(_$$AppConfigImpl) then) =
      __$$$AppConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String minimumAppVersion});
}

/// @nodoc
class __$$$AppConfigImplCopyWithImpl<$Res>
    extends _$AppConfigCopyWithImpl<$Res, _$$AppConfigImpl>
    implements _$$$AppConfigImplCopyWith<$Res> {
  __$$$AppConfigImplCopyWithImpl(
      _$$AppConfigImpl _value, $Res Function(_$$AppConfigImpl) _then)
      : super(_value, _then);

  /// Create a copy of AppConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? minimumAppVersion = null,
  }) {
    return _then(_$$AppConfigImpl(
      minimumAppVersion: null == minimumAppVersion
          ? _value.minimumAppVersion
          : minimumAppVersion // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$$AppConfigImpl implements $AppConfig {
  const _$$AppConfigImpl({required this.minimumAppVersion});

  @override
  final String minimumAppVersion;

  @override
  String toString() {
    return 'AppConfig(minimumAppVersion: $minimumAppVersion)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$$AppConfigImpl &&
            (identical(other.minimumAppVersion, minimumAppVersion) ||
                other.minimumAppVersion == minimumAppVersion));
  }

  @override
  int get hashCode => Object.hash(runtimeType, minimumAppVersion);

  /// Create a copy of AppConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$$AppConfigImplCopyWith<_$$AppConfigImpl> get copyWith =>
      __$$$AppConfigImplCopyWithImpl<_$$AppConfigImpl>(this, _$identity);
}

abstract class $AppConfig implements AppConfig {
  const factory $AppConfig({required final String minimumAppVersion}) =
      _$$AppConfigImpl;

  @override
  String get minimumAppVersion;

  /// Create a copy of AppConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$$AppConfigImplCopyWith<_$$AppConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
