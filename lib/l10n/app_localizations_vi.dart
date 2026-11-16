// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get tabHome => 'Sắp tới';

  @override
  String get tabPeople => 'Gia tiên';

  @override
  String get tabCalendar => 'Lịch âm';

  @override
  String get regionVietnam => 'Việt Nam';

  @override
  String get regionChina => 'Trung Quốc';

  @override
  String get regionKorea => 'Hàn Quốc';

  @override
  String get regionJapan => 'Nhật Bản';

  @override
  String get regionVietnamHint => 'Tính theo giờ Hà Nội (UTC+7).';

  @override
  String get regionChinaHint =>
      'Tính theo giờ Bắc Kinh (UTC+8). Cũng dùng ở Đài Loan, Hồng Kông, Singapore, Malaysia.';

  @override
  String get regionKoreaHint => 'Tính theo giờ Seoul (UTC+9).';

  @override
  String get regionJapanHint =>
      'Lịch cũ tính theo giờ Tokyo (UTC+9). Ở Nhật, đa số gia đình giữ ngày giỗ theo dương lịch.';

  @override
  String calendarOf(String region) {
    return 'Âm lịch $region';
  }

  @override
  String get emptyTitle => 'Uống nước nhớ nguồn';

  @override
  String get emptyBody =>
      'Thêm những người thân đã khuất. Mỗi năm app tự tính ngày giỗ ra dương lịch và nhắc bạn trước để kịp chuẩn bị.';

  @override
  String get addPerson => 'Thêm người thân';

  @override
  String get nextUp => 'Ngày giỗ sắp tới';

  @override
  String get sectionUpcoming => 'Những ngày sắp tới';

  @override
  String inDays(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Còn $n ngày',
      one: 'Ngày mai',
      zero: 'Hôm nay',
    );
    return '$_temp0';
  }

  @override
  String memorialTitle(String name) {
    return 'Ngày giỗ $name';
  }

  @override
  String anniversaryNth(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Giỗ lần thứ $n',
      two: 'Giỗ hết',
      one: 'Giỗ đầu',
    );
    return '$_temp0';
  }

  @override
  String differsElsewhere(String regions, String date) {
    return 'Năm này, theo lịch $regions thì ngày này rơi vào $date.';
  }

  @override
  String followingRegion(String region) {
    return 'App đang nhắc theo lịch $region.';
  }

  @override
  String get webPreviewNotice =>
      'Đây là bản xem thử trên web. Lời nhắc chỉ chạy trong app trên điện thoại.';

  @override
  String get notificationsOffNotice =>
      'Thông báo của app đang bị tắt. Hãy bật lại trong phần Cài đặt của điện thoại để nhận lời nhắc.';

  @override
  String get peopleTitle => 'Sổ ngày giỗ';

  @override
  String peopleCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n người được tưởng nhớ',
      zero: 'Chưa có ai',
    );
    return '$_temp0';
  }

  @override
  String nextOn(String date) {
    return 'Sắp tới: $date';
  }

  @override
  String get editAddTitle => 'Thêm người thân';

  @override
  String get editEditTitle => 'Sửa thông tin';

  @override
  String get fieldName => 'Tên người đã khuất';

  @override
  String get fieldNameHint => 'Ví dụ: Ông nội Nguyễn Văn An';

  @override
  String get fieldRelation => 'Quan hệ với bạn (không bắt buộc)';

  @override
  String get relationSuggestions =>
      'Ông nội,Bà nội,Ông ngoại,Bà ngoại,Bố,Mẹ,Chồng,Vợ,Anh,Chị,Em,Cụ';

  @override
  String get sectionDay => 'Ngày mất';

  @override
  String get kindLunar => 'Âm lịch';

  @override
  String get kindSolar => 'Dương lịch';

  @override
  String get fieldDay => 'Ngày';

  @override
  String get fieldMonth => 'Tháng';

  @override
  String get fieldYear => 'Năm (nếu nhớ)';

  @override
  String lunarKindHint(String region) {
    return 'Mỗi năm app tính lại ngày dương theo âm lịch $region.';
  }

  @override
  String get solarKindHint => 'Mỗi năm nhắc đúng ngày dương lịch này.';

  @override
  String get shortMonthNote =>
      'Năm nào tháng này thiếu (chỉ có 29 ngày), ngày giỗ được tính vào ngày 29.';

  @override
  String get convertFromSolar => 'Tôi chỉ nhớ ngày dương lịch';

  @override
  String convertedNote(String solar, String lunar) {
    return '$solar là $lunar.';
  }

  @override
  String get convertDifferNote =>
      'Lưu ý: vào ngày đó lịch âm các nước không trùng nhau. Bạn nên hỏi lại người thân cho chắc ngày âm.';

  @override
  String get fieldNote => 'Đôi dòng tưởng nhớ';

  @override
  String get fieldNoteHint => 'Một kỷ niệm, món người thích, nơi an nghỉ…';

  @override
  String get previewTitle => 'Ngày giỗ những năm tới';

  @override
  String get save => 'Lưu';

  @override
  String get delete => 'Xóa';

  @override
  String get cancel => 'Thôi';

  @override
  String deleteConfirmTitle(String name) {
    return 'Xóa $name khỏi sổ?';
  }

  @override
  String get deleteConfirmBody =>
      'App sẽ không nhắc ngày giỗ này nữa. Không thể hoàn tác.';

  @override
  String get errorName => 'Bạn chưa nhập tên.';

  @override
  String get errorDay => 'Ngày này không có. Bạn xem lại ngày và tháng nhé.';

  @override
  String get errorYear => 'Bạn xem lại năm nhé.';

  @override
  String get nothingThisDay => 'Ngày này không có ngày giỗ hay ngày lễ.';

  @override
  String get backToToday => 'Hôm nay';

  @override
  String get settingsTitle => 'Cài đặt';

  @override
  String get settingsCalendar => 'Lịch âm của nước nào';

  @override
  String get calendarExplain =>
      'Mỗi nước tính lịch âm theo múi giờ của mình. Vì vậy thỉnh thoảng cùng một ngày âm lại rơi vào ngày dương khác nhau, có năm lệch cả tháng. Lịch âm có sẵn trên điện thoại thường là lịch Trung Quốc. Hãy chọn đúng lịch gia đình bạn theo.';

  @override
  String get seeDifferences => 'Xem những ngày các lịch lệch nhau';

  @override
  String get differencesTitle => 'Khi các lịch lệch nhau';

  @override
  String differencesIntro(String region) {
    return 'Những khoảng thời gian trong 20 năm tới mà âm lịch $region khác với lịch nước khác. Nếu dùng nhầm lịch, bạn sẽ cúng sai ngày trong những khoảng này.';
  }

  @override
  String dateRange(String from, String to) {
    return '$from đến $to';
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
      other: '$n ngày',
    );
    return '$_temp0';
  }

  @override
  String get settingsReminders => 'Lời nhắc';

  @override
  String get leadDaysTitle => 'Nhắc ngày giỗ vào lúc';

  @override
  String leadDay(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Trước $n ngày',
      zero: 'Đúng ngày',
    );
    return '$_temp0';
  }

  @override
  String get reminderTime => 'Giờ nhắc';

  @override
  String get settingsObservances => 'Rằm, mùng một và ngày lễ';

  @override
  String get observanceDayBefore => 'Nhắc thêm trước một ngày';

  @override
  String get languageTitle => 'Ngôn ngữ';

  @override
  String get languageFollowPhone => 'Theo điện thoại';

  @override
  String get testNotification => 'Gửi thử một lời nhắc';

  @override
  String get testNotificationHint =>
      'Một lời nhắc đến ngay, một lời nhắc đến sau 1 phút.';

  @override
  String get testNotificationBody => 'Lời nhắc sẽ hiện như thế này.';

  @override
  String get testNotificationLaterBody =>
      'Lời nhắc hẹn giờ cũng đến được. Mọi thứ đều ổn.';

  @override
  String get testNotificationSent => 'Đã gửi. Bạn xem phía trên màn hình nhé.';

  @override
  String get testNotificationBlocked =>
      'Điện thoại đang không cho app hiện thông báo.';

  @override
  String get notifChannelName => 'Ngày giỗ và ngày lễ';

  @override
  String get notifChannelDescription =>
      'Nhắc trước và đúng ngày giỗ, rằm, mùng một, ngày lễ';

  @override
  String get privacyNote =>
      'Mọi thứ chỉ nằm trên điện thoại này. Không tài khoản, không cần mạng, không thu thập gì.';

  @override
  String get welcomeTagline =>
      'Để ngày của người thương không bao giờ bị lãng quên.';

  @override
  String get welcomeBody =>
      'Ngày giỗ, rằm, mùng một tính theo âm lịch nên mỗi năm rơi vào một ngày dương khác nhau. App tính sẵn và nhắc bạn kịp lúc.';

  @override
  String get chooseCalendarTitle => 'Gia đình bạn theo lịch âm của nước nào?';

  @override
  String get start => 'Bắt đầu';

  @override
  String notifMemorialTodayTitle(String name) {
    return 'Hôm nay là ngày giỗ $name';
  }

  @override
  String notifMemorialTodayBody(String lunar) {
    return '$lunar. Thắp một nén hương, nhớ về người thương.';
  }

  @override
  String get notifMemorialTodayBodySolar =>
      'Thắp một nén hương, nhớ về người thương.';

  @override
  String notifMemorialAheadTitle(int n, String name) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Còn $n ngày nữa là giỗ $name',
      one: 'Ngày mai là ngày giỗ $name',
    );
    return '$_temp0';
  }

  @override
  String notifMemorialAheadBody(String date, String lunar) {
    return '$date, tức $lunar. Vẫn kịp chuẩn bị mâm cơm cúng.';
  }

  @override
  String notifMemorialAheadBodySolar(String date) {
    return '$date. Vẫn kịp chuẩn bị mâm cơm cúng.';
  }

  @override
  String notifObservanceTodayTitle(String title) {
    return 'Hôm nay: $title';
  }

  @override
  String notifObservanceTomorrowTitle(String title) {
    return 'Ngày mai: $title';
  }

  @override
  String get notifKeepAliveTitle => 'Mở app một lần để lời nhắc tiếp tục';

  @override
  String get notifKeepAliveBody =>
      'App chuẩn bị sẵn lời nhắc cho khoảng một năm. Mở app một lần để chuẩn bị tiếp cho những ngày sau.';
}
