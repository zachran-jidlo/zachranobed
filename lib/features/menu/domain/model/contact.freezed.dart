// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'contact.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Contact {
  String get name;
  String? get position;
  String? get phoneNumber;

  /// Create a copy of Contact
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ContactCopyWith<Contact> get copyWith => _$ContactCopyWithImpl<Contact>(this as Contact, _$identity);

  @override
  bool operator ==(Object other) {
    final _this = this as Contact;
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Contact &&
            (identical(other.name, _this.name) || other.name == _this.name) &&
            (identical(other.position, _this.position) || other.position == _this.position) &&
            (identical(other.phoneNumber, _this.phoneNumber) || other.phoneNumber == _this.phoneNumber));
  }

  @override
  int get hashCode {
    final _this = this as Contact;
    return Object.hash(
      runtimeType,
      _this.name,
      _this.position,
      _this.phoneNumber,
    );
  }

  @override
  String toString() {
    final _this = this as Contact;
    return 'Contact(name: ${_this.name}, position: ${_this.position}, phoneNumber: ${_this.phoneNumber})';
  }
}

/// @nodoc
abstract mixin class $ContactCopyWith<$Res> {
  factory $ContactCopyWith(Contact value, $Res Function(Contact) _then) = _$ContactCopyWithImpl;
  @useResult
  $Res call({String name, String? position, String? phoneNumber});
}

/// @nodoc
class _$ContactCopyWithImpl<$Res> implements $ContactCopyWith<$Res> {
  _$ContactCopyWithImpl(this._self, this._then);

  final Contact _self;
  final $Res Function(Contact) _then;

  /// Create a copy of Contact
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? position = freezed,
    Object? phoneNumber = freezed,
  }) {
    return _then(
      Contact(
        name: null == name
            ? _self.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        position: freezed == position
            ? _self.position
            : position // ignore: cast_nullable_to_non_nullable
                  as String?,
        phoneNumber: freezed == phoneNumber
            ? _self.phoneNumber
            : phoneNumber // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// Adds pattern-matching-related methods to [Contact].
extension ContactPatterns on Contact {
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
    TResult Function($Contact value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case $Contact() when $default != null:
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
    TResult Function($Contact value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case $Contact():
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
    TResult? Function($Contact value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case $Contact() when $default != null:
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
    TResult Function(String name, String? position, String? phoneNumber)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case $Contact() when $default != null:
        return $default(_that.name, _that.position, _that.phoneNumber);
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
    TResult Function(String name, String? position, String? phoneNumber) $default,
  ) {
    final _that = this;
    switch (_that) {
      case $Contact():
        return $default(_that.name, _that.position, _that.phoneNumber);
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
    TResult? Function(String name, String? position, String? phoneNumber)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case $Contact() when $default != null:
        return $default(_that.name, _that.position, _that.phoneNumber);
      case _:
        return null;
    }
  }
}

/// @nodoc

class $Contact extends Contact {
  const $Contact({
    required this.name,
    required this.position,
    required this.phoneNumber,
  }) : super._();

  @override
  final String name;
  @override
  final String? position;
  @override
  final String? phoneNumber;

  /// Create a copy of Contact
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $$ContactCopyWith<$Contact> get copyWith => _$$ContactCopyWithImpl<$Contact>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is $Contact &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.position, position) || other.position == position) &&
            (identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber));
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, name, position, phoneNumber);
  }

  @override
  String toString() {
    return 'Contact(name: $name, position: $position, phoneNumber: $phoneNumber)';
  }
}

/// @nodoc
abstract mixin class $$ContactCopyWith<$Res> implements $ContactCopyWith<$Res> {
  factory $$ContactCopyWith($Contact value, $Res Function($Contact) _then) = _$$ContactCopyWithImpl;
  @override
  @useResult
  $Res call({String name, String? position, String? phoneNumber});
}

/// @nodoc
class _$$ContactCopyWithImpl<$Res> implements $$ContactCopyWith<$Res> {
  _$$ContactCopyWithImpl(this._self, this._then);

  final $Contact _self;
  final $Res Function($Contact) _then;

  /// Create a copy of Contact
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? name = null,
    Object? position = freezed,
    Object? phoneNumber = freezed,
  }) {
    return _then(
      $Contact(
        name: null == name
            ? _self.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        position: freezed == position
            ? _self.position
            : position // ignore: cast_nullable_to_non_nullable
                  as String?,
        phoneNumber: freezed == phoneNumber
            ? _self.phoneNumber
            : phoneNumber // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}
