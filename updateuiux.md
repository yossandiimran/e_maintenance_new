# Update UI/UX - Warm Mistral Mobile System

Dokumen ini menggantikan spesifikasi UI lama yang masih berorientasi `Linear dark-only`.
Referensi visual utama sekarang mengikuti [DESIGN.md](./DESIGN.md): hangat, berani, tajam, dan mobile-first.

## Tujuan

- Menyatukan seluruh screen agar konsisten 100%.
- Mengubah arah visual menjadi warm Mistral-inspired, bukan lagi cold dark dashboard.
- Menambahkan `light/dark mode` dengan toggle di menu pengaturan.
- Membuat UI nyaman dipakai di HP Android dengan target sentuh besar, hierarchy jelas, dan teks mudah dibaca.
- Menjaga implementasi selaras dengan refactor arsitektur baru: tanpa `part of`, tanpa state global liar, tanpa service yang menggerakkan UI langsung.

## Arah Visual

- Mood utama: warm ivory, cream, amber, gold, orange.
- Brand accent: `#fa520f`.
- Accent sekunder: `#ffa110`.
- Background light utama: `#fffaeb`.
- Background dark utama: `#1b130b`.
- Surface light: putih hangat atau cream.
- Surface dark: coklat gelap hangat, bukan abu kebiruan.
- Bentuk: tegas dan rapi, radius tetap ada untuk kenyamanan mobile, tetapi tidak bubbly.
- Hero identity: blok warna bertingkat kuning -> amber -> orange -> burnt orange.

## Light/Dark Mode

### Prinsip

- Light mode menjadi ekspresi utama dari `DESIGN.md`.
- Dark mode adalah turunan resmi dari palet hangat yang sama, bukan tema gelap generik.
- Toggle harus ada di `ConfigSettingPage`.
- Preference disimpan lokal melalui `SharedPreferences`.

### Token Utama

| Role | Light | Dark |
|------|-------|------|
| Page background | `#fffaeb` | `#1b130b` |
| Alt background | `#fff0c2` | `#2a1d10` |
| Surface | `#ffffff` | `#24180e` |
| Elevated surface | `#fffaeb` | `#3e2916` |
| Primary text | `#1f1f1f` | `#fff4df` |
| Secondary text | `#533d22` | `#f2d7ad` |
| Muted text | `#876847` | `#d5b27b` |
| Brand | `#fa520f` | `#ff7a1a` |
| Accent | `#ffa110` | `#ffd06a` |
| Success | `#2c8c4b` | `#6edb8d` |

## Tipografi

- Headline: `Nunito`, rapat, tegas, dipakai untuk hero dan judul section.
- Body: `Lato`, dipakai untuk form, deskripsi, tabel ringkas, dan helper text.
- Hierarchy:
  - Display: 30-38
  - Section title: 20-24
  - Body utama: 14-16
  - Caption: 12
- Hindari font weight berlebihan di banyak level. Fokus pada ukuran dan spasi.

## Aturan Komponen

### Card dan panel

- Semua panel utama menggunakan `AppSurfaceCard`.
- Border lembut hangat, bukan border abu dingin.
- Shadow hangat amber-tinted, ringan tapi terasa.
- Padding minimum `16-20`.

### Button

- Primary action: filled orange.
- Secondary action: outlined / soft surface.
- Ikon dan label harus konsisten antar screen.
- Target sentuh minimum `44px`.

### Chip dan badge

- Dipakai untuk host aktif, role user, mode tema, jenis kendaraan, dan status.
- Harus selalu mengandung ikon + label.

### Form

- Input wajib filled, rounded medium, dan readable di mobile.
- Helper text dipakai untuk menjelaskan state, bukan dekorasi.
- Error message tampil langsung di bawah field.

### Dialog dan feedback

- Semua dialog memakai style global hangat.
- Loading ditampilkan melalui helper `Alert.runWithLoading`.
- Success/error memakai snackbar yang konsisten.

