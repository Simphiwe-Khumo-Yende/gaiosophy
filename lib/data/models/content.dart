import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
part 'content.freezed.dart';
part 'content.g.dart';

enum ContentType { seasonal, plant, recipe }

@freezed
class ContentBlock with _$ContentBlock {
  const factory ContentBlock({
    required String id,
    required String type,
    required int order,
    required ContentBlockData data,
    ContentBlockButton? button,
  }) = _ContentBlock;

  factory ContentBlock.fromJson(Map<String, dynamic> json) => _$ContentBlockFromJson(json);
}

@freezed
class ContentBlockButton with _$ContentBlockButton {
  const factory ContentBlockButton({
    required String action,
    required bool show,
    required String text,
  }) = _ContentBlockButton;

  factory ContentBlockButton.fromJson(Map<String, dynamic> json) => _$ContentBlockButtonFromJson(json);
}

@freezed
class SubBlock with _$SubBlock {
  const factory SubBlock({
    String? id,
    String? plantPartName,
    String? imageUrl,
    @Default([]) List<String> medicinalUses,
    @Default([]) List<String> energeticUses,
    @Default([]) List<String> skincareUses,
  }) = _SubBlock;

  factory SubBlock.fromJson(Map<String, dynamic> json) => _$SubBlockFromJson(json);
}

@freezed
class ContentBlockData with _$ContentBlockData {
  const factory ContentBlockData({
    String? title,
    String? subtitle,
    String? content,
    String? featuredImageId,
    @Default([]) List<String> galleryImageIds,
    @Default([]) List<SubBlock> subBlocks,
  }) = _ContentBlockData;

  factory ContentBlockData.fromJson(Map<String, dynamic> json) => _$ContentBlockDataFromJson(json);
}

@freezed
class Content with _$Content {
  const factory Content({
    required String id,
    required ContentType type,
    required String title,
    required String slug,
    String? summary,
    String? body,
    String? season,
    String? featuredImageId,
    String? audioId,
    String? templateType,
    String? status,
    // Recipe-specific fields
    String? prepTime,
    String? infusionTime,
    String? difficulty,
    @Default(false) bool published,
    @Default([]) List<String> tags,
    @Default([]) List<String> media,
    @Default([]) List<ContentBlock> contentBlocks,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Content;

  factory Content.fromJson(Map<String, dynamic> json) => _$ContentFromJson(json);

  /// Firestore convenience factory (accepts snake_case or camelCase, handles Timestamp)
  static Content fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? <String, dynamic>{};
    
    DateTime? parseDate(dynamic v) {
      if (v == null) return null;
      if (v is Timestamp) return v.toDate();
      if (v is int) return DateTime.fromMillisecondsSinceEpoch(v);
      if (v is String) return DateTime.tryParse(v);
      return null;
    }
    return Content(
      id: doc.id,
      type: () {
        final t = data['type'] as String?;
        switch (t) {
          case 'plant':
            return ContentType.plant;
          case 'recipe':
            return ContentType.recipe;
          case 'seasonal':
          default:
            return ContentType.seasonal;
        }
      }(),
      title: data['title'] as String? ?? 'Untitled',
      slug: data['slug'] as String? ?? doc.id,
      summary: data['summary'] as String? ?? data['excerpt'] as String?,
      body: data['body'] as String? ?? data['content'] as String?,
      season: data['season'] as String?,
      featuredImageId: data['featured_image_id'] as String?,
      audioId: data['audio_id'] as String?,
      templateType: data['template_type'] as String?,
      status: data['status'] as String?,
      // Recipe-specific fields
      prepTime: data['prep_time'] as String?,
      infusionTime: data['infusion_time'] as String?,
      difficulty: data['difficulty'] as String?,
      published: data['published'] as bool? ?? (data['status'] == 'published'),
      tags: (data['tags'] as List?)?.whereType<String>().toList() ?? const [],
      media: (data['media'] as List?)?.whereType<String>().toList() ?? const [],
      contentBlocks: () {
        final blocks = data['content_blocks'] as List?;
        if (blocks == null) return <ContentBlock>[];
        return blocks
            .whereType<Map<String, dynamic>>()
            .map((blockData) => ContentBlock(
                  id: blockData['id'] as String? ?? '',
                  type: blockData['type'] as String? ?? 'text',
                  order: blockData['order'] as int? ?? 0,
                  data: ContentBlockData(
                    title: blockData['data']?['title'] as String?,
                    subtitle: blockData['data']?['subtitle'] as String?,
                    content: blockData['data']?['content'] as String?,
                    featuredImageId: blockData['data']?['featured_image_id'] as String?,
                    galleryImageIds: (blockData['data']?['gallery_image_ids'] as List?)
                            ?.whereType<String>()
                            .toList() ??
                        const [],
                  ),
                  button: () {
                    final buttonData = blockData['data']?['button'] as Map<String, dynamic>?;
                    if (buttonData == null) return null;
                    return ContentBlockButton(
                      action: buttonData['action'] as String? ?? 'next',
                      show: buttonData['show'] as bool? ?? false,
                      text: buttonData['text'] as String? ?? '',
                    );
                  }(),
                ))
            .toList();
      }(),
      createdAt: parseDate(data['created_at'] ?? data['createdAt']),
      updatedAt: parseDate(data['updated_at'] ?? data['updatedAt']),
    );
  }
}
