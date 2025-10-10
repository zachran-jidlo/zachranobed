// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'delivery.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Delivery {
  String get id;
  String get donorId;
  String get recipientId;
  DeliveryState get state;
  DeliveryType get type;
  int get confirmationTime;

  /// Create a copy of Delivery
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $DeliveryCopyWith<Delivery> get copyWith =>
      _$DeliveryCopyWithImpl<Delivery>(this as Delivery, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Delivery &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.donorId, donorId) || other.donorId == donorId) &&
            (identical(other.recipientId, recipientId) ||
                other.recipientId == recipientId) &&
            (identical(other.state, state) || other.state == state) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.confirmationTime, confirmationTime) ||
                other.confirmationTime == confirmationTime));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, id, donorId, recipientId, state, type, confirmationTime);

  @override
  String toString() {
    return 'Delivery(id: $id, donorId: $donorId, recipientId: $recipientId, state: $state, type: $type, confirmationTime: $confirmationTime)';
  }
}

/// @nodoc
abstract mixin class $DeliveryCopyWith<$Res> {
  factory $DeliveryCopyWith(Delivery value, $Res Function(Delivery) _then) =
      _$DeliveryCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String donorId,
      String recipientId,
      DeliveryState state,
      DeliveryType type,
      int confirmationTime});
}

/// @nodoc
class _$DeliveryCopyWithImpl<$Res> implements $DeliveryCopyWith<$Res> {
  _$DeliveryCopyWithImpl(this._self, this._then);

  final Delivery _self;
  final $Res Function(Delivery) _then;

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
    Object? confirmationTime = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      donorId: null == donorId
          ? _self.donorId
          : donorId // ignore: cast_nullable_to_non_nullable
              as String,
      recipientId: null == recipientId
          ? _self.recipientId
          : recipientId // ignore: cast_nullable_to_non_nullable
              as String,
      state: null == state
          ? _self.state
          : state // ignore: cast_nullable_to_non_nullable
              as DeliveryState,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as DeliveryType,
      confirmationTime: null == confirmationTime
          ? _self.confirmationTime
          : confirmationTime // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _Delivery extends Delivery {
  const _Delivery(
      {required this.id,
      required this.donorId,
      required this.recipientId,
      required this.state,
      required this.type,
      required this.confirmationTime})
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
  final int confirmationTime;

  /// Create a copy of Delivery
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$DeliveryCopyWith<_Delivery> get copyWith =>
      __$DeliveryCopyWithImpl<_Delivery>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Delivery &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.donorId, donorId) || other.donorId == donorId) &&
            (identical(other.recipientId, recipientId) ||
                other.recipientId == recipientId) &&
            (identical(other.state, state) || other.state == state) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.confirmationTime, confirmationTime) ||
                other.confirmationTime == confirmationTime));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, id, donorId, recipientId, state, type, confirmationTime);

  @override
  String toString() {
    return 'Delivery(id: $id, donorId: $donorId, recipientId: $recipientId, state: $state, type: $type, confirmationTime: $confirmationTime)';
  }
}

/// @nodoc
abstract mixin class _$DeliveryCopyWith<$Res>
    implements $DeliveryCopyWith<$Res> {
  factory _$DeliveryCopyWith(_Delivery value, $Res Function(_Delivery) _then) =
      __$DeliveryCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String donorId,
      String recipientId,
      DeliveryState state,
      DeliveryType type,
      int confirmationTime});
}

/// @nodoc
class __$DeliveryCopyWithImpl<$Res> implements _$DeliveryCopyWith<$Res> {
  __$DeliveryCopyWithImpl(this._self, this._then);

  final _Delivery _self;
  final $Res Function(_Delivery) _then;

  /// Create a copy of Delivery
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? donorId = null,
    Object? recipientId = null,
    Object? state = null,
    Object? type = null,
    Object? confirmationTime = null,
  }) {
    return _then(_Delivery(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      donorId: null == donorId
          ? _self.donorId
          : donorId // ignore: cast_nullable_to_non_nullable
              as String,
      recipientId: null == recipientId
          ? _self.recipientId
          : recipientId // ignore: cast_nullable_to_non_nullable
              as String,
      state: null == state
          ? _self.state
          : state // ignore: cast_nullable_to_non_nullable
              as DeliveryState,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as DeliveryType,
      confirmationTime: null == confirmationTime
          ? _self.confirmationTime
          : confirmationTime // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

// dart format on
