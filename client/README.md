# Reality Cultivation — shell Flutter V0

Giao diện text thích nghi dùng chung lõi mô phỏng trong `../game`.

Đích đã tạo:

- Android;
- Windows;
- Web/PWA cho trình duyệt điện thoại và máy tính.

Đã kiểm chứng trên máy hiện tại:

```powershell
flutter analyze
flutter test
flutter build web --release
```

Bản lưu V0 dùng `shared_preferences` để giữ JSON save phiên bản 1 trên từng nền tảng. Giao diện tự lưu khi ứng dụng xuống nền và tự khôi phục bản gần nhất khi mở lại.

Bản web được tạo tại `build/web`. Android cần Android SDK và Windows cần Visual Studio với workload Desktop development with C++; hai toolchain này chưa có trên máy hiện tại.
