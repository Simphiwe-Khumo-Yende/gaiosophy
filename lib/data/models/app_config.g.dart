// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AppConfigImpl _$$AppConfigImplFromJson(Map<String, dynamic> json) =>
    _$AppConfigImpl(
      currentSeasonName: json['currentSeasonName'] as String? ?? 'Autumn',
      currentSeason: json['currentSeason'] as String? ?? '',
      appDirection: json['appDirection'] as String? ?? '',
      appElement: json['appElement'] as String? ?? '',
      appSeason: json['appSeason'] as String? ?? '',
      appImageUrl: json['appImageUrl'] as String?,
      appImageId: json['appImageId'] as String?,
      appVersion: json['appVersion'] as String? ?? '1.0.0',
      contentRefreshInterval:
          (json['contentRefreshInterval'] as num?)?.toInt() ?? 3600,
      analyticsEnabled: json['analyticsEnabled'] as bool? ?? true,
      offlineModeEnabled: json['offlineModeEnabled'] as bool? ?? true,
      pushNotificationsEnabled:
          json['pushNotificationsEnabled'] as bool? ?? true,
      themeMode: json['themeMode'] as String? ?? 'auto',
    );

Map<String, dynamic> _$$AppConfigImplToJson(_$AppConfigImpl instance) =>
    <String, dynamic>{
      'currentSeasonName': instance.currentSeasonName,
      'currentSeason': instance.currentSeason,
      'appDirection': instance.appDirection,
      'appElement': instance.appElement,
      'appSeason': instance.appSeason,
      'appImageUrl': instance.appImageUrl,
      'appImageId': instance.appImageId,
      'appVersion': instance.appVersion,
      'contentRefreshInterval': instance.contentRefreshInterval,
      'analyticsEnabled': instance.analyticsEnabled,
      'offlineModeEnabled': instance.offlineModeEnabled,
      'pushNotificationsEnabled': instance.pushNotificationsEnabled,
      'themeMode': instance.themeMode,
    };
