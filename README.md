# E-Maintenance

E-Maintenance adalah aplikasi Flutter untuk inspeksi kendaraan, pelaporan transaksi, pelaporan user, dan administrasi akun internal Central Springbed.

## Perubahan Utama

- UI/UX diseragamkan ulang mengikuti [DESIGN.md](./DESIGN.md) dengan arah warm Mistral-inspired.
- Aplikasi sekarang mendukung `light mode` dan `dark mode` dengan toggle di menu pengaturan.
- Arsitektur `part of` monolitik dihapus dari app code aktif dan diganti dengan screen, service, controller, dan theme yang terpisah.
- Global state lama dipindah ke controller typed:
  - `AppSettingsController`
  - `SessionController`
- Navigasi utama sekarang typed lewat `AppRouter`.
- Service layer tidak lagi memanggil dialog, snackbar, atau navigation secara langsung.
- Launcher icon diganti memakai `assets/icon_new.png`.
- Asset dan dependency yang tidak dipakai dibersihkan.

## Modul Utama

- `Splash` dan `Login`
- `Home` dengan `Dashboard` dan `Profile`
- `Config Setting` untuk host, koneksi, dan toggle theme
- `QR Scanner`
- `Insert Page` untuk checklist inspeksi kendaraan
- `Laporan Transaksi`
- `Laporan User`
- `Manajemen User`

## Stack

- Flutter + Material 3
- Provider
- Shared Preferences
- Firebase Core + Firebase Messaging
- HTTP
- QR Code Scanner
- Image Picker
- Excel export
- Permission Handler

## Struktur Penting

- `lib/main.dart` bootstrap provider, theme, dan messaging
- `lib/route.dart` router typed
- `lib/app/app_theme.dart` design tokens dan theme light/dark
- `lib/controllers/` state global aplikasi
- `lib/core/` config, logging, result, dan API client
- `lib/service/` service layer tanpa side-effect UI
- `lib/screen/` seluruh halaman aplikasi
- `lib/widget/` komponen visual bersama
- `updateuiux.md` pedoman UI/UX yang sesuai implementasi terbaru

## Konfigurasi

Default konfigurasi operasional sekarang tersentral di `AppEnvironment` dan bisa dioverride via `dart-define`:

```powershell
flutter run `
  --dart-define=EMAINTENANCE_API_HOST=10.0.0.2 `
  --dart-define=EMAINTENANCE_API_BASE_PATH=/e_maintenance_v2/public/ `
  --dart-define=EMAINTENANCE_ASSET_BASE_PATH=/e_maintenance/public/
```

Host aktif juga bisa diubah langsung dari screen pengaturan tanpa edit source code.

## Menjalankan Proyek

```powershell
flutter pub get
flutter run
```

## Verifikasi Lokal

```powershell
flutter analyze
flutter test
cd android
.\gradlew app:assembleDebug
```

## Status Verifikasi Terbaru

- `flutter analyze` lulus
- `flutter test` lulus
- Widget test sudah mencakup:
  - validasi login kosong
  - toggle light/dark mode di settings

## Catatan Desain

- Referensi visual utama ada di [DESIGN.md](./DESIGN.md).
- Checklist implementasi UI ada di [updateuiux.md](./updateuiux.md).
- Implementasi sekarang memakai warm surfaces, orange-gold block identity, dan layout mobile-first yang konsisten di seluruh screen aktif.

## Catatan Arsitektur

- `part of` tidak lagi dipakai di alur aplikasi aktif.
- Routing string-based dan argument dynamic sudah diganti di flow utama.
- Logging `print()` pada kode aplikasi aktif sudah dibersihkan.
- Hardcoded config yang sebelumnya tersebar dipusatkan ke config dan storage.
- Launcher icon dan asset bundle sudah dirapikan.
