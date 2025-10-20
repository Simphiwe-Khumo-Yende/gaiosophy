import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_config.freezed.dart';
part 'app_config.g.dart';

@freezed
class AppConfig with _$AppConfig {
  const factory AppConfig({
    @Default('Autumn') String currentSeasonName,
    @Default('') String currentSeason,
    @Default('') String appDirection,
    @Default('') String appElement,
    @Default('') String appSeason,
    String? appImageUrl,
    String? appImageId,
    @Default('1.0.0') String appVersion,
    @Default(3600) int contentRefreshInterval,
    @Default(true) bool analyticsEnabled,
    @Default(true) bool offlineModeEnabled,
    @Default(true) bool pushNotificationsEnabled,
    @Default('auto') String themeMode,
  }) = _AppConfig;

  factory AppConfig.fromJson(Map<String, dynamic> json) => _$AppConfigFromJson(json);
}
