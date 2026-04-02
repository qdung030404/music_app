# Music App - Flutter Music Streaming Application

![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-039BE5?style=for-the-badge&logo=Firebase&logoColor=white)
![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)

Một ứng dụng nghe nhạc hiện đại được xây dựng bằng **Flutter**, mang đến trải nghiệm âm nhạc mượt mà với nhiều tính năng nâng cao, giao diện đẹp mắt và quản lý dữ liệu toàn diện qua Firebase.

## 🚀 Tính năng nổi bật

- **Khám phá & Trang chủ (Home & Discovery):**
  - Gợi ý bài hát, tĩnh năng khám phá âm nhạc và các nghệ sĩ phổ biến.
  - Quản lý thư viện cá nhân, danh sách phát (Playlist) và nghệ sĩ (Artist).
  - Truy cập danh sách bài hát yêu thích, lịch sử nghe nhạc gần đây trực quan.
- **Trình phát nhạc nâng cao (Music Player):**
  - Trình phát chi tiết với thiết kế UI hiện đại, thanh tiến trình trực quan (Play/Pause, Seek, Next/Previous).
  - Hỗ trợ phát nhạc dưới nền (Background Audio) và điều khiển linh hoạt qua thanh thông báo/màn hình khóa.
- **Tìm kiếm thông minh (Search):**
  - Tích hợp tìm kiếm bằng giọng nói (`speech_to_text`) mang lại trải nghiệm tiện lợi (Hands-free).
  - Lưu trữ và quản lý lịch sử tìm kiếm dễ dàng.
- **Giao diện & Trải nghiệm (UI/UX):**
  - Tính năng chuyển đổi Chế độ Sáng/Tối (Light/Dark mode) linh hoạt qua cài đặt.
  - Tích hợp màn hình khởi động native mượt mà (Splash Screen).
- **Xác thực & Bảo mật (Authentication):**
  - Quản lý tài khoản an toàn qua hệ thống Firebase Auth (Hỗ trợ xác thực bằng Email/Password và Google Sign-In).
  - Tính năng Cài đặt, gửi Phản hồi (Feedback) và quản lý thiết bị âm thanh đầu vào.

## 🛠 Công nghệ & Thư viện sử dụng

- **Framework:** [Flutter](https://flutter.dev/) (SDK ^3.10.7)
- **State Management & Routing:** [GetX](https://pub.dev/packages/get) & RxDart.
- **Backend Services:** [Firebase](https://firebase.google.com/) (Auth, Firestore đám mây).
- **Audio Core:** [just_audio](https://pub.dev/packages/just_audio), [just_audio_background](https://pub.dev/packages/just_audio_background), `audio_session`.
- **Tiện ích và UI:** `speech_to_text`, `dio`, `shared_preferences`, `flutter_native_splash`, `audio_video_progress_bar`, `font_awesome_flutter`.

## 📂 Kiến trúc dự án (Model-View-Presenter - MVP)

Mã nguồn dự án được tổ chức theo kiến trúc **MVP** (Model-View-Presenter) kết hợp với hướng tiếp cận phân chia theo chức năng (Feature-first), giúp tăng khả năng bảo trì và mở rộng linh hoạt:

```text
lib/
├── core/         # Các module cốt lõi: Theme (Sáng/Tối), Services nền tảng, Cấu hình...
├── data/         # Lớp Model: Chịu trách nhiệm quản lý dữ liệu:
│   ├── datasources/   # Tương tác trực tiếp với API (Jamendo) và Firebase
│   ├── models/        # Các thực thể dữ liệu (Song, Playlist, Album...)
│   └── repositories/  # Lớp trung gian kết nối datasources và cung cấp dữ liệu cho presenters
├── features/     # Lớp View & Presenter phân chia theo từng tính năng cụ thể:
│   ├── <feature_name>/
│   │   ├── view/      # Lớp View: Chỉ chứa giao diện người dùng (Widgets, Screens)
│   │   ├── presenter/ # Lớp Presenter/ViewModel: Xử lý logic nghiệp vụ và quản lý trạng thái qua Streams/RxDart
│   │   └── widget/    # Các widget UI đặc thù (nếu có) dành riêng cho tính năng đó
│   ├── shared/        # Các thành phần giao diện và trình quản lý (Managers) dùng chung
│   └── ...            # auth, home, playlist, song_detail, discovery...
├── app.dart      # Cấu hình chính cho ứng dụng: Material App, Theme và Routing
└── main.dart     # Điểm bắt đầu (Entry point): Khởi tạo Flutter, Firebase và các dịch vụ nền
```

---
**Tóm tắt luồng hoạt động:**
-   **View**: Nhận tương tác của người dùng và gửi thông điệp tới Presenter.
-   **Presenter**: Nhận yêu cầu từ View, gọi tới Repository để lấy dữ liệu, xử lý logic và cập nhật lại View thông qua Streams (RxDart).
-   **Model (Data)**: Xử lý việc truy xuất dữ liệu từ các nguồn khác nhau (Firebase, API).

## ⚙️ Cài đặt & Khởi chạy

1. **Clone dự án:**
   ```bash
   git clone https://github.com/qdung030404/music_app.git
   cd music_app
   ```

2. **Cài đặt dependencies:**
   ```bash
   flutter pub get
   ```

3. **Cấu hình Firebase:**
   - Dự án yêu cầu liên kết với Firebase. Bạn cần tạo project trên [Firebase Console](https://console.firebase.google.com/).
   - Copy file cấu hình `google-services.json` (dành cho Android) và `GoogleService-Info.plist` (dành cho iOS) vào thư mục tương ứng theo hướng dẫn của Firebase.

4. **Chạy ứng dụng:**
   ```bash
   flutter run
   ```
---
Developed by **Dũng**
