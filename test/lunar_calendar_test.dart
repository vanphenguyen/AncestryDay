import 'dart:convert';
import 'dart:io';

import 'package:ancestry_day/lunar/lunar_calendar.dart';
import 'package:flutter_test/flutter_test.dart';

/// Checks the lunar calendar engine: the heart of the app. A wrong day here
/// means a family remembers on the wrong day.
void main() {
  final vn = LunarCalendar(LunarRegion.vietnam);
  final cn = LunarCalendar(LunarRegion.china);
  final kr = LunarCalendar(LunarRegion.korea);
  final jp = LunarCalendar(LunarRegion.japan);

  DateTime newYear(LunarCalendar c, int year) =>
      c.toSolar(LunarDate(year, 1, 1))!;

  test('Tết falls on the days Vietnam actually celebrated', () {
    const known = {
      1985: (1, 21),
      2007: (2, 17),
      2020: (1, 25),
      2021: (2, 12),
      2022: (2, 1),
      2023: (1, 22),
      2024: (2, 10),
      2025: (1, 29),
      2026: (2, 17),
      2027: (2, 6),
      2028: (1, 26),
      2029: (2, 13),
      2030: (2, 2),
    };
    known.forEach((year, day) {
      expect(
        newYear(vn, year),
        DateTime(year, day.$1, day.$2),
        reason: '$year',
      );
    });
  });

  test('the countries differ exactly where history says they do', () {
    // 1985: Vietnam's Tết came a whole month before China's.
    expect(newYear(vn, 1985), DateTime(1985, 1, 21));
    expect(newYear(cn, 1985), DateTime(1985, 2, 20));
    // 2030: one day apart.
    expect(newYear(vn, 2030), DateTime(2030, 2, 2));
    expect(newYear(cn, 2030), DateTime(2030, 2, 3));
    // Korea a day after China.
    expect(newYear(cn, 1997), DateTime(1997, 2, 7));
    expect(newYear(kr, 1997), DateTime(1997, 2, 8));
    expect(newYear(cn, 2028), DateTime(2028, 1, 26));
    expect(newYear(kr, 2028), DateTime(2028, 1, 27));
    // 2012: Korea repeated month 3, China and Vietnam month 4.
    expect(kr.leapMonthOf(2012), 3);
    expect(cn.leapMonthOf(2012), 4);
    expect(vn.leapMonthOf(2012), 4);
  });

  test('Korea and Japan share a meridian and so a calendar', () {
    for (
      var d = DateTime(2020);
      d.year < 2040;
      d = DateTime(d.year, d.month, d.day + 17)
    ) {
      expect(jp.fromSolar(d), kr.fromSolar(d));
    }
  });

  test('leap months', () {
    expect(vn.leapMonthOf(2023), 2);
    expect(vn.leapMonthOf(2025), 6);
    expect(vn.leapMonthOf(2026), 0);
    expect(vn.leapMonthOf(2028), 5);
    expect(cn.leapMonthOf(2033), 11);
    expect(vn.toSolar(const LunarDate(2026, 6, 1, isLeap: true)), isNull);
    expect(
      vn.fromSolar(DateTime(2025, 7, 25)),
      const LunarDate(2025, 6, 1, isLeap: true),
    );
  });

  test('every day converts there and back', () {
    for (final calendar in [vn, cn, kr]) {
      var previous = calendar.fromSolar(DateTime(1950, 1, 1));
      for (var n = 1; n < 366 * 150; n++) {
        final day = DateTime(1950, 1, 1 + n);
        final lunar = calendar.fromSolar(day);
        expect(calendar.toSolar(lunar), day, reason: '$day ${calendar.region}');
        // Days count up by one, or a new month starts.
        expect(
          lunar.day == previous.day + 1 ||
              (lunar.day == 1 && previous.day >= 29),
          isTrue,
          reason: '$day ${calendar.region}: $previous then $lunar',
        );
        previous = lunar;
      }
    }
  });

  test('a day that does not exist gives null', () {
    final short = [for (var m = 1; m <= 12; m++) m]
        .firstWhere((m) => vn.daysInMonth(2026, m) == 29);
    expect(vn.toSolar(LunarDate(2026, short, 30)), isNull);
    expect(vn.toSolar(LunarDate(2026, short, 29)), isNotNull);
  });

  test('solar terms', () {
    expect(vn.solarTermDay(2026, 15), DateTime(2026, 4, 5)); // Thanh minh
    expect(
      cn.solarTermDay(2026, 270),
      DateTime(2026, 12, 22),
    ); // winter solstice
    expect(jp.solarTermDay(2026, 0), DateTime(2026, 3, 20)); // spring equinox
    expect(jp.solarTermDay(2026, 180), DateTime(2026, 9, 23)); // autumn equinox
  });

  // ICU is the calendar data inside phones and browsers. It was dumped by
  // tool/make_reference.js. The engine agrees with it for all but a few of
  // 4230 months; those few are months whose new moon falls within minutes
  // of midnight, where ICU's rougher astronomy picks the neighbouring day.
  // For the ones that have already happened or are officially published
  // (Chinese New Year 1954, 2027 and 2030, the leap month of 1987, the Korean
  // second month of 2017...) the official almanacs agree with this engine.
  group('agrees with ICU from 1930 to 2100', () {
    final reference = jsonDecode(
      File('test/fixtures/icu_months.json').readAsStringSync(),
    ) as Map<String, dynamic>;
    const knownIcuErrors = {
      'chinese': {
        '1954-02-04',
        '1955-02-23',
        '1987-07-26',
        '1987-08-24',
        '1999-01-18',
        '2012-08-18',
        '2018-11-07',
        '2027-02-07',
        '2030-02-02',
        '2057-09-29',
        '2070-03-13',
      },
      // Before 1961 Korea's clocks were not on today's meridian.
      'dangi': {'2017-02-27', '2051-08-06', '2051-11-04', '2097-01-14'},
    };
    for (final entry in {'chinese': cn, 'dangi': kr}.entries) {
      test(entry.key, () {
        final different = <String>{};
        for (final row in reference[entry.key] as List) {
          final parts = (row as String).split(' ');
          if (entry.key == 'dangi' && parts[0].compareTo('1962') < 0) continue;
          final d = DateTime.parse(parts[0]);
          final lunar = entry.value.fromSolar(DateTime(d.year, d.month, d.day));
          final month = '${lunar.isLeap ? 'L' : ''}${lunar.month}';
          if (lunar.day != 1 || month != parts[1]) different.add(parts[0]);
        }
        expect(different, knownIcuErrors[entry.key]);
      });
    }
  });
}
