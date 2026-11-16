import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:ancestry_day/texts.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:ancestry_day/lunar/lunar_calendar.dart';

/// Checks lib/l10n/app_*.arb. Run after editing a translation.
void main() {
  Map<String, dynamic> read(File f) =>
      jsonDecode(f.readAsStringSync()) as Map<String, dynamic>;
  Set<String> keys(Map<String, dynamic> arb) =>
      arb.keys.where((k) => !k.startsWith('@')).toSet();

  /// The placeholder names English declares for [key].
  Iterable<String> declared(Map<String, dynamic> english, String key) =>
      ((english['@$key'] as Map?)?['placeholders'] as Map? ?? const {}).keys
          .cast<String>();

  final english = read(File('lib/l10n/app_en.arb'));
  final files = Directory('lib/l10n')
      .listSync()
      .whereType<File>()
      .where((f) => f.path.endsWith('.arb'))
      .toList();

  test('every language in the picker has a file', () {
    expect(
      {for (final f in files) f.uri.pathSegments.last},
      {for (final key in languageNames.keys) 'app_$key.arb'},
    );
  });

  for (final file in files) {
    final name = file.uri.pathSegments.last;
    test('$name has every string, with the same placeholders as English', () {
      final arb = read(file);
      expect(keys(arb), keys(english));
      for (final key in keys(english)) {
        final text = arb[key] as String;
        expect(text.trim(), isNotEmpty, reason: key);
        final names = declared(english, key);
        for (final name in names) {
          expect(
            text.contains('{$name}') || text.contains('{$name,'),
            isTrue,
            reason: '$key thiếu {$name}',
          );
        }
        if (names.isEmpty) expect(text.contains('{'), isFalse, reason: key);
      }
    });
  }

  test('lunar dates read naturally in each language', () async {
    await initializeDateFormatting();
    String words(String key) =>
        AppTexts(localeOfKey(key)).lunarDayMonth(7, 15, marked: false);
    expect(
      AppTexts(localeOfKey('vi')).lunarDayMonth(1, 5),
      'mùng 5 tháng Giêng âm lịch',
    );
    expect(
      AppTexts(localeOfKey('vi'))
          .lunarDayMonth(4, 20, isLeap: true, marked: false),
      '20 tháng 4 nhuận',
    );
    expect(words('zh'), '七月十五');
    expect(AppTexts(localeOfKey('zh_Hant')).lunarDayMonth(12, 23), '農曆臘月廿三');
    expect(words('ja'), '7月15日');
    expect(words('ko'), '7월 15일');
    expect(words('en'), 'day 15 of month 7');
    expect(
      AppTexts(localeOfKey('vi')).yearName(2026, LunarRegion.vietnam),
      'năm Bính Ngọ',
    );
    expect(
      AppTexts(localeOfKey('zh')).yearName(2026, LunarRegion.china),
      '丙午年',
    );
    expect(
      AppTexts(localeOfKey('en')).yearName(2023, LunarRegion.vietnam),
      'Year of the Cat',
    );
    expect(
      AppTexts(localeOfKey('en')).yearName(2023, LunarRegion.china),
      'Year of the Rabbit',
    );
    expect(AppTexts(localeOfKey('vi')).anniversary(1), 'Giỗ đầu');
    expect(AppTexts(localeOfKey('vi')).anniversary(21), 'Giỗ lần thứ 21');
    expect(AppTexts(localeOfKey('ja')).anniversary(2), '三回忌');
    expect(AppTexts(localeOfKey('ja')).anniversary(6), '七回忌');
  });

  test('the phone language picks the app language and suggests a calendar', () {
    expect(languageKeyOf(resolveLocale(const [Locale('zh', 'TW')])), 'zh_Hant');
    expect(languageKeyOf(resolveLocale(const [Locale('zh', 'CN')])), 'zh');
    expect(
      languageKeyOf(resolveLocale(const [Locale('fr'), Locale('ko')])),
      'ko',
    );
    expect(languageKeyOf(resolveLocale(const [Locale('fr')])), 'en');
    expect(suggestRegion(const [Locale('vi', 'US')]), LunarRegion.vietnam);
    expect(suggestRegion(const [Locale('en', 'KR')]), LunarRegion.korea);
    expect(suggestRegion(const [Locale('zh', 'TW')]), LunarRegion.china);
    expect(suggestRegion(const [Locale('ja', 'JP')]), LunarRegion.japan);
  });
}
