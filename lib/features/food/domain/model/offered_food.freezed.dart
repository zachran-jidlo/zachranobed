// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'offered_food.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OfferedFood {
  String get id;
  DateTime get date;
  String get dishName;
  String get foodCategory;
  FoodCategoryType? get foodCategoryType;
  int? get foodTemperature;
  List<String> get allergens;
  int? get numberOfServings;
  int? get numberOfPackages;
  FoodDateTime? get preparedAt;
  FoodDateTime get consumeBy;
  String get donorId;
  String get recipientId;

  /// Create a copy of OfferedFood
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $OfferedFoodCopyWith<OfferedFood> get copyWith =>
      _$OfferedFoodCopyWithImpl<OfferedFood>(this as OfferedFood, _$identity);

  @override
  bool operator ==(Object other) {
    final _this = this as OfferedFood;
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is OfferedFood &&
            (identical(other.id, _this.id) || other.id == _this.id) &&
            (identical(other.date, _this.date) || other.date == _this.date) &&
            (identical(other.dishName, _this.dishName) || other.dishName == _this.dishName) &&
            (identical(other.foodCategory, _this.foodCategory) || other.foodCategory == _this.foodCategory) &&
            (identical(other.foodCategoryType, _this.foodCategoryType) ||
                other.foodCategoryType == _this.foodCategoryType) &&
            (identical(other.foodTemperature, _this.foodTemperature) ||
                other.foodTemperature == _this.foodTemperature) &&
            const DeepCollectionEquality().equals(
              other.allergens,
              _this.allergens,
            ) &&
            (identical(other.numberOfServings, _this.numberOfServings) ||
                other.numberOfServings == _this.numberOfServings) &&
            (identical(other.numberOfPackages, _this.numberOfPackages) ||
                other.numberOfPackages == _this.numberOfPackages) &&
            (identical(other.preparedAt, _this.preparedAt) || other.preparedAt == _this.preparedAt) &&
            (identical(other.consumeBy, _this.consumeBy) || other.consumeBy == _this.consumeBy) &&
            (identical(other.donorId, _this.donorId) || other.donorId == _this.donorId) &&
            (identical(other.recipientId, _this.recipientId) || other.recipientId == _this.recipientId));
  }

  @override
  int get hashCode {
    final _this = this as OfferedFood;
    return Object.hash(
      runtimeType,
      _this.id,
      _this.date,
      _this.dishName,
      _this.foodCategory,
      _this.foodCategoryType,
      _this.foodTemperature,
      const DeepCollectionEquality().hash(_this.allergens),
      _this.numberOfServings,
      _this.numberOfPackages,
      _this.preparedAt,
      _this.consumeBy,
      _this.donorId,
      _this.recipientId,
    );
  }

  @override
  String toString() {
    final _this = this as OfferedFood;
    return 'OfferedFood(id: ${_this.id}, date: ${_this.date}, dishName: ${_this.dishName}, foodCategory: ${_this.foodCategory}, foodCategoryType: ${_this.foodCategoryType}, foodTemperature: ${_this.foodTemperature}, allergens: ${_this.allergens}, numberOfServings: ${_this.numberOfServings}, numberOfPackages: ${_this.numberOfPackages}, preparedAt: ${_this.preparedAt}, consumeBy: ${_this.consumeBy}, donorId: ${_this.donorId}, recipientId: ${_this.recipientId})';
  }
}

/// @nodoc
abstract mixin class $OfferedFoodCopyWith<$Res> {
  factory $OfferedFoodCopyWith(
    OfferedFood value,
    $Res Function(OfferedFood) _then,
  ) = _$OfferedFoodCopyWithImpl;
  @useResult
  $Res call({
    String id,
    DateTime date,
    String dishName,
    String foodCategory,
    FoodCategoryType? foodCategoryType,
    int? foodTemperature,
    List<String> allergens,
    int? numberOfServings,
    int? numberOfPackages,
    FoodDateTime? preparedAt,
    FoodDateTime consumeBy,
    String donorId,
    String recipientId,
  });
}

/// @nodoc
class _$OfferedFoodCopyWithImpl<$Res> implements $OfferedFoodCopyWith<$Res> {
  _$OfferedFoodCopyWithImpl(this._self, this._then);

  final OfferedFood _self;
  final $Res Function(OfferedFood) _then;

