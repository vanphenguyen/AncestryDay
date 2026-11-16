// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get tabHome => 'これから';

  @override
  String get tabPeople => 'ご先祖';

  @override
  String get tabCalendar => '暦';

  @override
  String get regionVietnam => 'ベトナム';

  @override
  String get regionChina => '中国';

  @override
  String get regionKorea => '韓国';

  @override
  String get regionJapan => '日本';

  @override
  String get regionVietnamHint => 'ハノイ時間(UTC+7)で計算します。';

  @override
  String get regionChinaHint => '北京時間(UTC+8)で計算します。台湾・香港・シンガポール・マレーシアでも使われます。';

  @override
  String get regionKoreaHint => 'ソウル時間(UTC+9)で計算します。';

  @override
  String get regionJapanHint => '旧暦は東京時間(UTC+9)で計算します。命日は新暦で数えるご家庭が一般的です。';

  @override
  String calendarOf(String region) {
    return '$regionの旧暦';
  }

  @override
  String get emptyTitle => 'ご先祖を想う';

  @override
  String get emptyBody => '大切な故人を登録してください。毎年の命日を計算し、準備に間に合うようお知らせします。';

  @override
  String get addPerson => '故人を登録';

  @override
  String get nextUp => '次のご命日';

  @override
  String get sectionUpcoming => 'これからの予定';

  @override
  String inDays(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'あと$n日',
      one: '明日',
      zero: '今日',
    );
    return '$_temp0';
  }

  @override
  String memorialTitle(String name) {
    return '$nameのご命日';
  }

  @override
  String anniversaryNth(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '没後$n年',
      two: '三回忌',
      one: '一周忌',
    );
    return '$_temp0';
  }

  @override
  String differsElsewhere(String regions, String date) {
    return 'この年、$regionsの暦ではこの日は$dateにあたります。';
  }

  @override
  String followingRegion(String region) {
    return 'このアプリは$regionの暦でお知らせします。';
  }

  @override
  String get webPreviewNotice => 'これはウェブ版プレビューです。通知はスマホアプリでのみ届きます。';

  @override
  String get notificationsOffNotice => '通知がオフになっています。端末の設定でオンにしてください。';

  @override
  String get peopleTitle => 'ご命日帳';

  @override
  String peopleCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n名を登録中',
      zero: 'まだ登録がありません',
    );
    return '$_temp0';
  }

  @override
  String nextOn(String date) {
    return '次回:$date';
  }

  @override
  String get editAddTitle => '故人を登録';

  @override
  String get editEditTitle => '編集';

  @override
  String get fieldName => 'お名前';

  @override
  String get fieldNameHint => '例:祖父 山田太郎';

  @override
  String get fieldRelation => '続柄(任意)';

  @override
  String get relationSuggestions => '祖父,祖母,父,母,夫,妻,兄,姉,弟,妹';

  @override
  String get sectionDay => '亡くなった日';

  @override
  String get kindLunar => '旧暦';

  @override
  String get kindSolar => '新暦';

  @override
  String get fieldDay => '日';

  @override
  String get fieldMonth => '月';

  @override
  String get fieldYear => '年(任意)';

  @override
  String lunarKindHint(String region) {
    return '毎年、$regionの旧暦から新暦の日付を計算します。';
  }

  @override
  String get solarKindHint => '毎年、同じ新暦の日にお知らせします。';

  @override
  String get shortMonthNote => 'その月が29日までの年は、29日にお知らせします。';

  @override
  String get convertFromSolar => '新暦の日付しか分からない';

  @override
  String convertedNote(String solar, String lunar) {
    return '$solarは$lunarです。';
  }

  @override
  String get convertDifferNote => 'ご注意:その日は国によって旧暦の日付が異なります。ご家族にご確認ください。';

  @override
  String get fieldNote => '思い出のことば';

  @override
  String get fieldNoteHint => '思い出、好きだった料理、お墓の場所など';

  @override
  String get previewTitle => 'これからの年の日付';

  @override
  String get save => '保存';

  @override
  String get delete => '削除';

  @override
  String get cancel => 'キャンセル';

  @override
  String deleteConfirmTitle(String name) {
    return '$nameを削除しますか?';
  }

  @override
  String get deleteConfirmBody => 'このご命日のお知らせは届かなくなります。元に戻せません。';

  @override
  String get errorName => 'お名前を入力してください。';

  @override
  String get errorDay => 'この日付はありません。日と月をご確認ください。';

  @override
  String get errorYear => '年をご確認ください。';

  @override
  String get nothingThisDay => 'この日の予定はありません。';

  @override
  String get backToToday => '今日';

  @override
  String get settingsTitle => '設定';

  @override
  String get settingsCalendar => 'どの国の旧暦を使うか';

  @override
  String get calendarExplain =>
      '旧暦は国ごとの時刻で計算するため、同じ旧暦の日が別の新暦の日になることがあり、ひと月ずれる年もあります。スマホ標準の旧暦は多くが中国式です。ご家庭で使う暦を選んでください。';

  @override
  String get seeDifferences => '暦が食い違う日を見る';

  @override
  String get differencesTitle => '暦が食い違う時期';

  @override
  String differencesIntro(String region) {
    return '今後20年のうち、$regionの旧暦が他国の暦と異なる期間です。暦を取り違えると、この期間は日がずれます。';
  }

  @override
  String dateRange(String from, String to) {
    return '$from 〜 $to';
  }

  @override
  String regionSays(String region, String lunar) {
    return '$region:$lunar';
  }

  @override
  String daysCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(n, locale: localeName, other: '$n日間');
    return '$_temp0';
  }

  @override
  String get settingsReminders => 'お知らせ';

  @override
  String get leadDaysTitle => 'ご命日のお知らせ';

  @override
  String leadDay(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n日前',
      zero: '当日',
    );
    return '$_temp0';
  }

  @override
  String get reminderTime => 'お知らせの時刻';

  @override
  String get settingsObservances => 'お彼岸・お盆などの行事';

  @override
  String get observanceDayBefore => '前日にもお知らせする';

  @override
  String get languageTitle => '言語';

  @override
  String get languageFollowPhone => '端末と同じ';

  @override
  String get testNotification => 'テスト通知を送る';

  @override
  String get testNotificationHint => 'ひとつはすぐに、もうひとつは1分後に届きます。';

  @override
  String get testNotificationBody => 'お知らせはこのように表示されます。';

  @override
  String get testNotificationLaterBody => '予約したお知らせも届きます。問題ありません。';

  @override
  String get testNotificationSent => '送信しました。画面上部をご覧ください。';

  @override
  String get testNotificationBlocked => '端末がこのアプリの通知を許可していません。';

  @override
  String get notifChannelName => 'ご命日と行事';

  @override
  String get notifChannelDescription => 'ご命日や行事の前と当日のお知らせ';

  @override
  String get privacyNote => 'データはすべてこの端末の中だけに保存されます。アカウントも通信も不要です。';

  @override
  String get welcomeTagline => '大切な人の日を、忘れないために。';

  @override
  String get welcomeBody => '旧暦の行事は毎年新暦の日付が変わります。アプリが日付を計算し、間に合うようお知らせします。';

  @override
  String get chooseCalendarTitle => 'ご家庭ではどの国の旧暦を使いますか?';

  @override
  String get start => 'はじめる';

  @override
  String notifMemorialTodayTitle(String name) {
    return '今日は$nameのご命日です';
  }

  @override
  String notifMemorialTodayBody(String lunar) {
    return '$lunar。お線香をあげて、故人を偲びましょう。';
  }

  @override
  String get notifMemorialTodayBodySolar => 'お線香をあげて、故人を偲びましょう。';

  @override
  String notifMemorialAheadTitle(int n, String name) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$nameのご命日まであと$n日',
      one: '明日は$nameのご命日です',
    );
    return '$_temp0';
  }

  @override
  String notifMemorialAheadBody(String date, String lunar) {
    return '$date($lunar)。まだ準備に間に合います。';
  }

  @override
  String notifMemorialAheadBodySolar(String date) {
    return '$date。まだ準備に間に合います。';
  }

  @override
  String notifObservanceTodayTitle(String title) {
    return '今日:$title';
  }

  @override
  String notifObservanceTomorrowTitle(String title) {
    return '明日:$title';
  }

  @override
  String get notifKeepAliveTitle => 'アプリを開いて、お知らせを続けましょう';

  @override
  String get notifKeepAliveBody => 'お知らせは約1年先まで準備されます。一度開くと、その先も準備されます。';
}
