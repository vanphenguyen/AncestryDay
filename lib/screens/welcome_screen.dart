import 'package:flutter/material.dart';

import '../app.dart';
import '../lunar/lunar_calendar.dart';
import '../texts.dart';
import '../widgets/eastern.dart';
import '../widgets/pickers.dart';

/// Shown once: what the app is for, and the one choice that must not be
/// guessed, which country's lunar calendar to follow.
class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  late LunarRegion _region = suggestRegion(
    WidgetsBinding.instance.platformDispatcher.locales,
  );

  @override
  Widget build(BuildContext context) {
    final controller = AppScope.of(context);
    final texts = AppScope.textsOf(context);
    final l10n = texts.l10n;
    final theme = Theme.of(context);
    final tones = Tones.of(context);
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          InkLandscape(
            height: 250,
            child: SafeArea(
              bottom: false,
              child: SizedBox(
                height: 250,
                child: Stack(
                  children: [
                    Positioned(
                      right: 8,
                      top: 4,
                      child: IconButton(
                        key: const ValueKey('language-button'),
                        tooltip: l10n.languageTitle,
                        icon: const Icon(Icons.language),
                        onPressed: () => showLanguagePicker(context),
                      ),
                    ),
                    const Positioned(
                      left: 24,
                      bottom: 18,
                      child: Lotus(size: 84),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 4, 24, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(texts.appName, style: theme.textTheme.headlineMedium),
                const SizedBox(height: 8),
                Text(
                  l10n.welcomeTagline,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontFamily: serif,
                    fontStyle: FontStyle.italic,
                    color: theme.colorScheme.primary,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  l10n.welcomeBody,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: tones.muted,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 20),
                const KeyPatternDivider(),
                const SizedBox(height: 20),
                Text(
                  l10n.chooseCalendarTitle,
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                RegionPicker(
                  selected: _region,
                  onSelected: (region) => setState(() => _region = region),
                ),
                const SizedBox(height: 4),
                Notice(icon: Icons.info_outline, text: l10n.calendarExplain),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    key: const ValueKey('welcome-start'),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () => controller.chooseRegion(_region),
                    child: Text(
                      l10n.start,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  l10n.privacyNote,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: tones.muted,
                  ),
                ),
                SizedBox(height: 24 + MediaQuery.paddingOf(context).bottom),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
