// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'delivery.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Delivery {
  String get id;
  String get donorId;
  String get recipientId;
  DeliveryState get state;
  DeliveryType get type;
  Duration get confirmationTime;
  bool get hasMeals;
  bool get isPickupConfirmed;
  Map<String, int> get foodBoxes;

  /// Create a copy of Delivery
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $DeliveryCopyWith<Delivery> get copyWith => _$DeliveryCopyWithImpl<Delivery>(this as Delivery, _$identity);

  @override
  bool operator ==(Object other) {
    final _this = this as Delivery;
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Delivery &&
            (identical(other.id, _this.id) || other.id == _this.id) &&
            (identical(other.donorId, _this.donorId) || other.donorId == _this.donorId) &&
            (identical(other.recipientId, _this.recipientId) || other.recipientId == _this.recipientId) &&
            (identical(other.state, _this.state) || other.state == _this.state) &&
            (identical(other.type, _this.type) || other.type == _this.type) &&
            (identical(other.confirmationTime, _this.confirmationTime) ||
                other.confirmationTime == _this.confirmationTime) &&
            (identical(other.hasMeals, _this.hasMeals) || other.hasMeals == _this.hasMeals) &&
            (identical(other.isPickupConfirmed, _this.isPickupConfirmed) ||
                other.isPickupConfirmed == _this.isPickupConfirmed) &&
            const DeepCollectionEquality().equals(
              other.foodBoxes,
              _this.foodBoxes,
            ));
  }

  @override
  int get hashCode {
    final _this = this as Delivery;
    return Object.hash(
      runtimeType,
      _this.id,
      _this.donorId,
      _this.recipientId,
      _this.state,
      _this.type,
      _this.confirmationTime,
      _this.hasMeals,
      _this.isPickupConfirmed,
      const DeepCollectionEquality().hash(_this.foodBoxes),
    );
  }

  @override
  String toString() {
    final _this = this as Delivery;
    return 'Delivery(id: ${_this.id}, donorId: ${_this.donorId}, recipientId: ${_this.recipientId}, state: ${_this.state}, type: ${_this.type}, confirmationTime: ${_this.confirmationTime}, hasMeals: ${_this.hasMeals}, isPickupConfirmed: ${_this.isPickupConfirmed}, foodBoxes: ${_this.foodBoxes})';
  }
}

/// @nodoc
abstract mixin class $DeliveryCopyWith<$Res> {
  factory $DeliveryCopyWith(Delivery value, $Res Function(Delivery) _then) = _$DeliveryCopyWithImpl;
  @useResult
  $Res call({
    String id,
    String donorId,
    String recipientId,
    DeliveryState state,
    DeliveryType type,
    Duration confirmationTime,
    bool hasMeals,
    bool isPickupConfirmed,
    Map<String, int> foodBoxes,
  });
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
    Object? hasMeals = null,
    Object? isPickupConfirmed = null,
    Object? foodBoxes = null,
  }) {
    return _then(
      Delivery(
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
                  as Duration,
        hasMeals: null == hasMeals
            ? _self.hasMeals
            : hasMeals // ignore: cast_nullable_to_non_nullable
                  as bool,
        isPickupConfirmed: null == isPickupConfirmed
            ? _self.isPickupConfirmed
            : isPickupConfirmed // ignore: cast_nullable_to_non_nullable
                  as bool,
        foodBoxes: null == foodBoxes
            ? _self.foodBoxes
            : foodBoxes // ignore: cast_nullable_to_non_nullable
                  as Map<String, int>,
      ),
    );
  }
}

