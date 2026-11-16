// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get tabHome => '近期';

  @override
  String get tabPeople => '先人';

  @override
  String get tabCalendar => '农历';

  @override
  String get regionVietnam => '越南';

  @override
  String get regionChina => '中国';

  @override
  String get regionKorea => '韩国';

  @override
  String get regionJapan => '日本';

  @override
  String get regionVietnamHint => '按河内时间(UTC+7)推算。';

  @override
  String get regionChinaHint => '按北京时间(UTC+8)推算。台湾、香港、新加坡、马来西亚同用。';

  @override
  String get regionKoreaHint => '按首尔时间(UTC+9)推算。';

  @override
  String get regionJapanHint => '旧历按东京时间(UTC+9)推算。日本多数家庭按公历过忌日。';

  @override
  String calendarOf(String region) {
    return '$region农历';
  }

  @override
  String get emptyTitle => '饮水思源';

  @override
  String get emptyBody => '添加家中已故的亲人。每年自动推算忌日对应的公历日期,并提前提醒您。';

  @override
  String get addPerson => '添加亲人';

  @override
  String get nextUp => '最近的忌日';

  @override
  String get sectionUpcoming => '接下来的日子';

  @override
  String inDays(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '还有$n天',
      one: '明天',
      zero: '今天',
    );
    return '$_temp0';
  }

  @override
  String memorialTitle(String name) {
    return '$name的忌日';
  }

  @override
  String anniversaryNth(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '逝世$n周年',
      one: '周年忌',
    );
    return '$_temp0';
  }

  @override
  String differsElsewhere(String regions, String date) {
    return '这一年按$regions历法,这一天是$date。';
  }

  @override
  String followingRegion(String region) {
    return '本应用按$region历法提醒。';
  }

  @override
  String get webPreviewNotice => '这是网页预览版,提醒功能仅在手机应用中有效。';

  @override
  String get notificationsOffNotice => '本应用的通知已关闭。请在手机设置中开启,以便收到提醒。';

  @override
  String get peopleTitle => '家族忌日簿';

  @override
  String peopleCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '纪念$n位亲人',
      zero: '尚未添加',
    );
    return '$_temp0';
  }

  @override
  String nextOn(String date) {
    return '下一次:$date';
  }

  @override
  String get editAddTitle => '添加亲人';

  @override
  String get editEditTitle => '编辑';

  @override
  String get fieldName => '姓名或称呼';

  @override
  String get fieldNameHint => '例如:爷爷 王建国';

  @override
  String get fieldRelation => '与您的关系(选填)';

  @override
  String get relationSuggestions => '爷爷,奶奶,外公,外婆,父亲,母亲,丈夫,妻子,哥哥,姐姐';

  @override
  String get sectionDay => '逝世日期';

  @override
  String get kindLunar => '农历';

  @override
  String get kindSolar => '公历';

  @override
  String get fieldDay => '日';

  @override
  String get fieldMonth => '月';

  @override
  String get fieldYear => '年份(选填)';

  @override
  String lunarKindHint(String region) {
    return '每年按$region农历重新推算公历日期。';
  }

  @override
  String get solarKindHint => '每年在同一公历日期提醒。';

  @override
  String get shortMonthNote => '若当年该月只有29天,则按廿九日纪念。';

  @override
  String get convertFromSolar => '我只记得公历日期';

  @override
  String convertedNote(String solar, String lunar) {
    return '$solar即$lunar。';
  }

  @override
  String get convertDifferNote => '注意:那一天各国农历并不一致,请向家人确认农历日期。';

  @override
  String get fieldNote => '怀念的话';

  @override
  String get fieldNoteHint => '一段回忆、爱吃的菜、长眠之地……';

  @override
  String get previewTitle => '未来几年的日期';

  @override
  String get save => '保存';

  @override
  String get delete => '删除';

  @override
  String get cancel => '取消';

  @override
  String deleteConfirmTitle(String name) {
    return '删除$name?';
  }

  @override
  String get deleteConfirmBody => '将不再提醒这个忌日,且无法恢复。';

  @override
  String get errorName => '请输入姓名。';

  @override
  String get errorDay => '没有这一天,请检查日期和月份。';

  @override
  String get errorYear => '请检查年份。';

  @override
  String get nothingThisDay => '这一天没有忌日或节日。';

  @override
  String get backToToday => '今天';

  @override
  String get settingsTitle => '设置';

  @override
  String get settingsCalendar => '使用哪国的农历';

  @override
  String get calendarExplain =>
      '各国按本国时区推算农历,所以同一个农历日偶尔会落在不同的公历日,有时甚至相差一个月。手机自带的通常只有中国农历。请选择您家所依循的历法。';

  @override
  String get seeDifferences => '查看各历法不一致的日子';

  @override
  String get differencesTitle => '各历法何时不同';

  @override
  String differencesIntro(String region) {
    return '未来20年中,$region农历与他国历法日期不同的时段。若用错历法,这些时段内就会记错日子。';
  }

  @override
  String dateRange(String from, String to) {
    return '$from 至 $to';
  }

  @override
  String regionSays(String region, String lunar) {
    return '$region:$lunar';
  }

  @override
  String daysCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(n, locale: localeName, other: '$n天');
    return '$_temp0';
  }

  @override
  String get settingsReminders => '提醒';

  @override
  String get leadDaysTitle => '忌日提醒时间';

  @override
  String leadDay(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '提前$n天',
      zero: '当天',
    );
    return '$_temp0';
  }

  @override
  String get reminderTime => '提醒时刻';

  @override
  String get settingsObservances => '初一、十五与节日';

  @override
  String get observanceDayBefore => '提前一天再提醒一次';

  @override
  String get languageTitle => '语言';

  @override
  String get languageFollowPhone => '跟随手机';

  @override
  String get testNotification => '发送测试提醒';

  @override
  String get testNotificationHint => '一条立即送达,一条一分钟后送达。';

  @override
  String get testNotificationBody => '提醒将这样显示。';

  @override
  String get testNotificationLaterBody => '定时提醒也能送达,一切正常。';

  @override
  String get testNotificationSent => '已发送,请看屏幕上方。';

  @override
  String get testNotificationBlocked => '手机未允许本应用显示通知。';

  @override
  String get notifChannelName => '忌日与节日';

  @override
  String get notifChannelDescription => '在忌日、初一、十五和节日之前及当天提醒';

  @override
  String get privacyNote => '所有内容只保存在本机。无需账号,无需联网,不收集任何数据。';

  @override
  String get welcomeTagline => '让所爱之人的日子,永不被遗忘。';

  @override
  String get welcomeBody => '忌日、初一、十五都按农历计算,每年对应的公历日期都不同。本应用为您推算并及时提醒。';

  @override
  String get chooseCalendarTitle => '您家依循哪国的农历?';

  @override
  String get start => '开始';

  @override
  String notifMemorialTodayTitle(String name) {
    return '今天是$name的忌日';
  }

  @override
  String notifMemorialTodayBody(String lunar) {
    return '$lunar。点一炷香,寄托思念。';
  }

  @override
  String get notifMemorialTodayBodySolar => '点一炷香,寄托思念。';

  @override
  String notifMemorialAheadTitle(int n, String name) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '距$name的忌日还有$n天',
      one: '明天是$name的忌日',
    );
    return '$_temp0';
  }

  @override
  String notifMemorialAheadBody(String date, String lunar) {
    return '$date($lunar)。还来得及准备。';
  }

  @override
  String notifMemorialAheadBodySolar(String date) {
    return '$date。还来得及准备。';
  }

  @override
  String notifObservanceTodayTitle(String title) {
    return '今天:$title';
  }

  @override
  String notifObservanceTomorrowTitle(String title) {
    return '明天:$title';
  }

  @override
  String get notifKeepAliveTitle => '请打开应用,以便继续提醒';

  @override
  String get notifKeepAliveBody => '提醒会预先安排约一年。打开一次应用,即可安排之后的提醒。';
}

