// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'contacts_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
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
  $ContactsSummaryCopyWith<ContactsSummary> get copyWith => _$ContactsSummaryCopyWithImpl<ContactsSummary>(
    this as ContactsSummary,
    _$identity,
  );

  @override
  bool operator ==(Object other) {
    final _this = this as ContactsSummary;
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ContactsSummary &&
            const DeepCollectionEquality().equals(
              other.targets,
              _this.targets,
            ) &&
            const DeepCollectionEquality().equals(
              other.deliveryContacts,
              _this.deliveryContacts,
            ) &&
            const DeepCollectionEquality().equals(
              other.organisationContacts,
              _this.organisationContacts,
            ));
  }

  @override
  int get hashCode {
    final _this = this as ContactsSummary;
    return Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_this.targets),
      const DeepCollectionEquality().hash(_this.deliveryContacts),
      const DeepCollectionEquality().hash(_this.organisationContacts),
    );
  }

  @override
  String toString() {
    final _this = this as ContactsSummary;
    return 'ContactsSummary(targets: ${_this.targets}, deliveryContacts: ${_this.deliveryContacts}, organisationContacts: ${_this.organisationContacts})';
  }
}

/// @nodoc
abstract mixin class $ContactsSummaryCopyWith<$Res> {
  factory $ContactsSummaryCopyWith(
    ContactsSummary value,
    $Res Function(ContactsSummary) _then,
  ) = _$ContactsSummaryCopyWithImpl;
  @useResult
  $Res call({
    List<EntityContacts> targets,
    List<Contact> deliveryContacts,
    List<Contact> organisationContacts,
  });
}

/// @nodoc
class _$ContactsSummaryCopyWithImpl<$Res> implements $ContactsSummaryCopyWith<$Res> {
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
    return _then(
      ContactsSummary(
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
      ),
    );
  }
}

/// Adds pattern-matching-related methods to [ContactsSummary].
extension ContactsSummaryPatterns on ContactsSummary {
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
    TResult Function($ContactsSummary value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case $ContactsSummary() when $default != null:
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
    TResult Function($ContactsSummary value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case $ContactsSummary():
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
    TResult? Function($ContactsSummary value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case $ContactsSummary() when $default != null:
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
      List<EntityContacts> targets,
      List<Contact> deliveryContacts,
      List<Contact> organisationContacts,
    )?
    $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case $ContactsSummary() when $default != null:
        return $default(
          _that.targets,
          _that.deliveryContacts,
          _that.organisationContacts,
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
      List<EntityContacts> targets,
      List<Contact> deliveryContacts,
      List<Contact> organisationContacts,
    )
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case $ContactsSummary():
        return $default(
          _that.targets,
          _that.deliveryContacts,
          _that.organisationContacts,
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
      List<EntityContacts> targets,
      List<Contact> deliveryContacts,
      List<Contact> organisationContacts,
    )?
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case $ContactsSummary() when $default != null:
        return $default(
          _that.targets,
          _that.deliveryContacts,
          _that.organisationContacts,
        );
      case _:
        return null;
    }
  }
}

/// @nodoc

class $ContactsSummary implements ContactsSummary {
  const $ContactsSummary({
    required List<EntityContacts> targets,
    required List<Contact> deliveryContacts,
    required List<Contact> organisationContacts,
  }) : _targets = targets,
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
    if (_deliveryContacts is EqualUnmodifiableListView) return _deliveryContacts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_deliveryContacts);
  }

  final List<Contact> _organisationContacts;
  @override
  List<Contact> get organisationContacts {
    if (_organisationContacts is EqualUnmodifiableListView) return _organisationContacts;
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
            const DeepCollectionEquality().equals(other.targets, _targets) &&
            const DeepCollectionEquality().equals(
              other.deliveryContacts,
              _deliveryContacts,
            ) &&
            const DeepCollectionEquality().equals(
              other.organisationContacts,
              _organisationContacts,
            ));
  }

  @override
  int get hashCode {
    return Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_targets),
      const DeepCollectionEquality().hash(_deliveryContacts),
      const DeepCollectionEquality().hash(_organisationContacts),
    );
  }

  @override
  String toString() {
    return 'ContactsSummary(targets: $targets, deliveryContacts: $deliveryContacts, organisationContacts: $organisationContacts)';
  }
}

/// @nodoc
abstract mixin class $$ContactsSummaryCopyWith<$Res> implements $ContactsSummaryCopyWith<$Res> {
  factory $$ContactsSummaryCopyWith(
    $ContactsSummary value,
    $Res Function($ContactsSummary) _then,
  ) = _$$ContactsSummaryCopyWithImpl;
  @override
  @useResult
  $Res call({
    List<EntityContacts> targets,
    List<Contact> deliveryContacts,
    List<Contact> organisationContacts,
  });
}

/// @nodoc
class _$$ContactsSummaryCopyWithImpl<$Res> implements $$ContactsSummaryCopyWith<$Res> {
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
    return _then(
      $ContactsSummary(
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
      ),
    );
  }
}
