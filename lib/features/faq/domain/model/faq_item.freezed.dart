// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'faq_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FaqItem {
  /// Firestore document ID.
  String get id;

  /// The question text displayed in the list.
  String get question;

  /// Full answer text.
  String get answer;

  /// Sort order within a category (or globally when no categories exist).
  int get order;

  /// Optional category this item belongs to.
  FaqCategory? get category;

  /// Create a copy of FaqItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $FaqItemCopyWith<FaqItem> get copyWith =>
      _$FaqItemCopyWithImpl<FaqItem>(this as FaqItem, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is FaqItem &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.question, question) ||
                other.question == question) &&
            (identical(other.answer, answer) || other.answer == answer) &&
            (identical(other.order, order) || other.order == order) &&
            (identical(other.category, category) ||
                other.category == category));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, id, question, answer, order, category);

  @override
  String toString() {
    return 'FaqItem(id: $id, question: $question, answer: $answer, order: $order, category: $category)';
  }
}

/// @nodoc
abstract mixin class $FaqItemCopyWith<$Res> {
  factory $FaqItemCopyWith(FaqItem value, $Res Function(FaqItem) _then) =
      _$FaqItemCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String question,
      String answer,
      int order,
      FaqCategory? category});

  $FaqCategoryCopyWith<$Res>? get category;
}

/// @nodoc
class _$FaqItemCopyWithImpl<$Res> implements $FaqItemCopyWith<$Res> {
  _$FaqItemCopyWithImpl(this._self, this._then);

  final FaqItem _self;
  final $Res Function(FaqItem) _then;

  /// Create a copy of FaqItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? question = null,
    Object? answer = null,
    Object? order = null,
    Object? category = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      question: null == question
          ? _self.question
          : question // ignore: cast_nullable_to_non_nullable
              as String,
      answer: null == answer
          ? _self.answer
          : answer // ignore: cast_nullable_to_non_nullable
              as String,
      order: null == order
          ? _self.order
          : order // ignore: cast_nullable_to_non_nullable
              as int,
      category: freezed == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as FaqCategory?,
    ));
  }

  /// Create a copy of FaqItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $FaqCategoryCopyWith<$Res>? get category {
    if (_self.category == null) {
      return null;
    }

    return $FaqCategoryCopyWith<$Res>(_self.category!, (value) {
      return _then(_self.copyWith(category: value));
    });
  }
}

/// @nodoc

class _FaqItem implements FaqItem {
  const _FaqItem(
      {required this.id,
      required this.question,
      required this.answer,
      required this.order,
      this.category});

  /// Firestore document ID.
  @override
  final String id;

  /// The question text displayed in the list.
  @override
  final String question;

  /// Full answer text.
  @override
  final String answer;

  /// Sort order within a category (or globally when no categories exist).
  @override
  final int order;

  /// Optional category this item belongs to.
  @override
  final FaqCategory? category;

  /// Create a copy of FaqItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$FaqItemCopyWith<_FaqItem> get copyWith =>
      __$FaqItemCopyWithImpl<_FaqItem>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _FaqItem &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.question, question) ||
                other.question == question) &&
            (identical(other.answer, answer) || other.answer == answer) &&
            (identical(other.order, order) || other.order == order) &&
            (identical(other.category, category) ||
                other.category == category));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, id, question, answer, order, category);

  @override
  String toString() {
    return 'FaqItem(id: $id, question: $question, answer: $answer, order: $order, category: $category)';
  }
}

/// @nodoc
abstract mixin class _$FaqItemCopyWith<$Res> implements $FaqItemCopyWith<$Res> {
  factory _$FaqItemCopyWith(_FaqItem value, $Res Function(_FaqItem) _then) =
      __$FaqItemCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String question,
      String answer,
      int order,
      FaqCategory? category});

  @override
  $FaqCategoryCopyWith<$Res>? get category;
}

/// @nodoc
class __$FaqItemCopyWithImpl<$Res> implements _$FaqItemCopyWith<$Res> {
  __$FaqItemCopyWithImpl(this._self, this._then);

  final _FaqItem _self;
  final $Res Function(_FaqItem) _then;

  /// Create a copy of FaqItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? question = null,
    Object? answer = null,
    Object? order = null,
    Object? category = freezed,
  }) {
    return _then(_FaqItem(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      question: null == question
          ? _self.question
          : question // ignore: cast_nullable_to_non_nullable
              as String,
      answer: null == answer
          ? _self.answer
          : answer // ignore: cast_nullable_to_non_nullable
              as String,
      order: null == order
          ? _self.order
          : order // ignore: cast_nullable_to_non_nullable
              as int,
      category: freezed == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as FaqCategory?,
    ));
  }

  /// Create a copy of FaqItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $FaqCategoryCopyWith<$Res>? get category {
    if (_self.category == null) {
      return null;
    }

    return $FaqCategoryCopyWith<$Res>(_self.category!, (value) {
      return _then(_self.copyWith(category: value));
    });
  }
}

// dart format on
