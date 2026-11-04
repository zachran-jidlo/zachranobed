// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'entity_pairs_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EntityPairsSummary {
  /// The currently active pair.
  EntityPair get active;

  /// A list of other available pairs.
  List<EntityPair> get otherPairs;

  /// Create a copy of EntityPairsSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $EntityPairsSummaryCopyWith<EntityPairsSummary> get copyWith => _$EntityPairsSummaryCopyWithImpl<EntityPairsSummary>(
    this as EntityPairsSummary,
    _$identity,
  );

  @override
  bool operator ==(Object other) {
    final _this = this as EntityPairsSummary;
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is EntityPairsSummary &&
            (identical(other.active, _this.active) || other.active == _this.active) &&
            const DeepCollectionEquality().equals(
              other.otherPairs,
              _this.otherPairs,
            ));
  }

  @override
  int get hashCode {
    final _this = this as EntityPairsSummary;
    return Object.hash(
      runtimeType,
      _this.active,
      const DeepCollectionEquality().hash(_this.otherPairs),
    );
  }

  @override
  String toString() {
    final _this = this as EntityPairsSummary;
    return 'EntityPairsSummary(active: ${_this.active}, otherPairs: ${_this.otherPairs})';
  }
}

/// @nodoc
abstract mixin class $EntityPairsSummaryCopyWith<$Res> {
  factory $EntityPairsSummaryCopyWith(
    EntityPairsSummary value,
    $Res Function(EntityPairsSummary) _then,
  ) = _$EntityPairsSummaryCopyWithImpl;
  @useResult
  $Res call({EntityPair active, List<EntityPair> otherPairs});
}

/// @nodoc
class _$EntityPairsSummaryCopyWithImpl<$Res> implements $EntityPairsSummaryCopyWith<$Res> {
  _$EntityPairsSummaryCopyWithImpl(this._self, this._then);

  final EntityPairsSummary _self;
  final $Res Function(EntityPairsSummary) _then;

  /// Create a copy of EntityPairsSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? active = null, Object? otherPairs = null}) {
    return _then(
      EntityPairsSummary(
        active: null == active
            ? _self.active
            : active // ignore: cast_nullable_to_non_nullable
                  as EntityPair,
        otherPairs: null == otherPairs
            ? _self.otherPairs
            : otherPairs // ignore: cast_nullable_to_non_nullable
                  as List<EntityPair>,
      ),
    );
  }
}

/// Adds pattern-matching-related methods to [EntityPairsSummary].
extension EntityPairsSummaryPatterns on EntityPairsSummary {
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
    TResult Function($EntityPairsSummary value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case $EntityPairsSummary() when $default != null:
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
    TResult Function($EntityPairsSummary value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case $EntityPairsSummary():
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
    TResult? Function($EntityPairsSummary value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case $EntityPairsSummary() when $default != null:
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
    TResult Function(EntityPair active, List<EntityPair> otherPairs)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case $EntityPairsSummary() when $default != null:
        return $default(_that.active, _that.otherPairs);
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
    TResult Function(EntityPair active, List<EntityPair> otherPairs) $default,
  ) {
    final _that = this;
    switch (_that) {
      case $EntityPairsSummary():
        return $default(_that.active, _that.otherPairs);
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
    TResult? Function(EntityPair active, List<EntityPair> otherPairs)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case $EntityPairsSummary() when $default != null:
        return $default(_that.active, _that.otherPairs);
      case _:
        return null;
    }
  }
}

/// @nodoc

class $EntityPairsSummary implements EntityPairsSummary {
  const $EntityPairsSummary({
    required this.active,
    required List<EntityPair> otherPairs,
  }) : _otherPairs = otherPairs;

  /// The currently active pair.
  @override
  final EntityPair active;

  /// A list of other available pairs.
  final List<EntityPair> _otherPairs;

  /// A list of other available pairs.
  @override
  List<EntityPair> get otherPairs {
    if (_otherPairs is EqualUnmodifiableListView) return _otherPairs;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_otherPairs);
  }

  /// Create a copy of EntityPairsSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $$EntityPairsSummaryCopyWith<$EntityPairsSummary> get copyWith =>
      _$$EntityPairsSummaryCopyWithImpl<$EntityPairsSummary>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is $EntityPairsSummary &&
            (identical(other.active, active) || other.active == active) &&
            const DeepCollectionEquality().equals(
              other.otherPairs,
              _otherPairs,
            ));
  }

  @override
  int get hashCode {
    return Object.hash(
      runtimeType,
      active,
      const DeepCollectionEquality().hash(_otherPairs),
    );
  }

  @override
  String toString() {
    return 'EntityPairsSummary(active: $active, otherPairs: $otherPairs)';
  }
}

/// @nodoc
abstract mixin class $$EntityPairsSummaryCopyWith<$Res> implements $EntityPairsSummaryCopyWith<$Res> {
  factory $$EntityPairsSummaryCopyWith(
    $EntityPairsSummary value,
    $Res Function($EntityPairsSummary) _then,
  ) = _$$EntityPairsSummaryCopyWithImpl;
  @override
  @useResult
  $Res call({EntityPair active, List<EntityPair> otherPairs});
}

/// @nodoc
class _$$EntityPairsSummaryCopyWithImpl<$Res> implements $$EntityPairsSummaryCopyWith<$Res> {
  _$$EntityPairsSummaryCopyWithImpl(this._self, this._then);

  final $EntityPairsSummary _self;
  final $Res Function($EntityPairsSummary) _then;

  /// Create a copy of EntityPairsSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({Object? active = null, Object? otherPairs = null}) {
    return _then(
      $EntityPairsSummary(
        active: null == active
            ? _self.active
            : active // ignore: cast_nullable_to_non_nullable
                  as EntityPair,
        otherPairs: null == otherPairs
            ? _self._otherPairs
            : otherPairs // ignore: cast_nullable_to_non_nullable
                  as List<EntityPair>,
      ),
    );
  }
}
