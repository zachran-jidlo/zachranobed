// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'contacts_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ContactsSummary {
  List<EntityContacts> get targets => throw _privateConstructorUsedError;
  List<Contact> get deliveryContacts => throw _privateConstructorUsedError;
  List<Contact> get organisationContacts => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ContactsSummaryCopyWith<ContactsSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ContactsSummaryCopyWith<$Res> {
  factory $ContactsSummaryCopyWith(
          ContactsSummary value, $Res Function(ContactsSummary) then) =
      _$ContactsSummaryCopyWithImpl<$Res, ContactsSummary>;
  @useResult
  $Res call(
      {List<EntityContacts> targets,
      List<Contact> deliveryContacts,
      List<Contact> organisationContacts});
}

/// @nodoc
class _$ContactsSummaryCopyWithImpl<$Res, $Val extends ContactsSummary>
    implements $ContactsSummaryCopyWith<$Res> {
  _$ContactsSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? targets = null,
    Object? deliveryContacts = null,
    Object? organisationContacts = null,
  }) {
    return _then(_value.copyWith(
      targets: null == targets
          ? _value.targets
          : targets // ignore: cast_nullable_to_non_nullable
              as List<EntityContacts>,
      deliveryContacts: null == deliveryContacts
          ? _value.deliveryContacts
          : deliveryContacts // ignore: cast_nullable_to_non_nullable
              as List<Contact>,
      organisationContacts: null == organisationContacts
          ? _value.organisationContacts
          : organisationContacts // ignore: cast_nullable_to_non_nullable
              as List<Contact>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$$ContactsSummaryImplCopyWith<$Res>
    implements $ContactsSummaryCopyWith<$Res> {
  factory _$$$ContactsSummaryImplCopyWith(_$$ContactsSummaryImpl value,
          $Res Function(_$$ContactsSummaryImpl) then) =
      __$$$ContactsSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<EntityContacts> targets,
      List<Contact> deliveryContacts,
      List<Contact> organisationContacts});
}

/// @nodoc
class __$$$ContactsSummaryImplCopyWithImpl<$Res>
    extends _$ContactsSummaryCopyWithImpl<$Res, _$$ContactsSummaryImpl>
    implements _$$$ContactsSummaryImplCopyWith<$Res> {
  __$$$ContactsSummaryImplCopyWithImpl(_$$ContactsSummaryImpl _value,
      $Res Function(_$$ContactsSummaryImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? targets = null,
    Object? deliveryContacts = null,
    Object? organisationContacts = null,
  }) {
    return _then(_$$ContactsSummaryImpl(
      targets: null == targets
          ? _value._targets
          : targets // ignore: cast_nullable_to_non_nullable
              as List<EntityContacts>,
      deliveryContacts: null == deliveryContacts
          ? _value._deliveryContacts
          : deliveryContacts // ignore: cast_nullable_to_non_nullable
              as List<Contact>,
      organisationContacts: null == organisationContacts
          ? _value._organisationContacts
          : organisationContacts // ignore: cast_nullable_to_non_nullable
              as List<Contact>,
    ));
  }
}

/// @nodoc

class _$$ContactsSummaryImpl implements $ContactsSummary {
  const _$$ContactsSummaryImpl(
      {required final List<EntityContacts> targets,
      required final List<Contact> deliveryContacts,
      required final List<Contact> organisationContacts})
      : _targets = targets,
        _deliveryContacts = deliveryContacts,
        _organisationContacts = organisationContacts;

  final List<EntityContacts> _targets;
  @override
  List<EntityContacts> get targets {
    if (_targets is EqualUnmodifiableListView) return _targets;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_targets);
  }

  final List<Contact> _deliveryContacts;
  @override
  List<Contact> get deliveryContacts {
    if (_deliveryContacts is EqualUnmodifiableListView)
      return _deliveryContacts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_deliveryContacts);
  }

  final List<Contact> _organisationContacts;
  @override
  List<Contact> get organisationContacts {
    if (_organisationContacts is EqualUnmodifiableListView)
      return _organisationContacts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_organisationContacts);
  }

  @override
  String toString() {
    return 'ContactsSummary(targets: $targets, deliveryContacts: $deliveryContacts, organisationContacts: $organisationContacts)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$$ContactsSummaryImpl &&
            const DeepCollectionEquality().equals(other._targets, _targets) &&
            const DeepCollectionEquality()
                .equals(other._deliveryContacts, _deliveryContacts) &&
            const DeepCollectionEquality()
                .equals(other._organisationContacts, _organisationContacts));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_targets),
      const DeepCollectionEquality().hash(_deliveryContacts),
      const DeepCollectionEquality().hash(_organisationContacts));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$$ContactsSummaryImplCopyWith<_$$ContactsSummaryImpl> get copyWith =>
      __$$$ContactsSummaryImplCopyWithImpl<_$$ContactsSummaryImpl>(
          this, _$identity);
}

abstract class $ContactsSummary implements ContactsSummary {
  const factory $ContactsSummary(
          {required final List<EntityContacts> targets,
          required final List<Contact> deliveryContacts,
          required final List<Contact> organisationContacts}) =
      _$$ContactsSummaryImpl;

  @override
  List<EntityContacts> get targets;
  @override
  List<Contact> get deliveryContacts;
  @override
  List<Contact> get organisationContacts;
  @override
  @JsonKey(ignore: true)
  _$$$ContactsSummaryImplCopyWith<_$$ContactsSummaryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
