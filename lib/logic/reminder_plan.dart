import '../models/settings.dart';
import 'occurrences.dart';

/// iPhones keep at most 64 scheduled notifications per app. The plan stays
/// below that, with one slot kept for the "open the app" notice.
const maxNotificationSlots = 60;

/// How far ahead reminders are put on the phone's schedule.
const planHorizonDays = 400;

/// One notification to schedule.
class ReminderSlot {
  const ReminderSlot({
    required this.when,
    required this.daysBefore,
    this.memorial,
    this.observances = const [],
  });

  /// A notice asking to open the app so that later reminders get scheduled.
  const ReminderSlot.keepAlive(this.when)
    : daysBefore = 0,
      memorial = null,
      observances = const [];

  final DateTime when;

  /// 0 on the day itself.
  final int daysBefore;
  final MemorialOccurrence? memorial;
  final List<ObservanceOccurrence> observances;

  bool get isKeepAlive => memorial == null && observances.isEmpty;
}

/// Decides which notifications to schedule for [agenda] (the coming days
/// with something to remember), within the phone's limit.
///
/// Reminders for people come first: shared days (rằm, mùng một, festivals)
/// only use what is left, so they can never push a remembrance day out.
/// The last slot asks the user to open the app, at the point where the
/// schedule runs out, so reminders never stop silently.
List<ReminderSlot> planReminders({
  required List<AgendaDay> agenda,
  required Settings settings,
  required DateTime now,
  int maxSlots = maxNotificationSlots,
}) {
  DateTime at(DateTime day, int daysBefore) {
    final d = addDays(day, -daysBefore);
    return DateTime(
      d.year,
      d.month,
      d.day,
      settings.time.hour,
      settings.time.minute,
    );
  }

  final people = <ReminderSlot>[];
  final shared = <ReminderSlot>[];
  for (final day in agenda) {
    for (final memorial in day.memorials) {
      for (final lead in settings.leadDays) {
        final when = at(day.date, lead);
        if (when.isAfter(now)) {
          people.add(
            ReminderSlot(when: when, daysBefore: lead, memorial: memorial),
          );
        }
      }
    }
    if (day.observances.isNotEmpty) {
      for (final lead in [0, if (settings.observanceDayBefore) 1]) {
        final when = at(day.date, lead);
        if (when.isAfter(now)) {
          shared.add(
            ReminderSlot(
              when: when,
              daysBefore: lead,
              observances: day.observances,
            ),
          );
        }
      }
    }
  }
  int byTime(ReminderSlot a, ReminderSlot b) => a.when.compareTo(b.when);
  people.sort(byTime);
  shared.sort(byTime);

  final room = maxSlots - 1;
  final keptPeople = people.take(room).toList();
  final keptShared = shared.take(room - keptPeople.length).toList();

  // Where the schedule runs out: the first reminder that did not fit, or
  // the end of the planned period.
  var end = at(addDays(dayOf(now), planHorizonDays), 0);
  for (final dropped in [
    if (keptPeople.length < people.length) people[keptPeople.length],
    if (keptShared.length < shared.length) shared[keptShared.length],
  ]) {
    if (dropped.when.isBefore(end)) end = dropped.when;
  }

  return [
    ...keptPeople,
    ...keptShared,
    if (keptPeople.isNotEmpty || keptShared.isNotEmpty)
      ReminderSlot.keepAlive(end),
  ]..sort(byTime);
}
