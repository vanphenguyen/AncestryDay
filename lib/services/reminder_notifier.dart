import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import '../l10n/app_localizations.dart';

/// The words Android shows for the app's notification channel.
class NotificationLabels {
  const NotificationLabels({
    required this.channelName,
    required this.channelDescription,
  });

  factory NotificationLabels.of(AppLocalizations l10n) => NotificationLabels(
    channelName: l10n.notifChannelName,
    channelDescription: l10n.notifChannelDescription,
  );

  final String channelName;
  final String channelDescription;
}

/// One notification with its words, ready to schedule.
class PlannedNotification {
  const PlannedNotification({
    required this.when,
    required this.title,
    required this.body,
  });

  final DateTime when;
  final String title;
  final String body;
}

/// Puts reminders on the phone's notification schedule.
abstract class ReminderNotifier {
  /// False where scheduled notifications do not exist (the web preview).
  bool get supported;

  Future<void> init();

  /// Asks the user to allow notifications. Returns whether they are allowed.
  Future<bool> requestPermission();

  /// Whether the phone currently lets the app show notifications.
  Future<bool> isAllowed();

  /// Shows one notification now and schedules another a minute from now,
  /// so the user can see that both kinds arrive.
  Future<void> sendTest({
    required String title,
    required String body,
    required String laterBody,
    required NotificationLabels labels,
  });

  /// Replaces everything scheduled with [notifications].
  Future<void> sync(
    List<PlannedNotification> notifications,
    NotificationLabels labels,
  );
}

/// Used on the web and in tests: remembers what was asked, shows nothing.
class NoopReminderNotifier implements ReminderNotifier {
  NoopReminderNotifier({this.supported = false});

  List<PlannedNotification> lastSynced = const [];
  int permissionRequests = 0;
  int testsSent = 0;

  @override
  final bool supported;

  @override
  Future<void> init() async {}

  @override
  Future<bool> requestPermission() async {
    permissionRequests++;
    return true;
  }

  @override
  Future<bool> isAllowed() async => true;

  @override
  Future<void> sendTest({
    required String title,
    required String body,
    required String laterBody,
    required NotificationLabels labels,
  }) async => testsSent++;

  @override
  Future<void> sync(
    List<PlannedNotification> notifications,
    NotificationLabels labels,
  ) async => lastSynced = List.of(notifications);
}

const _channelId = 'remembrance';

/// The status-bar icon: `android/app/src/main/res/drawable/ic_stat_bell.xml`.
const _androidIcon = 'ic_stat_bell';

/// Test notifications use these two ids.
const _testIdBase = 1 << 21;

final _plugin = FlutterLocalNotificationsPlugin();

/// Exact alarms are used when the phone allows them; otherwise Android may
/// deliver a notification much later than the chosen time.
Future<AndroidScheduleMode> _scheduleMode() async {
  if (defaultTargetPlatform != TargetPlatform.android) {
    return AndroidScheduleMode.exactAllowWhileIdle;
  }
  final android = _plugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >();
  final exact = await android?.canScheduleExactNotifications() ?? false;
  return exact
      ? AndroidScheduleMode.exactAllowWhileIdle
      : AndroidScheduleMode.inexactAllowWhileIdle;
}

NotificationDetails _details(NotificationLabels labels, String body) =>
    NotificationDetails(
      android: AndroidNotificationDetails(
        _channelId,
        labels.channelName,
        channelDescription: labels.channelDescription,
        importance: Importance.high,
        priority: Priority.high,
        // Lets a long line be read in full when the notification is opened.
        styleInformation: BigTextStyleInformation(body),
      ),
      iOS: const DarwinNotificationDetails(),
    );

/// The real notifier for Android and iOS.
class LocalReminderNotifier implements ReminderNotifier {
  @override
  bool get supported => true;

  @override
  Future<void> init() async {
    tzdata.initializeTimeZones();
    try {
      final zone = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(zone.identifier));
    } on Object {
      tz.setLocalLocation(tz.getLocation('Asia/Ho_Chi_Minh'));
    }
    await _plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings(_androidIcon),
        iOS: DarwinInitializationSettings(
          // Permission is asked later, when the first person is added.
          requestAlertPermission: false,
          requestSoundPermission: false,
          requestBadgePermission: false,
        ),
      ),
    );
  }

  @override
  Future<bool> requestPermission() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      final android = _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      return await android?.requestNotificationsPermission() ?? false;
    }
    final ios = _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();
    return await ios?.requestPermissions(
          alert: true,
          sound: true,
          badge: true,
        ) ??
        false;
  }

  @override
  Future<bool> isAllowed() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      final android = _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      return await android?.areNotificationsEnabled() ?? false;
    }
    final ios = _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();
    return (await ios?.checkPermissions())?.isEnabled ?? false;
  }

  @override
  Future<void> sendTest({
    required String title,
    required String body,
    required String laterBody,
    required NotificationLabels labels,
  }) async {
    final details = _details(labels, body);
    await _plugin.show(
      id: _testIdBase,
      title: title,
      body: body,
      notificationDetails: details,
    );
    await _plugin.zonedSchedule(
      id: _testIdBase + 1,
      title: title,
      body: laterBody,
      scheduledDate: tz.TZDateTime.now(tz.local)
          .add(const Duration(minutes: 1)),
      notificationDetails: _details(labels, laterBody),
      androidScheduleMode: await _scheduleMode(),
    );
  }

  @override
  Future<void> sync(
    List<PlannedNotification> notifications,
    NotificationLabels labels,
  ) async {
    await _plugin.cancelAllPendingNotifications();
    final mode = await _scheduleMode();
    final now = tz.TZDateTime.now(tz.local);
    var id = 0;
    for (final n in notifications) {
      final w = n.when;
      // The same wall-clock time wherever the phone is.
      final at = tz.TZDateTime(
        tz.local,
        w.year,
        w.month,
        w.day,
        w.hour,
        w.minute,
      );
      if (!at.isAfter(now)) continue;
      await _plugin.zonedSchedule(
        id: id++,
        title: n.title,
        body: n.body,
        scheduledDate: at,
        notificationDetails: _details(labels, n.body),
        androidScheduleMode: mode,
      );
    }
  }
}
