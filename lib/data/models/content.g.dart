// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'content.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ContentBlockImpl _$$ContentBlockImplFromJson(Map<String, dynamic> json) =>
    _$ContentBlockImpl(
      id: json['id'] as String,
      type: json['type'] as String,
      order: (json['order'] as num).toInt(),
      data: ContentBlockData.fromJson(json['data'] as Map<String, dynamic>),
      button: json['button'] == null
          ? null
          : ContentBlockButton.fromJson(json['button'] as Map<String, dynamic>),
      audioId: json['audioId'] as String?,
      audioAutoPlay: json['audioAutoPlay'] as bool? ?? false,
      audioTranscript: json['audioTranscript'] as String?,
      showAudioTranscript: json['showAudioTranscript'] as bool? ?? false,
    );

Map<String, dynamic> _$$ContentBlockImplToJson(_$ContentBlockImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'order': instance.order,
      'data': instance.data,
      'button': instance.button,
      'audioId': instance.audioId,
      'audioAutoPlay': instance.audioAutoPlay,
      'audioTranscript': instance.audioTranscript,
      'showAudioTranscript': instance.showAudioTranscript,
    };

_$ContentBlockButtonImpl _$$ContentBlockButtonImplFromJson(
        Map<String, dynamic> json) =>
    _$ContentBlockButtonImpl(
      action: json['action'] as String,
      show: json['show'] as bool,
      text: json['text'] as String,
    );

Map<String, dynamic> _$$ContentBlockButtonImplToJson(
        _$ContentBlockButtonImpl instance) =>
    <String, dynamic>{
      'action': instance.action,
      'show': instance.show,
      'text': instance.text,
    };

_$SubBlockImpl _$$SubBlockImplFromJson(Map<String, dynamic> json) =>
    _$SubBlockImpl(
      id: json['id'] as String?,
      plantPartName: json['plantPartName'] as String?,
      imageUrl: json['image_url'] as String?,
      medicinalUses: (json['medicinalUses'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      energeticUses: (json['energeticUses'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      skincareUses: (json['skincareUses'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$SubBlockImplToJson(_$SubBlockImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'plantPartName': instance.plantPartName,
      'image_url': instance.imageUrl,
      'medicinalUses': instance.medicinalUses,
      'energeticUses': instance.energeticUses,
      'skincareUses': instance.skincareUses,
    };

_$ContentBlockDataImpl _$$ContentBlockDataImplFromJson(
        Map<String, dynamic> json) =>
    _$ContentBlockDataImpl(
      title: json['title'] as String?,
      subtitle: json['subtitle'] as String?,
      content: json['content'] as String?,
      featuredImageId: json['featuredImageId'] as String?,
      galleryImageIds: (json['galleryImageIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      subBlocks: (json['subBlocks'] as List<dynamic>?)
              ?.map((e) => SubBlock.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      listItems: (json['listItems'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      listStyle: json['listStyle'] as String?,
      harvestPeriods: (json['harvestPeriods'] as List<dynamic>?)
              ?.map((e) => HarvestPeriod.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$ContentBlockDataImplToJson(
        _$ContentBlockDataImpl instance) =>
    <String, dynamic>{
      'title': instance.title,
      'subtitle': instance.subtitle,
      'content': instance.content,
      'featuredImageId': instance.featuredImageId,
      'galleryImageIds': instance.galleryImageIds,
      'subBlocks': instance.subBlocks,
      'listItems': instance.listItems,
      'listStyle': instance.listStyle,
      'harvestPeriods': instance.harvestPeriods,
    };

_$ContentImpl _$$ContentImplFromJson(Map<String, dynamic> json) =>
    _$ContentImpl(
      id: json['id'] as String,
      type: $enumDecode(_$ContentTypeEnumMap, json['type']),
      title: json['title'] as String,
      slug: json['slug'] as String,
      summary: json['summary'] as String?,
      body: json['body'] as String?,
      season: json['season'] as String?,
      seasonId: json['seasonId'] as String?,
      featuredImageId: json['featuredImageId'] as String?,
      audioId: json['audioId'] as String?,
      templateType: json['templateType'] as String?,
      status: json['status'] as String?,
      subtitle: json['subtitle'] as String?,
      prepTime: json['prepTime'] as String?,
      infusionTime: json['infusionTime'] as String?,
      difficulty: json['difficulty'] as String?,
      ritual: json['ritual'] as bool?,
      published: json['published'] as bool? ?? false,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      media:
          (json['media'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      linkedRecipeIds: (json['linkedRecipeIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      contentBlocks: (json['contentBlocks'] as List<dynamic>?)
              ?.map((e) => ContentBlock.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      harvestPeriods: (json['harvestPeriods'] as List<dynamic>?)
              ?.map((e) => HarvestPeriod.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$ContentImplToJson(_$ContentImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$ContentTypeEnumMap[instance.type]!,
      'title': instance.title,
      'slug': instance.slug,
      'summary': instance.summary,
      'body': instance.body,
      'season': instance.season,
      'seasonId': instance.seasonId,
      'featuredImageId': instance.featuredImageId,
      'audioId': instance.audioId,
      'templateType': instance.templateType,
      'status': instance.status,
      'subtitle': instance.subtitle,
      'prepTime': instance.prepTime,
      'infusionTime': instance.infusionTime,
      'difficulty': instance.difficulty,
      'ritual': instance.ritual,
      'published': instance.published,
      'tags': instance.tags,
      'media': instance.media,
      'linkedRecipeIds': instance.linkedRecipeIds,
      'contentBlocks': instance.contentBlocks,
      'harvestPeriods': instance.harvestPeriods,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$ContentTypeEnumMap = {
  ContentType.seasonal: 'seasonal',
  ContentType.plant: 'plant',
  ContentType.recipe: 'recipe',
};