/// The translations for Chinese, using the Han script (`zh_Hant`).
class AppLocalizationsZhHant extends AppLocalizationsZh {
  AppLocalizationsZhHant() : super('zh_Hant');

  @override
  String get tabHome => '近期';

  @override
  String get tabPeople => '先人';

  @override
  String get tabCalendar => '農曆';

  @override
  String get regionVietnam => '越南';

  @override
  String get regionChina => '中國';

  @override
  String get regionKorea => '韓國';

  @override
  String get regionJapan => '日本';

  @override
  String get regionVietnamHint => '依河內時間(UTC+7)推算。';

  @override
  String get regionChinaHint => '依北京時間(UTC+8)推算。台灣、香港、新加坡、馬來西亞同用。';

  @override
  String get regionKoreaHint => '依首爾時間(UTC+9)推算。';

  @override
  String get regionJapanHint => '舊曆依東京時間(UTC+9)推算。日本多數家庭按國曆過忌日。';

  @override
  String calendarOf(String region) {
    return '$region農曆';
  }

  @override
  String get emptyTitle => '飲水思源';

  @override
  String get emptyBody => '新增家中已故的親人。每年自動推算忌日對應的國曆日期,並提前提醒您。';

  @override
  String get addPerson => '新增親人';

  @override
  String get nextUp => '最近的忌日';

