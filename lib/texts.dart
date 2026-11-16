import 'dart:ui';

import 'package:intl/intl.dart';

import 'l10n/app_localizations.dart';
import 'logic/occurrences.dart';
import 'lunar/lunar_calendar.dart';
import 'models/observance.dart';

/// The app's name: "Nhớ Ngày Giỗ" in Vietnamese, "AncestryDay" everywhere
/// else. The name under the app icon follows the same rule (see
/// `ios/Runner/*.lproj/InfoPlist.strings` and Android's `values*/strings.xml`).
String appNameFor(String language) =>
    language == 'vi' ? 'Nhớ Ngày Giỗ' : 'AncestryDay';

/// Each language the app has, by its own name, in the order shown in the
/// language list. The key is what is saved when the user picks one.
const languageNames = <String, String>{
  'vi': 'Tiếng Việt',
  'en': 'English',
  'zh': '简体中文',
  'zh_Hant': '繁體中文',
  'ja': '日本語',
  'ko': '한국어',
};

/// "zh_Hant" for Traditional Chinese, otherwise the language code.
String languageKeyOf(Locale locale) =>
    locale.languageCode == 'zh' && locale.scriptCode == 'Hant'
    ? 'zh_Hant'
    : locale.languageCode;

Locale localeOfKey(String key) => key == 'zh_Hant'
    ? const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant')
    : Locale(key);

const _traditionalChineseCountries = {'TW', 'HK', 'MO'};

/// Picks the app language: the first of the phone's languages that the app
/// has a translation for, otherwise English.
Locale resolveLocale(List<Locale>? deviceLocales) {
  for (final device in deviceLocales ?? const <Locale>[]) {
    if (device.languageCode == 'zh') {
      final traditional =
          device.scriptCode == 'Hant' ||
          (device.scriptCode == null &&
              _traditionalChineseCountries.contains(device.countryCode));
      return localeOfKey(traditional ? 'zh_Hant' : 'zh');
    }
    if (languageNames.containsKey(device.languageCode)) {
      return Locale(device.languageCode);
    }
  }
  return const Locale(LocalizedText.fallbackLanguage);
}

/// The lunar calendar most likely meant by someone with these phone
/// settings. Only a suggestion: the welcome screen always asks.
LunarRegion suggestRegion(List<Locale>? deviceLocales) {
  const byCountry = {
    'VN': LunarRegion.vietnam,
    'CN': LunarRegion.china,
    'TW': LunarRegion.china,
    'HK': LunarRegion.china,
    'MO': LunarRegion.china,
    'SG': LunarRegion.china,
    'MY': LunarRegion.china,
    'KR': LunarRegion.korea,
    'JP': LunarRegion.japan,
  };
  const byLanguage = {
    'vi': LunarRegion.vietnam,
    'zh': LunarRegion.china,
    'ko': LunarRegion.korea,
    'ja': LunarRegion.japan,
  };
  final locales = deviceLocales ?? const <Locale>[];
  // The language says more than the country: a Vietnamese speaker abroad
  // still follows the Vietnamese calendar.
  for (final locale in locales) {
    final region = byLanguage[locale.languageCode];
    if (region != null) return region;
  }
  for (final locale in locales) {
    final region = byCountry[locale.countryCode];
    if (region != null) return region;
  }
  return LunarRegion.vietnam;
}

// Calendar vocabulary that cannot be a plain translated sentence.

const _stems = {
  'vi': [
    'Giáp',
    'Ất',
    'Bính',
    'Đinh',
    'Mậu',
    'Kỷ',
    'Canh',
    'Tân',
    'Nhâm',
    'Quý',
  ],
  'han': ['甲', '乙', '丙', '丁', '戊', '己', '庚', '辛', '壬', '癸'],
  'ko': ['갑', '을', '병', '정', '무', '기', '경', '신', '임', '계'],
};

