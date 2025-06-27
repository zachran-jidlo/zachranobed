// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'entity_pairs_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
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
  $EntityPairsSummaryCopyWith<EntityPairsSummary> get copyWith =>
      _$EntityPairsSummaryCopyWithImpl<EntityPairsSummary>(
          this as EntityPairsSummary, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is EntityPairsSummary &&
            (identical(other.active, active) || other.active == active) &&
            const DeepCollectionEquality()
                .equals(other.otherPairs, otherPairs));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, active, const DeepCollectionEquality().hash(otherPairs));

  @override
  String toString() {
    return 'EntityPairsSummary(active: $active, otherPairs: $otherPairs)';
  }
}

/// @nodoc
abstract mixin class $EntityPairsSummaryCopyWith<$Res> {
  factory $EntityPairsSummaryCopyWith(
          EntityPairsSummary value, $Res Function(EntityPairsSummary) _then) =
      _$EntityPairsSummaryCopyWithImpl;
  @useResult
  $Res call({EntityPair active, List<EntityPair> otherPairs});
}

/// @nodoc
class _$EntityPairsSummaryCopyWithImpl<$Res>
    implements $EntityPairsSummaryCopyWith<$Res> {
  _$EntityPairsSummaryCopyWithImpl(this._self, this._then);

  final EntityPairsSummary _self;
  final $Res Function(EntityPairsSummary) _then;

  /// Create a copy of EntityPairsSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? active = null,
    Object? otherPairs = null,
  }) {
    return _then(_self.copyWith(
      active: null == active
          ? _self.active
          : active // ignore: cast_nullable_to_non_nullable
              as EntityPair,
      otherPairs: null == otherPairs
          ? _self.otherPairs
          : otherPairs // ignore: cast_nullable_to_non_nullable
              as List<EntityPair>,
    ));
  }
}

/// @nodoc

class $EntityPairsSummary implements EntityPairsSummary {
  const $EntityPairsSummary(
      {required this.active, required final List<EntityPair> otherPairs})
      : _otherPairs = otherPairs;

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
            const DeepCollectionEquality()
                .equals(other._otherPairs, _otherPairs));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, active, const DeepCollectionEquality().hash(_otherPairs));

  @override
  String toString() {
    return 'EntityPairsSummary(active: $active, otherPairs: $otherPairs)';
  }
}

/// @nodoc
abstract mixin class $$EntityPairsSummaryCopyWith<$Res>
    implements $EntityPairsSummaryCopyWith<$Res> {
  factory $$EntityPairsSummaryCopyWith(
          $EntityPairsSummary value, $Res Function($EntityPairsSummary) _then) =
      _$$EntityPairsSummaryCopyWithImpl;
  @override
  @useResult
  $Res call({EntityPair active, List<EntityPair> otherPairs});
}

/// @nodoc
class _$$EntityPairsSummaryCopyWithImpl<$Res>
    implements $$EntityPairsSummaryCopyWith<$Res> {
  _$$EntityPairsSummaryCopyWithImpl(this._self, this._then);

  final $EntityPairsSummary _self;
  final $Res Function($EntityPairsSummary) _then;

  /// Create a copy of EntityPairsSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? active = null,
    Object? otherPairs = null,
  }) {
    return _then($EntityPairsSummary(
      active: null == active
          ? _self.active
          : active // ignore: cast_nullable_to_non_nullable
              as EntityPair,
      otherPairs: null == otherPairs
          ? _self._otherPairs
          : otherPairs // ignore: cast_nullable_to_non_nullable
              as List<EntityPair>,
    ));
  }
}

// dart format on
