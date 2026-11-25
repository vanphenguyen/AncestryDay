# Nhớ Ngày Giỗ (AncestryDay): ghi chú cho Claude

App Flutter nhắc ngày giỗ, rằm, mùng một và ngày lễ theo **lịch âm của từng nước** (Việt Nam, Trung Quốc, Hàn Quốc,
Nhật Bản), đổi ra ngày dương mỗi năm và nhắc trước. Dựng trên khung của `MemoMate` (Nhớ Nhé).
Chủ dự án không phải lập trình viên: trả lời bằng tiếng Việt, đơn giản, kèm ảnh chụp màn hình khi đổi giao diện.

## Cấu trúc
- `lib/lunar/lunar_calendar.dart`: **bộ tính lịch âm, phần quan trọng nhất của app.** Tính trăng mới và kinh độ mặt trời
  (Meeus), rồi áp múi giờ của từng nước (`LunarRegion`: VN +7, TQ +8, Hàn và Nhật +9). Sai ở đây là người dùng cúng sai ngày:
  mọi thay đổi phải qua `test/lunar_calendar_test.dart`. Giải thích ở `docs/THIET_KE.md`.
- `assets/observances/<vn|cn|kr|jp>.json`: rằm, mùng một, ngày lễ của từng nước. **Thêm, sửa ngày lễ thì chỉ sửa JSON.**
- `lib/l10n/app_*.arb`: chữ giao diện (`app_en.arb` là bản gốc). Các file `app_localizations*.dart` là code tự sinh:
  **không sửa tay**, chạy `flutter gen-l10n` sau khi sửa `.arb`.
- `lib/texts.dart`: chọn ngôn ngữ theo máy, gợi ý lịch theo máy, và chữ ghép bằng code (ngày âm bằng lời, tên năm can chi).
- `lib/models/`: `Memorial` (người đã khuất và ngày giỗ), `Observance` (ngày lễ chung), `Settings`.
- `lib/logic/occurrences.dart`: ngày giỗ rơi vào ngày dương nào, lịch nước khác có lệch không, danh sách ngày sắp tới.
- `lib/logic/reminder_plan.dart`: chọn những thông báo nào được lên lịch (tối đa 60).
- `lib/logic/differences.dart`: tìm các khoảng thời gian lịch các nước lệch nhau.
- `lib/app_controller.dart`: trạng thái app; các màn hình lắng nghe nó. Viết lời cho thông báo.
- `lib/services/`: `app_store.dart` (lưu trên máy bằng `shared_preferences`), `reminder_notifier.dart` (lên lịch thông báo).
- `lib/screens/`: chào mừng (chọn lịch), Sắp tới, Sổ ngày giỗ, Lịch âm, thêm/sửa người thân, cài đặt, so sánh lịch.
- `lib/widgets/eastern.dart`: các hình vẽ bằng code (núi thủy mặc, trăng theo ngày âm, hoa sen, con dấu, hồi văn).

## Lệnh
- Kiểm tra trước khi commit: `flutter analyze && flutter test`. Cả hai phải sạch.
- Phiên cloud: nếu chưa có lệnh `flutter`, chạy `CLAUDE_CODE_REMOTE=true bash scripts/claude_session_start.sh`
  (cài Flutter vào `~/flutter`), rồi thêm `~/flutter/bin` vào `PATH`.
- Xem giao diện trên cloud: `flutter build web --no-web-resources-cdn --dart-define=SCREENSHOTS=true`, phục vụ `build/web`
  bằng `python3 -m http.server`, chụp bằng Playwright (Node) khung 390x844, đặt `locale` (`vi-VN`, `ja-JP`...).
  Muốn có sẵn dữ liệu: ghi `localStorage` các khóa `flutter.settings` và `flutter.memorials` trước khi tải trang
  (giá trị là chuỗi JSON được `JSON.stringify` thêm một lần nữa).
- Repo GitHub: `vanphenguyen/AncestryDay`. Mỗi lần đẩy lên `main`, `.github/workflows/pages.yml` đăng bản web lên
  https://vanphenguyen.github.io/AncestryDay/ (đổi tên repo thì phải sửa `--base-href` trong file đó).
