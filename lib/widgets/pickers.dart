import 'package:flutter/material.dart';

import '../app.dart';
import '../lunar/lunar_calendar.dart';
import '../texts.dart';

/// The four lunar calendars as a list to choose one from.
class RegionPicker extends StatelessWidget {
  const RegionPicker({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  final LunarRegion? selected;
  final ValueChanged<LunarRegion> onSelected;

  @override
  Widget build(BuildContext context) {
    final texts = AppScope.textsOf(context);
    final tones = Tones.of(context);
    final theme = Theme.of(context);
    return Column(
      children: [
        for (final region in LunarRegion.values)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Material(
              color: region == selected
                  ? tones.gold.withValues(alpha: 0.14)
                  : tones.card,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: BorderSide(
                  color: region == selected ? tones.gold : tones.line,
                  width: region == selected ? 1.6 : 1,
                ),
              ),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                key: ValueKey('region-${region.code}'),
                onTap: () => onSelected(region),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                  child: Row(
                    children: [
                      Icon(
                        region == selected
                            ? Icons.radio_button_checked
                            : Icons.radio_button_unchecked,
                        color: region == selected
                            ? theme.colorScheme.primary
                            : tones.muted,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              texts.regionName(region),
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              texts.regionHint(region),
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: tones.muted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// Opens the list of languages. The first row follows the phone's language.
Future<void> showLanguagePicker(BuildContext context) =>
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) {
        final controller = AppScope.of(context);
        final l10n = AppScope.textsOf(context).l10n;
        final chosen = controller.languageChoice;

        Widget row(String? code, String label) => ListTile(
          key: ValueKey('language-${code ?? 'phone'}'),
          title: Text(label),
          trailing: chosen == code ? const Icon(Icons.check) : null,
          selected: chosen == code,
          onTap: () {
            controller.chooseLanguage(code);
            Navigator.of(context).pop();
          },
        );

        return SafeArea(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.sizeOf(context).height * 0.8,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                    child: Text(
                      l10n.languageTitle,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  row(null, l10n.languageFollowPhone),
                  const Divider(height: 1),
                  for (final entry in languageNames.entries)
                    row(entry.key, entry.value),
                ],
              ),
            ),
          ),
        );
      },
    );
