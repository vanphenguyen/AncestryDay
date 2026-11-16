import '../lunar/lunar_calendar.dart';
import 'occurrences.dart';

/// A stretch of days on which two countries' lunar calendars show different
/// dates.
class CalendarDifference {
  const CalendarDifference({
    required this.from,
    required this.to,
    required this.others,
    required this.here,
    required this.there,
  });

  /// First and last solar day of the stretch.
  final DateTime from;
  final DateTime to;

  /// The countries that differ from the chosen one.
  final List<LunarRegion> others;

  /// The lunar date on [from] in the chosen country, and in [others].
  final LunarDate here;
  final LunarDate there;

  int get days => daysBetween(from, to) + 1;
}

/// Every stretch from [from] to [to] on which [region]'s lunar calendar
/// differs from another country's, oldest first.
List<CalendarDifference> calendarDifferences(
  LunarRegion region,
  DateTime from,
  DateTime to,
) {
  final here = LunarCalendar(region);
  final result = <CalendarDifference>[];
  for (final group in regionGroups) {
    if (group.contains(region)) continue;
    final there = LunarCalendar(group.first);
    DateTime? start;
    LunarDate? hereAtStart;
    LunarDate? thereAtStart;
    for (var day = from; !day.isAfter(to); day = addDays(day, 1)) {
      final a = here.fromSolar(day);
      final b = there.fromSolar(day);
      if (a != b) {
        start ??= day;
        hereAtStart ??= a;
        thereAtStart ??= b;
      } else if (start != null) {
        result.add(
          CalendarDifference(
            from: start,
            to: addDays(day, -1),
            others: group,
            here: hereAtStart!,
            there: thereAtStart!,
          ),
        );
        start = hereAtStart = thereAtStart = null;
      }
    }
  }
  return result..sort((a, b) => a.from.compareTo(b.from));
}
