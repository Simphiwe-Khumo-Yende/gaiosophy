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
    String? audioId,
    @Default(false) bool audioAutoPlay,
    String? audioTranscript,
    @Default(false) bool showAudioTranscript,
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

class HarvestPeriod {
  final String season;
  final String timing;

  HarvestPeriod({
    required this.season,
    required this.timing,
  });

  factory HarvestPeriod.fromJson(Map<String, dynamic> json) {
    return HarvestPeriod(
      season: json['season'] as String,
      timing: json['timing'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'season': season,
    'timing': timing,
  };

  // Convert season + timing to approximate month position (1-12)
  int get monthPosition {
    int baseMonth;
    switch (season.toLowerCase()) {
      case 'spring':
        baseMonth = 3; // March = start of spring
        break;
      case 'summer':
        baseMonth = 6; // June = start of summer
        break;
      case 'autumn':
        baseMonth = 9; // September = start of autumn
        break;
      case 'winter':
        baseMonth = 12; // December = start of winter
        break;
      default:
        baseMonth = 1;
    }

    // Adjust based on timing
    switch (timing.toLowerCase()) {
      case 'early':
        return baseMonth;
      case 'mid':
        return baseMonth + 1;
      case 'late':
        return baseMonth + 2;
      default:
        return baseMonth;
    }
  }
}

@freezed
class SubBlock with _$SubBlock {
  const factory SubBlock({
    String? id,
    String? plantPartName,
    @JsonKey(name: 'image_url') String? imageUrl,
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
    @Default([]) List<String> listItems,
    String? listStyle,
    @Default([]) List<HarvestPeriod> harvestPeriods,
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
    String? subtitle,
    // Recipe-specific fields
    String? prepTime,
    String? infusionTime,
    String? difficulty,
    bool? ritual, // Ritual flag for seasonal content
    @Default(false) bool published,
    @Default([]) List<String> tags,
    @Default([]) List<String> media,
    @Default([]) List<String> linkedRecipeIds,
    @Default([]) List<ContentBlock> contentBlocks,
    @Default([]) List<HarvestPeriod> harvestPeriods, // Harvest periods for plants
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
    
    final finalContent = Content(
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
      ritual: data['ritual'] as bool?, // Parse ritual field from Firestore
      published: data['published'] as bool? ?? (data['status'] == 'published'),
      tags: (data['tags'] as List?)?.whereType<String>().toList() ?? const [],
      media: (data['media'] as List?)?.whereType<String>().toList() ?? const [],
      linkedRecipeIds: (data['linked_recipe_ids'] as List?)?.whereType<String>().toList() ?? const [],
      harvestPeriods: () {
        final rawHarvestPeriods = data['harvest_periods'];
        
        if (rawHarvestPeriods == null) {
          return <HarvestPeriod>[];
        }
        
        if (rawHarvestPeriods is! List) {
          return <HarvestPeriod>[];
        }
        
        final periods = rawHarvestPeriods
            .map((p) {
              try {
                if (p is! Map) {
                  return null;
                }
                
                final periodMap = p as Map<String, dynamic>;
                return HarvestPeriod.fromJson(periodMap);
              } catch (e) {
                return null;
              }
            })
            .whereType<HarvestPeriod>()
            .toList();
        
        return periods;
      }(),
      contentBlocks: () {
        final blocks = data['content_blocks'] as List?;
        if (blocks == null) return <ContentBlock>[];
        return blocks
            .whereType<Map<String, dynamic>>()
            .map((blockData) {
              return ContentBlock(
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
                    listItems: (blockData['data']?['list_items'] as List?)
                            ?.whereType<String>()
                            .toList() ??
                        const [],
                    listStyle: blockData['data']?['list_style'] as String?,
                    harvestPeriods: () {
                      final rawPeriods = blockData['data']?['harvest_periods'];
                      
                      if (rawPeriods == null) {
                        return <HarvestPeriod>[];
                      }
                      
                      return (rawPeriods as List?)
                              ?.map((p) {
                                try {
                                  return HarvestPeriod.fromJson(p as Map<String, dynamic>);
                                } catch (e) {
                                  return null;
                                }
                              })
                              .whereType<HarvestPeriod>()
                              .toList() ??
                          const [];
                    }(),
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
                );
            })
            .toList();
      }(),
      createdAt: parseDate(data['created_at'] ?? data['createdAt']),
      updatedAt: parseDate(data['updated_at'] ?? data['updatedAt']),
    );
    
    return finalContent;
  }
}