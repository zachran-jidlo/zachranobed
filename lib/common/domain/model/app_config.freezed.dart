// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AppConfig {
  String get minimumAppVersion;
  String get latestAppVersion;

  /// Create a copy of AppConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AppConfigCopyWith<AppConfig> get copyWith => _$AppConfigCopyWithImpl<AppConfig>(this as AppConfig, _$identity);

  @override
  bool operator ==(Object other) {
    final _this = this as AppConfig;
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AppConfig &&
            (identical(other.minimumAppVersion, _this.minimumAppVersion) ||
                other.minimumAppVersion == _this.minimumAppVersion) &&
            (identical(other.latestAppVersion, _this.latestAppVersion) ||
                other.latestAppVersion == _this.latestAppVersion));
  }

  @override
  int get hashCode {
    final _this = this as AppConfig;
    return Object.hash(
      runtimeType,
      _this.minimumAppVersion,
      _this.latestAppVersion,
    );
  }

  @override
  String toString() {
    final _this = this as AppConfig;
    return 'AppConfig(minimumAppVersion: ${_this.minimumAppVersion}, latestAppVersion: ${_this.latestAppVersion})';
  }
}

/// @nodoc
abstract mixin class $AppConfigCopyWith<$Res> {
  factory $AppConfigCopyWith(AppConfig value, $Res Function(AppConfig) _then) = _$AppConfigCopyWithImpl;
  @useResult
  $Res call({String minimumAppVersion, String latestAppVersion});
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
    Object? latestAppVersion = null,
  }) {
    return _then(
      AppConfig(
        minimumAppVersion: null == minimumAppVersion
            ? _self.minimumAppVersion
            : minimumAppVersion // ignore: cast_nullable_to_non_nullable
                  as String,
        latestAppVersion: null == latestAppVersion
            ? _self.latestAppVersion
            : latestAppVersion // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// Adds pattern-matching-related methods to [AppConfig].
extension AppConfigPatterns on AppConfig {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function($AppConfig value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case $AppConfig() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function($AppConfig value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case $AppConfig():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function($AppConfig value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case $AppConfig() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(String minimumAppVersion, String latestAppVersion)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case $AppConfig() when $default != null:
        return $default(_that.minimumAppVersion, _that.latestAppVersion);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(String minimumAppVersion, String latestAppVersion) $default,
  ) {
    final _that = this;
    switch (_that) {
      case $AppConfig():
        return $default(_that.minimumAppVersion, _that.latestAppVersion);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(String minimumAppVersion, String latestAppVersion)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case $AppConfig() when $default != null:
        return $default(_that.minimumAppVersion, _that.latestAppVersion);
      case _:
        return null;
    }
  }
}

/// @nodoc

class $AppConfig implements AppConfig {
  const $AppConfig({
    required this.minimumAppVersion,
    required this.latestAppVersion,
  });

  @override
  final String minimumAppVersion;
  @override
  final String latestAppVersion;

  /// Create a copy of AppConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $$AppConfigCopyWith<$AppConfig> get copyWith => _$$AppConfigCopyWithImpl<$AppConfig>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is $AppConfig &&
            (identical(other.minimumAppVersion, minimumAppVersion) || other.minimumAppVersion == minimumAppVersion) &&
            (identical(other.latestAppVersion, latestAppVersion) || other.latestAppVersion == latestAppVersion));
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, minimumAppVersion, latestAppVersion);
  }

  @override
  String toString() {
    return 'AppConfig(minimumAppVersion: $minimumAppVersion, latestAppVersion: $latestAppVersion)';
  }
}

/// @nodoc
abstract mixin class $$AppConfigCopyWith<$Res> implements $AppConfigCopyWith<$Res> {
  factory $$AppConfigCopyWith(
    $AppConfig value,
    $Res Function($AppConfig) _then,
  ) = _$$AppConfigCopyWithImpl;
  @override
  @useResult
  $Res call({String minimumAppVersion, String latestAppVersion});
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
    Object? latestAppVersion = null,
  }) {
    return _then(
      $AppConfig(
        minimumAppVersion: null == minimumAppVersion
            ? _self.minimumAppVersion
            : minimumAppVersion // ignore: cast_nullable_to_non_nullable
                  as String,
        latestAppVersion: null == latestAppVersion
            ? _self.latestAppVersion
            : latestAppVersion // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}
