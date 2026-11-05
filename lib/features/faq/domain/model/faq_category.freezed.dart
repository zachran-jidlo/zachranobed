// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'faq_category.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FaqCategory {
  /// Unique identifier used to group FAQ items.
  String get id;

  /// Display title shown in the category list.
  String get title;

  /// Short description shown below the title in the category card.
  String get description;

  /// Sort order of the category in the list.
  int get order;

  /// Create a copy of FaqCategory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $FaqCategoryCopyWith<FaqCategory> get copyWith =>
      _$FaqCategoryCopyWithImpl<FaqCategory>(this as FaqCategory, _$identity);

  @override
  bool operator ==(Object other) {
    final _this = this as FaqCategory;
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is FaqCategory &&
            (identical(other.id, _this.id) || other.id == _this.id) &&
            (identical(other.title, _this.title) || other.title == _this.title) &&
            (identical(other.description, _this.description) || other.description == _this.description) &&
            (identical(other.order, _this.order) || other.order == _this.order));
  }

  @override
  int get hashCode {
    final _this = this as FaqCategory;
    return Object.hash(
      runtimeType,
      _this.id,
      _this.title,
      _this.description,
      _this.order,
    );
  }

  @override
  String toString() {
    final _this = this as FaqCategory;
    return 'FaqCategory(id: ${_this.id}, title: ${_this.title}, description: ${_this.description}, order: ${_this.order})';
  }
}

/// @nodoc
abstract mixin class $FaqCategoryCopyWith<$Res> {
  factory $FaqCategoryCopyWith(
    FaqCategory value,
    $Res Function(FaqCategory) _then,
  ) = _$FaqCategoryCopyWithImpl;
  @useResult
  $Res call({String id, String title, String description, int order});
}

/// @nodoc
class _$FaqCategoryCopyWithImpl<$Res> implements $FaqCategoryCopyWith<$Res> {
  _$FaqCategoryCopyWithImpl(this._self, this._then);

  final FaqCategory _self;
  final $Res Function(FaqCategory) _then;

  /// Create a copy of FaqCategory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? order = null,
  }) {
    return _then(
      FaqCategory(
        id: null == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _self.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        description: null == description
            ? _self.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        order: null == order
            ? _self.order
            : order // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// Adds pattern-matching-related methods to [FaqCategory].
extension FaqCategoryPatterns on FaqCategory {
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
    TResult Function(_FaqCategory value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _FaqCategory() when $default != null:
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
    TResult Function(_FaqCategory value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FaqCategory():
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
    TResult? Function(_FaqCategory value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FaqCategory() when $default != null:
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
    TResult Function(String id, String title, String description, int order)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _FaqCategory() when $default != null:
        return $default(_that.id, _that.title, _that.description, _that.order);
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
    TResult Function(String id, String title, String description, int order) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FaqCategory():
        return $default(_that.id, _that.title, _that.description, _that.order);
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
    TResult? Function(String id, String title, String description, int order)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FaqCategory() when $default != null:
        return $default(_that.id, _that.title, _that.description, _that.order);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _FaqCategory implements FaqCategory {
  const _FaqCategory({
    required this.id,
    required this.title,
    required this.description,
    required this.order,
  });

  /// Unique identifier used to group FAQ items.
  @override
  final String id;

  /// Display title shown in the category list.
  @override
  final String title;

  /// Short description shown below the title in the category card.
  @override
  final String description;

  /// Sort order of the category in the list.
  @override
  final int order;

  /// Create a copy of FaqCategory
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$FaqCategoryCopyWith<_FaqCategory> get copyWith => __$FaqCategoryCopyWithImpl<_FaqCategory>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _FaqCategory &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) || other.description == description) &&
            (identical(other.order, order) || other.order == order));
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, id, title, description, order);
  }

  @override
  String toString() {
    return 'FaqCategory(id: $id, title: $title, description: $description, order: $order)';
  }
}

/// @nodoc
abstract mixin class _$FaqCategoryCopyWith<$Res> implements $FaqCategoryCopyWith<$Res> {
  factory _$FaqCategoryCopyWith(
    _FaqCategory value,
    $Res Function(_FaqCategory) _then,
  ) = __$FaqCategoryCopyWithImpl;
  @override
  @useResult
  $Res call({String id, String title, String description, int order});
}

/// @nodoc
class __$FaqCategoryCopyWithImpl<$Res> implements _$FaqCategoryCopyWith<$Res> {
  __$FaqCategoryCopyWithImpl(this._self, this._then);

  final _FaqCategory _self;
  final $Res Function(_FaqCategory) _then;

  /// Create a copy of FaqCategory
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? order = null,
  }) {
    return _then(
      _FaqCategory(
        id: null == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _self.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        description: null == description
            ? _self.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        order: null == order
            ? _self.order
            : order // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}