  /// Create a copy of OfferedFood
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? date = null,
    Object? dishName = null,
    Object? foodCategory = null,
    Object? foodCategoryType = freezed,
    Object? foodTemperature = freezed,
    Object? allergens = null,
    Object? numberOfServings = freezed,
    Object? numberOfPackages = freezed,
    Object? preparedAt = freezed,
    Object? consumeBy = null,
    Object? donorId = null,
    Object? recipientId = null,
  }) {
    return _then(
      OfferedFood(
        id: null == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        date: null == date
            ? _self.date
            : date // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        dishName: null == dishName
            ? _self.dishName
            : dishName // ignore: cast_nullable_to_non_nullable
                  as String,
        foodCategory: null == foodCategory
            ? _self.foodCategory
            : foodCategory // ignore: cast_nullable_to_non_nullable
                  as String,
        foodCategoryType: freezed == foodCategoryType
            ? _self.foodCategoryType
            : foodCategoryType // ignore: cast_nullable_to_non_nullable
                  as FoodCategoryType?,
        foodTemperature: freezed == foodTemperature
            ? _self.foodTemperature
            : foodTemperature // ignore: cast_nullable_to_non_nullable
                  as int?,
        allergens: null == allergens
            ? _self.allergens
            : allergens // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        numberOfServings: freezed == numberOfServings
            ? _self.numberOfServings
            : numberOfServings // ignore: cast_nullable_to_non_nullable
                  as int?,
        numberOfPackages: freezed == numberOfPackages
            ? _self.numberOfPackages
            : numberOfPackages // ignore: cast_nullable_to_non_nullable
                  as int?,
        preparedAt: freezed == preparedAt
            ? _self.preparedAt
            : preparedAt // ignore: cast_nullable_to_non_nullable
                  as FoodDateTime?,
        consumeBy: null == consumeBy
            ? _self.consumeBy
            : consumeBy // ignore: cast_nullable_to_non_nullable
                  as FoodDateTime,
        donorId: null == donorId
            ? _self.donorId
            : donorId // ignore: cast_nullable_to_non_nullable
                  as String,
        recipientId: null == recipientId
            ? _self.recipientId
            : recipientId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// Adds pattern-matching-related methods to [OfferedFood].
extension OfferedFoodPatterns on OfferedFood {
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
    TResult Function(_OfferedFood value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _OfferedFood() when $default != null:
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
    TResult Function(_OfferedFood value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OfferedFood():
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
    TResult? Function(_OfferedFood value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OfferedFood() when $default != null:
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
      DateTime date,
      String dishName,
      String foodCategory,
      FoodCategoryType? foodCategoryType,
      int? foodTemperature,
      List<String> allergens,
      int? numberOfServings,
      int? numberOfPackages,
      FoodDateTime? preparedAt,
      FoodDateTime consumeBy,
      String donorId,
      String recipientId,
    )?
    $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _OfferedFood() when $default != null:
        return $default(
          _that.id,
          _that.date,
          _that.dishName,
          _that.foodCategory,
          _that.foodCategoryType,
          _that.foodTemperature,
          _that.allergens,
          _that.numberOfServings,
          _that.numberOfPackages,
          _that.preparedAt,
          _that.consumeBy,
          _that.donorId,
          _that.recipientId,
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
      DateTime date,
      String dishName,
      String foodCategory,
      FoodCategoryType? foodCategoryType,
      int? foodTemperature,
      List<String> allergens,
      int? numberOfServings,
      int? numberOfPackages,
      FoodDateTime? preparedAt,
      FoodDateTime consumeBy,
      String donorId,
      String recipientId,
    )
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OfferedFood():
        return $default(
          _that.id,
          _that.date,
          _that.dishName,
          _that.foodCategory,
          _that.foodCategoryType,
          _that.foodTemperature,
          _that.allergens,
          _that.numberOfServings,
          _that.numberOfPackages,
          _that.preparedAt,
          _that.consumeBy,
          _that.donorId,
          _that.recipientId,
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
      DateTime date,
      String dishName,
      String foodCategory,
      FoodCategoryType? foodCategoryType,
      int? foodTemperature,
      List<String> allergens,
      int? numberOfServings,
      int? numberOfPackages,
      FoodDateTime? preparedAt,
      FoodDateTime consumeBy,
      String donorId,
      String recipientId,
    )?
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OfferedFood() when $default != null:
        return $default(
          _that.id,
          _that.date,
          _that.dishName,
          _that.foodCategory,
          _that.foodCategoryType,
          _that.foodTemperature,
          _that.allergens,
          _that.numberOfServings,
          _that.numberOfPackages,
          _that.preparedAt,
          _that.consumeBy,
          _that.donorId,
          _that.recipientId,
        );
      case _:
        return null;
    }
  }
}

/// @nodoc

class _OfferedFood implements OfferedFood {
  const _OfferedFood({
    required this.id,
    required this.date,
    required this.dishName,
    required this.foodCategory,
    required this.foodCategoryType,
    required this.foodTemperature,
    required List<String> allergens,
    required this.numberOfServings,
    required this.numberOfPackages,
    required this.preparedAt,
    required this.consumeBy,
    required this.donorId,
    required this.recipientId,
  }) : _allergens = allergens;

  @override
  final String id;
  @override
  final DateTime date;
  @override
  final String dishName;
  @override
  final String foodCategory;
  @override
  final FoodCategoryType? foodCategoryType;
  @override
  final int? foodTemperature;
  final List<String> _allergens;
  @override
  List<String> get allergens {
    if (_allergens is EqualUnmodifiableListView) return _allergens;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_allergens);
  }

  @override
  final int? numberOfServings;
  @override
  final int? numberOfPackages;
  @override
  final FoodDateTime? preparedAt;
  @override
  final FoodDateTime consumeBy;
  @override
  final String donorId;
  @override
  final String recipientId;

  /// Create a copy of OfferedFood
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$OfferedFoodCopyWith<_OfferedFood> get copyWith => __$OfferedFoodCopyWithImpl<_OfferedFood>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _OfferedFood &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.dishName, dishName) || other.dishName == dishName) &&
            (identical(other.foodCategory, foodCategory) || other.foodCategory == foodCategory) &&
            (identical(other.foodCategoryType, foodCategoryType) || other.foodCategoryType == foodCategoryType) &&
            (identical(other.foodTemperature, foodTemperature) || other.foodTemperature == foodTemperature) &&
            const DeepCollectionEquality().equals(
              other.allergens,
              _allergens,
            ) &&
            (identical(other.numberOfServings, numberOfServings) || other.numberOfServings == numberOfServings) &&
            (identical(other.numberOfPackages, numberOfPackages) || other.numberOfPackages == numberOfPackages) &&
            (identical(other.preparedAt, preparedAt) || other.preparedAt == preparedAt) &&
            (identical(other.consumeBy, consumeBy) || other.consumeBy == consumeBy) &&
            (identical(other.donorId, donorId) || other.donorId == donorId) &&
            (identical(other.recipientId, recipientId) || other.recipientId == recipientId));
  }

  @override
  int get hashCode {
    return Object.hash(
      runtimeType,
      id,
      date,
      dishName,
      foodCategory,
      foodCategoryType,
      foodTemperature,
      const DeepCollectionEquality().hash(_allergens),
      numberOfServings,
      numberOfPackages,
      preparedAt,
      consumeBy,
      donorId,
      recipientId,
    );
  }

  @override
  String toString() {
    return 'OfferedFood(id: $id, date: $date, dishName: $dishName, foodCategory: $foodCategory, foodCategoryType: $foodCategoryType, foodTemperature: $foodTemperature, allergens: $allergens, numberOfServings: $numberOfServings, numberOfPackages: $numberOfPackages, preparedAt: $preparedAt, consumeBy: $consumeBy, donorId: $donorId, recipientId: $recipientId)';
  }
}

