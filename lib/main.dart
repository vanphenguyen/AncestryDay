import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'app.dart';
import 'app_controller.dart';
import 'data/observance_repository.dart';
import 'services/app_store.dart';
import 'services/reminder_notifier.dart';
import 'texts.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await initializeDateFormatting();
  // The app follows the phone's language (English if it has no translation)
  // unless a language was picked in the app.
  final store = await AppStore.load();
  final choice = store.languageChoice;
  final texts = AppTexts(
    choice != null
        ? localeOfKey(choice)
        : resolveLocale(PlatformDispatcher.instance.locales),
  );
  // Browsers cannot schedule notifications, so the web build is a preview.
  // Built with --dart-define=SCREENSHOTS=true, the web build looks like the
  // phone app (no "web preview" note) so store screenshots can be taken.
  const forScreenshots = bool.fromEnvironment('SCREENSHOTS');
  final ReminderNotifier notifier = kIsWeb
      ? NoopReminderNotifier(supported: forScreenshots)
      : LocalReminderNotifier();
  // A problem in the notification system must never keep the app from
  // opening, so setting it up is given a time limit and may fail quietly.
  await _guarded(notifier.init);
  final controller = AppController(
    observancesByRegion: await ObservanceRepository().loadAll(),
    store: store,
    notifier: notifier,
    texts: texts,
  );
  runApp(AncestryDayApp(controller: controller));
  // Re-scheduling reminders happens after the first screen is up.
  await _guarded(controller.start);
}

Future<void> _guarded(Future<void> Function() work) async {
  try {
    await work().timeout(const Duration(seconds: 8));
  } on Object catch (error, stack) {
    debugPrint('Startup step failed: $error\n$stack');
  }
}
