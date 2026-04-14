# E-Maintenance

> Aplikasi inspeksi kendaraan, pelaporan transaksi, pelaporan user, dan administrasi akun internal — dibangun dengan Flutter dan Material 3.

## Daftar Isi

- [Fitur](#fitur)
- [Screenshot](#screenshot)
- [Prasyarat](#prasyarat)
- [Instalasi](#instalasi)
- [Menjalankan Aplikasi](#menjalankan-aplikasi)
- [Build Produksi](#build-produksi)
- [Konfigurasi](#konfigurasi)
- [Struktur Proyek](#struktur-proyek)
- [Tech Stack](#tech-stack)
- [Pengujian](#pengujian)
- [Arsitektur](#arsitektur)
- [Lisensi](#lisensi)

## Fitur

| Modul | Deskripsi |
|---|---|
| **Login** | Autentikasi user dengan sesi 6 jam dan default password |
| **QR Scanner** | Scan barcode kendaraan dengan dialog preview sebelum lanjut |
| **Checklist Inspeksi** | Input harian/mingguan/bulanan/tutup pabrik + foto bukti |
| **Laporan Transaksi** | Filter berdasarkan lokasi, kendaraan, dan periode — hasil dalam grouped list |
| **Laporan User** | Pantau aktivitas user lapangan dalam tabel ringkas dengan detail tanggal bolos |
| **Manajemen User** | CRUD akun internal dengan role badge dan aksi kompak |
| **Pengaturan** | Ganti host backend, tes koneksi, dark/light mode, sync setting server |
| **Ekspor Excel** | Unduh laporan transaksi dan user ke file `.xlsx` |
| **Push Notification** | Firebase Cloud Messaging (opsional, graceful fallback di web) |

## Screenshot

> Tampilan menggunakan warm surface palette (orange-gold) dengan dukungan **light mode** dan **dark mode**.

## Prasyarat

- [Flutter SDK](https://docs.flutter.dev/get-started/install) ≥ 3.0.0
- Dart SDK ≥ 3.0.0
- Android Studio / VS Code
- Android SDK (untuk build Android)
- Chrome (untuk build web)

## Instalasi

```bash
git clone <repository-url>
cd e_maintenance_new
flutter pub get
```

## Menjalankan Aplikasi

```bash
# Android (device / emulator)
flutter run

# Web (Chrome)
flutter run -d chrome

# Web tanpa CORS (development only)
flutter run -d chrome --web-browser-flag "--disable-web-security"
```

## Build Produksi

```bash
# APK
flutter build apk --release

# App Bundle
flutter build appbundle --release

# Web
flutter build web --release
```

## Konfigurasi

Konfigurasi default tersentral di `lib/core/config/app_environment.dart` dan dapat di-override via `dart-define`:

```bash
flutter run \
  --dart-define=EMAINTENANCE_API_HOST=10.0.0.2 \
  --dart-define=EMAINTENANCE_API_BASE_PATH=/e_maintenance_v2/public/ \
  --dart-define=EMAINTENANCE_ASSET_BASE_PATH=/e_maintenance/public/
```

| Variable | Default | Keterangan |
|---|---|---|
| `EMAINTENANCE_API_HOST` | `210.210.165.197` | IP / hostname backend |
| `EMAINTENANCE_API_BASE_PATH` | `/e_maintenance_v2/public/` | Base path API |
| `EMAINTENANCE_ASSET_BASE_PATH` | `/e_maintenance/public/` | Base path asset/foto |

Host aktif juga bisa diubah langsung dari halaman **Pengaturan** tanpa mengedit source code.

## Struktur Proyek

```
lib/
├── main.dart                  # Bootstrap provider, theme, messaging
├── route.dart                 # Typed router (AppRouter)
├── app/
│   └── app_theme.dart         # Design tokens, light/dark theme
├── controllers/               # Global state (AppSettingsController, SessionController)
├── core/
│   ├── config/                # AppEnvironment, constants
│   ├── network/               # AppApiClient (HTTP)
│   └── result/                # Result wrapper
├── helper/                    # Utilities, preferences, date formatting
├── model/                     # Data models (UserSession, AppUser, dll.)
├── screen/
│   ├── SplashScreen.dart
│   ├── Login.dart
│   ├── Home.dart
│   ├── Dashboard.dart
│   ├── ConfigSetting.dart
│   ├── QrScanner.dart
│   ├── cek_kendaraan/         # InsertPage (checklist inspeksi)
│   ├── laporan/               # Laporan1, Laporan2, ListReportPage
│   ├── menu/                  # Profile
│   └── user/                  # User management (CRUD)
├── service/                   # Service layer (tanpa side-effect UI)
└── widget/                    # Shared components (AppSurfaceCard, Alert, dll.)
```

## Tech Stack

| Kategori | Library |
|---|---|
| Framework | Flutter 3 + Material 3 |
| State Management | Provider |
| Persistence | Shared Preferences |
| Networking | HTTP |
| Push Notification | Firebase Core + Firebase Messaging |
| Scanner | QR Code Scanner |
| Camera | Image Picker |
| Export | Excel (syncfusion / dart) |
| Permissions | Permission Handler |

## Pengujian

```bash
# Static analysis
flutter analyze

# Unit & widget tests
flutter test

# Android build verification
cd android && ./gradlew app:assembleDebug
```

## Arsitektur

- **Provider** untuk dependency injection dan state management.
- **Service layer** murni — tidak memanggil dialog, snackbar, atau navigation.
- **Typed routing** via `AppRouter` — tanpa string-based route atau dynamic arguments.
- **Design tokens** (`AppTokens`) untuk konsistensi visual di seluruh screen.
- **Session expiry** otomatis setelah 6 jam.
- **Firebase Messaging** bersifat opsional dan non-blocking (graceful fallback jika gagal init).

## Lisensi

Internal — Central Springbed. Tidak untuk distribusi publik.
