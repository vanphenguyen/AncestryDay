import 'package:flutter/material.dart';

import '../app.dart';
import '../logic/occurrences.dart';
import '../models/memorial.dart';
import '../widgets/eastern.dart';
import 'edit_memorial_screen.dart';
import 'settings_screen.dart';

/// How far ahead plain shared days (rằm, mùng một) are listed. Remembrance
/// days of people are listed for the whole coming year.
const _sharedDaysAhead = 45;

/// Today's lunar date and what is coming.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = AppScope.of(context);
    final texts = AppScope.textsOf(context);
    final l10n = texts.l10n;
    final today = controller.today;
    final days = [
      for (final day in controller.agenda(today, addDays(today, 385)))
        if (day.memorials.isNotEmpty ||
            daysBetween(today, day.date) <= _sharedDaysAhead)
          day,
    ];
    final next = days.expand((d) => d.memorials).firstOrNull;

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        const _TodayHeader(),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (!controller.notifier.supported) ...[
                Notice(icon: Icons.info_outline, text: l10n.webPreviewNotice),
                const SizedBox(height: 12),
              ] else if (!controller.notificationsAllowed) ...[
                Notice(
                  icon: Icons.notifications_off_outlined,
                  text: l10n.notificationsOffNotice,
                  strong: true,
                ),
                const SizedBox(height: 12),
              ],
              if (next != null)
                _NextCard(occurrence: next)
              else
                const _EmptyCard(),
              if (days.isNotEmpty) ...[
                SectionTitle(l10n.sectionUpcoming),
                for (final day in days) _DayTile(day: day),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

Future<void> openMemorial(BuildContext context, [Memorial? memorial]) =>
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => EditMemorialScreen(memorial: memorial),
      ),
    );

class _TodayHeader extends StatelessWidget {
  const _TodayHeader();

