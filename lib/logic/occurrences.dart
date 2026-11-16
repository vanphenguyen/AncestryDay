import 'dart:math' as math;

import '../lunar/lunar_calendar.dart';
import '../models/memorial.dart';
import '../models/observance.dart';

/// [moment] with the time of day removed.
DateTime dayOf(DateTime moment) =>
    DateTime(moment.year, moment.month, moment.day);

/// [day] moved by [days] (calendar days, so daylight saving cannot shift it).
DateTime addDays(DateTime day, int days) =>
    DateTime(day.year, day.month, day.day + days);

/// Whole days from [from] to [to].
int daysBetween(DateTime from, DateTime to) =>
    LunarCalendar.dayNumberOf(to) - LunarCalendar.dayNumberOf(from);

/// The solar day on which lunar [month]/[day] is observed in [lunarYear].
/// It is always the regular month (never the leap one), and day 30 moves to
/// day 29 in a short month, as families do.
DateTime observedLunarDay(
  LunarCalendar calendar,
  int lunarYear,
  int month,
  int day,
) {
  final length = calendar.daysInMonth(lunarYear, month);
  return calendar.toSolar(LunarDate(lunarYear, month, math.min(day, length)))!;
}

/// The solar day [month]/[day] of [year]; 29 February moves to the 28th.
DateTime observedSolarDay(int year, int month, int day) {
  final length = DateTime(year, month + 1, 0).day;
  return DateTime(year, month, math.min(day, length));
}

/// Countries whose calendars always agree are compared as one.
const regionGroups = [
  [LunarRegion.vietnam],
  [LunarRegion.china],
  [LunarRegion.korea, LunarRegion.japan],
];

/// The same lunar day falling on another solar day in other countries.
class RegionVariant {
  const RegionVariant(this.regions, this.date);

  final List<LunarRegion> regions;
  final DateTime date;
}

/// Where lunar [month]/[day] of [lunarYear] falls on a different solar day
/// in other countries' calendars than in [region]'s. Empty in most years.
List<RegionVariant> variantsElsewhere(
  LunarRegion region,
  int lunarYear,
  int month,
  int day,
) {
  final here = observedLunarDay(LunarCalendar(region), lunarYear, month, day);
  // Countries that agree with each other are reported together.
  final byDate = <DateTime, List<LunarRegion>>{};
  for (final group in regionGroups) {
    if (group.contains(region)) continue;
    final there = observedLunarDay(
      LunarCalendar(group.first),
      lunarYear,
      month,
      day,
    );
    if (there != here) byDate.putIfAbsent(there, () => []).addAll(group);
  }
  return [
    for (final entry in byDate.entries) RegionVariant(entry.value, entry.key),
  ];
}

/// One year's remembrance day of one person.
class MemorialOccurrence {
  const MemorialOccurrence({
    required this.memorial,
    required this.date,
    required this.calendarYear,
    this.lunar,
    this.elsewhere = const [],
  });

  final Memorial memorial;

  /// The solar day it is observed on.
  final DateTime date;

  /// The year (lunar or solar, like the memorial) this occurrence is in.
  final int calendarYear;

  /// The lunar date observed, for lunar memorials.
  final LunarDate? lunar;

  /// Other countries' calendars that put it on another day this year.
  final List<RegionVariant> elsewhere;

  /// Which anniversary this is (1 = first), when the year of passing is
  /// known.
  int? get nth {
    final year = memorial.year;
    if (year == null || calendarYear <= year) return null;
    return calendarYear - year;
  }
}

/// The remembrance days of [memorial] from [from] to [to], both included,
/// oldest first.
List<MemorialOccurrence> memorialOccurrences(
  Memorial memorial,
  LunarRegion region,
  DateTime from,
  DateTime to,
) {
  final result = <MemorialOccurrence>[];
  final calendar = LunarCalendar(region);
  for (var year = from.year - 1; year <= to.year + 1; year++) {
    final MemorialOccurrence occurrence;
    if (memorial.kind == CalendarKind.lunar) {
      final date = observedLunarDay(
        calendar,
        year,
        memorial.month,
        memorial.day,
      );
      occurrence = MemorialOccurrence(
        memorial: memorial,
        date: date,
        calendarYear: year,
        lunar: calendar.fromSolar(date),
        elsewhere: variantsElsewhere(
          region,
          year,
          memorial.month,
          memorial.day,
        ),
      );
    } else {
      occurrence = MemorialOccurrence(
        memorial: memorial,
        date: observedSolarDay(year, memorial.month, memorial.day),
        calendarYear: year,
      );
    }
    if (!occurrence.date.isBefore(from) && !occurrence.date.isAfter(to)) {
      result.add(occurrence);
    }
  }
  return result;
}

