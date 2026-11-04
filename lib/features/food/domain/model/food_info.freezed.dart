// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'food_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FoodInfo {
  String get id;
  String? get dishName;
  List<String>? get allergens;
  FoodCategory? get foodCategory;
  int? get foodTemperature;
  int? get numberOfPackages;
  int? get numberOfServings;
  FoodDateTime? get preparedAt;
  FoodDateTime? get consumeBy;

  /// Create a copy of FoodInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $FoodInfoCopyWith<FoodInfo> get copyWith => _$FoodInfoCopyWithImpl<FoodInfo>(this as FoodInfo, _$identity);

  @override
  bool operator ==(Object other) {
    final _this = this as FoodInfo;
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is FoodInfo &&
            (identical(other.id, _this.id) || other.id == _this.id) &&
            (identical(other.dishName, _this.dishName) || other.dishName == _this.dishName) &&
            const DeepCollectionEquality().equals(
              other.allergens,
              _this.allergens,
            ) &&
            (identical(other.foodCategory, _this.foodCategory) || other.foodCategory == _this.foodCategory) &&
            (identical(other.foodTemperature, _this.foodTemperature) ||
                other.foodTemperature == _this.foodTemperature) &&
            (identical(other.numberOfPackages, _this.numberOfPackages) ||
                other.numberOfPackages == _this.numberOfPackages) &&
            (identical(other.numberOfServings, _this.numberOfServings) ||
                other.numberOfServings == _this.numberOfServings) &&
            (identical(other.preparedAt, _this.preparedAt) || other.preparedAt == _this.preparedAt) &&
            (identical(other.consumeBy, _this.consumeBy) || other.consumeBy == _this.consumeBy));
  }

  @override
  int get hashCode {
    final _this = this as FoodInfo;
    return Object.hash(
      runtimeType,
      _this.id,
      _this.dishName,
      const DeepCollectionEquality().hash(_this.allergens),
      _this.foodCategory,
      _this.foodTemperature,
      _this.numberOfPackages,
      _this.numberOfServings,
      _this.preparedAt,
      _this.consumeBy,
    );
  }

  @override
  String toString() {
    final _this = this as FoodInfo;
    return 'FoodInfo(id: ${_this.id}, dishName: ${_this.dishName}, allergens: ${_this.allergens}, foodCategory: ${_this.foodCategory}, foodTemperature: ${_this.foodTemperature}, numberOfPackages: ${_this.numberOfPackages}, numberOfServings: ${_this.numberOfServings}, preparedAt: ${_this.preparedAt}, consumeBy: ${_this.consumeBy})';
  }
}

/// @nodoc
abstract mixin class $FoodInfoCopyWith<$Res> {
  factory $FoodInfoCopyWith(FoodInfo value, $Res Function(FoodInfo) _then) = _$FoodInfoCopyWithImpl;
  @useResult
  $Res call({
    String id,
    String? dishName,
    List<String>? allergens,
    FoodCategory? foodCategory,
    int? foodTemperature,
    int? numberOfPackages,
    int? numberOfServings,
    FoodDateTime? preparedAt,
    FoodDateTime? consumeBy,
  });
}

/// @nodoc
class _$FoodInfoCopyWithImpl<$Res> implements $FoodInfoCopyWith<$Res> {
  _$FoodInfoCopyWithImpl(this._self, this._then);

  final FoodInfo _self;
  final $Res Function(FoodInfo) _then;

