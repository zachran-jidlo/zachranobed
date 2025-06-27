// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'contacts_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ContactsSummary {
  List<EntityContacts> get targets;
  List<Contact> get deliveryContacts;
  List<Contact> get organisationContacts;

  /// Create a copy of ContactsSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ContactsSummaryCopyWith<ContactsSummary> get copyWith =>
      _$ContactsSummaryCopyWithImpl<ContactsSummary>(
          this as ContactsSummary, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ContactsSummary &&
            const DeepCollectionEquality().equals(other.targets, targets) &&
            const DeepCollectionEquality()
                .equals(other.deliveryContacts, deliveryContacts) &&
            const DeepCollectionEquality()
                .equals(other.organisationContacts, organisationContacts));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(targets),
      const DeepCollectionEquality().hash(deliveryContacts),
      const DeepCollectionEquality().hash(organisationContacts));

  @override
  String toString() {
    return 'ContactsSummary(targets: $targets, deliveryContacts: $deliveryContacts, organisationContacts: $organisationContacts)';
  }
}

/// @nodoc
abstract mixin class $ContactsSummaryCopyWith<$Res> {
  factory $ContactsSummaryCopyWith(
          ContactsSummary value, $Res Function(ContactsSummary) _then) =
      _$ContactsSummaryCopyWithImpl;
  @useResult
  $Res call(
      {List<EntityContacts> targets,
      List<Contact> deliveryContacts,
      List<Contact> organisationContacts});
}

/// @nodoc
class _$ContactsSummaryCopyWithImpl<$Res>
    implements $ContactsSummaryCopyWith<$Res> {
  _$ContactsSummaryCopyWithImpl(this._self, this._then);

  final ContactsSummary _self;
  final $Res Function(ContactsSummary) _then;

  /// Create a copy of ContactsSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? targets = null,
    Object? deliveryContacts = null,
    Object? organisationContacts = null,
  }) {
    return _then(_self.copyWith(
      targets: null == targets
          ? _self.targets
          : targets // ignore: cast_nullable_to_non_nullable
              as List<EntityContacts>,
      deliveryContacts: null == deliveryContacts
          ? _self.deliveryContacts
          : deliveryContacts // ignore: cast_nullable_to_non_nullable
              as List<Contact>,
      organisationContacts: null == organisationContacts
          ? _self.organisationContacts
          : organisationContacts // ignore: cast_nullable_to_non_nullable
              as List<Contact>,
    ));
  }
}

/// @nodoc

class $ContactsSummary implements ContactsSummary {
  const $ContactsSummary(
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

  /// Create a copy of ContactsSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $$ContactsSummaryCopyWith<$ContactsSummary> get copyWith =>
      _$$ContactsSummaryCopyWithImpl<$ContactsSummary>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is $ContactsSummary &&
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

  @override
  String toString() {
    return 'ContactsSummary(targets: $targets, deliveryContacts: $deliveryContacts, organisationContacts: $organisationContacts)';
  }
}

/// @nodoc
abstract mixin class $$ContactsSummaryCopyWith<$Res>
    implements $ContactsSummaryCopyWith<$Res> {
  factory $$ContactsSummaryCopyWith(
          $ContactsSummary value, $Res Function($ContactsSummary) _then) =
      _$$ContactsSummaryCopyWithImpl;
  @override
  @useResult
  $Res call(
      {List<EntityContacts> targets,
      List<Contact> deliveryContacts,
      List<Contact> organisationContacts});
}

/// @nodoc
class _$$ContactsSummaryCopyWithImpl<$Res>
    implements $$ContactsSummaryCopyWith<$Res> {
  _$$ContactsSummaryCopyWithImpl(this._self, this._then);

  final $ContactsSummary _self;
  final $Res Function($ContactsSummary) _then;

  /// Create a copy of ContactsSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? targets = null,
    Object? deliveryContacts = null,
    Object? organisationContacts = null,
  }) {
    return _then($ContactsSummary(
      targets: null == targets
          ? _self._targets
          : targets // ignore: cast_nullable_to_non_nullable
              as List<EntityContacts>,
      deliveryContacts: null == deliveryContacts
          ? _self._deliveryContacts
          : deliveryContacts // ignore: cast_nullable_to_non_nullable
              as List<Contact>,
      organisationContacts: null == organisationContacts
          ? _self._organisationContacts
          : organisationContacts // ignore: cast_nullable_to_non_nullable
              as List<Contact>,
    ));
  }
}

// dart format on
