// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'meal_suggestion.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MealSuggestion {
  String get id;
  String get name;
  List<String> get allergens;

  /// Create a copy of MealSuggestion
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MealSuggestionCopyWith<MealSuggestion> get copyWith => _$MealSuggestionCopyWithImpl<MealSuggestion>(
    this as MealSuggestion,
    _$identity,
  );

  @override
  bool operator ==(Object other) {
    final _this = this as MealSuggestion;
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MealSuggestion &&
            (identical(other.id, _this.id) || other.id == _this.id) &&
            (identical(other.name, _this.name) || other.name == _this.name) &&
            const DeepCollectionEquality().equals(
              other.allergens,
              _this.allergens,
            ));
  }

  @override
  int get hashCode {
    final _this = this as MealSuggestion;
    return Object.hash(
      runtimeType,
      _this.id,
      _this.name,
      const DeepCollectionEquality().hash(_this.allergens),
    );
  }

  @override
  String toString() {
    final _this = this as MealSuggestion;
    return 'MealSuggestion(id: ${_this.id}, name: ${_this.name}, allergens: ${_this.allergens})';
  }
}

/// @nodoc
abstract mixin class $MealSuggestionCopyWith<$Res> {
  factory $MealSuggestionCopyWith(
    MealSuggestion value,
    $Res Function(MealSuggestion) _then,
  ) = _$MealSuggestionCopyWithImpl;
  @useResult
  $Res call({String id, String name, List<String> allergens});
}

/// @nodoc
class _$MealSuggestionCopyWithImpl<$Res> implements $MealSuggestionCopyWith<$Res> {
  _$MealSuggestionCopyWithImpl(this._self, this._then);

  final MealSuggestion _self;
  final $Res Function(MealSuggestion) _then;

  /// Create a copy of MealSuggestion
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? allergens = null,
  }) {
    return _then(
      MealSuggestion(
        id: null == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _self.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        allergens: null == allergens
            ? _self.allergens
            : allergens // ignore: cast_nullable_to_non_nullable
                  as List<String>,
      ),
    );
  }
}

/// Adds pattern-matching-related methods to [MealSuggestion].
extension MealSuggestionPatterns on MealSuggestion {
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
    TResult Function(_MealSuggestion value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MealSuggestion() when $default != null:
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
    TResult Function(_MealSuggestion value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MealSuggestion():
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
    TResult? Function(_MealSuggestion value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MealSuggestion() when $default != null:
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
    TResult Function(String id, String name, List<String> allergens)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MealSuggestion() when $default != null:
        return $default(_that.id, _that.name, _that.allergens);
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
    TResult Function(String id, String name, List<String> allergens) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MealSuggestion():
        return $default(_that.id, _that.name, _that.allergens);
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
    TResult? Function(String id, String name, List<String> allergens)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MealSuggestion() when $default != null:
        return $default(_that.id, _that.name, _that.allergens);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _MealSuggestion implements MealSuggestion {
  const _MealSuggestion({
    required this.id,
    required this.name,
    required List<String> allergens,
  }) : _allergens = allergens;

  @override
  final String id;
  @override
  final String name;
  final List<String> _allergens;
  @override
  List<String> get allergens {
    if (_allergens is EqualUnmodifiableListView) return _allergens;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_allergens);
  }

  /// Create a copy of MealSuggestion
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MealSuggestionCopyWith<_MealSuggestion> get copyWith =>
      __$MealSuggestionCopyWithImpl<_MealSuggestion>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MealSuggestion &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            const DeepCollectionEquality().equals(other.allergens, _allergens));
  }

  @override
  int get hashCode {
    return Object.hash(
      runtimeType,
      id,
      name,
      const DeepCollectionEquality().hash(_allergens),
    );
  }

  @override
  String toString() {
    return 'MealSuggestion(id: $id, name: $name, allergens: $allergens)';
  }
}

/// @nodoc
abstract mixin class _$MealSuggestionCopyWith<$Res> implements $MealSuggestionCopyWith<$Res> {
  factory _$MealSuggestionCopyWith(
    _MealSuggestion value,
    $Res Function(_MealSuggestion) _then,
  ) = __$MealSuggestionCopyWithImpl;
  @override
  @useResult
  $Res call({String id, String name, List<String> allergens});
}

/// @nodoc
class __$MealSuggestionCopyWithImpl<$Res> implements _$MealSuggestionCopyWith<$Res> {
  __$MealSuggestionCopyWithImpl(this._self, this._then);

  final _MealSuggestion _self;
  final $Res Function(_MealSuggestion) _then;

  /// Create a copy of MealSuggestion
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? allergens = null,
  }) {
    return _then(
      _MealSuggestion(
        id: null == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _self.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        allergens: null == allergens
            ? _self._allergens
            : allergens // ignore: cast_nullable_to_non_nullable
                  as List<String>,
      ),
    );
  }
}