  /// Create a copy of FoodInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? dishName = freezed,
    Object? allergens = freezed,
    Object? foodCategory = freezed,
    Object? foodTemperature = freezed,
    Object? numberOfPackages = freezed,
    Object? numberOfServings = freezed,
    Object? preparedAt = freezed,
    Object? consumeBy = freezed,
  }) {
    return _then(
      FoodInfo(
        id: null == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        dishName: freezed == dishName
            ? _self.dishName
            : dishName // ignore: cast_nullable_to_non_nullable
                  as String?,
        allergens: freezed == allergens
            ? _self.allergens
            : allergens // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        foodCategory: freezed == foodCategory
            ? _self.foodCategory
            : foodCategory // ignore: cast_nullable_to_non_nullable
                  as FoodCategory?,
        foodTemperature: freezed == foodTemperature
            ? _self.foodTemperature
            : foodTemperature // ignore: cast_nullable_to_non_nullable
                  as int?,
        numberOfPackages: freezed == numberOfPackages
            ? _self.numberOfPackages
            : numberOfPackages // ignore: cast_nullable_to_non_nullable
                  as int?,
        numberOfServings: freezed == numberOfServings
            ? _self.numberOfServings
            : numberOfServings // ignore: cast_nullable_to_non_nullable
                  as int?,
        preparedAt: freezed == preparedAt
            ? _self.preparedAt
            : preparedAt // ignore: cast_nullable_to_non_nullable
                  as FoodDateTime?,
        consumeBy: freezed == consumeBy
            ? _self.consumeBy
            : consumeBy // ignore: cast_nullable_to_non_nullable
                  as FoodDateTime?,
      ),
    );
  }
}

/// Adds pattern-matching-related methods to [FoodInfo].
extension FoodInfoPatterns on FoodInfo {
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
    TResult Function(_FoodInfo value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _FoodInfo() when $default != null:
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
    TResult Function(_FoodInfo value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FoodInfo():
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
    TResult? Function(_FoodInfo value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FoodInfo() when $default != null:
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
      String? dishName,
      List<String>? allergens,
      FoodCategory? foodCategory,
      int? foodTemperature,
      int? numberOfPackages,
      int? numberOfServings,
      FoodDateTime? preparedAt,
      FoodDateTime? consumeBy,
    )?
    $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _FoodInfo() when $default != null:
        return $default(
          _that.id,
          _that.dishName,
          _that.allergens,
          _that.foodCategory,
          _that.foodTemperature,
          _that.numberOfPackages,
          _that.numberOfServings,
          _that.preparedAt,
          _that.consumeBy,
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
      String? dishName,
      List<String>? allergens,
      FoodCategory? foodCategory,
      int? foodTemperature,
      int? numberOfPackages,
      int? numberOfServings,
      FoodDateTime? preparedAt,
      FoodDateTime? consumeBy,
    )
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FoodInfo():
        return $default(
          _that.id,
          _that.dishName,
          _that.allergens,
          _that.foodCategory,
          _that.foodTemperature,
          _that.numberOfPackages,
          _that.numberOfServings,
          _that.preparedAt,
          _that.consumeBy,
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
      String? dishName,
      List<String>? allergens,
      FoodCategory? foodCategory,
      int? foodTemperature,
      int? numberOfPackages,
      int? numberOfServings,
      FoodDateTime? preparedAt,
      FoodDateTime? consumeBy,
    )?
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FoodInfo() when $default != null:
        return $default(
          _that.id,
          _that.dishName,
          _that.allergens,
          _that.foodCategory,
          _that.foodTemperature,
          _that.numberOfPackages,
          _that.numberOfServings,
          _that.preparedAt,
          _that.consumeBy,
        );
      case _:
        return null;
    }
  }
}

/// @nodoc

class _FoodInfo implements FoodInfo {
  const _FoodInfo({
    required this.id,
    this.dishName,
    List<String>? allergens,
    this.foodCategory,
    this.foodTemperature,
    this.numberOfPackages,
    this.numberOfServings,
    this.preparedAt,
    this.consumeBy,
  }) : _allergens = allergens;

