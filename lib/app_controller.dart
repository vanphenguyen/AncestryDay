import 'package:flutter/widgets.dart';

import 'logic/occurrences.dart';
import 'logic/reminder_plan.dart';
import 'lunar/lunar_calendar.dart';
import 'models/memorial.dart';
import 'models/observance.dart';
import 'models/settings.dart';
import 'services/app_store.dart';
import 'services/reminder_notifier.dart';
import 'texts.dart';

/// The app's state: the family's remembrance days and the user's choices.
/// Screens listen to it and rebuild when it changes.
class AppController extends ChangeNotifier {
  AppController({
    required this.observancesByRegion,
    required this.store,
    required this.notifier,
    required AppTexts texts,
    DateTime Function()? clock,
  }) : _clock = clock ?? DateTime.now,
       // ignore: prefer_initializing_formals
       _texts = texts {
    _memorials = store.memorials();
    _settings = store.settings();
  }

  /// Each country's shared days, from `assets/observances/`.
  final Map<LunarRegion, List<Observance>> observancesByRegion;
  final AppStore store;
  final ReminderNotifier notifier;
  final DateTime Function() _clock;

  late List<Memorial> _memorials;
  late Settings _settings;
  AppTexts _texts;

  /// Everything the app says, in the current language.
  AppTexts get texts => _texts;

  DateTime get now => _clock();

  DateTime get today => dayOf(now);

  Settings get settings => _settings;

  /// False until a lunar calendar has been chosen on the welcome screen.
  bool get hasChosenRegion => _settings.region != null;

  /// The country whose lunar calendar is followed.
  LunarRegion get region => _settings.region ?? LunarRegion.vietnam;

  LunarCalendar get calendar => LunarCalendar(region);

  List<Memorial> get memorials => List.unmodifiable(_memorials);

  /// False after the user refused notifications; the app then says so.
  bool notificationsAllowed = true;

  // -- Language

  /// The language picked in the app; null means "same as the phone".
  String? get languageChoice => store.languageChoice;

  /// Picks a language by key, or null to follow the phone again. The app
  /// rebuilds in that language, which then reaches [setLocale].
  Future<void> chooseLanguage(String? language) async {
    await store.saveLanguageChoice(language);
    notifyListeners();
  }

  /// Switches language. Notifications are rewritten in the new language.
  Future<void> setLocale(Locale locale) async {
    if (locale == _texts.locale) return;
    // No notifyListeners: this is called while the app is being built, and
    // every screen below reads the new texts in that same build.
    _texts = AppTexts(locale);
    await _syncNotifications();
  }

  // -- Shared days

  /// The shared days of the chosen country, in the order of the data file.
  List<Observance> get observances => observancesByRegion[region] ?? const [];

  bool isObservanceOn(Observance observance) =>
      _settings.observanceChoices[observance.id] ?? observance.enabledByDefault;

  List<Observance> get activeObservances => [
    for (final o in observances)
      if (isObservanceOn(o)) o,
  ];

  // -- What is coming

  /// The days from [from] to [to] with something to remember.
  List<AgendaDay> agenda(DateTime from, DateTime to) => buildAgenda(
    memorials: _memorials,
    observances: activeObservances,
    region: region,
    from: from,
    to: to,
  );

  /// The next remembrance day of [memorial], today included.
  MemorialOccurrence nextOccurrence(Memorial memorial) =>
      nextMemorialOccurrences(memorial, region, today).first;

  // -- Changes

  /// Call at startup: puts the reminders back on the phone's schedule (they
  /// are lost if the app's data was restored or the OS dropped them) and
  /// extends them further into the future.
  Future<void> start() async {
    if (store.askedPermission) {
      notificationsAllowed = await notifier.isAllowed();
    }
    if (hasChosenRegion) await _syncNotifications();
  }

  /// Call when the app comes back to the front.
  Future<void> refresh() async {
    // The user may have switched notifications on or off in Settings.
    if (store.askedPermission) {
      notificationsAllowed = await notifier.isAllowed();
    }
    notifyListeners();
    if (hasChosenRegion) await _syncNotifications();
  }

