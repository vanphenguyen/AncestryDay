// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get tabHome => 'Upcoming';

  @override
  String get tabPeople => 'Family';

  @override
  String get tabCalendar => 'Calendar';

  @override
  String get regionVietnam => 'Vietnam';

  @override
  String get regionChina => 'China';

  @override
  String get regionKorea => 'Korea';

  @override
  String get regionJapan => 'Japan';

  @override
  String get regionVietnamHint => 'Worked out for Hanoi time (UTC+7).';

  @override
  String get regionChinaHint =>
      'Worked out for Beijing time (UTC+8). Also used in Taiwan, Hong Kong, Singapore and Malaysia.';

  @override
  String get regionKoreaHint => 'Worked out for Seoul time (UTC+9).';

  @override
  String get regionJapanHint =>
      'Old calendar worked out for Tokyo time (UTC+9). In Japan most families keep remembrance days on the solar date.';

  @override
  String calendarOf(String region) {
    return '$region lunar calendar';
  }

  @override
  String get emptyTitle => 'Remember where we come from';

  @override
  String get emptyBody =>
      'Add the people your family remembers. Every year the app finds the right day and reminds you in time.';

  @override
  String get addPerson => 'Add a loved one';

  @override
  String get nextUp => 'Next remembrance day';

  @override
  String get sectionUpcoming => 'Coming up';

  @override
  String inDays(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'In $n days',
      one: 'Tomorrow',
      zero: 'Today',
    );
    return '$_temp0';
  }

  @override
  String memorialTitle(String name) {
    return 'Remembrance day of $name';
  }

  @override
  String anniversaryNth(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n years since passing',
      one: 'First anniversary',
    );
    return '$_temp0';
  }

  @override
  String differsElsewhere(String regions, String date) {
    return 'In the $regions calendar this day falls on $date this year.';
  }

  @override
  String followingRegion(String region) {
    return 'The app follows the $region calendar.';
  }

  @override
  String get webPreviewNotice =>
      'This is a web preview. Reminders only work in the app on a phone.';

  @override
  String get notificationsOffNotice =>
      'Notifications are off for this app. Turn them on in the phone’s Settings so reminders can reach you.';

  @override
  String get peopleTitle => 'Family remembrance book';

  @override
  String peopleCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n people remembered',
      one: '1 person remembered',
      zero: 'No one yet',
    );
    return '$_temp0';
  }

  @override
  String nextOn(String date) {
    return 'Next: $date';
  }

  @override
  String get editAddTitle => 'Add a loved one';

  @override
  String get editEditTitle => 'Edit';

  @override
  String get fieldName => 'Name';

  @override
  String get fieldNameHint => 'e.g. Grandpa An';

  @override
  String get fieldRelation => 'Relationship (optional)';

  @override
  String get relationSuggestions =>
      'Grandfather,Grandmother,Father,Mother,Husband,Wife,Brother,Sister,Uncle,Aunt';

  @override
  String get sectionDay => 'Day of passing';

  @override
  String get kindLunar => 'Lunar calendar';

  @override
  String get kindSolar => 'Solar calendar';

  @override
  String get fieldDay => 'Day';

  @override
  String get fieldMonth => 'Month';

  @override
  String get fieldYear => 'Year (optional)';

  @override
  String lunarKindHint(String region) {
    return 'The solar date is worked out anew each year with the $region lunar calendar.';
  }

  @override
  String get solarKindHint => 'The same solar date every year.';

  @override
  String get shortMonthNote =>
      'In years when this month has only 29 days, the day is kept on the 29th.';

  @override
  String get convertFromSolar => 'I only know the solar date';

  @override
  String convertedNote(String solar, String lunar) {
    return '$solar was $lunar.';
  }

  @override
  String get convertDifferNote =>
      'Careful: on that day the countries’ calendars did not agree. Please check the lunar date with your family.';

  @override
  String get fieldNote => 'A few words of remembrance';

  @override
  String get fieldNoteHint => 'A memory, a favourite dish, where they rest…';

  @override
  String get previewTitle => 'The coming years';

  @override
  String get save => 'Save';

  @override
  String get delete => 'Remove';

  @override
  String get cancel => 'Cancel';

  @override
  String deleteConfirmTitle(String name) {
    return 'Remove $name?';
  }

  @override
  String get deleteConfirmBody =>
      'The reminders for this day will stop. This cannot be undone.';

  @override
  String get errorName => 'Please enter a name.';

  @override
  String get errorDay =>
      'This day does not exist. Please check the day and month.';

  @override
  String get errorYear => 'Please check the year.';

  @override
  String get nothingThisDay => 'Nothing to remember on this day.';

  @override
  String get backToToday => 'Today';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsCalendar => 'Which lunar calendar';

  @override
  String get calendarExplain =>
      'Each country works out the lunar calendar in its own time zone. Now and then the same lunar day lands on different solar days, sometimes a whole month apart. Phones usually show the Chinese calendar only. Choose the one your family follows.';

  @override
  String get seeDifferences => 'See when the calendars differ';

  @override
  String get differencesTitle => 'When the calendars differ';

  @override
  String differencesIntro(String region) {
    return 'Periods in the next 20 years when the $region lunar calendar shows another date than a neighbour’s. A day entered from the wrong calendar would be missed in these periods.';
  }

  @override
  String dateRange(String from, String to) {
    return '$from to $to';
  }

  @override
  String regionSays(String region, String lunar) {
    return '$region: $lunar';
  }

  @override
  String daysCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n days',
      one: '1 day',
    );
    return '$_temp0';
  }

  @override
  String get settingsReminders => 'Reminders';

  @override
  String get leadDaysTitle => 'Remind me about a remembrance day';

  @override
  String leadDay(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n days before',
      one: '1 day before',
      zero: 'On the day',
    );
    return '$_temp0';
  }

  @override
  String get reminderTime => 'Time of day';

  @override
  String get settingsObservances => 'Shared days of remembrance';

  @override
  String get observanceDayBefore => 'Also remind me the day before';

  @override
  String get languageTitle => 'Language';

  @override
  String get languageFollowPhone => 'Same as the phone';

  @override
  String get testNotification => 'Send a test reminder';

  @override
  String get testNotificationHint => 'One arrives now and one in a minute.';

  @override
  String get testNotificationBody => 'This is how a reminder will look.';

  @override
  String get testNotificationLaterBody =>
      'Scheduled reminders arrive too. All is well.';

  @override
  String get testNotificationSent => 'Sent. Look at the top of your screen.';

  @override
  String get testNotificationBlocked =>
      'The phone is not letting this app show notifications.';

  @override
  String get notifChannelName => 'Remembrance days';

  @override
  String get notifChannelDescription =>
      'Reminders before and on days of remembrance';

  @override
  String get privacyNote =>
      'Everything stays on this phone. No account, no internet, nothing collected.';

  @override
  String get welcomeTagline =>
      'So the days of those we love are never forgotten.';

  @override
  String get welcomeBody =>
      'Remembrance days follow the lunar calendar, so they land on a different solar date every year. The app finds the date and reminds you in time.';

  @override
  String get chooseCalendarTitle =>
      'Which lunar calendar does your family follow?';

  @override
  String get start => 'Begin';

  @override
  String notifMemorialTodayTitle(String name) {
    return 'Today is the remembrance day of $name';
  }

  @override
  String notifMemorialTodayBody(String lunar) {
    return '$lunar. Light a stick of incense and remember.';
  }

  @override
  String get notifMemorialTodayBodySolar =>
      'Light a stick of incense and remember.';

  @override
  String notifMemorialAheadTitle(int n, String name) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n days until the remembrance day of $name',
      one: 'Tomorrow is the remembrance day of $name',
    );
    return '$_temp0';
  }

  @override
  String notifMemorialAheadBody(String date, String lunar) {
    return '$date ($lunar). There is still time to prepare.';
  }

  @override
  String notifMemorialAheadBodySolar(String date) {
    return '$date. There is still time to prepare.';
  }

  @override
  String notifObservanceTodayTitle(String title) {
    return 'Today: $title';
  }

  @override
  String notifObservanceTomorrowTitle(String title) {
    return 'Tomorrow: $title';
  }

  @override
  String get notifKeepAliveTitle => 'Open the app to keep the reminders coming';

  @override
  String get notifKeepAliveBody =>
      'Reminders are prepared about a year ahead. Opening the app once prepares the next ones.';
}
