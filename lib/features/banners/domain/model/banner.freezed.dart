// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'banner.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Banner {
  /// Unique identifier.
  String get id;

  /// Display order when several banners match. Lower shows first.
  int get priority;

  /// Banner headline.
  String get title;

  /// Banner body. Rendered as markdown.
  String get text;

  /// Visual tone. Drives the icon and color. Null shows no icon.
  BannerType? get type;

  /// Start of the display window. Null means show immediately.
  DateTime? get validFrom;

  /// End of the display window. Null means no end.
  DateTime? get validTo;

  /// Target role. [BannerRole.all] means every role.
  BannerRole get role;

  /// Specific entity IDs to target. Null/empty means no restriction.
  List<String>? get entityIds;

  /// Entity tags to target. Matches when the entity has at least one.
  /// Null/empty means no restriction.
  List<String>? get tags;

  /// Target platforms. Null/empty means all platforms.
  List<RunningPlatform>? get platforms;

  /// Lowest app version that shows the banner. Null means no lower bound.
  String? get minAppVersion;

  /// Highest app version that shows the banner. Null means no upper bound.
  String? get maxAppVersion;

  /// Whether the user can close the banner. Once closed it stays hidden.
  bool get closable;

  /// Label for the optional action button. Null hides the button.
  String? get actionLabel;

  /// Target of the action button. A deeplink or external URL.
  String? get actionUrl;

  /// Create a copy of Banner
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $BannerCopyWith<Banner> get copyWith =>
      _$BannerCopyWithImpl<Banner>(this as Banner, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Banner &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.validFrom, validFrom) ||
                other.validFrom == validFrom) &&
            (identical(other.validTo, validTo) || other.validTo == validTo) &&
            (identical(other.role, role) || other.role == role) &&
            const DeepCollectionEquality().equals(other.entityIds, entityIds) &&
            const DeepCollectionEquality().equals(other.tags, tags) &&
            const DeepCollectionEquality().equals(other.platforms, platforms) &&
            (identical(other.minAppVersion, minAppVersion) ||
                other.minAppVersion == minAppVersion) &&
            (identical(other.maxAppVersion, maxAppVersion) ||
                other.maxAppVersion == maxAppVersion) &&
            (identical(other.closable, closable) ||
                other.closable == closable) &&
            (identical(other.actionLabel, actionLabel) ||
                other.actionLabel == actionLabel) &&
            (identical(other.actionUrl, actionUrl) ||
                other.actionUrl == actionUrl));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      priority,
      title,
      text,
      type,
      validFrom,
      validTo,
      role,
      const DeepCollectionEquality().hash(entityIds),
      const DeepCollectionEquality().hash(tags),
      const DeepCollectionEquality().hash(platforms),
      minAppVersion,
      maxAppVersion,
      closable,
      actionLabel,
      actionUrl);

  @override
  String toString() {
    return 'Banner(id: $id, priority: $priority, title: $title, text: $text, type: $type, validFrom: $validFrom, validTo: $validTo, role: $role, entityIds: $entityIds, tags: $tags, platforms: $platforms, minAppVersion: $minAppVersion, maxAppVersion: $maxAppVersion, closable: $closable, actionLabel: $actionLabel, actionUrl: $actionUrl)';
  }
}

/// @nodoc
abstract mixin class $BannerCopyWith<$Res> {
  factory $BannerCopyWith(Banner value, $Res Function(Banner) _then) =
      _$BannerCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      int priority,
      String title,
      String text,
      BannerType? type,
      DateTime? validFrom,
      DateTime? validTo,
      BannerRole role,
      List<String>? entityIds,
      List<String>? tags,
      List<RunningPlatform>? platforms,
      String? minAppVersion,
      String? maxAppVersion,
      bool closable,
      String? actionLabel,
      String? actionUrl});
}

/// @nodoc
class _$BannerCopyWithImpl<$Res> implements $BannerCopyWith<$Res> {
  _$BannerCopyWithImpl(this._self, this._then);

  final Banner _self;
  final $Res Function(Banner) _then;