  @override
  Widget build(BuildContext context) {
    final controller = AppScope.of(context);
    final texts = AppScope.textsOf(context);
    final l10n = texts.l10n;
    final theme = Theme.of(context);
    final tones = Tones.of(context);
    final today = controller.today;
    final lunar = controller.calendar.fromSolar(today);
    return InkLandscape(
      height: 150 + MediaQuery.paddingOf(context).top,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 8, 44),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      texts.weekdayAndDate(today),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: tones.muted,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        MoonPhase(lunarDay: lunar.day, size: 26),
                        const SizedBox(width: 10),
                        Flexible(
                          child: Text(
                            texts.lunarDateTitle(lunar, marked: false),
                            key: const ValueKey('today-lunar'),
                            style: theme.textTheme.headlineSmall?.copyWith(
                              height: 1.2,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${texts.yearName(lunar.year, controller.region)} · '
                      '${l10n.calendarOf(texts.regionName(controller.region))}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                key: const ValueKey('settings-button'),
                tooltip: l10n.settingsTitle,
                icon: const Icon(Icons.settings_outlined),
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const SettingsScreen(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The next remembrance day, large, on lacquer red.
class _NextCard extends StatelessWidget {
  const _NextCard({required this.occurrence});

  final MemorialOccurrence occurrence;

  @override
  Widget build(BuildContext context) {
    final controller = AppScope.of(context);
    final texts = AppScope.textsOf(context);
    final l10n = texts.l10n;
    final tones = Tones.of(context);
    final theme = Theme.of(context);
    final memorial = occurrence.memorial;
    final left = daysBetween(controller.today, occurrence.date);
    final lunar = occurrence.lunar;
    final nth = occurrence.nth;
    final soft = tones.onLacquer.withValues(alpha: 0.82);
    return Material(
      color: tones.lacquer,
      borderRadius: BorderRadius.circular(22),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        key: const ValueKey('next-card'),
        onTap: () => openMemorial(context, memorial),
        child: Stack(
          children: [
            Positioned(
              right: -18,
              bottom: -10,
              child: Lotus(
                size: 150,
                color: tones.onLacquer.withValues(alpha: 0.13),
                accent: Colors.transparent,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          l10n.nextUp.toUpperCase(),
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: soft,
                            letterSpacing: 1.1,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Tones.dark.gold,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          l10n.inDays(left),
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: const Color(0xFF3A1A0A),
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    memorial.name,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: tones.onLacquer,
                    ),
                  ),
                  if ([
                        memorial.relation,
                        if (nth != null) texts.anniversary(nth),
                      ].nonNulls.join(' · ')
                      case final line when line.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      line,
                      style: theme.textTheme.bodyMedium?.copyWith(color: soft),
                    ),
                  ],
                  const SizedBox(height: 14),
                  Text(
                    texts.fullDate(occurrence.date),
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: tones.onLacquer,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (lunar != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      '${texts.lunarDateTitle(lunar)} · ${texts.yearName(lunar.year, controller.region)}',
                      style: theme.textTheme.bodyMedium?.copyWith(color: soft),
                    ),
                  ],
                  for (final warning in texts.variantWarnings(occurrence)) ...[
                    const SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 16,
                          color: Tones.dark.gold,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            '$warning ${l10n.followingRegion(texts.regionName(controller.region))}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: tones.onLacquer,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyCard extends StatelessWidget {
  const _EmptyCard();

  @override
  Widget build(BuildContext context) {
    final l10n = AppScope.textsOf(context).l10n;
    final theme = Theme.of(context);
    final tones = Tones.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
        child: Column(
          children: [
            const Lotus(size: 92),
            const SizedBox(height: 14),
            Text(
              l10n.emptyTitle,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.emptyBody,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: tones.muted,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 18),
            FilledButton.icon(
              key: const ValueKey('empty-add'),
              onPressed: () => openMemorial(context),
              icon: const Icon(Icons.add),
              label: Text(l10n.addPerson),
            ),
          ],
        ),
      ),
    );
  }
}

/// One day of the list: the solar date on the left, what is remembered on
/// the right.
class _DayTile extends StatelessWidget {
  const _DayTile({required this.day});

  final AgendaDay day;

  @override
  Widget build(BuildContext context) {
    final controller = AppScope.of(context);
    final texts = AppScope.textsOf(context);
    final l10n = texts.l10n;
    final theme = Theme.of(context);
    final tones = Tones.of(context);
    final left = daysBetween(controller.today, day.date);
    final lunar = controller.calendar.fromSolar(day.date);
    final hasPerson = day.memorials.isNotEmpty;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: hasPerson
              ? () => openMemorial(context, day.memorials.first.memorial)
              : null,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 14, 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (hasPerson)
                  Seal(
                    top: texts.shortMonth(day.date),
                    bottom: '${day.date.day}',
                  )
                else
                  _PlainDate(
                    top: texts.shortMonth(day.date),
                    bottom: '${day.date.day}',
                  ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (final m in day.memorials) ...[
                        Text(
                          l10n.memorialTitle(m.memorial.name),
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        if (m.nth case final nth?)
                          Text(
                            texts.anniversary(nth),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                      ],
                      if (day.observances.isNotEmpty)
                        Text(
                          texts.observanceTitles(day.observances),
                          style: hasPerson
                              ? theme.textTheme.bodyMedium
                              : theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                        ),
                      const SizedBox(height: 3),
                      Text(
                        '${texts.shortWeekday(day.date)} · ${texts.lunarDate(lunar)}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: tones.muted,
                        ),
                      ),
                      for (final m in day.memorials)
                        for (final warning in texts.variantWarnings(m))
                          Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  size: 15,
                                  color: theme.colorScheme.primary,
                                ),
                                const SizedBox(width: 5),
                                Expanded(
                                  child: Text(
                                    warning,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.primary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  l10n.inDays(left),
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: left <= 7 ? theme.colorScheme.primary : tones.muted,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// The date block of a shared day: like a [Seal], but only outlined.
class _PlainDate extends StatelessWidget {
  const _PlainDate({required this.top, required this.bottom});

  final String top;
  final String bottom;

  @override
  Widget build(BuildContext context) {
    final tones = Tones.of(context);
    return Container(
      width: 54,
      height: 54,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: tones.gold, width: 1.2),
        color: tones.gold.withValues(alpha: 0.10),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              top,
              maxLines: 1,
              style: TextStyle(
                color: tones.muted,
                fontSize: 10.5,
                height: 1.1,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              bottom,
              style: TextStyle(
                color: tones.ink,
                fontSize: 21,
                height: 1.05,
                fontFamily: serif,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