/// Adds pattern-matching-related methods to [Delivery].
extension DeliveryPatterns on Delivery {
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
    TResult Function(_Delivery value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Delivery() when $default != null:
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
    TResult Function(_Delivery value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Delivery():
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
    TResult? Function(_Delivery value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Delivery() when $default != null:
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
      String id,
      String donorId,
      String recipientId,
      DeliveryState state,
      DeliveryType type,
      Duration confirmationTime,
      bool hasMeals,
      bool isPickupConfirmed,
      Map<String, int> foodBoxes,
    )?
    $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Delivery() when $default != null:
        return $default(
          _that.id,
          _that.donorId,
          _that.recipientId,
          _that.state,
          _that.type,
          _that.confirmationTime,
          _that.hasMeals,
          _that.isPickupConfirmed,
          _that.foodBoxes,
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
      String id,
      String donorId,
      String recipientId,
      DeliveryState state,
      DeliveryType type,
      Duration confirmationTime,
      bool hasMeals,
      bool isPickupConfirmed,
      Map<String, int> foodBoxes,
    )
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Delivery():
        return $default(
          _that.id,
          _that.donorId,
          _that.recipientId,
          _that.state,
          _that.type,
          _that.confirmationTime,
          _that.hasMeals,
          _that.isPickupConfirmed,
          _that.foodBoxes,
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
      String id,
      String donorId,
      String recipientId,
      DeliveryState state,
      DeliveryType type,
      Duration confirmationTime,
      bool hasMeals,
      bool isPickupConfirmed,
      Map<String, int> foodBoxes,
    )?
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Delivery() when $default != null:
        return $default(
          _that.id,
          _that.donorId,
          _that.recipientId,
          _that.state,
          _that.type,
          _that.confirmationTime,
          _that.hasMeals,
          _that.isPickupConfirmed,
          _that.foodBoxes,
        );
      case _:
        return null;
    }
  }
}

/// @nodoc

class _Delivery extends Delivery {
  const _Delivery({
    required this.id,
    required this.donorId,
    required this.recipientId,
    required this.state,
    required this.type,
    required this.confirmationTime,
    required this.hasMeals,
    required this.isPickupConfirmed,
    required Map<String, int> foodBoxes,
  }) : _foodBoxes = foodBoxes,
       super._();

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
  final Duration confirmationTime;
  @override
  final bool hasMeals;
  @override
  final bool isPickupConfirmed;
  final Map<String, int> _foodBoxes;
  @override
  Map<String, int> get foodBoxes {
    if (_foodBoxes is EqualUnmodifiableMapView) return _foodBoxes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_foodBoxes);
  }

  /// Create a copy of Delivery
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$DeliveryCopyWith<_Delivery> get copyWith => __$DeliveryCopyWithImpl<_Delivery>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Delivery &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.donorId, donorId) || other.donorId == donorId) &&
            (identical(other.recipientId, recipientId) || other.recipientId == recipientId) &&
            (identical(other.state, state) || other.state == state) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.confirmationTime, confirmationTime) || other.confirmationTime == confirmationTime) &&
            (identical(other.hasMeals, hasMeals) || other.hasMeals == hasMeals) &&
            (identical(other.isPickupConfirmed, isPickupConfirmed) || other.isPickupConfirmed == isPickupConfirmed) &&
            const DeepCollectionEquality().equals(other.foodBoxes, _foodBoxes));
  }

  @override
  int get hashCode {
    return Object.hash(
      runtimeType,
      id,
      donorId,
      recipientId,
      state,
      type,
      confirmationTime,
      hasMeals,
      isPickupConfirmed,
      const DeepCollectionEquality().hash(_foodBoxes),
    );
  }

  @override
  String toString() {
    return 'Delivery(id: $id, donorId: $donorId, recipientId: $recipientId, state: $state, type: $type, confirmationTime: $confirmationTime, hasMeals: $hasMeals, isPickupConfirmed: $isPickupConfirmed, foodBoxes: $foodBoxes)';
  }
}

/// @nodoc
abstract mixin class _$DeliveryCopyWith<$Res> implements $DeliveryCopyWith<$Res> {
  factory _$DeliveryCopyWith(_Delivery value, $Res Function(_Delivery) _then) = __$DeliveryCopyWithImpl;
  @override
  @useResult
  $Res call({
    String id,
    String donorId,
    String recipientId,
    DeliveryState state,
    DeliveryType type,
    Duration confirmationTime,
    bool hasMeals,
    bool isPickupConfirmed,
    Map<String, int> foodBoxes,
  });
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
    Object? hasMeals = null,
    Object? isPickupConfirmed = null,
    Object? foodBoxes = null,
  }) {
    return _then(
      _Delivery(
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
                  as Duration,
        hasMeals: null == hasMeals
            ? _self.hasMeals
            : hasMeals // ignore: cast_nullable_to_non_nullable
                  as bool,
        isPickupConfirmed: null == isPickupConfirmed
            ? _self.isPickupConfirmed
            : isPickupConfirmed // ignore: cast_nullable_to_non_nullable
                  as bool,
        foodBoxes: null == foodBoxes
            ? _self._foodBoxes
            : foodBoxes // ignore: cast_nullable_to_non_nullable
                  as Map<String, int>,
      ),
    );
  }
}
