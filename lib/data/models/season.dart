import 'package:freezed_annotation/freezed_annotation.dart';
part 'season.freezed.dart';
part 'season.g.dart';

@freezed
class Season with _$Season {
  const factory Season({
    required String name,
    required DateTime startDate,
    required DateTime endDate,
    @Default([]) List<String> themes,
    @Default([]) List<String> featuredContentIds,
  }) = _Season;

  factory Season.fromJson(Map<String, dynamic> json) => _$SeasonFromJson(json);
}
