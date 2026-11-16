# Thiết kế Nhớ Ngày Giỗ (AncestryDay)

## Ý tưởng

Ngày giỗ, rằm, mùng một tính theo âm lịch, nhưng đời sống hằng ngày dùng dương lịch. Mỗi năm ngày giỗ rơi vào một ngày
dương khác, nên rất dễ quên hoặc nhớ ra quá muộn để chuẩn bị. App làm ba việc:

1. **Tính sẵn.** Nhập ngày giỗ một lần; mỗi năm app tự đổi ra ngày dương.
2. **Nhắc trước.** Mặc định nhắc trước 7 ngày, trước 1 ngày và đúng ngày, để kịp đi chợ, báo con cháu.
3. **Đúng lịch của nước mình.** Xem mục dưới.

App nói về người đã khuất, nên lời lẽ nhẹ nhàng, không dùng giọng "việc cần làm". Giao diện lấy màu giấy dó, đỏ son,
vàng kim, mực; hình vẽ là núi thủy mặc, hoa sen, con dấu, hồi văn, trăng tròn khuyết theo ngày âm.

## Vì sao lịch âm các nước khác nhau

Các nước dùng chung một quy tắc: tháng âm bắt đầu vào **ngày có trăng mới (sóc)**. Nhưng "ngày" được tính theo giờ của
từng nước: Việt Nam theo giờ Hà Nội (UTC+7), Trung Quốc giờ Bắc Kinh (UTC+8), Hàn Quốc và Nhật Bản UTC+9.

Nếu trăng mới xảy ra lúc 23:30 giờ Hà Nội thì ở Bắc Kinh đã là 00:30 ngày hôm sau. Tháng âm ở Việt Nam bắt đầu sớm hơn
một ngày. Đôi khi sự lệch này còn làm đổi tháng nhuận, và cả năm lệch nhau một tháng.

| Năm | Việt Nam | Trung Quốc | Hàn Quốc |
|---|---|---|---|
| Tết 1985 | 21/1 | 20/2 (lệch một tháng) | 20/2 |
| Tết 2007 | 17/2 | 18/2 | 18/2 |
| Tết 2027 | 6/2 | 6/2 | 7/2 |
| Tết 2030 | 2/2 | 3/2 | 3/2 |
| Tháng nhuận 2012 | tháng 4 | tháng 4 | tháng 3 |

Lịch âm có sẵn trên iPhone và nhiều điện thoại là **lịch Trung Quốc**. Người Việt dùng lịch đó sẽ có lúc cúng sai ngày.

### App xử lý thế nào

- Lần mở đầu tiên, app **bắt buộc chọn** lịch của nước nào (có gợi ý theo ngôn ngữ của máy, nhưng không tự quyết).
- Lịch đang dùng luôn hiện ở đầu màn hình ("Âm lịch Việt Nam").
- Năm nào lịch nước khác đặt ngày giỗ vào ngày dương khác, app hiện dòng cảnh báo ngay cạnh ngày đó, cả ở màn hình
  thêm người thân (bảng "Ngày giỗ những năm tới").
- Cài đặt > "Xem những ngày các lịch lệch nhau" liệt kê mọi khoảng thời gian lệch trong 20 năm tới.
- Khi đổi từ ngày dương sang ngày âm cho một ngày mất trong quá khứ mà hôm đó các lịch không trùng nhau, app nhắc người dùng
  hỏi lại người thân.

### Bộ tính (`lib/lunar/lunar_calendar.dart`)

- Thời điểm trăng mới và kinh độ mặt trời tính theo công thức thiên văn của Jean Meeus (sai số vài chục giây đến vài phút).
- Quy tắc lịch theo mô tả quen thuộc của Hồ Ngọc Đức: tháng chứa đông chí là tháng 11; năm có 13 tháng thì tháng đầu tiên
  không có trung khí là tháng nhuận.
- Dùng tốt cho các năm 1900 đến 2100.

**Đã kiểm chứng thế nào** (`test/lunar_calendar_test.dart`):

- Ngày Tết Việt Nam các năm đã biết (1985, 2007, 2020 đến 2030).
- Những chỗ các nước lệch nhau đã được ghi nhận trong lịch sử (bảng trên).
- So với dữ liệu lịch ICU (bộ dữ liệu lịch có trong điện thoại và trình duyệt) cho lịch Trung Quốc 1930 đến 2100 và
  lịch Hàn Quốc 1962 đến 2100: khớp 4215 trên 4230 tháng. 15 tháng còn lại đều là tháng có trăng mới sát nửa đêm.
  Với những tháng đã kiểm tra được bằng lịch chính thức (Tết Trung Quốc 1954, 2027, 2030; tháng nhuận 1987; tháng 2 âm
  Hàn Quốc 2017...), lịch chính thức trùng với bộ tính của app, không trùng với ICU.

**Giới hạn đã biết:**

