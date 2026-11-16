import 'package:flutter/material.dart';

import '../app.dart';
import '../logic/occurrences.dart';
import '../models/settings.dart';
import '../texts.dart';
import '../widgets/eastern.dart';
import '../widgets/pickers.dart';
import 'differences_screen.dart';

/// The lunar calendar to follow, when to be reminded, and which shared days
/// to be reminded of.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = AppScope.of(context);
    final texts = AppScope.textsOf(context);
    final l10n = texts.l10n;
    final theme = Theme.of(context);
    final tones = Tones.of(context);
    final settings = controller.settings;
    final today = controller.today;
    final chosenLanguage = controller.languageChoice;

    Future<void> pickTime() async {
      final picked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay(
          hour: settings.time.hour,
          minute: settings.time.minute,
        ),
      );
      if (picked == null) return;
      await controller.updateSettings(
        settings.copyWith(time: ClockTime(picked.hour, picked.minute)),
      );
    }

    Future<void> sendTest() async {
      final messenger = ScaffoldMessenger.of(context);
      final sent = await controller.sendTestNotification();
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            sent ? l10n.testNotificationSent : l10n.testNotificationBlocked,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
        children: [
          SectionTitle(l10n.settingsCalendar),
          Notice(icon: Icons.info_outline, text: l10n.calendarExplain),
          const SizedBox(height: 10),
          RegionPicker(
            selected: controller.region,
            onSelected: controller.chooseRegion,
          ),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: TextButton.icon(
              key: const ValueKey('see-differences'),
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const DifferencesScreen(),
                ),
              ),
              icon: const Icon(Icons.compare_arrows),
              label: Text(l10n.seeDifferences),
            ),
          ),
          SectionTitle(l10n.settingsReminders),
          Card(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.leadDaysTitle, style: theme.textTheme.titleSmall),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      for (final days in Settings.leadDayOptions)
                        FilterChip(
                          key: ValueKey('lead-$days'),
                          label: Text(l10n.leadDay(days)),
                          selected: settings.leadDays.contains(days),
                          // At least one must stay on, or nothing would remind.
                          onSelected: (on) {
                            final next = {...settings.leadDays};
                            on ? next.add(days) : next.remove(days);
                            if (next.isNotEmpty) {
                              controller.updateSettings(
                                settings.copyWith(leadDays: next),
                              );
                            }
                          },
                        ),
                    ],
                  ),
                  const Divider(height: 20),
                  ListTile(
                    key: const ValueKey('reminder-time'),
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.schedule),
                    title: Text(l10n.reminderTime),
                    trailing: Text(
                      settings.time.label,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    onTap: pickTime,
                  ),
                  if (controller.notifier.supported)
                    ListTile(
                      key: const ValueKey('test-notification'),
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.notifications_active_outlined),
                      title: Text(l10n.testNotification),
                      subtitle: Text(l10n.testNotificationHint),
                      onTap: sendTest,
                    ),
                ],
              ),
            ),
          ),
          SectionTitle(l10n.settingsObservances),
          Card(
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                SwitchListTile(
                  title: Text(l10n.observanceDayBefore),
                  value: settings.observanceDayBefore,
                  onChanged: (on) => controller.updateSettings(
                    settings.copyWith(observanceDayBefore: on),
                  ),
                ),
                const Divider(),
                for (final observance in controller.observances)
                  SwitchListTile(
                    key: ValueKey('observance-${observance.id}'),
                    dense: true,
                    title: Text(
                      texts.resolve(observance.title),
                      style: theme.textTheme.bodyLarge,
                    ),
                    subtitle: switch (observanceOccurrences(
                      observance,
                      controller.region,
                      today,
                      addDays(today, 400),
                    ).firstOrNull) {
                      final next? => Text(
                        l10n.nextOn(texts.fullDate(next.date)),
                      ),
                      null => null,
                    },
                    value: controller.isObservanceOn(observance),
                    onChanged: (on) => controller.setObservance(observance, on),
                  ),
              ],
            ),
          ),
          SectionTitle(l10n.languageTitle),
          Card(
            clipBehavior: Clip.antiAlias,
            child: ListTile(
              key: const ValueKey('language-button'),
              leading: const Icon(Icons.language),
              title: Text(
                chosenLanguage == null
                    ? l10n.languageFollowPhone
                    : languageNames[chosenLanguage] ?? chosenLanguage,
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => showLanguagePicker(context),
            ),
          ),
          const SizedBox(height: 24),
          const Center(child: Lotus(size: 44)),
          const SizedBox(height: 10),
          Text(
            l10n.privacyNote,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(color: tones.muted),
          ),
        ],
      ),
    );
  }
}
