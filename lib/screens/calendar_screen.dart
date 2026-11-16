import 'package:flutter/material.dart';

import '../app.dart';
import '../logic/occurrences.dart';
import '../lunar/lunar_calendar.dart';
import '../widgets/eastern.dart';
import 'home_screen.dart';

/// A month of solar days with the lunar day under each, in the chosen
/// country's calendar.
class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  /// First day of the month shown; null means "the current month".
  DateTime? _month;
  DateTime? _selected;

  @override
  Widget build(BuildContext context) {
    final controller = AppScope.of(context);
    final texts = AppScope.textsOf(context);
    final l10n = texts.l10n;
    final theme = Theme.of(context);
    final tones = Tones.of(context);
    final today = controller.today;
    final month = _month ?? DateTime(today.year, today.month);
    final selected = _selected ?? today;
    // The grid starts on the Monday on or before the 1st and has six weeks.
    final gridStart = addDays(month, 1 - month.weekday);
    final agenda = {
      for (final day in controller.agenda(gridStart, addDays(gridStart, 41)))
        LunarCalendar.dayNumberOf(day.date): day,
    };
    final selectedDay = agenda[LunarCalendar.dayNumberOf(selected)];
    final selectedLunar = controller.calendar.fromSolar(selected);

    void show(DateTime newMonth, [DateTime? day]) => setState(() {
      _month = newMonth;
      _selected = day;
    });

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
      children: [
        Text(
          l10n.calendarOf(texts.regionName(controller.region)),
          style: theme.textTheme.bodyMedium?.copyWith(color: tones.muted),
        ),
        const SizedBox(height: 2),
        Row(
          children: [
            Expanded(
              child: Text(
                texts.monthAndYear(month),
                style: theme.textTheme.headlineMedium,
              ),
            ),
            IconButton(
              key: const ValueKey('month-previous'),
              icon: const Icon(Icons.chevron_left),
              onPressed: () => show(DateTime(month.year, month.month - 1)),
            ),
            IconButton(
              key: const ValueKey('month-next'),
              icon: const Icon(Icons.chevron_right),
              onPressed: () => show(DateTime(month.year, month.month + 1)),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const KeyPatternDivider(),
        const SizedBox(height: 12),
        Row(
          children: [
            for (var weekday = 1; weekday <= 7; weekday++)
              Expanded(
                child: Center(
                  child: Text(
                    texts.weekdayInitial(weekday),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: weekday == 7
                          ? theme.colorScheme.primary
                          : tones.muted,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 6),
        for (var week = 0; week < 6; week++)
          Row(
            children: [
              for (var i = 0; i < 7; i++)
                Expanded(
                  child: _DayCell(
                    day: addDays(gridStart, week * 7 + i),
                    month: month,
                    today: today,
                    selected: selected,
                    agenda:
                        agenda[LunarCalendar.dayNumberOf(
                          addDays(gridStart, week * 7 + i),
                        )],
                    onTap: (day) => show(DateTime(day.year, day.month), day),
                  ),
                ),
            ],
          ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    MoonPhase(lunarDay: selectedLunar.day, size: 22),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        texts.lunarDateTitle(selectedLunar),
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontFamily: serif,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    if (selected != today)
                      TextButton(
                        onPressed: () =>
                            show(DateTime(today.year, today.month)),
                        child: Text(l10n.backToToday),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '${texts.fullDate(selected)} · '
                  '${texts.yearName(selectedLunar.year, controller.region)}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: tones.muted,
                  ),
                ),
                const Divider(height: 24),
                if (selectedDay == null)
                  Text(
                    l10n.nothingThisDay,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: tones.muted,
                    ),
                  )
                else ...[
                  for (final m in selectedDay.memorials)
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                      leading: Monogram(name: m.memorial.name, size: 36),
                      title: Text(
                        l10n.memorialTitle(m.memorial.name),
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      subtitle: m.nth == null
                          ? null
                          : Text(texts.anniversary(m.nth!)),
                      onTap: () => openMemorial(context, m.memorial),
                    ),
                  for (final o in selectedDay.observances)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          Icon(Icons.brightness_1, size: 8, color: tones.gold),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(texts.resolve(o.observance.title)),
                          ),
                        ],
                      ),
                    ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.day,
    required this.month,
    required this.today,
    required this.selected,
    required this.agenda,
    required this.onTap,
  });

  final DateTime day;
  final DateTime month;
  final DateTime today;
  final DateTime selected;
  final AgendaDay? agenda;
  final ValueChanged<DateTime> onTap;

  @override
  Widget build(BuildContext context) {
    final controller = AppScope.of(context);
    final theme = Theme.of(context);
    final tones = Tones.of(context);
    final lunar = controller.calendar.fromSolar(day);
    final inMonth = day.month == month.month;
    final isToday = day == today;
    final isSelected = day == selected;
    final firstOfLunarMonth = lunar.day == 1;
    final fade = inMonth ? 1.0 : 0.35;
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => onTap(day),
      child: Container(
        height: 54,
        margin: const EdgeInsets.all(1.5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: isSelected ? tones.gold.withValues(alpha: 0.22) : null,
          border: isToday
              ? Border.all(color: theme.colorScheme.primary, width: 1.5)
              : null,
        ),
        alignment: Alignment.center,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${day.day}',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color:
                      (day.weekday == 7 ? theme.colorScheme.primary : tones.ink)
                          .withValues(alpha: fade),
                ),
              ),
              Text(
                // The first day of a lunar month shows the month too.
                firstOfLunarMonth
                    ? '1/${lunar.month}${lunar.isLeap ? '+' : ''}'
                    : '${lunar.day}',
                style: theme.textTheme.labelSmall?.copyWith(
                  fontSize: 10,
                  height: 1.1,
                  fontWeight: firstOfLunarMonth || lunar.day == 15
                      ? FontWeight.w800
                      : FontWeight.w400,
                  color:
                      (firstOfLunarMonth || lunar.day == 15
                              ? theme.colorScheme.primary
                              : tones.muted)
                          .withValues(alpha: fade),
                ),
              ),
              const SizedBox(height: 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (agenda?.memorials.isNotEmpty ?? false)
                    _Dot(theme.colorScheme.primary.withValues(alpha: fade)),
                  if (agenda?.observances.isNotEmpty ?? false)
                    _Dot(tones.gold.withValues(alpha: fade)),
                  if (agenda == null) const SizedBox(height: 5),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot(this.color);

  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    width: 5,
    height: 5,
    margin: const EdgeInsets.symmetric(horizontal: 1.5),
    decoration: BoxDecoration(color: color, shape: BoxShape.circle),
  );
}
