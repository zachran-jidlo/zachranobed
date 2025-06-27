// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
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
  $NotificationCopyWith<Notification> get copyWith =>
      _$NotificationCopyWithImpl<Notification>(
          this as Notification, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Notification &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.read, read) || other.read == read));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, id, title, message, timestamp, read);

  @override
  String toString() {
    return 'Notification(id: $id, title: $title, message: $message, timestamp: $timestamp, read: $read)';
  }
}

/// @nodoc
abstract mixin class $NotificationCopyWith<$Res> {
  factory $NotificationCopyWith(
          Notification value, $Res Function(Notification) _then) =
      _$NotificationCopyWithImpl;
  @useResult
  $Res call(
      {String id, String title, String message, DateTime timestamp, bool read});
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
    return _then(_self.copyWith(
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
    ));
  }
}

/// @nodoc

class $Notification implements Notification {
  const $Notification(
      {required this.id,
      required this.title,
      required this.message,
      required this.timestamp,
      required this.read});

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
  $$NotificationCopyWith<$Notification> get copyWith =>
      _$$NotificationCopyWithImpl<$Notification>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is $Notification &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.read, read) || other.read == read));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, id, title, message, timestamp, read);

  @override
  String toString() {
    return 'Notification(id: $id, title: $title, message: $message, timestamp: $timestamp, read: $read)';
  }
}

/// @nodoc
abstract mixin class $$NotificationCopyWith<$Res>
    implements $NotificationCopyWith<$Res> {
  factory $$NotificationCopyWith(
          $Notification value, $Res Function($Notification) _then) =
      _$$NotificationCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id, String title, String message, DateTime timestamp, bool read});
}

/// @nodoc
class _$$NotificationCopyWithImpl<$Res>
    implements $$NotificationCopyWith<$Res> {
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
    return _then($Notification(
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
    ));
  }
}

// dart format on
