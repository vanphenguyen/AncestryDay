import 'package:flutter/material.dart';

import '../app.dart';
import '../logic/differences.dart';
import '../widgets/eastern.dart';

/// Lists when the chosen lunar calendar and its neighbours disagree in the
/// next twenty years.
class DifferencesScreen extends StatefulWidget {
  const DifferencesScreen({super.key});

  @override
  State<DifferencesScreen> createState() => _DifferencesScreenState();
}

class _DifferencesScreenState extends State<DifferencesScreen> {
  List<CalendarDifference>? _differences;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final controller = AppScope.of(context);
    final today = controller.today;
    _differences ??= calendarDifferences(
      controller.region,
      today,
      DateTime(today.year + 20, today.month, today.day),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = AppScope.of(context);
    final texts = AppScope.textsOf(context);
    final l10n = texts.l10n;
    final theme = Theme.of(context);
    final tones = Tones.of(context);
    final region = controller.region;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.differencesTitle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          Text(
            l10n.differencesIntro(texts.regionName(region)),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: tones.muted,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 14),
          const KeyPatternDivider(),
          const SizedBox(height: 14),
          for (final d in _differences!)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              l10n.dateRange(
                                texts.date(d.from),
                                texts.date(d.to),
                              ),
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          Text(
                            l10n.daysCount(d.days),
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        l10n.regionSays(
                          texts.regionName(region),
                          texts.lunarDate(d.here, marked: false),
                        ),
                        style: theme.textTheme.bodySmall,
                      ),
                      Text(
                        l10n.regionSays(
                          texts.regionNames(d.others),
                          texts.lunarDate(d.there, marked: false),
                        ),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: tones.muted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
