import 'package:ancestry_day/logic/differences.dart';
import 'package:ancestry_day/logic/occurrences.dart';
import 'package:ancestry_day/logic/reminder_plan.dart';
import 'package:ancestry_day/lunar/lunar_calendar.dart';
import 'package:ancestry_day/models/memorial.dart';
import 'package:ancestry_day/models/observance.dart';
import 'package:ancestry_day/models/settings.dart';
import 'package:flutter_test/flutter_test.dart';

Memorial lunar(String id, int month, int day, {int? year}) => Memorial(
  id: id,
  name: id,
  kind: CalendarKind.lunar,
  month: month,
  day: day,
  year: year,
);

void main() {
  const vn = LunarRegion.vietnam;

  test('a lunar remembrance day moves through the solar year', () {
    final days = nextMemorialOccurrences(
      lunar('a', 3, 10, year: 2020),
      vn,
      DateTime(2026, 1, 1),
      count: 3,
    );
    expect(
      [for (final d in days) d.date],
      [DateTime(2026, 4, 26), DateTime(2027, 4, 16), DateTime(2028, 4, 4)],
    );
    expect([for (final d in days) d.nth], [6, 7, 8]);
    expect(days.first.lunar, const LunarDate(2026, 3, 10));
  });

  test('today counts as the next occurrence', () {
    final next = nextMemorialOccurrences(
      lunar('a', 3, 10),
      vn,
      DateTime(2026, 4, 26),
    ).single;
    expect(next.date, DateTime(2026, 4, 26));
    expect(next.nth, isNull);
  });

  test('day 30 is kept on the 29th when the month is short', () {
    final cal = LunarCalendar(vn);
    for (var year = 2026; year < 2036; year++) {
      final date = observedLunarDay(cal, year, 2, 30);
      final l = cal.fromSolar(date);
      expect(l.month, 2);
      expect(l.isLeap, isFalse);
      expect(l.day, cal.daysInMonth(year, 2));
    }
  });

  test('a solar day stays put; 29 February moves to the 28th', () {
    const m = Memorial(
      id: 's',
      name: 's',
      kind: CalendarKind.solar,
      month: 2,
      day: 29,
      year: 2000,
    );
    final days = nextMemorialOccurrences(
      m,
      LunarRegion.japan,
      DateTime(2027, 1, 1),
      count: 2,
    );
    expect(days[0].date, DateTime(2027, 2, 28));
    expect(days[1].date, DateTime(2028, 2, 29));
    expect(days[0].nth, 27);
    expect(days[0].elsewhere, isEmpty);
  });

  test('warns when another country puts the day elsewhere', () {
    // Tết 2030: 2 February in Vietnam, 3 February in China, Korea and Japan.
    final o = memorialOccurrences(
      lunar('a', 1, 1),
      vn,
      DateTime(2030, 1, 1),
      DateTime(2030, 12, 31),
    ).single;
    expect(o.date, DateTime(2030, 2, 2));
    expect(o.elsewhere.map((v) => v.date).toSet(), {DateTime(2030, 2, 3)});
    expect(o.elsewhere.expand((v) => v.regions).toSet(), {
      LunarRegion.china,
      LunarRegion.korea,
      LunarRegion.japan,
    });
    // Most years nobody disagrees.
    final calm = memorialOccurrences(
      lunar('a', 1, 1),
      vn,
      DateTime(2026, 1, 1),
      DateTime(2026, 12, 31),
    ).single;
    expect(calm.elsewhere, isEmpty);
  });

  test('calendar differences are found as stretches of days', () {
    final all = calendarDifferences(
      vn,
      DateTime(2030, 1, 1),
      DateTime(2030, 12, 31),
    );
    final china = all.firstWhere((d) => d.others.contains(LunarRegion.china));
    expect(china.from, DateTime(2030, 2, 2));
    expect(china.here, const LunarDate(2030, 1, 1));
    expect(china.there.day, 30);
  });

  group('shared days', () {
    Observance o(ObservanceRule rule) => Observance(
      id: 'x',
      title: const LocalizedText({'en': 'x'}),
      rule: rule,
      enabledByDefault: true,
    );
    List<DateTime> dates(ObservanceRule rule, DateTime from, DateTime to) => [
      for (final x in observanceOccurrences(o(rule), vn, from, to)) x.date,
    ];

    test('the fifteenth of every lunar month, leap months included', () {
      final days = dates(
        const ObservanceRule.lunarMonthly(15),
        DateTime(2025, 1, 29),
        DateTime(2026, 2, 16),
      );
      expect(days.length, 13); // the lunar year 2025 has a leap sixth month
      final cal = LunarCalendar(vn);
      expect(days.every((d) => cal.fromSolar(d).day == 15), isTrue);
    });

    test('a festival, the last day of the year, a solar day, a solar term', () {
      expect(
        dates(
          const ObservanceRule.lunar(7, 15),
          DateTime(2026, 1, 1),
          DateTime(2026, 12, 31),
        ),
        [DateTime(2026, 8, 27)],
      );
      final eve = dates(
        const ObservanceRule.lunar(12, 30),
        DateTime(2026, 1, 1),
        DateTime(2026, 12, 31),
      ).single;
      expect(addDays(eve, 1), DateTime(2026, 2, 17));
      expect(
        dates(
          const ObservanceRule.solar(8, 13),
          DateTime(2026, 1, 1),
          DateTime(2027, 12, 31),
        ),
        [DateTime(2026, 8, 13), DateTime(2027, 8, 13)],
      );
      expect(
        dates(
          const ObservanceRule.solarTerm(15),
          DateTime(2026, 1, 1),
          DateTime(2026, 12, 31),
        ),
        [DateTime(2026, 4, 5)],
      );
    });

    test('a named festival replaces the plain fifteenth on its day', () {
      final agenda = buildAgenda(
        memorials: const [],
        observances: [
          o(const ObservanceRule.lunarMonthly(15)),
          Observance(
            id: 'vu-lan',
            title: const LocalizedText({'en': 'Vu Lan'}),
            rule: const ObservanceRule.lunar(7, 15),
            enabledByDefault: true,
          ),
        ],
        region: vn,
        from: DateTime(2026, 8, 27),
        to: DateTime(2026, 8, 27),
      );
      expect(agenda.single.observances.single.observance.id, 'vu-lan');
    });
  });

  group('reminder plan', () {
    final now = DateTime(2026, 11, 16, 9);
    List<AgendaDay> agenda(
      List<Memorial> memorials,
      List<Observance> observances,
    ) => buildAgenda(
      memorials: memorials,
      observances: observances,
      region: vn,
      from: dayOf(now),
      to: addDays(dayOf(now), planHorizonDays),
    );
    final monthly = [
      for (final day in [1, 15])
        Observance(
          id: 'm$day',
          title: const LocalizedText({'en': 'x'}),
          rule: ObservanceRule.lunarMonthly(day),
          enabledByDefault: true,
        ),
    ];

    test('reminds ahead and on the day, at the chosen time', () {
      final slots = planReminders(
        agenda: agenda([lunar('a', 3, 10)], const []),
        settings: const Settings(leadDays: {0, 1, 7}, time: ClockTime(6, 30)),
        now: now,
      );
      final people = slots.where((s) => s.memorial != null).toList();
      expect(
        [for (final s in people) s.when],
        [
          DateTime(2027, 4, 9, 6, 30),
          DateTime(2027, 4, 15, 6, 30),
          DateTime(2027, 4, 16, 6, 30),
        ],
      );
      expect([for (final s in people) s.daysBefore], [7, 1, 0]);
      expect(slots.last.isKeepAlive, isTrue);
    });

    test('never plans more than the phone can hold, and people come first', () {
      final many = [
        for (var i = 0; i < 40; i++) lunar('p$i', 1 + i % 12, 1 + i % 28),
      ];
      final slots = planReminders(
        agenda: agenda(many, monthly),
        settings: const Settings(),
        now: now,
      );
      expect(slots.length, maxNotificationSlots);
      expect(slots.where((s) => s.isKeepAlive).length, 1);
      expect(
        slots.where((s) => s.memorial != null).length,
        maxNotificationSlots - 1,
      );
      // The "open the app" notice comes when the first reminder was left out.
      final keepAlive = slots.firstWhere((s) => s.isKeepAlive);
      expect(keepAlive.when.isBefore(addDays(now, 300)), isTrue);
    });

    test('shared days use the room that is left', () {
      final slots = planReminders(
        agenda: agenda([lunar('a', 3, 10)], monthly),
        settings: const Settings(),
        now: now,
      );
      expect(slots.length, lessThanOrEqualTo(maxNotificationSlots));
      expect(slots.where((s) => s.memorial != null).length, 3);
      expect(
        slots.where((s) => s.observances.isNotEmpty).length,
        greaterThan(40),
      );
      expect(slots.every((s) => s.when.isAfter(now)), isTrue);
    });

    test('nothing to remember, nothing scheduled', () {
      expect(
        planReminders(agenda: const [], settings: const Settings(), now: now),
        isEmpty,
      );
    });
  });
}