  @override
  String get sectionUpcoming => '接下來的日子';

  @override
  String inDays(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '還有$n天',
      one: '明天',
      zero: '今天',
    );
    return '$_temp0';
  }

  @override
  String memorialTitle(String name) {
    return '$name的忌日';
  }

  @override
  String anniversaryNth(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '逝世$n週年',
      one: '對年',
    );
    return '$_temp0';
  }

  @override
  String differsElsewhere(String regions, String date) {
    return '這一年依$regions曆法,這一天是$date。';
  }

  @override
  String followingRegion(String region) {
    return '本應用依$region曆法提醒。';
  }

  @override
  String get webPreviewNotice => '這是網頁預覽版,提醒功能僅在手機應用中有效。';

  @override
  String get notificationsOffNotice => '本應用的通知已關閉。請在手機設定中開啟,以便收到提醒。';

  @override
  String get peopleTitle => '家族忌日簿';

  @override
  String peopleCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '紀念$n位親人',
      zero: '尚未新增',
    );
    return '$_temp0';
  }

  @override
  String nextOn(String date) {
    return '下一次:$date';
  }

  @override
  String get editAddTitle => '新增親人';

  @override
  String get editEditTitle => '編輯';

  @override
  String get fieldName => '姓名或稱呼';

  @override
  String get fieldNameHint => '例如:爺爺 王建國';

  @override
  String get fieldRelation => '與您的關係(選填)';

  @override
  String get relationSuggestions => '爺爺,奶奶,外公,外婆,父親,母親,丈夫,妻子,哥哥,姊姊';

  @override
  String get sectionDay => '逝世日期';

  @override
  String get kindLunar => '農曆';

  @override
  String get kindSolar => '國曆';

  @override
  String get fieldDay => '日';

  @override
  String get fieldMonth => '月';

  @override
  String get fieldYear => '年份(選填)';

  @override
  String lunarKindHint(String region) {
    return '每年依$region農曆重新推算國曆日期。';
  }

  @override
  String get solarKindHint => '每年在同一國曆日期提醒。';

  @override
  String get shortMonthNote => '若當年該月只有29天,則按廿九日紀念。';

  @override
  String get convertFromSolar => '我只記得國曆日期';

  @override
  String convertedNote(String solar, String lunar) {
    return '$solar即$lunar。';
  }

  @override
  String get convertDifferNote => '注意:那一天各國農曆並不一致,請向家人確認農曆日期。';

  @override
  String get fieldNote => '懷念的話';

  @override
  String get fieldNoteHint => '一段回憶、愛吃的菜、長眠之地……';

  @override
  String get previewTitle => '未來幾年的日期';

  @override
  String get save => '儲存';

  @override
  String get delete => '刪除';

  @override
  String get cancel => '取消';

  @override
  String deleteConfirmTitle(String name) {
    return '刪除$name?';
  }

  @override
  String get deleteConfirmBody => '將不再提醒這個忌日,且無法復原。';

  @override
  String get errorName => '請輸入姓名。';

  @override
  String get errorDay => '沒有這一天,請檢查日期和月份。';

  @override
  String get errorYear => '請檢查年份。';

  @override
  String get nothingThisDay => '這一天沒有忌日或節日。';

  @override
  String get backToToday => '今天';

  @override
  String get settingsTitle => '設定';

  @override
  String get settingsCalendar => '使用哪國的農曆';

  @override
  String get calendarExplain =>
      '各國依本國時區推算農曆,所以同一個農曆日偶爾會落在不同的國曆日,有時甚至相差一個月。手機內建的通常只有中國農曆。請選擇您家所依循的曆法。';

  @override
  String get seeDifferences => '查看各曆法不一致的日子';

  @override
  String get differencesTitle => '各曆法何時不同';

  @override
  String differencesIntro(String region) {
    return '未來20年中,$region農曆與他國曆法日期不同的時段。若用錯曆法,這些時段內就會記錯日子。';
  }

  @override
  String dateRange(String from, String to) {
    return '$from 至 $to';
  }

  @override
  String regionSays(String region, String lunar) {
    return '$region:$lunar';
  }

  @override
  String daysCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(n, locale: localeName, other: '$n天');
    return '$_temp0';
  }

  @override
  String get settingsReminders => '提醒';

  @override
  String get leadDaysTitle => '忌日提醒時間';

  @override
  String leadDay(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '提前$n天',
      zero: '當天',
    );
    return '$_temp0';
  }

  @override
  String get reminderTime => '提醒時刻';

  @override
  String get settingsObservances => '初一、十五與節日';

  @override
  String get observanceDayBefore => '提前一天再提醒一次';

  @override
  String get languageTitle => '語言';

  @override
  String get languageFollowPhone => '跟隨手機';

  @override
  String get testNotification => '傳送測試提醒';

  @override
  String get testNotificationHint => '一則立即送達,一則一分鐘後送達。';

  @override
  String get testNotificationBody => '提醒將這樣顯示。';

  @override
  String get testNotificationLaterBody => '定時提醒也能送達,一切正常。';

  @override
  String get testNotificationSent => '已傳送,請看螢幕上方。';

  @override
  String get testNotificationBlocked => '手機未允許本應用顯示通知。';

  @override
  String get notifChannelName => '忌日與節日';

  @override
  String get notifChannelDescription => '在忌日、初一、十五和節日之前及當天提醒';

  @override
  String get privacyNote => '所有內容只保存在本機。無需帳號,無需連網,不蒐集任何資料。';

  @override
  String get welcomeTagline => '讓所愛之人的日子,永不被遺忘。';

  @override
  String get welcomeBody => '忌日、初一、十五都按農曆計算,每年對應的國曆日期都不同。本應用為您推算並及時提醒。';

  @override
  String get chooseCalendarTitle => '您家依循哪國的農曆?';

  @override
  String get start => '開始';

  @override
  String notifMemorialTodayTitle(String name) {
    return '今天是$name的忌日';
  }

  @override
  String notifMemorialTodayBody(String lunar) {
    return '$lunar。點一炷香,寄託思念。';
  }

  @override
  String get notifMemorialTodayBodySolar => '點一炷香,寄託思念。';

  @override
  String notifMemorialAheadTitle(int n, String name) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '距$name的忌日還有$n天',
      one: '明天是$name的忌日',
    );
    return '$_temp0';
  }

  @override
  String notifMemorialAheadBody(String date, String lunar) {
    return '$date($lunar)。還來得及準備。';
  }

  @override
  String notifMemorialAheadBodySolar(String date) {
    return '$date。還來得及準備。';
  }

  @override
  String notifObservanceTodayTitle(String title) {
    return '今天:$title';
  }

  @override
  String notifObservanceTomorrowTitle(String title) {
    return '明天:$title';
  }

  @override
  String get notifKeepAliveTitle => '請打開應用,以便繼續提醒';

  @override
  String get notifKeepAliveBody => '提醒會預先安排約一年。打開一次應用,即可安排之後的提醒。';
}
