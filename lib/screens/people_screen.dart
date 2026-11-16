import 'package:flutter/material.dart';

import '../app.dart';
import '../logic/occurrences.dart';
import '../models/memorial.dart';
import '../widgets/eastern.dart';
import 'home_screen.dart';

/// The family's book of remembrance days: everyone remembered, the soonest
/// day first.
class PeopleScreen extends StatelessWidget {
  const PeopleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = AppScope.of(context);
    final texts = AppScope.textsOf(context);
    final l10n = texts.l10n;
    final theme = Theme.of(context);
    final tones = Tones.of(context);
    final entries = [
      for (final m in controller.memorials)
        (memorial: m, next: controller.nextOccurrence(m)),
    ]..sort((a, b) => a.next.date.compareTo(b.next.date));

    return Stack(
      children: [
        ListView(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 96),
          children: [
            Text(
              l10n.peopleCount(entries.length),
              style: theme.textTheme.bodyMedium?.copyWith(color: tones.muted),
            ),
            const SizedBox(height: 2),
            Text(l10n.peopleTitle, style: theme.textTheme.headlineMedium),
            const SizedBox(height: 12),
            const KeyPatternDivider(),
            const SizedBox(height: 16),
            if (entries.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Column(
                  children: [
                    const Lotus(size: 96),
                    const SizedBox(height: 16),
                    Text(l10n.emptyTitle, style: theme.textTheme.titleLarge),
                    const SizedBox(height: 8),
                    Text(
                      l10n.emptyBody,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: tones.muted,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            for (final entry in entries)
              _PersonTile(memorial: entry.memorial, next: entry.next),
          ],
        ),
        Positioned(
          right: 16,
          bottom: 16,
          child: FloatingActionButton.extended(
            key: const ValueKey('add-person'),
            onPressed: () => openMemorial(context),
            icon: const Icon(Icons.add),
            label: Text(l10n.addPerson),
          ),
        ),
      ],
    );
  }
}

class _PersonTile extends StatelessWidget {
  const _PersonTile({required this.memorial, required this.next});

  final Memorial memorial;
  final MemorialOccurrence next;

  @override
  Widget build(BuildContext context) {
    final controller = AppScope.of(context);
    final texts = AppScope.textsOf(context);
    final l10n = texts.l10n;
    final theme = Theme.of(context);
    final tones = Tones.of(context);
    final day = memorial.kind == CalendarKind.lunar
        ? texts.lunarDayMonth(memorial.month, memorial.day)
        : '${l10n.kindSolar} · ${texts.date(next.date)}';
    final left = daysBetween(controller.today, next.date);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          key: ValueKey('person-${memorial.id}'),
          onTap: () => openMemorial(context, memorial),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
            child: Row(
              children: [
                Monogram(name: memorial.name),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        memorial.name,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        [?memorial.relation, day].join(' · '),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: tones.muted,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${l10n.nextOn(texts.fullDate(next.date))} · ${l10n.inDays(left)}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, color: tones.muted),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
