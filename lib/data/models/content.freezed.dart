// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'content.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ContentBlock _$ContentBlockFromJson(Map<String, dynamic> json) {
  return _ContentBlock.fromJson(json);
}

/// @nodoc
mixin _$ContentBlock {
  String get id => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  int get order => throw _privateConstructorUsedError;
  ContentBlockData get data => throw _privateConstructorUsedError;
  ContentBlockButton? get button => throw _privateConstructorUsedError;

  /// Serializes this ContentBlock to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ContentBlock
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ContentBlockCopyWith<ContentBlock> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ContentBlockCopyWith<$Res> {
  factory $ContentBlockCopyWith(
          ContentBlock value, $Res Function(ContentBlock) then) =
      _$ContentBlockCopyWithImpl<$Res, ContentBlock>;
  @useResult
  $Res call(
      {String id,
      String type,
      int order,
      ContentBlockData data,
      ContentBlockButton? button});

  $ContentBlockDataCopyWith<$Res> get data;
  $ContentBlockButtonCopyWith<$Res>? get button;
}

/// @nodoc
class _$ContentBlockCopyWithImpl<$Res, $Val extends ContentBlock>
    implements $ContentBlockCopyWith<$Res> {
  _$ContentBlockCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ContentBlock
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? order = null,
    Object? data = null,
    Object? button = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      order: null == order
          ? _value.order
          : order // ignore: cast_nullable_to_non_nullable
              as int,
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as ContentBlockData,
      button: freezed == button
          ? _value.button
          : button // ignore: cast_nullable_to_non_nullable
              as ContentBlockButton?,
    ) as $Val);
  }

  /// Create a copy of ContentBlock
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ContentBlockDataCopyWith<$Res> get data {
    return $ContentBlockDataCopyWith<$Res>(_value.data, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }

  /// Create a copy of ContentBlock
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ContentBlockButtonCopyWith<$Res>? get button {
    if (_value.button == null) {
      return null;
    }

    return $ContentBlockButtonCopyWith<$Res>(_value.button!, (value) {
      return _then(_value.copyWith(button: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ContentBlockImplCopyWith<$Res>
    implements $ContentBlockCopyWith<$Res> {
  factory _$$ContentBlockImplCopyWith(
          _$ContentBlockImpl value, $Res Function(_$ContentBlockImpl) then) =
      __$$ContentBlockImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String type,
      int order,
      ContentBlockData data,
      ContentBlockButton? button});

  @override
  $ContentBlockDataCopyWith<$Res> get data;
  @override
  $ContentBlockButtonCopyWith<$Res>? get button;
}

/// @nodoc
class __$$ContentBlockImplCopyWithImpl<$Res>
    extends _$ContentBlockCopyWithImpl<$Res, _$ContentBlockImpl>
    implements _$$ContentBlockImplCopyWith<$Res> {
  __$$ContentBlockImplCopyWithImpl(
      _$ContentBlockImpl _value, $Res Function(_$ContentBlockImpl) _then)
      : super(_value, _then);

  /// Create a copy of ContentBlock
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? order = null,
    Object? data = null,
    Object? button = freezed,
  }) {
    return _then(_$ContentBlockImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      order: null == order
          ? _value.order
          : order // ignore: cast_nullable_to_non_nullable
              as int,
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as ContentBlockData,
      button: freezed == button
          ? _value.button
          : button // ignore: cast_nullable_to_non_nullable
              as ContentBlockButton?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ContentBlockImpl implements _ContentBlock {
  const _$ContentBlockImpl(
      {required this.id,
      required this.type,
      required this.order,
      required this.data,
      this.button});

  factory _$ContentBlockImpl.fromJson(Map<String, dynamic> json) =>
      _$$ContentBlockImplFromJson(json);

  @override
  final String id;
  @override
  final String type;
  @override
  final int order;
  @override
  final ContentBlockData data;
  @override
  final ContentBlockButton? button;

  @override
  String toString() {
    return 'ContentBlock(id: $id, type: $type, order: $order, data: $data, button: $button)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ContentBlockImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.order, order) || other.order == order) &&
            (identical(other.data, data) || other.data == data) &&
            (identical(other.button, button) || other.button == button));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, type, order, data, button);

  /// Create a copy of ContentBlock
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ContentBlockImplCopyWith<_$ContentBlockImpl> get copyWith =>
      __$$ContentBlockImplCopyWithImpl<_$ContentBlockImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ContentBlockImplToJson(
      this,
    );
  }
}

abstract class _ContentBlock implements ContentBlock {
  const factory _ContentBlock(
      {required final String id,
      required final String type,
      required final int order,
      required final ContentBlockData data,
      final ContentBlockButton? button}) = _$ContentBlockImpl;

  factory _ContentBlock.fromJson(Map<String, dynamic> json) =
      _$ContentBlockImpl.fromJson;

  @override
  String get id;
  @override
  String get type;
  @override
  int get order;
  @override
  ContentBlockData get data;
  @override
  ContentBlockButton? get button;

  /// Create a copy of ContentBlock
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ContentBlockImplCopyWith<_$ContentBlockImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ContentBlockButton _$ContentBlockButtonFromJson(Map<String, dynamic> json) {
  return _ContentBlockButton.fromJson(json);
}

/// @nodoc
mixin _$ContentBlockButton {
  String get action => throw _privateConstructorUsedError;
  bool get show => throw _privateConstructorUsedError;
  String get text => throw _privateConstructorUsedError;

  /// Serializes this ContentBlockButton to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ContentBlockButton
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ContentBlockButtonCopyWith<ContentBlockButton> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ContentBlockButtonCopyWith<$Res> {
  factory $ContentBlockButtonCopyWith(
          ContentBlockButton value, $Res Function(ContentBlockButton) then) =
      _$ContentBlockButtonCopyWithImpl<$Res, ContentBlockButton>;
  @useResult
  $Res call({String action, bool show, String text});
}

/// @nodoc
class _$ContentBlockButtonCopyWithImpl<$Res, $Val extends ContentBlockButton>
    implements $ContentBlockButtonCopyWith<$Res> {
  _$ContentBlockButtonCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ContentBlockButton
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? action = null,
    Object? show = null,
    Object? text = null,
  }) {
    return _then(_value.copyWith(
      action: null == action
          ? _value.action
          : action // ignore: cast_nullable_to_non_nullable
              as String,
      show: null == show
          ? _value.show
          : show // ignore: cast_nullable_to_non_nullable
              as bool,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ContentBlockButtonImplCopyWith<$Res>
    implements $ContentBlockButtonCopyWith<$Res> {
  factory _$$ContentBlockButtonImplCopyWith(_$ContentBlockButtonImpl value,
          $Res Function(_$ContentBlockButtonImpl) then) =
      __$$ContentBlockButtonImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String action, bool show, String text});
}

/// @nodoc
class __$$ContentBlockButtonImplCopyWithImpl<$Res>
    extends _$ContentBlockButtonCopyWithImpl<$Res, _$ContentBlockButtonImpl>
    implements _$$ContentBlockButtonImplCopyWith<$Res> {
  __$$ContentBlockButtonImplCopyWithImpl(_$ContentBlockButtonImpl _value,
      $Res Function(_$ContentBlockButtonImpl) _then)
      : super(_value, _then);

  /// Create a copy of ContentBlockButton
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? action = null,
    Object? show = null,
    Object? text = null,
  }) {
    return _then(_$ContentBlockButtonImpl(
      action: null == action
          ? _value.action
          : action // ignore: cast_nullable_to_non_nullable
              as String,
      show: null == show
          ? _value.show
          : show // ignore: cast_nullable_to_non_nullable
              as bool,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ContentBlockButtonImpl implements _ContentBlockButton {
  const _$ContentBlockButtonImpl(
      {required this.action, required this.show, required this.text});

  factory _$ContentBlockButtonImpl.fromJson(Map<String, dynamic> json) =>
      _$$ContentBlockButtonImplFromJson(json);

  @override
  final String action;
  @override
  final bool show;
  @override
  final String text;

  @override
  String toString() {
    return 'ContentBlockButton(action: $action, show: $show, text: $text)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ContentBlockButtonImpl &&
            (identical(other.action, action) || other.action == action) &&
            (identical(other.show, show) || other.show == show) &&
            (identical(other.text, text) || other.text == text));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, action, show, text);

  /// Create a copy of ContentBlockButton
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ContentBlockButtonImplCopyWith<_$ContentBlockButtonImpl> get copyWith =>
      __$$ContentBlockButtonImplCopyWithImpl<_$ContentBlockButtonImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ContentBlockButtonImplToJson(
      this,
    );
  }
}

abstract class _ContentBlockButton implements ContentBlockButton {
  const factory _ContentBlockButton(
      {required final String action,
      required final bool show,
      required final String text}) = _$ContentBlockButtonImpl;

  factory _ContentBlockButton.fromJson(Map<String, dynamic> json) =
      _$ContentBlockButtonImpl.fromJson;

  @override
  String get action;
  @override
  bool get show;
  @override
  String get text;

  /// Create a copy of ContentBlockButton
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ContentBlockButtonImplCopyWith<_$ContentBlockButtonImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ContentBlockData _$ContentBlockDataFromJson(Map<String, dynamic> json) {
  return _ContentBlockData.fromJson(json);
}

/// @nodoc
mixin _$ContentBlockData {
  String? get title => throw _privateConstructorUsedError;
  String? get subtitle => throw _privateConstructorUsedError;
  String? get content => throw _privateConstructorUsedError;
  String? get featuredImageId => throw _privateConstructorUsedError;
  List<String> get galleryImageIds => throw _privateConstructorUsedError;

  /// Serializes this ContentBlockData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ContentBlockData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ContentBlockDataCopyWith<ContentBlockData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ContentBlockDataCopyWith<$Res> {
  factory $ContentBlockDataCopyWith(
          ContentBlockData value, $Res Function(ContentBlockData) then) =
      _$ContentBlockDataCopyWithImpl<$Res, ContentBlockData>;
  @useResult
  $Res call(
      {String? title,
      String? subtitle,
      String? content,
      String? featuredImageId,
      List<String> galleryImageIds});
}

/// @nodoc
class _$ContentBlockDataCopyWithImpl<$Res, $Val extends ContentBlockData>
    implements $ContentBlockDataCopyWith<$Res> {
  _$ContentBlockDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ContentBlockData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = freezed,
    Object? subtitle = freezed,
    Object? content = freezed,
    Object? featuredImageId = freezed,
    Object? galleryImageIds = null,
  }) {
    return _then(_value.copyWith(
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      subtitle: freezed == subtitle
          ? _value.subtitle
          : subtitle // ignore: cast_nullable_to_non_nullable
              as String?,
      content: freezed == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String?,
      featuredImageId: freezed == featuredImageId
          ? _value.featuredImageId
          : featuredImageId // ignore: cast_nullable_to_non_nullable
              as String?,
      galleryImageIds: null == galleryImageIds
          ? _value.galleryImageIds
          : galleryImageIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ContentBlockDataImplCopyWith<$Res>
    implements $ContentBlockDataCopyWith<$Res> {
  factory _$$ContentBlockDataImplCopyWith(_$ContentBlockDataImpl value,
          $Res Function(_$ContentBlockDataImpl) then) =
      __$$ContentBlockDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? title,
      String? subtitle,
      String? content,
      String? featuredImageId,
      List<String> galleryImageIds});
}

/// @nodoc
class __$$ContentBlockDataImplCopyWithImpl<$Res>
    extends _$ContentBlockDataCopyWithImpl<$Res, _$ContentBlockDataImpl>
    implements _$$ContentBlockDataImplCopyWith<$Res> {
  __$$ContentBlockDataImplCopyWithImpl(_$ContentBlockDataImpl _value,
      $Res Function(_$ContentBlockDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of ContentBlockData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = freezed,
    Object? subtitle = freezed,
    Object? content = freezed,
    Object? featuredImageId = freezed,
    Object? galleryImageIds = null,
  }) {
    return _then(_$ContentBlockDataImpl(
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      subtitle: freezed == subtitle
          ? _value.subtitle
          : subtitle // ignore: cast_nullable_to_non_nullable
              as String?,
      content: freezed == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String?,
      featuredImageId: freezed == featuredImageId
          ? _value.featuredImageId
          : featuredImageId // ignore: cast_nullable_to_non_nullable
              as String?,
      galleryImageIds: null == galleryImageIds
          ? _value._galleryImageIds
          : galleryImageIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ContentBlockDataImpl implements _ContentBlockData {
  const _$ContentBlockDataImpl(
      {this.title,
      this.subtitle,
      this.content,
      this.featuredImageId,
      final List<String> galleryImageIds = const []})
      : _galleryImageIds = galleryImageIds;

  factory _$ContentBlockDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$ContentBlockDataImplFromJson(json);

  @override
  final String? title;
  @override
  final String? subtitle;
  @override
  final String? content;
  @override
  final String? featuredImageId;
  final List<String> _galleryImageIds;
  @override
  @JsonKey()
  List<String> get galleryImageIds {
    if (_galleryImageIds is EqualUnmodifiableListView) return _galleryImageIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_galleryImageIds);
  }

  @override
  String toString() {
    return 'ContentBlockData(title: $title, subtitle: $subtitle, content: $content, featuredImageId: $featuredImageId, galleryImageIds: $galleryImageIds)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ContentBlockDataImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.subtitle, subtitle) ||
                other.subtitle == subtitle) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.featuredImageId, featuredImageId) ||
                other.featuredImageId == featuredImageId) &&
            const DeepCollectionEquality()
                .equals(other._galleryImageIds, _galleryImageIds));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, title, subtitle, content,
      featuredImageId, const DeepCollectionEquality().hash(_galleryImageIds));

  /// Create a copy of ContentBlockData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ContentBlockDataImplCopyWith<_$ContentBlockDataImpl> get copyWith =>
      __$$ContentBlockDataImplCopyWithImpl<_$ContentBlockDataImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ContentBlockDataImplToJson(
      this,
    );
  }
}

abstract class _ContentBlockData implements ContentBlockData {
  const factory _ContentBlockData(
      {final String? title,
      final String? subtitle,
      final String? content,
      final String? featuredImageId,
      final List<String> galleryImageIds}) = _$ContentBlockDataImpl;

  factory _ContentBlockData.fromJson(Map<String, dynamic> json) =
      _$ContentBlockDataImpl.fromJson;

  @override
  String? get title;
  @override
  String? get subtitle;
  @override
  String? get content;
  @override
  String? get featuredImageId;
  @override
  List<String> get galleryImageIds;

  /// Create a copy of ContentBlockData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ContentBlockDataImplCopyWith<_$ContentBlockDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Content _$ContentFromJson(Map<String, dynamic> json) {
  return _Content.fromJson(json);
}

/// @nodoc
mixin _$Content {
  String get id => throw _privateConstructorUsedError;
  ContentType get type => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get slug => throw _privateConstructorUsedError;
  String? get summary => throw _privateConstructorUsedError;
  String? get body => throw _privateConstructorUsedError;
  String? get season => throw _privateConstructorUsedError;
  String? get featuredImageId => throw _privateConstructorUsedError;
  String? get templateType => throw _privateConstructorUsedError;
  String? get status => throw _privateConstructorUsedError;
  bool get published => throw _privateConstructorUsedError;
  List<String> get tags => throw _privateConstructorUsedError;
  List<String> get media => throw _privateConstructorUsedError;
  List<ContentBlock> get contentBlocks => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this Content to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Content
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ContentCopyWith<Content> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ContentCopyWith<$Res> {
  factory $ContentCopyWith(Content value, $Res Function(Content) then) =
      _$ContentCopyWithImpl<$Res, Content>;
  @useResult
  $Res call(
      {String id,
      ContentType type,
      String title,
      String slug,
      String? summary,
      String? body,
      String? season,
      String? featuredImageId,
      String? templateType,
      String? status,
      bool published,
      List<String> tags,
      List<String> media,
      List<ContentBlock> contentBlocks,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$ContentCopyWithImpl<$Res, $Val extends Content>
    implements $ContentCopyWith<$Res> {
  _$ContentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Content
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? title = null,
    Object? slug = null,
    Object? summary = freezed,
    Object? body = freezed,
    Object? season = freezed,
    Object? featuredImageId = freezed,
    Object? templateType = freezed,
    Object? status = freezed,
    Object? published = null,
    Object? tags = null,
    Object? media = null,
    Object? contentBlocks = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ContentType,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      slug: null == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String,
      summary: freezed == summary
          ? _value.summary
          : summary // ignore: cast_nullable_to_non_nullable
              as String?,
      body: freezed == body
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as String?,
      season: freezed == season
          ? _value.season
          : season // ignore: cast_nullable_to_non_nullable
              as String?,
      featuredImageId: freezed == featuredImageId
          ? _value.featuredImageId
          : featuredImageId // ignore: cast_nullable_to_non_nullable
              as String?,
      templateType: freezed == templateType
          ? _value.templateType
          : templateType // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      published: null == published
          ? _value.published
          : published // ignore: cast_nullable_to_non_nullable
              as bool,
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      media: null == media
          ? _value.media
          : media // ignore: cast_nullable_to_non_nullable
              as List<String>,
      contentBlocks: null == contentBlocks
          ? _value.contentBlocks
          : contentBlocks // ignore: cast_nullable_to_non_nullable
              as List<ContentBlock>,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ContentImplCopyWith<$Res> implements $ContentCopyWith<$Res> {
  factory _$$ContentImplCopyWith(
          _$ContentImpl value, $Res Function(_$ContentImpl) then) =
      __$$ContentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      ContentType type,
      String title,
      String slug,
      String? summary,
      String? body,
      String? season,
      String? featuredImageId,
      String? templateType,
      String? status,
      bool published,
      List<String> tags,
      List<String> media,
      List<ContentBlock> contentBlocks,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$ContentImplCopyWithImpl<$Res>
    extends _$ContentCopyWithImpl<$Res, _$ContentImpl>
    implements _$$ContentImplCopyWith<$Res> {
  __$$ContentImplCopyWithImpl(
      _$ContentImpl _value, $Res Function(_$ContentImpl) _then)
      : super(_value, _then);

  /// Create a copy of Content
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? title = null,
    Object? slug = null,
    Object? summary = freezed,
    Object? body = freezed,
    Object? season = freezed,
    Object? featuredImageId = freezed,
    Object? templateType = freezed,
    Object? status = freezed,
    Object? published = null,
    Object? tags = null,
    Object? media = null,
    Object? contentBlocks = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$ContentImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ContentType,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      slug: null == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String,
      summary: freezed == summary
          ? _value.summary
          : summary // ignore: cast_nullable_to_non_nullable
              as String?,
      body: freezed == body
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as String?,
      season: freezed == season
          ? _value.season
          : season // ignore: cast_nullable_to_non_nullable
              as String?,
      featuredImageId: freezed == featuredImageId
          ? _value.featuredImageId
          : featuredImageId // ignore: cast_nullable_to_non_nullable
              as String?,
      templateType: freezed == templateType
          ? _value.templateType
          : templateType // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      published: null == published
          ? _value.published
          : published // ignore: cast_nullable_to_non_nullable
              as bool,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      media: null == media
          ? _value._media
          : media // ignore: cast_nullable_to_non_nullable
              as List<String>,
      contentBlocks: null == contentBlocks
          ? _value._contentBlocks
          : contentBlocks // ignore: cast_nullable_to_non_nullable
              as List<ContentBlock>,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ContentImpl implements _Content {
  const _$ContentImpl(
      {required this.id,
      required this.type,
      required this.title,
      required this.slug,
      this.summary,
      this.body,
      this.season,
      this.featuredImageId,
      this.templateType,
      this.status,
      this.published = false,
      final List<String> tags = const [],
      final List<String> media = const [],
      final List<ContentBlock> contentBlocks = const [],
      this.createdAt,
      this.updatedAt})
      : _tags = tags,
        _media = media,
        _contentBlocks = contentBlocks;

  factory _$ContentImpl.fromJson(Map<String, dynamic> json) =>
      _$$ContentImplFromJson(json);

  @override
  final String id;
  @override
  final ContentType type;
  @override
  final String title;
  @override
  final String slug;
  @override
  final String? summary;
  @override
  final String? body;
  @override
  final String? season;
  @override
  final String? featuredImageId;
  @override
  final String? templateType;
  @override
  final String? status;
  @override
  @JsonKey()
  final bool published;
  final List<String> _tags;
  @override
  @JsonKey()
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  final List<String> _media;
  @override
  @JsonKey()
  List<String> get media {
    if (_media is EqualUnmodifiableListView) return _media;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_media);
  }

  final List<ContentBlock> _contentBlocks;
  @override
  @JsonKey()
  List<ContentBlock> get contentBlocks {
    if (_contentBlocks is EqualUnmodifiableListView) return _contentBlocks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_contentBlocks);
  }

  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'Content(id: $id, type: $type, title: $title, slug: $slug, summary: $summary, body: $body, season: $season, featuredImageId: $featuredImageId, templateType: $templateType, status: $status, published: $published, tags: $tags, media: $media, contentBlocks: $contentBlocks, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ContentImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.slug, slug) || other.slug == slug) &&
            (identical(other.summary, summary) || other.summary == summary) &&
            (identical(other.body, body) || other.body == body) &&
            (identical(other.season, season) || other.season == season) &&
            (identical(other.featuredImageId, featuredImageId) ||
                other.featuredImageId == featuredImageId) &&
            (identical(other.templateType, templateType) ||
                other.templateType == templateType) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.published, published) ||
                other.published == published) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            const DeepCollectionEquality().equals(other._media, _media) &&
            const DeepCollectionEquality()
                .equals(other._contentBlocks, _contentBlocks) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      type,
      title,
      slug,
      summary,
      body,
      season,
      featuredImageId,
      templateType,
      status,
      published,
      const DeepCollectionEquality().hash(_tags),
      const DeepCollectionEquality().hash(_media),
      const DeepCollectionEquality().hash(_contentBlocks),
      createdAt,
      updatedAt);

  /// Create a copy of Content
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ContentImplCopyWith<_$ContentImpl> get copyWith =>
      __$$ContentImplCopyWithImpl<_$ContentImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ContentImplToJson(
      this,
    );
  }
}

abstract class _Content implements Content {
  const factory _Content(
      {required final String id,
      required final ContentType type,
      required final String title,
      required final String slug,
      final String? summary,
      final String? body,
      final String? season,
      final String? featuredImageId,
      final String? templateType,
      final String? status,
      final bool published,
      final List<String> tags,
      final List<String> media,
      final List<ContentBlock> contentBlocks,
      final DateTime? createdAt,
      final DateTime? updatedAt}) = _$ContentImpl;

  factory _Content.fromJson(Map<String, dynamic> json) = _$ContentImpl.fromJson;

  @override
  String get id;
  @override
  ContentType get type;
  @override
  String get title;
  @override
  String get slug;
  @override
  String? get summary;
  @override
  String? get body;
  @override
  String? get season;
  @override
  String? get featuredImageId;
  @override
  String? get templateType;
  @override
  String? get status;
  @override
  bool get published;
  @override
  List<String> get tags;
  @override
  List<String> get media;
  @override
  List<ContentBlock> get contentBlocks;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of Content
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ContentImplCopyWith<_$ContentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