/// The next [count] remembrance days of [memorial], starting with [from].
List<MemorialOccurrence> nextMemorialOccurrences(
  Memorial memorial,
  LunarRegion region,
  DateTime from, {
  int count = 1,
}) => memorialOccurrences(
  memorial,
  region,
  from,
  DateTime(from.year + count + 1, from.month, from.day),
).take(count).toList();

/// One day on which a shared observance falls.
class ObservanceOccurrence {
  const ObservanceOccurrence({required this.observance, required this.date});

  final Observance observance;
  final DateTime date;
}

/// The days of [observance] from [from] to [to], both included.
List<ObservanceOccurrence> observanceOccurrences(
  Observance observance,
  LunarRegion region,
  DateTime from,
  DateTime to,
) {
  final calendar = LunarCalendar(region);
  final rule = observance.rule;
  final days = <DateTime>[];
  switch (rule.type) {
    case ObservanceRuleType.lunarMonthly:
      // Walk month by month from the start of the lunar month [from] is in.
      var monthStart = addDays(from, 1 - calendar.fromSolar(from).day);
      while (!monthStart.isAfter(to)) {
        final length = calendar.fromSolar(addDays(monthStart, 29)).day == 30
            ? 30
            : 29;
        days.add(addDays(monthStart, math.min(rule.day, length) - 1));
        monthStart = addDays(monthStart, length);
      }
    case ObservanceRuleType.lunar:
      for (var year = from.year - 1; year <= to.year + 1; year++) {
        days.add(observedLunarDay(calendar, year, rule.month, rule.day));
      }
    case ObservanceRuleType.solar:
      for (var year = from.year; year <= to.year; year++) {
        days.add(observedSolarDay(year, rule.month, rule.day));
      }
    case ObservanceRuleType.solarTerm:
      for (var year = from.year - 1; year <= to.year; year++) {
        days.add(
          addDays(calendar.solarTermDay(year, rule.longitude), rule.offsetDays),
        );
      }
  }
  return [
    for (final day in days)
      if (!day.isBefore(from) && !day.isAfter(to))
        ObservanceOccurrence(observance: observance, date: day),
  ];
}

/// Everything remembered on one day.
class AgendaDay {
  AgendaDay(this.date);

  final DateTime date;
  final memorials = <MemorialOccurrence>[];
  final observances = <ObservanceOccurrence>[];
}

/// The days from [from] to [to] that have something to remember, oldest
/// first. A plain "first of the month" or "fifteenth" is left out on a day
/// that already has a named festival (Tết, Vu Lan...).
List<AgendaDay> buildAgenda({
  required List<Memorial> memorials,
  required List<Observance> observances,
  required LunarRegion region,
  required DateTime from,
  required DateTime to,
}) {
  final days = <int, AgendaDay>{};
  AgendaDay at(DateTime date) =>
      days.putIfAbsent(LunarCalendar.dayNumberOf(date), () => AgendaDay(date));

  for (final memorial in memorials) {
    for (final o in memorialOccurrences(memorial, region, from, to)) {
      at(o.date).memorials.add(o);
    }
  }
  for (final observance in observances) {
    for (final o in observanceOccurrences(observance, region, from, to)) {
      at(o.date).observances.add(o);
    }
  }
  for (final day in days.values) {
    bool monthly(ObservanceOccurrence o) =>
        o.observance.rule.type == ObservanceRuleType.lunarMonthly;
    if (day.observances.any((o) => !monthly(o))) {
      day.observances.removeWhere(monthly);
    }
  }
  final keys = days.keys.toList()..sort();
  return [for (final key in keys) days[key]!];
}
