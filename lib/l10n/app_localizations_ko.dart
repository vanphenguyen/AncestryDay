// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get tabHome => '다가오는 날';

  @override
  String get tabPeople => '가족';

  @override
  String get tabCalendar => '달력';

  @override
  String get regionVietnam => '베트남';

  @override
  String get regionChina => '중국';

  @override
  String get regionKorea => '한국';

  @override
  String get regionJapan => '일본';

  @override
  String get regionVietnamHint => '하노이 시간(UTC+7) 기준으로 계산합니다.';

  @override
  String get regionChinaHint =>
      '베이징 시간(UTC+8) 기준입니다. 대만, 홍콩, 싱가포르, 말레이시아도 같습니다.';

  @override
  String get regionKoreaHint => '서울 시간(UTC+9) 기준으로 계산합니다.';

  @override
  String get regionJapanHint =>
      '음력은 도쿄 시간(UTC+9) 기준입니다. 일본은 대부분 양력으로 기일을 지냅니다.';

  @override
  String calendarOf(String region) {
    return '$region 음력';
  }

  @override
  String get emptyTitle => '뿌리를 기억합니다';

  @override
  String get emptyBody => '먼저 떠난 가족을 등록해 주세요. 해마다 기일을 양력으로 계산해 미리 알려 드립니다.';

  @override
  String get addPerson => '가족 추가';

  @override
  String get nextUp => '다가오는 기일';

  @override
  String get sectionUpcoming => '다가오는 일정';

  @override
  String inDays(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n일 남음',
      one: '내일',
      zero: '오늘',
    );
    return '$_temp0';
  }

  @override
  String memorialTitle(String name) {
    return '$name 기일';
  }

  @override
  String anniversaryNth(int n) {
    String _temp0 = intl.Intl.pluralLogic(n, locale: localeName, other: '$n주기');
    return '$_temp0';
  }

  @override
  String differsElsewhere(String regions, String date) {
    return '이 해에는 $regions 달력으로 이 날이 $date입니다.';
  }

  @override
  String followingRegion(String region) {
    return '앱은 $region 달력에 맞춰 알려 드립니다.';
  }

  @override
  String get webPreviewNotice => '웹 미리보기입니다. 알림은 휴대폰 앱에서만 작동합니다.';

  @override
  String get notificationsOffNotice => '앱 알림이 꺼져 있습니다. 휴대폰 설정에서 켜 주세요.';

  @override
  String get peopleTitle => '가족 기일 수첩';

  @override
  String peopleCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n분을 기억합니다',
      zero: '아직 없습니다',
    );
    return '$_temp0';
  }

  @override
  String nextOn(String date) {
    return '다음: $date';
  }

  @override
  String get editAddTitle => '가족 추가';

  @override
  String get editEditTitle => '수정';

  @override
  String get fieldName => '이름';

  @override
  String get fieldNameHint => '예: 할아버지 김영수';

  @override
  String get fieldRelation => '관계 (선택)';

  @override
  String get relationSuggestions => '할아버지,할머니,외할아버지,외할머니,아버지,어머니,남편,아내,형제,자매';

  @override
  String get sectionDay => '돌아가신 날';

  @override
  String get kindLunar => '음력';

  @override
  String get kindSolar => '양력';

  @override
  String get fieldDay => '일';

  @override
  String get fieldMonth => '월';

  @override
  String get fieldYear => '연도 (선택)';

  @override
  String lunarKindHint(String region) {
    return '해마다 $region 음력으로 양력 날짜를 다시 계산합니다.';
  }

  @override
  String get solarKindHint => '해마다 같은 양력 날짜에 알려 드립니다.';

  @override
  String get shortMonthNote => '그 달이 29일까지인 해에는 29일에 지냅니다.';

  @override
  String get convertFromSolar => '양력 날짜만 알아요';

  @override
  String convertedNote(String solar, String lunar) {
    return '$solar은(는) $lunar입니다.';
  }

  @override
  String get convertDifferNote => '주의: 그날은 나라마다 음력 날짜가 달랐습니다. 가족에게 확인해 보세요.';

  @override
  String get fieldNote => '추억의 한마디';

  @override
  String get fieldNoteHint => '추억, 좋아하시던 음식, 모신 곳…';

  @override
  String get previewTitle => '앞으로의 날짜';

  @override
  String get save => '저장';

  @override
  String get delete => '삭제';

  @override
  String get cancel => '취소';

  @override
  String deleteConfirmTitle(String name) {
    return '$name을(를) 삭제할까요?';
  }

  @override
  String get deleteConfirmBody => '이 기일 알림이 중단되며 되돌릴 수 없습니다.';

  @override
  String get errorName => '이름을 입력해 주세요.';

  @override
  String get errorDay => '없는 날짜입니다. 일과 월을 확인해 주세요.';

  @override
  String get errorYear => '연도를 확인해 주세요.';

  @override
  String get nothingThisDay => '이 날은 기일이나 명절이 없습니다.';

  @override
  String get backToToday => '오늘';

  @override
  String get settingsTitle => '설정';

  @override
  String get settingsCalendar => '어느 나라 음력을 쓸까요';

  @override
  String get calendarExplain =>
      '음력은 나라마다 자기 시간대로 계산합니다. 그래서 같은 음력 날짜가 가끔 다른 양력 날짜가 되고, 한 달씩 차이 나는 해도 있습니다. 휴대폰 기본 음력은 대개 중국식입니다. 가족이 따르는 달력을 골라 주세요.';

  @override
  String get seeDifferences => '달력이 서로 다른 날 보기';

  @override
  String get differencesTitle => '달력이 다른 시기';

  @override
  String differencesIntro(String region) {
    return '앞으로 20년 동안 $region 음력이 다른 나라 달력과 다른 기간입니다. 달력을 잘못 쓰면 이 기간에 날짜가 어긋납니다.';
  }

  @override
  String dateRange(String from, String to) {
    return '$from ~ $to';
  }

  @override
  String regionSays(String region, String lunar) {
    return '$region: $lunar';
  }

  @override
  String daysCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(n, locale: localeName, other: '$n일');
    return '$_temp0';
  }

  @override
  String get settingsReminders => '알림';

  @override
  String get leadDaysTitle => '기일 알림 시점';

  @override
  String leadDay(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n일 전',
      zero: '당일',
    );
    return '$_temp0';
  }

  @override
  String get reminderTime => '알림 시각';

  @override
  String get settingsObservances => '명절과 초하루·보름';

  @override
  String get observanceDayBefore => '하루 전에도 알림';

  @override
  String get languageTitle => '언어';

  @override
  String get languageFollowPhone => '휴대폰과 같게';

  @override
  String get testNotification => '테스트 알림 보내기';

  @override
  String get testNotificationHint => '하나는 지금, 하나는 1분 뒤에 도착합니다.';

  @override
  String get testNotificationBody => '알림은 이렇게 표시됩니다.';

  @override
  String get testNotificationLaterBody => '예약 알림도 잘 도착합니다. 모두 정상입니다.';

  @override
  String get testNotificationSent => '보냈습니다. 화면 위쪽을 확인해 주세요.';

  @override
  String get testNotificationBlocked => '휴대폰이 이 앱의 알림을 허용하지 않습니다.';

  @override
  String get notifChannelName => '기일과 명절';

  @override
  String get notifChannelDescription => '기일과 명절 전날과 당일 알림';

  @override
  String get privacyNote => '모든 내용은 이 휴대폰에만 저장됩니다. 계정도 인터넷도 필요 없습니다.';

  @override
  String get welcomeTagline => '사랑하는 이의 날을 잊지 않도록.';

  @override
  String get welcomeBody =>
      '기일과 명절은 음력이라 해마다 양력 날짜가 달라집니다. 앱이 날짜를 계산해 제때 알려 드립니다.';

  @override
  String get chooseCalendarTitle => '가족이 따르는 음력은 어느 나라 것인가요?';

  @override
  String get start => '시작하기';

  @override
  String notifMemorialTodayTitle(String name) {
    return '오늘은 $name 기일입니다';
  }

  @override
  String notifMemorialTodayBody(String lunar) {
    return '$lunar. 향 하나 올리며 그리운 분을 떠올려 보세요.';
  }

  @override
  String get notifMemorialTodayBodySolar => '향 하나 올리며 그리운 분을 떠올려 보세요.';

  @override
  String notifMemorialAheadTitle(int n, String name) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$name 기일까지 $n일 남았습니다',
      one: '내일은 $name 기일입니다',
    );
    return '$_temp0';
  }

  @override
  String notifMemorialAheadBody(String date, String lunar) {
    return '$date ($lunar). 아직 준비할 시간이 있습니다.';
  }

  @override
  String notifMemorialAheadBodySolar(String date) {
    return '$date. 아직 준비할 시간이 있습니다.';
  }

  @override
  String notifObservanceTodayTitle(String title) {
    return '오늘: $title';
  }

  @override
  String notifObservanceTomorrowTitle(String title) {
    return '내일: $title';
  }

  @override
  String get notifKeepAliveTitle => '앱을 한 번 열어 알림을 이어 가세요';

  @override
  String get notifKeepAliveBody => '알림은 약 1년 치가 준비됩니다. 앱을 한 번 열면 다음 알림이 준비됩니다.';
}
