// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'entity_contacts.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EntityContacts {
  String get name;
  bool get active;
  List<Contact> get contacts;

  /// Create a copy of EntityContacts
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $EntityContactsCopyWith<EntityContacts> get copyWith =>
      _$EntityContactsCopyWithImpl<EntityContacts>(
          this as EntityContacts, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is EntityContacts &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.active, active) || other.active == active) &&
            const DeepCollectionEquality().equals(other.contacts, contacts));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, name, active, const DeepCollectionEquality().hash(contacts));

  @override
  String toString() {
    return 'EntityContacts(name: $name, active: $active, contacts: $contacts)';
  }
}

/// @nodoc
abstract mixin class $EntityContactsCopyWith<$Res> {
  factory $EntityContactsCopyWith(
          EntityContacts value, $Res Function(EntityContacts) _then) =
      _$EntityContactsCopyWithImpl;
  @useResult
  $Res call({String name, bool active, List<Contact> contacts});
}

/// @nodoc
class _$EntityContactsCopyWithImpl<$Res>
    implements $EntityContactsCopyWith<$Res> {
  _$EntityContactsCopyWithImpl(this._self, this._then);

  final EntityContacts _self;
  final $Res Function(EntityContacts) _then;

  /// Create a copy of EntityContacts
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? active = null,
    Object? contacts = null,
  }) {
    return _then(_self.copyWith(
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      active: null == active
          ? _self.active
          : active // ignore: cast_nullable_to_non_nullable
              as bool,
      contacts: null == contacts
          ? _self.contacts
          : contacts // ignore: cast_nullable_to_non_nullable
              as List<Contact>,
    ));
  }
}

/// @nodoc

class $EntityContacts implements EntityContacts {
  const $EntityContacts(
      {required this.name,
      required this.active,
      required final List<Contact> contacts})
      : _contacts = contacts;

  @override
  final String name;
  @override
  final bool active;
  final List<Contact> _contacts;
  @override
  List<Contact> get contacts {
    if (_contacts is EqualUnmodifiableListView) return _contacts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_contacts);
  }

  /// Create a copy of EntityContacts
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $$EntityContactsCopyWith<$EntityContacts> get copyWith =>
      _$$EntityContactsCopyWithImpl<$EntityContacts>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is $EntityContacts &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.active, active) || other.active == active) &&
            const DeepCollectionEquality().equals(other._contacts, _contacts));
  }

  @override
  int get hashCode => Object.hash(runtimeType, name, active,
      const DeepCollectionEquality().hash(_contacts));

  @override
  String toString() {
    return 'EntityContacts(name: $name, active: $active, contacts: $contacts)';
  }
}

/// @nodoc
abstract mixin class $$EntityContactsCopyWith<$Res>
    implements $EntityContactsCopyWith<$Res> {
  factory $$EntityContactsCopyWith(
          $EntityContacts value, $Res Function($EntityContacts) _then) =
      _$$EntityContactsCopyWithImpl;
  @override
  @useResult
  $Res call({String name, bool active, List<Contact> contacts});
}

/// @nodoc
class _$$EntityContactsCopyWithImpl<$Res>
    implements $$EntityContactsCopyWith<$Res> {
  _$$EntityContactsCopyWithImpl(this._self, this._then);

  final $EntityContacts _self;
  final $Res Function($EntityContacts) _then;

  /// Create a copy of EntityContacts
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? name = null,
    Object? active = null,
    Object? contacts = null,
  }) {
    return _then($EntityContacts(
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      active: null == active
          ? _self.active
          : active // ignore: cast_nullable_to_non_nullable
              as bool,
      contacts: null == contacts
          ? _self._contacts
          : contacts // ignore: cast_nullable_to_non_nullable
              as List<Contact>,
    ));
  }
}

// dart format on