- Bản iPhone do Codemagic build và tải lên App Store Connect (`codemagic.yaml`, chạy tay); các bước ở `docs/APP_STORE.md`.
  Trang chính sách riêng tư là `web/privacy.html`, được đăng cùng bản web.
- Trang App Store: phần chung ở `docs/app-store/listing.md`; mỗi ngôn ngữ một thư mục `docs/app-store/<en|vi|zh-Hans|ja|ko>/`
  gồm `thong-tin.md` (chữ cho từng ô) và ảnh `1.png` đến `5.png` (1206x2622, chụp từ bản web khung 402x874 tỉ lệ 3).
- Biểu tượng app: sửa ảnh trong `assets/icon/` rồi chạy `dart run flutter_launcher_icons`.
- Bản web chỉ để xem giao diện: trình duyệt không lên lịch thông báo được, nên web dùng `NoopReminderNotifier`.
- Container cloud không tải được Android SDK; APK do GitHub Actions build (`.github/workflows/build.yml`).
  **Thông báo chỉ thử được trên điện thoại thật.**
- `tool/make_reference.js` (Node) tạo lại `test/fixtures/icu_months.json`, dữ liệu đối chiếu lịch Trung Quốc và Hàn Quốc.

## Quy ước
- Tên app: **Nhớ Ngày Giỗ** khi máy dùng tiếng Việt, **AncestryDay** ở mọi ngôn ngữ khác (`appNameFor` trong `lib/texts.dart`,
  `ios/Runner/{en,vi,zh-Hans,zh-Hant, ja,ko}.lproj/InfoPlist.strings`, `android/app/src/main/res/values{,-vi}/strings.xml`).
- Mã định danh app: `com.phenv.ancestryday` (Android và iOS). Không đổi sau khi đã lên store.
- **Không bao giờ tự đoán lịch âm của nước nào.** Màn hình chào mừng bắt người dùng chọn; `Settings.region` là null cho tới lúc đó.
  Lịch đang dùng luôn hiện ở đầu màn hình Sắp tới và Lịch âm.
- Ngày giỗ âm lịch tính vào tháng thường (không tính tháng nhuận); ngày 30 rơi vào tháng thiếu thì tính ngày 29.
  Ngày 29/2 dương lịch tính ngày 28/2 ở năm không nhuận.
- Năm nào lịch nước khác đặt ngày giỗ vào ngày dương khác, app phải hiện cảnh báo (`variantsElsewhere`). Không bỏ tính năng này.
- Không thu thập dữ liệu, không cần mạng, không tài khoản. Không thêm thư viện gửi dữ liệu ra ngoài nếu chủ dự án chưa đồng ý.
- Ngôn ngữ: vi, en, zh (giản thể), zh_Hant (phồn thể), ja, ko. App theo ngôn ngữ của máy, không có thì dùng tiếng Anh.
  **Không viết chữ hiển thị thẳng trong code**: thêm vào mọi file `.arb`; tên ngày lễ nằm trong JSON, đủ cả 6 ngôn ngữ.
  Từ vựng lịch (mùng, Giêng, Chạp, 初一, 腊月, can chi) nằm trong `lib/texts.dart`.
  Thêm ngôn ngữ: thêm `app_xx.arb`, thêm vào `languageNames`, thêm `xx` vào JSON và `CFBundleLocalizations` của `ios/Runner/Info.plist`.
- iPhone chỉ giữ 64 thông báo đã lên lịch cho mỗi app. Kế hoạch nhắc giữ ở 60 (`maxNotificationSlots`): ngày giỗ được ưu tiên,
  rằm và ngày lễ dùng chỗ còn lại, và chỗ cuối cùng là lời nhắc "mở app để nhắc tiếp". App lên lịch lại mỗi lần được mở.
- Chữ có chân (`NotoSerif`, giấy phép OFL trong `assets/fonts/`) chỉ có chữ Latin và tiếng Việt; chữ Hán, Nhật, Hàn dùng phông của máy.
- Mỗi thay đổi đáng kể: cập nhật `CHANGELOG.md`; khi phát hành tăng `version` trong `pubspec.yaml` (`x.y.z+build`).
  Bản iOS lấy số build từ ngày giờ UTC lúc build (xem `codemagic.yaml`).
- Làm trên nhánh riêng, mở Pull Request vào `main`.