## Aturan Screen

### Splash

- Tampilkan brand block, launcher icon baru, dan intro singkat.
- Auto redirect ke login atau home.

### Login

- Tidak boleh ada password default hardcoded di field.
- Host setting bisa diubah tanpa keluar dari screen.
- Hero dan form berada dalam dua panel yang konsisten.

### Home / Dashboard

- Menu utama berbasis card, bukan list lama.
- Ikon menu disesuaikan fungsi:
  - `qr_code_scanner_rounded` untuk inspeksi
  - `description_outlined` untuk laporan transaksi
  - `groups_rounded` untuk laporan user
  - `manage_accounts_outlined` untuk manajemen user
  - `tune_rounded` untuk pengaturan
- Restricted menu tetap tampil, tetapi memberi feedback akses yang jelas.

### Profile

- Fokus ke ringkasan akun, mode tema aktif, dan akses cepat ke pengaturan / logout.

### Settings

- Harus menjadi pusat kontrol:
  - light/dark mode
  - host aktif
  - test koneksi
  - sync setting server
  - restart koneksi backend
  - manajemen user

### Scanner

- Fullscreen area kamera dengan header ringkas.
- Result preview singkat di bawah.

### Inspection

- Ringkasan kendaraan di atas.
- Jenis pengecekan pakai chip / choice selection.
- Setiap checklist item harus punya state jelas:
  - belum ada bukti
  - sudah ada bukti
  - bisa reset
- Foto + catatan harus diperlakukan sebagai evidence, bukan sekadar checkbox.

### Reports

- Filter screen dan result screen memakai struktur panel yang sama.
- Empty state wajib jelas.
- Export Excel tidak boleh side-effect di service layer.

### User Management

- List user berbasis card.
- Form user harus menjelaskan bahwa password default mengikuti backend, bukan hardcoded di UI.

## Aturan Arsitektur yang Mendukung UI

- Tidak ada lagi `part of` monolitik.
- Tidak ada top-level state seperti `isMenuActive`, `qrCode`, atau helper singleton global.
- Theme mode, host override, remote settings, dan session disimpan dalam controller typed.
- Service layer hanya mengembalikan `AppResult`, tanpa `Navigator`, `showDialog`, atau `SnackBar`.
- Navigasi wajib typed lewat `AppRouter`, bukan `pushNamed` + `dynamic arguments`.

## Checklist Implementasi

- [x] Tema global warm light/dark dibuat dari token yang selaras dengan `DESIGN.md`.
- [x] Toggle light/dark mode ditambahkan di `ConfigSettingPage`.
- [x] Launcher icon diganti dari `assets/icon_new.png`.
- [x] Menu dashboard memakai ikon yang sesuai kebutuhan aktual.
- [x] Screen utama diseragamkan dengan `AppPageScaffold`, `AppSurfaceCard`, dan `AppStatusChip`.
- [x] Login tidak lagi membawa password default hardcoded.
- [x] Host backend tidak lagi tersebar hardcoded; sekarang tersentral di config + preference.
- [x] State global dipindah ke `AppSettingsController` dan `SessionController`.
- [x] `print()` dibersihkan dari app code yang aktif.
- [x] Service layer dipisahkan dari presentational side effect.
- [x] Routing utama dipindah ke `AppRouter`.
- [x] Asset yang tidak dipakai dibersihkan.
- [x] Dependency yang tidak dipakai dibersihkan.
- [x] Widget test ditambah untuk login validation dan theme toggle.

## Catatan Implementasi

- Jika nanti ingin iterasi visual lanjutan, perubahan harus dimulai dari token di `lib/app/app_theme.dart`, bukan hardcode warna per screen.
- Jika menambah screen baru, gunakan pattern:
  - `AppPageScaffold`
  - `AppSurfaceCard`
  - `Alert`
  - `AppRouter`
  - `AppResult`

Dokumen ini menjadi baseline UI/UX yang benar untuk project ini.
