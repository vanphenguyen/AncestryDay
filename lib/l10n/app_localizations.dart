import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_vi.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ja'),
    Locale('ko'),
    Locale('vi'),
    Locale('zh'),
    Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'),
  ];

  /// No description provided for @tabHome.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get tabHome;

  /// No description provided for @tabPeople.
  ///
  /// In en, this message translates to:
  /// **'Family'**
  String get tabPeople;

  /// No description provided for @tabCalendar.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get tabCalendar;

  /// No description provided for @regionVietnam.
  ///
  /// In en, this message translates to:
  /// **'Vietnam'**
  String get regionVietnam;

  /// No description provided for @regionChina.
  ///
  /// In en, this message translates to:
  /// **'China'**
  String get regionChina;

  /// No description provided for @regionKorea.
  ///
  /// In en, this message translates to:
  /// **'Korea'**
  String get regionKorea;

  /// No description provided for @regionJapan.
  ///
  /// In en, this message translates to:
  /// **'Japan'**
  String get regionJapan;

  /// No description provided for @regionVietnamHint.
  ///
  /// In en, this message translates to:
  /// **'Worked out for Hanoi time (UTC+7).'**
  String get regionVietnamHint;

  /// No description provided for @regionChinaHint.
  ///
  /// In en, this message translates to:
  /// **'Worked out for Beijing time (UTC+8). Also used in Taiwan, Hong Kong, Singapore and Malaysia.'**
  String get regionChinaHint;

  /// No description provided for @regionKoreaHint.
  ///
  /// In en, this message translates to:
  /// **'Worked out for Seoul time (UTC+9).'**
  String get regionKoreaHint;

  /// No description provided for @regionJapanHint.
  ///
  /// In en, this message translates to:
  /// **'Old calendar worked out for Tokyo time (UTC+9). In Japan most families keep remembrance days on the solar date.'**
  String get regionJapanHint;

  /// No description provided for @calendarOf.
  ///
  /// In en, this message translates to:
  /// **'{region} lunar calendar'**
  String calendarOf(String region);

  /// No description provided for @emptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Remember where we come from'**
  String get emptyTitle;

  /// No description provided for @emptyBody.
  ///
  /// In en, this message translates to:
  /// **'Add the people your family remembers. Every year the app finds the right day and reminds you in time.'**
  String get emptyBody;

  /// No description provided for @addPerson.
  ///
  /// In en, this message translates to:
  /// **'Add a loved one'**
  String get addPerson;

  /// No description provided for @nextUp.
  ///
  /// In en, this message translates to:
  /// **'Next remembrance day'**
  String get nextUp;

  /// No description provided for @sectionUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Coming up'**
  String get sectionUpcoming;

  /// No description provided for @inDays.
  ///
  /// In en, this message translates to:
  /// **'{n, plural, =0{Today} =1{Tomorrow} other{In {n} days}}'**
  String inDays(int n);

  /// No description provided for @memorialTitle.
  ///
  /// In en, this message translates to:
  /// **'Remembrance day of {name}'**
  String memorialTitle(String name);

  /// No description provided for @anniversaryNth.
  ///
  /// In en, this message translates to:
  /// **'{n, plural, =1{First anniversary} other{{n} years since passing}}'**
  String anniversaryNth(int n);

  /// No description provided for @differsElsewhere.
  ///
  /// In en, this message translates to:
  /// **'In the {regions} calendar this day falls on {date} this year.'**
  String differsElsewhere(String regions, String date);

  /// No description provided for @followingRegion.
  ///
  /// In en, this message translates to:
  /// **'The app follows the {region} calendar.'**
  String followingRegion(String region);

  /// No description provided for @webPreviewNotice.
  ///
  /// In en, this message translates to:
  /// **'This is a web preview. Reminders only work in the app on a phone.'**
  String get webPreviewNotice;

  /// No description provided for @notificationsOffNotice.
  ///
  /// In en, this message translates to:
  /// **'Notifications are off for this app. Turn them on in the phone’s Settings so reminders can reach you.'**
  String get notificationsOffNotice;

  /// No description provided for @peopleTitle.
  ///
  /// In en, this message translates to:
  /// **'Family remembrance book'**
  String get peopleTitle;

  /// No description provided for @peopleCount.
  ///
  /// In en, this message translates to:
  /// **'{n, plural, =0{No one yet} =1{1 person remembered} other{{n} people remembered}}'**
  String peopleCount(int n);

  /// No description provided for @nextOn.
  ///
  /// In en, this message translates to:
  /// **'Next: {date}'**
  String nextOn(String date);

  /// No description provided for @editAddTitle.
  ///
  /// In en, this message translates to:
  /// **'Add a loved one'**
  String get editAddTitle;

  /// No description provided for @editEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get editEditTitle;

  /// No description provided for @fieldName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get fieldName;

  /// No description provided for @fieldNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Grandpa An'**
  String get fieldNameHint;

  /// No description provided for @fieldRelation.
  ///
  /// In en, this message translates to:
  /// **'Relationship (optional)'**
  String get fieldRelation;

  /// No description provided for @relationSuggestions.
  ///
  /// In en, this message translates to:
  /// **'Grandfather,Grandmother,Father,Mother,Husband,Wife,Brother,Sister,Uncle,Aunt'**
  String get relationSuggestions;

  /// No description provided for @sectionDay.
  ///
  /// In en, this message translates to:
  /// **'Day of passing'**
  String get sectionDay;

  /// No description provided for @kindLunar.
  ///
  /// In en, this message translates to:
  /// **'Lunar calendar'**
  String get kindLunar;

  /// No description provided for @kindSolar.
  ///
  /// In en, this message translates to:
  /// **'Solar calendar'**
  String get kindSolar;

  /// No description provided for @fieldDay.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get fieldDay;

  /// No description provided for @fieldMonth.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get fieldMonth;

  /// No description provided for @fieldYear.
  ///
  /// In en, this message translates to:
  /// **'Year (optional)'**
  String get fieldYear;

  /// No description provided for @lunarKindHint.
  ///
  /// In en, this message translates to:
  /// **'The solar date is worked out anew each year with the {region} lunar calendar.'**
  String lunarKindHint(String region);

  /// No description provided for @solarKindHint.
  ///
  /// In en, this message translates to:
  /// **'The same solar date every year.'**
  String get solarKindHint;

  /// No description provided for @shortMonthNote.
  ///
  /// In en, this message translates to:
  /// **'In years when this month has only 29 days, the day is kept on the 29th.'**
  String get shortMonthNote;

  /// No description provided for @convertFromSolar.
  ///
  /// In en, this message translates to:
  /// **'I only know the solar date'**
  String get convertFromSolar;

  /// No description provided for @convertedNote.
  ///
  /// In en, this message translates to:
  /// **'{solar} was {lunar}.'**
  String convertedNote(String solar, String lunar);

  /// No description provided for @convertDifferNote.
  ///
  /// In en, this message translates to:
  /// **'Careful: on that day the countries’ calendars did not agree. Please check the lunar date with your family.'**
  String get convertDifferNote;

  /// No description provided for @fieldNote.
  ///
  /// In en, this message translates to:
  /// **'A few words of remembrance'**
  String get fieldNote;

  /// No description provided for @fieldNoteHint.
  ///
  /// In en, this message translates to:
  /// **'A memory, a favourite dish, where they rest…'**
  String get fieldNoteHint;

  /// No description provided for @previewTitle.
  ///
  /// In en, this message translates to:
  /// **'The coming years'**
  String get previewTitle;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get delete;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @deleteConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove {name}?'**
  String deleteConfirmTitle(String name);

  /// No description provided for @deleteConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'The reminders for this day will stop. This cannot be undone.'**
  String get deleteConfirmBody;

  /// No description provided for @errorName.
  ///
  /// In en, this message translates to:
  /// **'Please enter a name.'**
  String get errorName;

  /// No description provided for @errorDay.
  ///
  /// In en, this message translates to:
  /// **'This day does not exist. Please check the day and month.'**
  String get errorDay;

  /// No description provided for @errorYear.
  ///
  /// In en, this message translates to:
  /// **'Please check the year.'**
  String get errorYear;

  /// No description provided for @nothingThisDay.
  ///
  /// In en, this message translates to:
  /// **'Nothing to remember on this day.'**
  String get nothingThisDay;

  /// No description provided for @backToToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get backToToday;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsCalendar.
  ///
  /// In en, this message translates to:
  /// **'Which lunar calendar'**
  String get settingsCalendar;

  /// No description provided for @calendarExplain.
  ///
  /// In en, this message translates to:
  /// **'Each country works out the lunar calendar in its own time zone. Now and then the same lunar day lands on different solar days, sometimes a whole month apart. Phones usually show the Chinese calendar only. Choose the one your family follows.'**
  String get calendarExplain;

  /// No description provided for @seeDifferences.
  ///
  /// In en, this message translates to:
  /// **'See when the calendars differ'**
  String get seeDifferences;

  /// No description provided for @differencesTitle.
  ///
  /// In en, this message translates to:
  /// **'When the calendars differ'**
  String get differencesTitle;

  /// No description provided for @differencesIntro.
  ///
  /// In en, this message translates to:
  /// **'Periods in the next 20 years when the {region} lunar calendar shows another date than a neighbour’s. A day entered from the wrong calendar would be missed in these periods.'**
  String differencesIntro(String region);

  /// No description provided for @dateRange.
  ///
  /// In en, this message translates to:
  /// **'{from} to {to}'**
  String dateRange(String from, String to);

  /// No description provided for @regionSays.
  ///
  /// In en, this message translates to:
  /// **'{region}: {lunar}'**
  String regionSays(String region, String lunar);

  /// No description provided for @daysCount.
  ///
  /// In en, this message translates to:
  /// **'{n, plural, =1{1 day} other{{n} days}}'**
  String daysCount(int n);

  /// No description provided for @settingsReminders.
  ///
  /// In en, this message translates to:
  /// **'Reminders'**
  String get settingsReminders;

  /// No description provided for @leadDaysTitle.
  ///
  /// In en, this message translates to:
  /// **'Remind me about a remembrance day'**
  String get leadDaysTitle;

  /// No description provided for @leadDay.
  ///
  /// In en, this message translates to:
  /// **'{n, plural, =0{On the day} =1{1 day before} other{{n} days before}}'**
  String leadDay(int n);

  /// No description provided for @reminderTime.
  ///
  /// In en, this message translates to:
  /// **'Time of day'**
  String get reminderTime;

  /// No description provided for @settingsObservances.
  ///
  /// In en, this message translates to:
  /// **'Shared days of remembrance'**
  String get settingsObservances;

  /// No description provided for @observanceDayBefore.
  ///
  /// In en, this message translates to:
  /// **'Also remind me the day before'**
  String get observanceDayBefore;

  /// No description provided for @languageTitle.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageTitle;

  /// No description provided for @languageFollowPhone.
  ///
  /// In en, this message translates to:
  /// **'Same as the phone'**
  String get languageFollowPhone;

  /// No description provided for @testNotification.
  ///
  /// In en, this message translates to:
  /// **'Send a test reminder'**
  String get testNotification;

  /// No description provided for @testNotificationHint.
  ///
  /// In en, this message translates to:
  /// **'One arrives now and one in a minute.'**
  String get testNotificationHint;

  /// No description provided for @testNotificationBody.
  ///
  /// In en, this message translates to:
  /// **'This is how a reminder will look.'**
  String get testNotificationBody;

  /// No description provided for @testNotificationLaterBody.
  ///
  /// In en, this message translates to:
  /// **'Scheduled reminders arrive too. All is well.'**
  String get testNotificationLaterBody;

  /// No description provided for @testNotificationSent.
  ///
  /// In en, this message translates to:
  /// **'Sent. Look at the top of your screen.'**
  String get testNotificationSent;

  /// No description provided for @testNotificationBlocked.
  ///
  /// In en, this message translates to:
  /// **'The phone is not letting this app show notifications.'**
  String get testNotificationBlocked;

  /// No description provided for @notifChannelName.
  ///
  /// In en, this message translates to:
  /// **'Remembrance days'**
  String get notifChannelName;

  /// No description provided for @notifChannelDescription.
  ///
  /// In en, this message translates to:
  /// **'Reminders before and on days of remembrance'**
  String get notifChannelDescription;

  /// No description provided for @privacyNote.
  ///
  /// In en, this message translates to:
  /// **'Everything stays on this phone. No account, no internet, nothing collected.'**
  String get privacyNote;

  /// No description provided for @welcomeTagline.
  ///
  /// In en, this message translates to:
  /// **'So the days of those we love are never forgotten.'**
  String get welcomeTagline;

  /// No description provided for @welcomeBody.
  ///
  /// In en, this message translates to:
  /// **'Remembrance days follow the lunar calendar, so they land on a different solar date every year. The app finds the date and reminds you in time.'**
  String get welcomeBody;

  /// No description provided for @chooseCalendarTitle.
  ///
  /// In en, this message translates to:
  /// **'Which lunar calendar does your family follow?'**
  String get chooseCalendarTitle;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'Begin'**
  String get start;

  /// No description provided for @notifMemorialTodayTitle.
  ///
  /// In en, this message translates to:
  /// **'Today is the remembrance day of {name}'**
  String notifMemorialTodayTitle(String name);

  /// No description provided for @notifMemorialTodayBody.
  ///
  /// In en, this message translates to:
  /// **'{lunar}. Light a stick of incense and remember.'**
  String notifMemorialTodayBody(String lunar);

  /// No description provided for @notifMemorialTodayBodySolar.
  ///
  /// In en, this message translates to:
  /// **'Light a stick of incense and remember.'**
  String get notifMemorialTodayBodySolar;

  /// No description provided for @notifMemorialAheadTitle.
  ///
  /// In en, this message translates to:
  /// **'{n, plural, =1{Tomorrow is the remembrance day of {name}} other{{n} days until the remembrance day of {name}}}'**
  String notifMemorialAheadTitle(int n, String name);

  /// No description provided for @notifMemorialAheadBody.
  ///
  /// In en, this message translates to:
  /// **'{date} ({lunar}). There is still time to prepare.'**
  String notifMemorialAheadBody(String date, String lunar);

  /// No description provided for @notifMemorialAheadBodySolar.
  ///
  /// In en, this message translates to:
  /// **'{date}. There is still time to prepare.'**
  String notifMemorialAheadBodySolar(String date);

  /// No description provided for @notifObservanceTodayTitle.
  ///
  /// In en, this message translates to:
  /// **'Today: {title}'**
  String notifObservanceTodayTitle(String title);

  /// No description provided for @notifObservanceTomorrowTitle.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow: {title}'**
  String notifObservanceTomorrowTitle(String title);

  /// No description provided for @notifKeepAliveTitle.
  ///
  /// In en, this message translates to:
  /// **'Open the app to keep the reminders coming'**
  String get notifKeepAliveTitle;

  /// No description provided for @notifKeepAliveBody.
  ///
  /// In en, this message translates to:
  /// **'Reminders are prepared about a year ahead. Opening the app once prepares the next ones.'**
  String get notifKeepAliveBody;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ja', 'ko', 'vi', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+script codes are specified.
  switch (locale.languageCode) {
    case 'zh':
      {
        switch (locale.scriptCode) {
          case 'Hant':
            return AppLocalizationsZhHant();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'vi':
      return AppLocalizationsVi();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
