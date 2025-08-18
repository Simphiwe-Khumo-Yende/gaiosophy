// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'season.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SeasonImpl _$$SeasonImplFromJson(Map<String, dynamic> json) => _$SeasonImpl(
      name: json['name'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      themes: (json['themes'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      featuredContentIds: (json['featuredContentIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$SeasonImplToJson(_$SeasonImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
      'themes': instance.themes,
      'featuredContentIds': instance.featuredContentIds,
    };