  @override
  final String id;
  @override
  final String? dishName;
  final List<String>? _allergens;
  @override
  List<String>? get allergens {
    final value = _allergens;
    if (value == null) return null;
    if (_allergens is EqualUnmodifiableListView) return _allergens;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final FoodCategory? foodCategory;
  @override
  final int? foodTemperature;
  @override
  final int? numberOfPackages;
  @override
  final int? numberOfServings;
  @override
  final FoodDateTime? preparedAt;
  @override
  final FoodDateTime? consumeBy;

  /// Create a copy of FoodInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$FoodInfoCopyWith<_FoodInfo> get copyWith => __$FoodInfoCopyWithImpl<_FoodInfo>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _FoodInfo &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.dishName, dishName) || other.dishName == dishName) &&
            const DeepCollectionEquality().equals(
              other.allergens,
              _allergens,
            ) &&
            (identical(other.foodCategory, foodCategory) || other.foodCategory == foodCategory) &&
            (identical(other.foodTemperature, foodTemperature) || other.foodTemperature == foodTemperature) &&
            (identical(other.numberOfPackages, numberOfPackages) || other.numberOfPackages == numberOfPackages) &&
            (identical(other.numberOfServings, numberOfServings) || other.numberOfServings == numberOfServings) &&
            (identical(other.preparedAt, preparedAt) || other.preparedAt == preparedAt) &&
            (identical(other.consumeBy, consumeBy) || other.consumeBy == consumeBy));
  }

  @override
  int get hashCode {
    return Object.hash(
      runtimeType,
      id,
      dishName,
      const DeepCollectionEquality().hash(_allergens),
      foodCategory,
      foodTemperature,
      numberOfPackages,
      numberOfServings,
      preparedAt,
      consumeBy,
    );
  }

  @override
  String toString() {
    return 'FoodInfo(id: $id, dishName: $dishName, allergens: $allergens, foodCategory: $foodCategory, foodTemperature: $foodTemperature, numberOfPackages: $numberOfPackages, numberOfServings: $numberOfServings, preparedAt: $preparedAt, consumeBy: $consumeBy)';
  }
}

/// @nodoc
abstract mixin class _$FoodInfoCopyWith<$Res> implements $FoodInfoCopyWith<$Res> {
  factory _$FoodInfoCopyWith(_FoodInfo value, $Res Function(_FoodInfo) _then) = __$FoodInfoCopyWithImpl;
  @override
  @useResult
  $Res call({
    String id,
    String? dishName,
    List<String>? allergens,
    FoodCategory? foodCategory,
    int? foodTemperature,
    int? numberOfPackages,
    int? numberOfServings,
    FoodDateTime? preparedAt,
    FoodDateTime? consumeBy,
  });
}

/// @nodoc
class __$FoodInfoCopyWithImpl<$Res> implements _$FoodInfoCopyWith<$Res> {
  __$FoodInfoCopyWithImpl(this._self, this._then);

  final _FoodInfo _self;
  final $Res Function(_FoodInfo) _then;

  /// Create a copy of FoodInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? dishName = freezed,
    Object? allergens = freezed,
    Object? foodCategory = freezed,
    Object? foodTemperature = freezed,
    Object? numberOfPackages = freezed,
    Object? numberOfServings = freezed,
    Object? preparedAt = freezed,
    Object? consumeBy = freezed,
  }) {
    return _then(
      _FoodInfo(
        id: null == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        dishName: freezed == dishName
            ? _self.dishName
            : dishName // ignore: cast_nullable_to_non_nullable
                  as String?,
        allergens: freezed == allergens
            ? _self._allergens
            : allergens // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        foodCategory: freezed == foodCategory
            ? _self.foodCategory
            : foodCategory // ignore: cast_nullable_to_non_nullable
                  as FoodCategory?,
        foodTemperature: freezed == foodTemperature
            ? _self.foodTemperature
            : foodTemperature // ignore: cast_nullable_to_non_nullable
                  as int?,
        numberOfPackages: freezed == numberOfPackages
            ? _self.numberOfPackages
            : numberOfPackages // ignore: cast_nullable_to_non_nullable
                  as int?,
        numberOfServings: freezed == numberOfServings
            ? _self.numberOfServings
            : numberOfServings // ignore: cast_nullable_to_non_nullable
                  as int?,
        preparedAt: freezed == preparedAt
            ? _self.preparedAt
            : preparedAt // ignore: cast_nullable_to_non_nullable
                  as FoodDateTime?,
        consumeBy: freezed == consumeBy
            ? _self.consumeBy
            : consumeBy // ignore: cast_nullable_to_non_nullable
                  as FoodDateTime?,
      ),
    );
  }
}
