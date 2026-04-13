# E-Maintenance

E-Maintenance adalah aplikasi Flutter untuk inspeksi rutin kendaraan, pelaporan transaksi, pelaporan user, dan administrasi akun internal Central Springbed.

## Status Saat Ini

- Flutter toolchain sudah dinaikkan ke Flutter `3.41.x` dan Dart `3.11.x`.
- `flutter analyze` lulus tanpa issue.
- `flutter test` lulus.
- Android debug build lulus lewat `android\\gradlew app:assembleDebug`.
- UI utama sudah diperbarui mengikuti [DESIGN.md](./DESIGN.md) dan arahan [updateuiux.md](./updateuiux.md) dengan pendekatan Linear-inspired dark interface.

## Modul Utama

- `Splash` dan `Login` untuk masuk ke aplikasi.
- `Dashboard` untuk akses cepat ke alur inspeksi, laporan, dan pengelolaan user.
- `QR Scanner` untuk membaca barcode/serial kendaraan.
- `Insert Page` untuk checklist inspeksi kendaraan.
- `Profile` dan `Config Setting` untuk akun serta pengaturan koneksi.
- `Laporan Transaksi` dan `Laporan User` untuk kebutuhan monitoring dan ekspor.

## Stack Teknis

- Flutter + Material
- Firebase Core + Firebase Messaging
- HTTP / Dio untuk komunikasi backend
- `excel` untuk ekspor laporan
- `image_picker` untuk foto inspeksi
- `permission_handler` untuk permission Android
- Plugin Zebra dan QR Scanner dipatch lokal di `third_party/` agar kompatibel dengan toolchain Android terbaru

## Struktur Penting

- `lib/main.dart` bootstrap aplikasi dan theme global
- `lib/header.dart` agregasi `part of` untuk screen, service, dan widget
- `lib/screen/` layer presentasi
- `lib/service/` integrasi backend
- `lib/helper/` global state sederhana, preference, helper formatting
- `third_party/flutter_zebra_sdk` patch lokal plugin Zebra
- `third_party/qr_code_scanner` patch lokal plugin QR Scanner
- `DESIGN.md` design system hasil generator `getdesign`

## Menjalankan Proyek

1. Install Flutter SDK yang kompatibel dengan channel stable modern.
2. Jalankan `flutter pub get`.
3. Jalankan aplikasi dengan `flutter run`.

Untuk verifikasi lokal:

```powershell
flutter analyze
flutter test
cd android
.\gradlew app:assembleDebug
```

## Catatan Desain

- Referensi visual utama ada di [DESIGN.md](./DESIGN.md).
- Checklist implementasi UI ada di [updateuiux.md](./updateuiux.md).
- Arah desain sekarang memakai dark surfaces, border halus, accent indigo, dan hierarchy tipografi yang lebih rapat untuk tampilan mobile yang lebih modern.

## Catatan Arsitektur

Project ini masih memakai pola `part of` monolitik lewat `lib/header.dart`. Pola ini masih berfungsi, tetapi membuat coupling tinggi antar screen, service, helper, dan widget. Untuk pengembangan jangka panjang, refactor bertahap ke struktur feature-based per file independen akan jauh lebih sehat.

## Technical Debt yang Masih Penting

- Banyak state global masih berada di helper/top-level variable.
- Layer service, UI, dan navigation masih saling terikat kuat.
- Validasi form dan error handling belum konsisten di semua screen.
- Sebagian screen admin/laporan masih membawa pola layout lama dan perlu pass UI lanjutan agar 100% seragam.
- Dependensi lama sudah distabilkan, tetapi masih ada patch lokal di `third_party/` yang sebaiknya diganti dengan package upstream yang lebih aktif saat memungkinkan.