  /// Create a copy of Banner
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? priority = null,
    Object? title = null,
    Object? text = null,
    Object? type = freezed,
    Object? validFrom = freezed,
    Object? validTo = freezed,
    Object? role = null,
    Object? entityIds = freezed,
    Object? tags = freezed,
    Object? platforms = freezed,
    Object? minAppVersion = freezed,
    Object? maxAppVersion = freezed,
    Object? closable = null,
    Object? actionLabel = freezed,
    Object? actionUrl = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      priority: null == priority
          ? _self.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      text: null == text
          ? _self.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      type: freezed == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as BannerType?,
      validFrom: freezed == validFrom
          ? _self.validFrom
          : validFrom // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      validTo: freezed == validTo
          ? _self.validTo
          : validTo // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      role: null == role
          ? _self.role
          : role // ignore: cast_nullable_to_non_nullable
              as BannerRole,
      entityIds: freezed == entityIds
          ? _self.entityIds
          : entityIds // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      tags: freezed == tags
          ? _self.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      platforms: freezed == platforms
          ? _self.platforms
          : platforms // ignore: cast_nullable_to_non_nullable
              as List<RunningPlatform>?,
      minAppVersion: freezed == minAppVersion
          ? _self.minAppVersion
          : minAppVersion // ignore: cast_nullable_to_non_nullable
              as String?,
      maxAppVersion: freezed == maxAppVersion
          ? _self.maxAppVersion
          : maxAppVersion // ignore: cast_nullable_to_non_nullable
              as String?,
      closable: null == closable
          ? _self.closable
          : closable // ignore: cast_nullable_to_non_nullable
              as bool,
      actionLabel: freezed == actionLabel
          ? _self.actionLabel
          : actionLabel // ignore: cast_nullable_to_non_nullable
              as String?,
      actionUrl: freezed == actionUrl
          ? _self.actionUrl
          : actionUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _Banner implements Banner {
  const _Banner(
      {required this.id,
      required this.priority,
      required this.title,
      required this.text,
      required this.type,
      required this.validFrom,
      required this.validTo,
      required this.role,
      required final List<String>? entityIds,
      required final List<String>? tags,
      required final List<RunningPlatform>? platforms,
      required this.minAppVersion,
      required this.maxAppVersion,
      required this.closable,
      required this.actionLabel,
      required this.actionUrl})
      : _entityIds = entityIds,
        _tags = tags,
        _platforms = platforms;

  /// Unique identifier.
  @override
  final String id;

  /// Display order when several banners match. Lower shows first.
  @override
  final int priority;

  /// Banner headline.
  @override
  final String title;

  /// Banner body. Rendered as markdown.
  @override
  final String text;

  /// Visual tone. Drives the icon and color. Null shows no icon.
  @override
  final BannerType? type;

  /// Start of the display window. Null means show immediately.
  @override
  final DateTime? validFrom;

  /// End of the display window. Null means no end.
  @override
  final DateTime? validTo;

  /// Target role. [BannerRole.all] means every role.
  @override
  final BannerRole role;

  /// Specific entity IDs to target. Null/empty means no restriction.
  final List<String>? _entityIds;

  /// Specific entity IDs to target. Null/empty means no restriction.
  @override
  List<String>? get entityIds {
    final value = _entityIds;
    if (value == null) return null;
    if (_entityIds is EqualUnmodifiableListView) return _entityIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  /// Entity tags to target. Matches when the entity has at least one.
  /// Null/empty means no restriction.
  final List<String>? _tags;

  /// Entity tags to target. Matches when the entity has at least one.
  /// Null/empty means no restriction.
  @override
  List<String>? get tags {
    final value = _tags;
    if (value == null) return null;
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  /// Target platforms. Null/empty means all platforms.
  final List<RunningPlatform>? _platforms;

  /// Target platforms. Null/empty means all platforms.
  @override
  List<RunningPlatform>? get platforms {
    final value = _platforms;
    if (value == null) return null;
    if (_platforms is EqualUnmodifiableListView) return _platforms;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  /// Lowest app version that shows the banner. Null means no lower bound.
  @override
  final String? minAppVersion;

  /// Highest app version that shows the banner. Null means no upper bound.
  @override
  final String? maxAppVersion;

  /// Whether the user can close the banner. Once closed it stays hidden.
  @override
  final bool closable;

  /// Label for the optional action button. Null hides the button.
  @override
  final String? actionLabel;

  /// Target of the action button. A deeplink or external URL.
  @override
  final String? actionUrl;

  /// Create a copy of Banner
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$BannerCopyWith<_Banner> get copyWith =>
      __$BannerCopyWithImpl<_Banner>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Banner &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.validFrom, validFrom) ||
                other.validFrom == validFrom) &&
            (identical(other.validTo, validTo) || other.validTo == validTo) &&
            (identical(other.role, role) || other.role == role) &&
            const DeepCollectionEquality()
                .equals(other._entityIds, _entityIds) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            const DeepCollectionEquality()
                .equals(other._platforms, _platforms) &&
            (identical(other.minAppVersion, minAppVersion) ||
                other.minAppVersion == minAppVersion) &&
            (identical(other.maxAppVersion, maxAppVersion) ||
                other.maxAppVersion == maxAppVersion) &&
            (identical(other.closable, closable) ||
                other.closable == closable) &&
            (identical(other.actionLabel, actionLabel) ||
                other.actionLabel == actionLabel) &&
            (identical(other.actionUrl, actionUrl) ||
                other.actionUrl == actionUrl));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      priority,
      title,
      text,
      type,
      validFrom,
      validTo,
      role,
      const DeepCollectionEquality().hash(_entityIds),
      const DeepCollectionEquality().hash(_tags),
      const DeepCollectionEquality().hash(_platforms),
      minAppVersion,
      maxAppVersion,
      closable,
      actionLabel,
      actionUrl);

