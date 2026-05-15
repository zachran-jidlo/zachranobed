// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'faq_category.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
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
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is FaqCategory &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.order, order) || other.order == order));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, title, description, order);

  @override
  String toString() {
    return 'FaqCategory(id: $id, title: $title, description: $description, order: $order)';
  }
}

/// @nodoc
abstract mixin class $FaqCategoryCopyWith<$Res> {
  factory $FaqCategoryCopyWith(
          FaqCategory value, $Res Function(FaqCategory) _then) =
      _$FaqCategoryCopyWithImpl;
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
    return _then(_self.copyWith(
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
    ));
  }
}

/// @nodoc

class _FaqCategory implements FaqCategory {
  const _FaqCategory(
      {required this.id,
      required this.title,
      required this.description,
      required this.order});

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
  _$FaqCategoryCopyWith<_FaqCategory> get copyWith =>
      __$FaqCategoryCopyWithImpl<_FaqCategory>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _FaqCategory &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.order, order) || other.order == order));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, title, description, order);

  @override
  String toString() {
    return 'FaqCategory(id: $id, title: $title, description: $description, order: $order)';
  }
}

/// @nodoc
abstract mixin class _$FaqCategoryCopyWith<$Res>
    implements $FaqCategoryCopyWith<$Res> {
  factory _$FaqCategoryCopyWith(
          _FaqCategory value, $Res Function(_FaqCategory) _then) =
      __$FaqCategoryCopyWithImpl;
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
    return _then(_FaqCategory(
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
    ));
  }
}

// dart format on
