/// A piece of text written in several languages, keyed by language code
/// ("vi", "en", "zh", "zh_Hant", "ja", "ko"), as found in
/// `assets/observances/*.json`.
class LocalizedText {
  const LocalizedText(this.byLanguage);

  factory LocalizedText.fromJson(Object? json) {
    if (json is! Map || json.isEmpty) {
      throw const FormatException(
        'Cần chữ cho từng ngôn ngữ, ví dụ {"vi": "...", "en": "..."}',
      );
    }
    return LocalizedText({
      for (final entry in json.entries)
        entry.key as String: entry.value as String,
    });
  }

  /// Used when a language has no text of its own.
  static const fallbackLanguage = 'en';

  final Map<String, String> byLanguage;

  String resolve(String language) =>
      byLanguage[language] ??
      byLanguage[fallbackLanguage] ??
      byLanguage.values.first;
}

/// How the day of an [Observance] is found.
enum ObservanceRuleType {
  /// The same day of every lunar month (mùng một, rằm), leap months included.
  lunarMonthly,

  /// One lunar day a year. Day 30 means "the last day of the month".
  lunar,

  /// One solar day a year.
  solar,

  /// The day the sun reaches a given longitude (Thanh minh, the equinoxes,
  /// the winter solstice), optionally some days later.
  solarTerm,
}

class ObservanceRule {
  const ObservanceRule.lunarMonthly(this.day)
    : type = ObservanceRuleType.lunarMonthly,
      month = 0,
      longitude = 0,
      offsetDays = 0;

  const ObservanceRule.lunar(this.month, this.day)
    : type = ObservanceRuleType.lunar,
      longitude = 0,
      offsetDays = 0;

  const ObservanceRule.solar(this.month, this.day)
    : type = ObservanceRuleType.solar,
      longitude = 0,
      offsetDays = 0;

  const ObservanceRule.solarTerm(this.longitude, {this.offsetDays = 0})
    : type = ObservanceRuleType.solarTerm,
      month = 0,
      day = 0;

  factory ObservanceRule.fromJson(Map<String, dynamic> json) {
    int field(String name, int min, int max) {
      final value = json[name];
      if (value is! int || value < min || value > max) {
        throw FormatException(
          '"$name" phải là số từ $min đến $max, đang là: $value',
        );
      }
      return value;
    }

    switch (json['type']) {
      case 'lunarMonthly':
        return ObservanceRule.lunarMonthly(field('day', 1, 30));
      case 'lunar':
        return ObservanceRule.lunar(field('month', 1, 12), field('day', 1, 30));
      case 'solar':
        return ObservanceRule.solar(field('month', 1, 12), field('day', 1, 31));
      case 'solarTerm':
        return ObservanceRule.solarTerm(
          field('longitude', 0, 359).toDouble(),
          offsetDays: json.containsKey('offsetDays')
              ? field('offsetDays', -30, 200)
              : 0,
        );
      default:
        throw FormatException('Kiểu ngày không hợp lệ: ${json['type']}');
    }
  }

  final ObservanceRuleType type;
  final int month;
  final int day;
  final double longitude;
  final int offsetDays;
}

/// A day of remembrance shared by everyone in a country: the first and the
/// fifteenth of each lunar month, Tết, Thanh minh, Vu Lan, Chuseok, Obon...
class Observance {
  const Observance({
    required this.id,
    required this.title,
    required this.rule,
    required this.enabledByDefault,
  });

  factory Observance.fromJson(Map<String, dynamic> json) => Observance(
    id: json['id'] as String,
    title: LocalizedText.fromJson(json['title']),
    rule: ObservanceRule.fromJson(json['rule'] as Map<String, dynamic>),
    enabledByDefault: json['default'] as bool? ?? false,
  );

  final String id;
  final LocalizedText title;
  final ObservanceRule rule;

  /// Whether the app reminds about it before the user has chosen.
  final bool enabledByDefault;
}
