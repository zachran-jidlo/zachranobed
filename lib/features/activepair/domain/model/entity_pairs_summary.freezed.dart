// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'entity_pairs_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$EntityPairsSummary {
  /// The currently active pair.
  EntityPair get active => throw _privateConstructorUsedError;

  /// A list of other available pairs.
  List<EntityPair> get otherPairs => throw _privateConstructorUsedError;

  /// Create a copy of EntityPairsSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EntityPairsSummaryCopyWith<EntityPairsSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EntityPairsSummaryCopyWith<$Res> {
  factory $EntityPairsSummaryCopyWith(
          EntityPairsSummary value, $Res Function(EntityPairsSummary) then) =
      _$EntityPairsSummaryCopyWithImpl<$Res, EntityPairsSummary>;
  @useResult
  $Res call({EntityPair active, List<EntityPair> otherPairs});
}

/// @nodoc
class _$EntityPairsSummaryCopyWithImpl<$Res, $Val extends EntityPairsSummary>
    implements $EntityPairsSummaryCopyWith<$Res> {
  _$EntityPairsSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EntityPairsSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? active = null,
    Object? otherPairs = null,
  }) {
    return _then(_value.copyWith(
      active: null == active
          ? _value.active
          : active // ignore: cast_nullable_to_non_nullable
              as EntityPair,
      otherPairs: null == otherPairs
          ? _value.otherPairs
          : otherPairs // ignore: cast_nullable_to_non_nullable
              as List<EntityPair>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$$EntityPairsSummaryImplCopyWith<$Res>
    implements $EntityPairsSummaryCopyWith<$Res> {
  factory _$$$EntityPairsSummaryImplCopyWith(_$$EntityPairsSummaryImpl value,
          $Res Function(_$$EntityPairsSummaryImpl) then) =
      __$$$EntityPairsSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({EntityPair active, List<EntityPair> otherPairs});
}

/// @nodoc
class __$$$EntityPairsSummaryImplCopyWithImpl<$Res>
    extends _$EntityPairsSummaryCopyWithImpl<$Res, _$$EntityPairsSummaryImpl>
    implements _$$$EntityPairsSummaryImplCopyWith<$Res> {
  __$$$EntityPairsSummaryImplCopyWithImpl(_$$EntityPairsSummaryImpl _value,
      $Res Function(_$$EntityPairsSummaryImpl) _then)
      : super(_value, _then);

  /// Create a copy of EntityPairsSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? active = null,
    Object? otherPairs = null,
  }) {
    return _then(_$$EntityPairsSummaryImpl(
      active: null == active
          ? _value.active
          : active // ignore: cast_nullable_to_non_nullable
              as EntityPair,
      otherPairs: null == otherPairs
          ? _value._otherPairs
          : otherPairs // ignore: cast_nullable_to_non_nullable
              as List<EntityPair>,
    ));
  }
}

/// @nodoc

class _$$EntityPairsSummaryImpl implements $EntityPairsSummary {
  const _$$EntityPairsSummaryImpl(
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

  @override
  String toString() {
    return 'EntityPairsSummary(active: $active, otherPairs: $otherPairs)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$$EntityPairsSummaryImpl &&
            (identical(other.active, active) || other.active == active) &&
            const DeepCollectionEquality()
                .equals(other._otherPairs, _otherPairs));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, active, const DeepCollectionEquality().hash(_otherPairs));

  /// Create a copy of EntityPairsSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$$EntityPairsSummaryImplCopyWith<_$$EntityPairsSummaryImpl> get copyWith =>
      __$$$EntityPairsSummaryImplCopyWithImpl<_$$EntityPairsSummaryImpl>(
          this, _$identity);
}

abstract class $EntityPairsSummary implements EntityPairsSummary {
  const factory $EntityPairsSummary(
      {required final EntityPair active,
      required final List<EntityPair> otherPairs}) = _$$EntityPairsSummaryImpl;

  /// The currently active pair.
  @override
  EntityPair get active;

  /// A list of other available pairs.
  @override
  List<EntityPair> get otherPairs;

  /// Create a copy of EntityPairsSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$$EntityPairsSummaryImplCopyWith<_$$EntityPairsSummaryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
