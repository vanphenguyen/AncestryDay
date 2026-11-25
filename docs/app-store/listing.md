# Nội dung trang App Store

Mỗi ngôn ngữ có một thư mục riêng, gồm file `thong-tin.md` (chữ cho từng ô) và 5 ảnh chụp màn hình `1.png` đến `5.png`:

| Ngôn ngữ trên App Store Connect | Thư mục |
|---|---|
| English (U.S.), ngôn ngữ chính | [en/](en/thong-tin.md) |
| Vietnamese | [vi/](vi/thong-tin.md) |
| Chinese (Simplified) | [zh-Hans/](zh-Hans/thong-tin.md) |
| Japanese | [ja/](ja/thong-tin.md) |
| Korean | [ko/](ko/thong-tin.md) |
| Chinese (Traditional) | [zh-Hant/](zh-Hant/thong-tin.md) |

Tạo app với ngôn ngữ chính là English (U.S.); các ngôn ngữ khác thêm bằng nút chọn ngôn ngữ ở góc trên bên phải trang app
(Add localization). File này chỉ chứa phần dùng chung cho mọi ngôn ngữ.

## Cách chọn từ khóa (đọc trước khi sửa)

Apple chỉ dùng ba ô để xếp hạng tìm kiếm: **Name** (nặng nhất), **Subtitle** và **Keywords**. Description không được tính.

- Không lặp lại một từ ở cả ba ô. Ô Keywords: cách nhau bằng dấu phẩy, không có dấu cách, không dùng tên app khác.
- Bản tiếng Việt có thêm từ không dấu, vì nhiều người gõ tìm kiếm không dấu.
- Các từ dưới đây chọn theo suy luận, **chưa dựa trên số liệu tìm kiếm thật**. Sau vài tuần, xem App Analytics > Search terms rồi chỉnh.
- Các bản dịch do AI viết, chưa có người bản xứ soát. Nên nhờ người bản xứ đọc trước khi đăng ở từng nước.

## Thông tin chung (không theo ngôn ngữ)

| Mục | Giá trị |
|---|---|
| Category | Primary: **Lifestyle**. Secondary: **Reference** |
| Price | Free |
| Age Rating | Trả lời "None / No" cho mọi câu hỏi, kết quả sẽ là **4+** |
| App Privacy | **Data Not Collected** |
| Support URL | `https://github.com/vanphenguyen/AncestryDay/issues` |
| Marketing URL | để trống |
| Privacy Policy URL | `https://vanphenguyen.github.io/AncestryDay/privacy.html` |
| Copyright | `2026` kèm tên bạn hoặc tên công ty |
| Sign-in required | No |

**App Review Information > Notes** (viết bằng tiếng Anh):

```
AncestryDay is an offline app that reminds families of death anniversaries and other days of remembrance that follow the lunar calendar. It has no account, no sign-in, no in-app purchases and does not connect to the internet.

To try it: on the first screen choose a lunar calendar and tap "Begin". Tap "Add a loved one", enter a name, a lunar day and month, and save. To see a notification, tap the gear icon, then "Send a test reminder": one notification arrives immediately and another about a minute later.

All notifications are local notifications scheduled on the device. The app does not use push notifications. The lunar calendar is calculated on the device.
```