const _branches = {
  'vi': [
    'Tý',
    'Sửu',
    'Dần',
    'Mão',
    'Thìn',
    'Tỵ',
    'Ngọ',
    'Mùi',
    'Thân',
    'Dậu',
    'Tuất',
    'Hợi',
  ],
  'han': ['子', '丑', '寅', '卯', '辰', '巳', '午', '未', '申', '酉', '戌', '亥'],
  'ko': ['자', '축', '인', '묘', '진', '사', '오', '미', '신', '유', '술', '해'],
};

const _animals = [
  'Rat',
  'Ox',
  'Tiger',
  'Rabbit',
  'Dragon',
  'Snake',
  'Horse',
  'Goat',
  'Monkey',
  'Rooster',
  'Dog',
  'Pig',
];

/// The Vietnamese zodiac has a buffalo and a cat where others have an ox
/// and a rabbit.
const _animalsVietnam = {1: 'Buffalo', 3: 'Cat'};

const _hanDigits = ['', '一', '二', '三', '四', '五', '六', '七', '八', '九', '十'];

String _hanDay(int day) {
  if (day <= 10) return '初${_hanDigits[day]}';
  if (day < 20) return '十${_hanDigits[day - 10]}';
  if (day == 20) return '二十';
  if (day < 30) return '廿${_hanDigits[day - 20]}';
  return '三十';
}

String _hanMonth(int month, {required bool traditional}) => switch (month) {
  1 => '正月',
  11 => '冬月',
  12 => traditional ? '臘月' : '腊月',
  _ => '${_hanDigits[month]}月',
};

/// Japanese memorial services are named by count, starting at "the third"
/// two years after the death.
const _japaneseNenki = {
  6: '七回忌',
  12: '十三回忌',
  16: '十七回忌',
  22: '二十三回忌',
  26: '二十七回忌',
  32: '三十三回忌',
  49: '五十回忌',
};

/// Everything the app says, in one language: the translated interface
/// strings ([l10n]) plus text that is put together in code.
class AppTexts {
  AppTexts(this.locale) : l10n = lookupAppLocalizations(locale);

  final Locale locale;
  final AppLocalizations l10n;

  /// "vi", "en", "zh", "zh_Hant", "ja" or "ko".
  String get language => languageKeyOf(locale);

  String get _intl => language == 'zh_Hant' ? 'zh_TW' : language;

  String get appName => appNameFor(language);

  /// A [LocalizedText] from the data files, in this language.
  String resolve(LocalizedText text) => text.resolve(language);

  // -- Solar dates

  /// e.g. "Monday, November 16".
  String weekdayAndDate(DateTime day) =>
      capitalized(DateFormat.MMMMEEEEd(_intl).format(day));

  /// e.g. "Mon, Nov 16, 2026".
  String fullDate(DateTime day) => DateFormat.yMMMEd(_intl).format(day);

  /// e.g. "Nov 16, 2026".
  String date(DateTime day) => DateFormat.yMMMd(_intl).format(day);

  /// e.g. "November 2026".
  String monthAndYear(DateTime day) =>
      capitalized(DateFormat.yMMMM(_intl).format(day));

  /// [text] with a capital first letter, for the start of a line.
  static String capitalized(String text) =>
      text.isEmpty ? text : text[0].toUpperCase() + text.substring(1);

  /// e.g. "Nov".
  String shortMonth(DateTime day) => DateFormat.MMM(_intl).format(day);

  /// e.g. "Mon".
  String shortWeekday(DateTime day) => DateFormat.E(_intl).format(day);

  /// One or two letters; 1 = Monday ... 7 = Sunday.
  String weekdayInitial(int weekday) =>
      // 1 January 2024 was a Monday.
      DateFormat.E(_intl).format(DateTime(2024, 1, weekday));

  // -- Lunar dates

  String regionName(LunarRegion region) => switch (region) {
    LunarRegion.vietnam => l10n.regionVietnam,
    LunarRegion.china => l10n.regionChina,
    LunarRegion.korea => l10n.regionKorea,
    LunarRegion.japan => l10n.regionJapan,
  };

