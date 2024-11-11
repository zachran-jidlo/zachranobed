// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'entity_contacts.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$EntityContacts {
  String get name => throw _privateConstructorUsedError;
  bool get active => throw _privateConstructorUsedError;
  List<Contact> get contacts => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $EntityContactsCopyWith<EntityContacts> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EntityContactsCopyWith<$Res> {
  factory $EntityContactsCopyWith(
          EntityContacts value, $Res Function(EntityContacts) then) =
      _$EntityContactsCopyWithImpl<$Res, EntityContacts>;
  @useResult
  $Res call({String name, bool active, List<Contact> contacts});
}

/// @nodoc
class _$EntityContactsCopyWithImpl<$Res, $Val extends EntityContacts>
    implements $EntityContactsCopyWith<$Res> {
  _$EntityContactsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? active = null,
    Object? contacts = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      active: null == active
          ? _value.active
          : active // ignore: cast_nullable_to_non_nullable
              as bool,
      contacts: null == contacts
          ? _value.contacts
          : contacts // ignore: cast_nullable_to_non_nullable
              as List<Contact>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$$EntityContactsImplCopyWith<$Res>
    implements $EntityContactsCopyWith<$Res> {
  factory _$$$EntityContactsImplCopyWith(_$$EntityContactsImpl value,
          $Res Function(_$$EntityContactsImpl) then) =
      __$$$EntityContactsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, bool active, List<Contact> contacts});
}

/// @nodoc
class __$$$EntityContactsImplCopyWithImpl<$Res>
    extends _$EntityContactsCopyWithImpl<$Res, _$$EntityContactsImpl>
    implements _$$$EntityContactsImplCopyWith<$Res> {
  __$$$EntityContactsImplCopyWithImpl(
      _$$EntityContactsImpl _value, $Res Function(_$$EntityContactsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? active = null,
    Object? contacts = null,
  }) {
    return _then(_$$EntityContactsImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      active: null == active
          ? _value.active
          : active // ignore: cast_nullable_to_non_nullable
              as bool,
      contacts: null == contacts
          ? _value._contacts
          : contacts // ignore: cast_nullable_to_non_nullable
              as List<Contact>,
    ));
  }
}

/// @nodoc

class _$$EntityContactsImpl implements $EntityContacts {
  const _$$EntityContactsImpl(
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

  @override
  String toString() {
    return 'EntityContacts(name: $name, active: $active, contacts: $contacts)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$$EntityContactsImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.active, active) || other.active == active) &&
            const DeepCollectionEquality().equals(other._contacts, _contacts));
  }

  @override
  int get hashCode => Object.hash(runtimeType, name, active,
      const DeepCollectionEquality().hash(_contacts));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$$EntityContactsImplCopyWith<_$$EntityContactsImpl> get copyWith =>
      __$$$EntityContactsImplCopyWithImpl<_$$EntityContactsImpl>(
          this, _$identity);
}

abstract class $EntityContacts implements EntityContacts {
  const factory $EntityContacts(
      {required final String name,
      required final bool active,
      required final List<Contact> contacts}) = _$$EntityContactsImpl;

  @override
  String get name;
  @override
  bool get active;
  @override
  List<Contact> get contacts;
  @override
  @JsonKey(ignore: true)
  _$$$EntityContactsImplCopyWith<_$$EntityContactsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
