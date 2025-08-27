import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'user_profile.freezed.dart';
part 'user_profile.g.dart';

@freezed
class UserProfile with _$UserProfile {
  const factory UserProfile({
    required String uid,
    required String email,
    String? firstName,
    String? lastName,
    @TimestampConverter() DateTime? dateOfBirth,
    String? zodiacSign,
    @TimestampConverter() DateTime? createdAt,
    @TimestampConverter() DateTime? updatedAt,
    @Default(false) bool profileCompleted,
  }) = _UserProfile;

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);

  factory UserProfile.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserProfile.fromJson({
      ...data,
      'uid': doc.id,
    });
  }
}

extension UserProfileExtension on UserProfile {
  Map<String, dynamic> toFirestore() {
    final json = toJson();
    json.remove('uid'); // Remove uid from data to be saved
    return json;
  }
}

class TimestampConverter implements JsonConverter<DateTime?, dynamic> {
  const TimestampConverter();

  @override
  DateTime? fromJson(dynamic json) {
    if (json == null) return null;
    if (json is Timestamp) return json.toDate();
    if (json is int) return DateTime.fromMillisecondsSinceEpoch(json);
    if (json is String) return DateTime.tryParse(json);
    return null;
  }

  @override
  dynamic toJson(DateTime? object) {
    return object != null ? Timestamp.fromDate(object) : null;
  }
}

enum ZodiacSign {
  aries('Aries', '♈'),
  taurus('Taurus', '♉'),
  gemini('Gemini', '♊'),
  cancer('Cancer', '♋'),
  leo('Leo', '♌'),
  virgo('Virgo', '♍'),
  libra('Libra', '♎'),
  scorpio('Scorpio', '♏'),
  sagittarius('Sagittarius', '♐'),
  capricorn('Capricorn', '♑'),
  aquarius('Aquarius', '♒'),
  pisces('Pisces', '♓');

  const ZodiacSign(this.name, this.symbol);
  final String name;
  final String symbol;

  static ZodiacSign? fromString(String? value) {
    if (value == null) return null;
    try {
      return ZodiacSign.values.firstWhere(
        (sign) => sign.name.toLowerCase() == value.toLowerCase(),
      );
    } catch (e) {
      return null;
    }
  }

  static ZodiacSign fromBirthDate(DateTime birthDate) {
    final month = birthDate.month;
    final day = birthDate.day;

    switch (month) {
      case 1: // January
        return day <= 19 ? ZodiacSign.capricorn : ZodiacSign.aquarius;
      case 2: // February
        return day <= 18 ? ZodiacSign.aquarius : ZodiacSign.pisces;
      case 3: // March
        return day <= 20 ? ZodiacSign.pisces : ZodiacSign.aries;
      case 4: // April
        return day <= 19 ? ZodiacSign.aries : ZodiacSign.taurus;
      case 5: // May
        return day <= 20 ? ZodiacSign.taurus : ZodiacSign.gemini;
      case 6: // June
        return day <= 20 ? ZodiacSign.gemini : ZodiacSign.cancer;
      case 7: // July
        return day <= 22 ? ZodiacSign.cancer : ZodiacSign.leo;
      case 8: // August
        return day <= 22 ? ZodiacSign.leo : ZodiacSign.virgo;
      case 9: // September
        return day <= 22 ? ZodiacSign.virgo : ZodiacSign.libra;
      case 10: // October
        return day <= 22 ? ZodiacSign.libra : ZodiacSign.scorpio;
      case 11: // November
        return day <= 21 ? ZodiacSign.scorpio : ZodiacSign.sagittarius;
      case 12: // December
        return day <= 21 ? ZodiacSign.sagittarius : ZodiacSign.capricorn;
      default:
        return ZodiacSign.aries;
    }
  }
}