  /// Adds [memorial], or replaces the one with the same id.
  Future<void> saveMemorial(Memorial memorial) async {
    if (!store.askedPermission) {
      notificationsAllowed = await notifier.requestPermission();
      await store.markAskedPermission();
    }
    _memorials = [
      for (final m in _memorials)
        if (m.id != memorial.id) m,
      memorial,
    ];
    await store.saveMemorials(_memorials);
    notifyListeners();
    await _syncNotifications();
  }

  Future<void> deleteMemorial(String id) async {
    _memorials = [
      for (final m in _memorials)
        if (m.id != id) m,
    ];
    await store.saveMemorials(_memorials);
    notifyListeners();
    await _syncNotifications();
  }

  Future<void> updateSettings(Settings settings) async {
    _settings = settings;
    await store.saveSettings(settings);
    notifyListeners();
    await _syncNotifications();
  }

  Future<void> chooseRegion(LunarRegion region) =>
      updateSettings(_settings.copyWith(region: region));

  Future<void> setObservance(Observance observance, bool on) => updateSettings(
    _settings.copyWith(
      observanceChoices: {..._settings.observanceChoices, observance.id: on},
    ),
  );

  /// Sends a test notification now and another in a minute. Returns false
  /// when the phone does not let the app show notifications.
  Future<bool> sendTestNotification() async {
    notificationsAllowed = await notifier.requestPermission();
    await store.markAskedPermission();
    notifyListeners();
    if (!notificationsAllowed) return false;
    await notifier.sendTest(
      title: _texts.appName,
      body: _texts.l10n.testNotificationBody,
      laterBody: _texts.l10n.testNotificationLaterBody,
      labels: NotificationLabels.of(_texts.l10n),
    );
    return true;
  }

  // -- Notifications

  /// The notifications that should be on the phone's schedule right now.
  List<PlannedNotification> plannedNotifications() {
    final slots = planReminders(
      agenda: agenda(today, addDays(today, planHorizonDays)),
      settings: _settings,
      now: now,
    );
    return [for (final slot in slots) _wording(slot)];
  }

  PlannedNotification _wording(ReminderSlot slot) {
    final l10n = _texts.l10n;
    final String title;
    final String body;
    final memorial = slot.memorial;
    if (slot.isKeepAlive) {
      title = l10n.notifKeepAliveTitle;
      body = l10n.notifKeepAliveBody;
    } else if (memorial != null) {
      final name = memorial.memorial.name;
      final lunar = memorial.lunar;
      final lunarWords = lunar == null ? null : _texts.lunarDate(lunar);
      final nth = memorial.nth;
      final String main;
      if (slot.daysBefore == 0) {
        title = l10n.notifMemorialTodayTitle(name);
        main = lunarWords == null
            ? l10n.notifMemorialTodayBodySolar
            : l10n.notifMemorialTodayBody(lunarWords);
      } else {
        title = l10n.notifMemorialAheadTitle(slot.daysBefore, name);
        final date = _texts.weekdayAndDate(memorial.date);
        main = lunarWords == null
            ? l10n.notifMemorialAheadBodySolar(date)
            : l10n.notifMemorialAheadBody(date, lunarWords);
      }
      body = nth == null ? main : '${_texts.anniversary(nth)}. $main';
    } else {
      final names = _texts.observanceTitles(slot.observances);
      final date = slot.observances.first.date;
      title = slot.daysBefore == 0
          ? l10n.notifObservanceTodayTitle(names)
          : l10n.notifObservanceTomorrowTitle(names);
      body =
          '${_texts.weekdayAndDate(date)} · ${_texts.lunarDate(calendar.fromSolar(date))}';
    }
    return PlannedNotification(when: slot.when, title: title, body: body);
  }

  Future<void> _syncNotifications() =>
      notifier.sync(plannedNotifications(), NotificationLabels.of(_texts.l10n));
}