- Vài tháng trong tương lai xa (ví dụ 2051, 2057, 2097) có trăng mới chỉ cách nửa đêm vài phút; chưa có lịch chính thức để đối chiếu.
- Ngày trong quá khứ: Việt Nam chỉ dùng múi giờ +7 cho lịch âm từ 1968 (miền Bắc) và 1976 (cả nước); Hàn Quốc trước 1961
  và Trung Quốc trước 1929 cũng dùng kinh tuyến khác. App tính mọi năm theo múi giờ hiện nay, nên khi đổi một ngày mất
  rất xa từ dương sang âm có thể lệch một ngày. Vì thế app luôn hiện kết quả để người dùng xác nhận.
- Nhật Bản không còn lịch âm chính thức; "旧暦" trong app tính theo giờ Tokyo với cùng quy tắc.

## Quy tắc tính ngày giỗ

- Ngày giỗ âm lịch tính vào **tháng thường**, kể cả khi người thân mất vào tháng nhuận.
- Ngày 30 mà năm đó tháng thiếu (29 ngày) thì tính **ngày 29**.
- Ngày giỗ dương lịch (phổ biến ở Nhật): 29/2 tính 28/2 ở năm không nhuận.
- "Giỗ lần thứ n" = năm đang xét trừ năm mất. Tiếng Việt gọi năm đầu là giỗ đầu, năm thứ hai là giỗ hết; tiếng Nhật dùng
  tên 一周忌, 三回忌, 七回忌...

## Thêm hoặc sửa ngày lễ

Mỗi nước một file trong `assets/observances/`, ví dụ `vn.json`:

```json
{
  "region": "vn",
  "items": [
    {
      "id": "vn-vu-lan",
      "title": { "vi": "Lễ Vu Lan (rằm tháng Bảy)", "en": "Vu Lan, the day of filial piety", "zh": "...", "zh_Hant": "...", "ja": "...", "ko": "..." },
      "rule": { "type": "lunar", "month": 7, "day": 15 },
      "default": true
    }
  ]
}
```

- `id` bắt đầu bằng mã nước, không trùng nhau, và **không đổi sau khi phát hành** (app dùng nó để nhớ ngày nào đang bật).
- `title` phải đủ 6 ngôn ngữ. `default` là bật sẵn hay không.

Bốn kiểu `rule`:

| Kiểu | Ví dụ | Ý nghĩa |
|---|---|---|
| `lunarMonthly` | `{ "type": "lunarMonthly", "day": 15 }` | Ngày đó của mọi tháng âm, kể cả tháng nhuận |
| `lunar` | `{ "type": "lunar", "month": 12, "day": 30 }` | Một ngày âm mỗi năm; ngày 30 nghĩa là ngày cuối tháng |
| `solar` | `{ "type": "solar", "month": 8, "day": 13 }` | Một ngày dương mỗi năm |
| `solarTerm` | `{ "type": "solarTerm", "longitude": 15 }` | Ngày mặt trời tới kinh độ đó: 0 xuân phân, 15 thanh minh, 180 thu phân, 270 đông chí. Thêm `"offsetDays": 105` để lùi hoặc tiến số ngày |

Rằm hoặc mùng một trùng ngày với một ngày lễ có tên (ví dụ rằm tháng Bảy và Vu Lan) thì app chỉ hiện ngày lễ.
Sau khi sửa, chạy `flutter test`.

## Lời nhắc

- Thông báo là thông báo tại máy, không cần mạng. Vì ngày dương mỗi năm một khác, app lên lịch **từng thông báo một** cho
  khoảng 400 ngày tới, và lên lịch lại mỗi lần app được mở.
- iPhone chỉ giữ 64 thông báo chờ cho mỗi app, nên kế hoạch dừng ở 60: ngày giỗ trước, rằm và ngày lễ dùng chỗ còn lại.
- Chỗ cuối cùng luôn là lời nhắc "Mở app một lần để lời nhắc tiếp tục", đặt đúng vào lúc kế hoạch hết. Nhờ vậy lời nhắc
  không bao giờ lặng lẽ dừng.
- Android: dùng hẹn giờ chính xác khi máy cho phép. Một số hãng (Xiaomi, Oppo...) có chế độ tiết kiệm pin chặn thông báo;
  người dùng cần cho app chạy nền.

## Ngôn ngữ

Việt, Anh, Trung giản thể, Trung phồn thể, Nhật, Hàn. App theo ngôn ngữ của máy, không có thì dùng tiếng Anh; đổi được
trong Cài đặt. Ngày âm được viết theo cách của từng tiếng: "mùng 5 tháng Giêng", "腊月廿三", "旧暦7月15日", "음력 7월 15일".

Các bản dịch do AI viết, **chưa có người bản xứ soát lại**. Nên nhờ người bản xứ đọc trước khi quảng bá ở từng nước,
nhất là các từ về tang lễ, cúng giỗ.

## Chưa làm (gợi ý cho bản sau)

- Sao lưu và chuyển dữ liệu sang máy khác (hiện dữ liệu mất khi xóa app).
- Ảnh người thân, chia sẻ sổ ngày giỗ cho anh chị em.
- 月命日 (ngày giỗ hằng tháng ở Nhật), 49 ngày, 100 ngày.
- Tên app dưới biểu tượng bằng tiếng Trung, Nhật, Hàn.
