# Music App - Flutter Music Streaming Application

![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-039BE5?style=for-the-badge&logo=Firebase&logoColor=white)
![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)

Một ứng dụng nghe nhạc hiện đại được xây dựng bằng Flutter, tích hợp Firebase để quản lý dữ liệu và xác thực người dùng.

## 🚀 Tính năng nổi bật

- **Trang chủ (Home):** Gợi ý bài hát và các nghệ sĩ phổ biến.
- **Khám phá (Discovery/Library):**
  - Quản lý thư viện cá nhân.
  - Xem lịch sử nghe nhạc gần đây (Gần đây).
  - Truy cập danh sách bài hát yêu thích.
- **Phát nhạc (Music Player):**
  - Trình phát nhạc chi tiết với đầy đủ chức năng (Play/Pause, Seek, Next/Previous).
  - Thanh tiến trình trực quan.
- **Yêu thích (Favorites):** Lưu trữ và quản lý các bài hát bạn yêu thích với hiệu ứng giao diện mượt mà.
- **Xác thực (Authentication):** Đăng nhập qua Firebase (Email/Password, Google Sign-In).

## 🛠 Công nghệ sử dụng

- **Framework:** [Flutter](https://flutter.dev/)
- **State Management:** [GetX](https://pub.dev/packages/get) & RxDart.
- **Backend:** [Firebase](https://firebase.google.com/) (Auth, Firestore).
- **Audio Player:** [just_audio](https://pub.dev/packages/just_audio).
- **UI:** Modern Custom UI với thanh AppBar động và Gradient background.

## 📂 Cấu trúc thư mục (Clean Architecture Style)

Dự án được tổ chức theo tính năng (Feature-first approach):
- `lib/features/home`: Giao diện và logic trang chủ.
- `lib/features/discovery`: Quản lý thư viện, lịch sử và bài hát yêu thích.
- `lib/features/song_detail`: Trình phát nhạc chi tiết.
- `lib/features/auth`: Xử lý đăng nhập và đăng ký.
- `lib/data`: Chứa các Service và Data Source (Firebase interaction).
- `lib/domain`: Chứa các thực thể (Entities) và logic nghiệp vụ chính.

## ⚙️ Cài đặt & Chạy ứng dụng

1. **Clone dự án:**
   ```bash
   git clone <repository_url>
   ```

2. **Cài đặt dependencies:**
   ```bash
   flutter pub get
   ```

3. **Cấu hình Firebase:**
   - Tạo dự án trên [Firebase Console](https://console.firebase.google.com/).
   - Thêm ứng dụng Android/iOS và tải file cấu hình (`google-services.json` / `GoogleService-Info.plist`) vào đúng thư mục tương ứng.

4. **Chạy ứng dụng:**
   ```bash
   flutter run
   ```

## 📸 Ảnh chụp giao diện (Mockups)

*(Bạn có thể thêm ảnh chụp màn hình ứng dụng tại đây)*

---
Developed by **Dũng**