/// @nodoc
abstract mixin class _$OfferedFoodCopyWith<$Res> implements $OfferedFoodCopyWith<$Res> {
  factory _$OfferedFoodCopyWith(
    _OfferedFood value,
    $Res Function(_OfferedFood) _then,
  ) = __$OfferedFoodCopyWithImpl;
  @override
  @useResult
  $Res call({
    String id,
    DateTime date,
    String dishName,
    String foodCategory,
    FoodCategoryType? foodCategoryType,
    int? foodTemperature,
    List<String> allergens,
    int? numberOfServings,
    int? numberOfPackages,
    FoodDateTime? preparedAt,
    FoodDateTime consumeBy,
    String donorId,
    String recipientId,
  });
}

/// @nodoc
class __$OfferedFoodCopyWithImpl<$Res> implements _$OfferedFoodCopyWith<$Res> {
  __$OfferedFoodCopyWithImpl(this._self, this._then);

  final _OfferedFood _self;
  final $Res Function(_OfferedFood) _then;

  /// Create a copy of OfferedFood
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? date = null,
    Object? dishName = null,
    Object? foodCategory = null,
    Object? foodCategoryType = freezed,
    Object? foodTemperature = freezed,
    Object? allergens = null,
    Object? numberOfServings = freezed,
    Object? numberOfPackages = freezed,
    Object? preparedAt = freezed,
    Object? consumeBy = null,
    Object? donorId = null,
    Object? recipientId = null,
  }) {
    return _then(
      _OfferedFood(
        id: null == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        date: null == date
            ? _self.date
            : date // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        dishName: null == dishName
            ? _self.dishName
            : dishName // ignore: cast_nullable_to_non_nullable
                  as String,
        foodCategory: null == foodCategory
            ? _self.foodCategory
            : foodCategory // ignore: cast_nullable_to_non_nullable
                  as String,
        foodCategoryType: freezed == foodCategoryType
            ? _self.foodCategoryType
            : foodCategoryType // ignore: cast_nullable_to_non_nullable
                  as FoodCategoryType?,
        foodTemperature: freezed == foodTemperature
            ? _self.foodTemperature
            : foodTemperature // ignore: cast_nullable_to_non_nullable
                  as int?,
        allergens: null == allergens
            ? _self._allergens
            : allergens // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        numberOfServings: freezed == numberOfServings
            ? _self.numberOfServings
            : numberOfServings // ignore: cast_nullable_to_non_nullable
                  as int?,
        numberOfPackages: freezed == numberOfPackages
            ? _self.numberOfPackages
            : numberOfPackages // ignore: cast_nullable_to_non_nullable
                  as int?,
        preparedAt: freezed == preparedAt
            ? _self.preparedAt
            : preparedAt // ignore: cast_nullable_to_non_nullable
                  as FoodDateTime?,
        consumeBy: null == consumeBy
            ? _self.consumeBy
            : consumeBy // ignore: cast_nullable_to_non_nullable
                  as FoodDateTime,
        donorId: null == donorId
            ? _self.donorId
            : donorId // ignore: cast_nullable_to_non_nullable
                  as String,
        recipientId: null == recipientId
            ? _self.recipientId
            : recipientId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}