  @override
  String toString() {
    return 'Banner(id: $id, priority: $priority, title: $title, text: $text, type: $type, validFrom: $validFrom, validTo: $validTo, role: $role, entityIds: $entityIds, tags: $tags, platforms: $platforms, minAppVersion: $minAppVersion, maxAppVersion: $maxAppVersion, closable: $closable, actionLabel: $actionLabel, actionUrl: $actionUrl)';
  }
}

/// @nodoc
abstract mixin class _$BannerCopyWith<$Res> implements $BannerCopyWith<$Res> {
  factory _$BannerCopyWith(_Banner value, $Res Function(_Banner) _then) =
      __$BannerCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      int priority,
      String title,
      String text,
      BannerType? type,
      DateTime? validFrom,
      DateTime? validTo,
      BannerRole role,
      List<String>? entityIds,
      List<String>? tags,
      List<RunningPlatform>? platforms,
      String? minAppVersion,
      String? maxAppVersion,
      bool closable,
      String? actionLabel,
      String? actionUrl});
}

/// @nodoc
class __$BannerCopyWithImpl<$Res> implements _$BannerCopyWith<$Res> {
  __$BannerCopyWithImpl(this._self, this._then);

  final _Banner _self;
  final $Res Function(_Banner) _then;

  /// Create a copy of Banner
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? priority = null,
    Object? title = null,
    Object? text = null,
    Object? type = freezed,
    Object? validFrom = freezed,
    Object? validTo = freezed,
    Object? role = null,
    Object? entityIds = freezed,
    Object? tags = freezed,
    Object? platforms = freezed,
    Object? minAppVersion = freezed,
    Object? maxAppVersion = freezed,
    Object? closable = null,
    Object? actionLabel = freezed,
    Object? actionUrl = freezed,
  }) {
    return _then(_Banner(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      priority: null == priority
          ? _self.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      text: null == text
          ? _self.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      type: freezed == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as BannerType?,
      validFrom: freezed == validFrom
          ? _self.validFrom
          : validFrom // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      validTo: freezed == validTo
          ? _self.validTo
          : validTo // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      role: null == role
          ? _self.role
          : role // ignore: cast_nullable_to_non_nullable
              as BannerRole,
      entityIds: freezed == entityIds
          ? _self._entityIds
          : entityIds // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      tags: freezed == tags
          ? _self._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      platforms: freezed == platforms
          ? _self._platforms
          : platforms // ignore: cast_nullable_to_non_nullable
              as List<RunningPlatform>?,
      minAppVersion: freezed == minAppVersion
          ? _self.minAppVersion
          : minAppVersion // ignore: cast_nullable_to_non_nullable
              as String?,
      maxAppVersion: freezed == maxAppVersion
          ? _self.maxAppVersion
          : maxAppVersion // ignore: cast_nullable_to_non_nullable
              as String?,
      closable: null == closable
          ? _self.closable
          : closable // ignore: cast_nullable_to_non_nullable
              as bool,
      actionLabel: freezed == actionLabel
          ? _self.actionLabel
          : actionLabel // ignore: cast_nullable_to_non_nullable
              as String?,
      actionUrl: freezed == actionUrl
          ? _self.actionUrl
          : actionUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
