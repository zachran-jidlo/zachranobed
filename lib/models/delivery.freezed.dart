// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'delivery.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$Delivery {
  String get id => throw _privateConstructorUsedError;
  String get donorId => throw _privateConstructorUsedError;
  String get recipientId => throw _privateConstructorUsedError;
  DeliveryState get state => throw _privateConstructorUsedError;
  DeliveryType get type => throw _privateConstructorUsedError;
  CarrierType get carrierType => throw _privateConstructorUsedError;

  /// Create a copy of Delivery
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DeliveryCopyWith<Delivery> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DeliveryCopyWith<$Res> {
  factory $DeliveryCopyWith(Delivery value, $Res Function(Delivery) then) =
      _$DeliveryCopyWithImpl<$Res, Delivery>;
  @useResult
  $Res call(
      {String id,
      String donorId,
      String recipientId,
      DeliveryState state,
      DeliveryType type,
      CarrierType carrierType});
}

/// @nodoc
class _$DeliveryCopyWithImpl<$Res, $Val extends Delivery>
    implements $DeliveryCopyWith<$Res> {
  _$DeliveryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Delivery
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? donorId = null,
    Object? recipientId = null,
    Object? state = null,
    Object? type = null,
    Object? carrierType = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      donorId: null == donorId
          ? _value.donorId
          : donorId // ignore: cast_nullable_to_non_nullable
              as String,
      recipientId: null == recipientId
          ? _value.recipientId
          : recipientId // ignore: cast_nullable_to_non_nullable
              as String,
      state: null == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as DeliveryState,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as DeliveryType,
      carrierType: null == carrierType
          ? _value.carrierType
          : carrierType // ignore: cast_nullable_to_non_nullable
              as CarrierType,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DeliveryImplCopyWith<$Res>
    implements $DeliveryCopyWith<$Res> {
  factory _$$DeliveryImplCopyWith(
          _$DeliveryImpl value, $Res Function(_$DeliveryImpl) then) =
      __$$DeliveryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String donorId,
      String recipientId,
      DeliveryState state,
      DeliveryType type,
      CarrierType carrierType});
}

/// @nodoc
class __$$DeliveryImplCopyWithImpl<$Res>
    extends _$DeliveryCopyWithImpl<$Res, _$DeliveryImpl>
    implements _$$DeliveryImplCopyWith<$Res> {
  __$$DeliveryImplCopyWithImpl(
      _$DeliveryImpl _value, $Res Function(_$DeliveryImpl) _then)
      : super(_value, _then);

  /// Create a copy of Delivery
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? donorId = null,
    Object? recipientId = null,
    Object? state = null,
    Object? type = null,
    Object? carrierType = null,
  }) {
    return _then(_$DeliveryImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      donorId: null == donorId
          ? _value.donorId
          : donorId // ignore: cast_nullable_to_non_nullable
              as String,
      recipientId: null == recipientId
          ? _value.recipientId
          : recipientId // ignore: cast_nullable_to_non_nullable
              as String,
      state: null == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as DeliveryState,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as DeliveryType,
      carrierType: null == carrierType
          ? _value.carrierType
          : carrierType // ignore: cast_nullable_to_non_nullable
              as CarrierType,
    ));
  }
}

/// @nodoc

class _$DeliveryImpl extends _Delivery {
  const _$DeliveryImpl(
      {required this.id,
      required this.donorId,
      required this.recipientId,
      required this.state,
      required this.type,
      required this.carrierType})
      : super._();

  @override
  final String id;
  @override
  final String donorId;
  @override
  final String recipientId;
  @override
  final DeliveryState state;
  @override
  final DeliveryType type;
  @override
  final CarrierType carrierType;

  @override
  String toString() {
    return 'Delivery(id: $id, donorId: $donorId, recipientId: $recipientId, state: $state, type: $type, carrierType: $carrierType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeliveryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.donorId, donorId) || other.donorId == donorId) &&
            (identical(other.recipientId, recipientId) ||
                other.recipientId == recipientId) &&
            (identical(other.state, state) || other.state == state) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.carrierType, carrierType) ||
                other.carrierType == carrierType));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, id, donorId, recipientId, state, type, carrierType);

  /// Create a copy of Delivery
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DeliveryImplCopyWith<_$DeliveryImpl> get copyWith =>
      __$$DeliveryImplCopyWithImpl<_$DeliveryImpl>(this, _$identity);
}

abstract class _Delivery extends Delivery {
  const factory _Delivery(
      {required final String id,
      required final String donorId,
      required final String recipientId,
      required final DeliveryState state,
      required final DeliveryType type,
      required final CarrierType carrierType}) = _$DeliveryImpl;
  const _Delivery._() : super._();

  @override
  String get id;
  @override
  String get donorId;
  @override
  String get recipientId;
  @override
  DeliveryState get state;
  @override
  DeliveryType get type;
  @override
  CarrierType get carrierType;

  /// Create a copy of Delivery
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DeliveryImplCopyWith<_$DeliveryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