  String regionHint(LunarRegion region) => switch (region) {
    LunarRegion.vietnam => l10n.regionVietnamHint,
    LunarRegion.china => l10n.regionChinaHint,
    LunarRegion.korea => l10n.regionKoreaHint,
    LunarRegion.japan => l10n.regionJapanHint,
  };

  String regionNames(List<LunarRegion> regions) =>
      regions.map(regionName).join(' · ');

  /// A lunar day and month in words, e.g. "mùng 5 tháng Giêng", "七月十五",
  /// "the 15th of lunar month 7". With [marked], languages whose wording
  /// does not already say so add "lunar" ("âm lịch", "旧暦", "음력").
  String lunarDayMonth(
    int month,
    int day, {
    bool isLeap = false,
    bool marked = true,
  }) {
    switch (language) {
      case 'vi':
        final dayWords = day <= 10 ? 'mùng $day' : '$day';
        final monthWords = switch (month) {
          1 => 'Giêng',
          12 => 'Chạp',
          _ => '$month',
        };
        return '$dayWords tháng $monthWords${isLeap ? ' nhuận' : ''}${marked ? ' âm lịch' : ''}';
      case 'zh':
        return '${marked ? '农历' : ''}${isLeap ? '闰' : ''}'
            '${_hanMonth(month, traditional: false)}${_hanDay(day)}';
      case 'zh_Hant':
        return '${marked ? '農曆' : ''}${isLeap ? '閏' : ''}'
            '${_hanMonth(month, traditional: true)}${_hanDay(day)}';
      case 'ja':
        return '${marked ? '旧暦' : ''}${isLeap ? '閏' : ''}$month月$day日';
      case 'ko':
        return '${marked ? '음력 ' : ''}${isLeap ? '윤' : ''}$month월 $day일';
      default:
        final monthWords =
            '${isLeap ? 'leap ' : ''}${marked ? 'lunar ' : ''}month $month';
        return 'day $day of $monthWords';
    }
  }

  String lunarDate(LunarDate date, {bool marked = true}) =>
      lunarDayMonth(date.month, date.day, isLeap: date.isLeap, marked: marked);

  /// [lunarDate] for the start of a line ("Mùng 8 tháng 10", "The 8th of...").
  String lunarDateTitle(LunarDate date, {bool marked = true}) =>
      capitalized(lunarDate(date, marked: marked));

  /// The name of a lunar year in the sixty-year cycle, e.g. "năm Bính Ngọ",
  /// "丙午年", "Year of the Horse".
  String yearName(int lunarYear, LunarRegion region) {
    final stem = (lunarYear + 6) % 10;
    final branch = (lunarYear + 8) % 12;
    switch (language) {
      case 'vi':
        return 'năm ${_stems['vi']![stem]} ${_branches['vi']![branch]}';
      case 'zh' || 'zh_Hant':
        return '${_stems['han']![stem]}${_branches['han']![branch]}年';
      case 'ja':
        return '${_stems['han']![stem]}${_branches['han']![branch]}の年';
      case 'ko':
        return '${_stems['ko']![stem]}${_branches['ko']![branch]}년';
      default:
        final animal = region == LunarRegion.vietnam
            ? _animalsVietnam[branch] ?? _animals[branch]
            : _animals[branch];
        return 'Year of the $animal';
    }
  }

  /// "Giỗ đầu", "三回忌", "5 years since passing"...
  String anniversary(int nth) =>
      (language == 'ja' ? _japaneseNenki[nth] : null) ??
      l10n.anniversaryNth(nth);

  // -- Sentences about occurrences

  /// The names of a day's shared observances, e.g. "Ngày rằm · Lễ Vu Lan".
  String observanceTitles(List<ObservanceOccurrence> observances) =>
      observances.map((o) => resolve(o.observance.title)).join(' · ');

  /// One line per other calendar that puts this day elsewhere this year.
  List<String> variantWarnings(MemorialOccurrence occurrence) => [
    for (final variant in occurrence.elsewhere)
      l10n.differsElsewhere(regionNames(variant.regions), date(variant.date)),
  ];
}
