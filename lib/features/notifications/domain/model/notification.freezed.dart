// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Notification {
  String get id;
  String get title;
  String get message;
  DateTime get timestamp;
  bool get read;

  /// Create a copy of Notification
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $NotificationCopyWith<Notification> get copyWith => _$NotificationCopyWithImpl<Notification>(
    this as Notification,
    _$identity,
  );

  @override
  bool operator ==(Object other) {
    final _this = this as Notification;
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Notification &&
            (identical(other.id, _this.id) || other.id == _this.id) &&
            (identical(other.title, _this.title) || other.title == _this.title) &&
            (identical(other.message, _this.message) || other.message == _this.message) &&
            (identical(other.timestamp, _this.timestamp) || other.timestamp == _this.timestamp) &&
            (identical(other.read, _this.read) || other.read == _this.read));
  }

  @override
  int get hashCode {
    final _this = this as Notification;
    return Object.hash(
      runtimeType,
      _this.id,
      _this.title,
      _this.message,
      _this.timestamp,
      _this.read,
    );
  }

  @override
  String toString() {
    final _this = this as Notification;
    return 'Notification(id: ${_this.id}, title: ${_this.title}, message: ${_this.message}, timestamp: ${_this.timestamp}, read: ${_this.read})';
  }
}

/// @nodoc
abstract mixin class $NotificationCopyWith<$Res> {
  factory $NotificationCopyWith(
    Notification value,
    $Res Function(Notification) _then,
  ) = _$NotificationCopyWithImpl;
  @useResult
  $Res call({
    String id,
    String title,
    String message,
    DateTime timestamp,
    bool read,
  });
}

/// @nodoc
class _$NotificationCopyWithImpl<$Res> implements $NotificationCopyWith<$Res> {
  _$NotificationCopyWithImpl(this._self, this._then);

  final Notification _self;
  final $Res Function(Notification) _then;

  /// Create a copy of Notification
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? message = null,
    Object? timestamp = null,
    Object? read = null,
  }) {
    return _then(
      Notification(
        id: null == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _self.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        message: null == message
            ? _self.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
        timestamp: null == timestamp
            ? _self.timestamp
            : timestamp // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        read: null == read
            ? _self.read
            : read // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// Adds pattern-matching-related methods to [Notification].
extension NotificationPatterns on Notification {
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
    TResult Function($Notification value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case $Notification() when $default != null:
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
    TResult Function($Notification value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case $Notification():
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
    TResult? Function($Notification value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case $Notification() when $default != null:
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
    TResult Function(
      String id,
      String title,
      String message,
      DateTime timestamp,
      bool read,
    )?
    $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case $Notification() when $default != null:
        return $default(
          _that.id,
          _that.title,
          _that.message,
          _that.timestamp,
          _that.read,
        );
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
    TResult Function(
      String id,
      String title,
      String message,
      DateTime timestamp,
      bool read,
    )
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case $Notification():
        return $default(
          _that.id,
          _that.title,
          _that.message,
          _that.timestamp,
          _that.read,
        );
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
    TResult? Function(
      String id,
      String title,
      String message,
      DateTime timestamp,
      bool read,
    )?
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case $Notification() when $default != null:
        return $default(
          _that.id,
          _that.title,
          _that.message,
          _that.timestamp,
          _that.read,
        );
      case _:
        return null;
    }
  }
}

/// @nodoc

class $Notification implements Notification {
  const $Notification({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    required this.read,
  });

  @override
  final String id;
  @override
  final String title;
  @override
  final String message;
  @override
  final DateTime timestamp;
  @override
  final bool read;

  /// Create a copy of Notification
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $$NotificationCopyWith<$Notification> get copyWith => _$$NotificationCopyWithImpl<$Notification>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is $Notification &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.timestamp, timestamp) || other.timestamp == timestamp) &&
            (identical(other.read, read) || other.read == read));
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, id, title, message, timestamp, read);
  }

  @override
  String toString() {
    return 'Notification(id: $id, title: $title, message: $message, timestamp: $timestamp, read: $read)';
  }
}

/// @nodoc
abstract mixin class $$NotificationCopyWith<$Res> implements $NotificationCopyWith<$Res> {
  factory $$NotificationCopyWith(
    $Notification value,
    $Res Function($Notification) _then,
  ) = _$$NotificationCopyWithImpl;
  @override
  @useResult
  $Res call({
    String id,
    String title,
    String message,
    DateTime timestamp,
    bool read,
  });
}

/// @nodoc
class _$$NotificationCopyWithImpl<$Res> implements $$NotificationCopyWith<$Res> {
  _$$NotificationCopyWithImpl(this._self, this._then);

  final $Notification _self;
  final $Res Function($Notification) _then;

  /// Create a copy of Notification
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? message = null,
    Object? timestamp = null,
    Object? read = null,
  }) {
    return _then(
      $Notification(
        id: null == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _self.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        message: null == message
            ? _self.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
        timestamp: null == timestamp
            ? _self.timestamp
            : timestamp // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        read: null == read
            ? _self.read
            : read // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}
