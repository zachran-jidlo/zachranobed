// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'contact.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
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
  $ContactCopyWith<Contact> get copyWith =>
      _$ContactCopyWithImpl<Contact>(this as Contact, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Contact &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.position, position) ||
                other.position == position) &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber));
  }

  @override
  int get hashCode => Object.hash(runtimeType, name, position, phoneNumber);

  @override
  String toString() {
    return 'Contact(name: $name, position: $position, phoneNumber: $phoneNumber)';
  }
}

/// @nodoc
abstract mixin class $ContactCopyWith<$Res> {
  factory $ContactCopyWith(Contact value, $Res Function(Contact) _then) =
      _$ContactCopyWithImpl;
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
    return _then(_self.copyWith(
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
    ));
  }
}

/// @nodoc

class $Contact implements Contact {
  const $Contact(
      {required this.name, required this.position, required this.phoneNumber});

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
  $$ContactCopyWith<$Contact> get copyWith =>
      _$$ContactCopyWithImpl<$Contact>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is $Contact &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.position, position) ||
                other.position == position) &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber));
  }

  @override
  int get hashCode => Object.hash(runtimeType, name, position, phoneNumber);

  @override
  String toString() {
    return 'Contact(name: $name, position: $position, phoneNumber: $phoneNumber)';
  }
}

/// @nodoc
abstract mixin class $$ContactCopyWith<$Res> implements $ContactCopyWith<$Res> {
  factory $$ContactCopyWith($Contact value, $Res Function($Contact) _then) =
      _$$ContactCopyWithImpl;
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
    return _then($Contact(
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
    ));
  }
}

// dart format on
