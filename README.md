# MStore - Mobile E-Commerce Prototype

MStore adalah aplikasi prototipe e-commerce berbasis mobile yang dibangun menggunakan framework **Flutter**. Aplikasi ini dirancang untuk mensimulasikan alur belanja online mulai dari proses autentikasi hingga penelusuran katalog produk secara interaktif.

## ✨ Fitur Utama

- **Autentikasi Pengguna:** Halaman login dengan validasi input untuk memastikan keamanan akses.
- **Katalog Produk (Home):** Etalase produk yang disusun menggunakan tata letak _Grid View_ yang responsif.
- **Navigasi Tab:** Navigasi cepat antar menu utama (Home & Profile) menggunakan _Bottom Navigation Bar_.
- **Informasi Detail:** Penjelasan spesifik mengenai produk termasuk gambar, harga, dan deskripsi lengkap.
- **Manajemen Akun:** Halaman profil pengguna yang dilengkapi dengan fungsi _Logout_ untuk kembali ke layar awal.

## 🛠️ Komponen Teknis

Aplikasi ini diimplementasikan dengan memanfaatkan komponen inti Flutter:

- **Sistem Navigasi:** Penggunaan `Navigator` untuk mengelola tumpukan halaman (_stack navigation_).
- **Manajemen Formulir:** Validasi data pengguna pada _input field_ secara real-time.
- **Layouting:** Penggunaan widget Material Design seperti `Card`, `Scaffold`, dan `GridView`.
- **Theming:** Pengaturan skema warna dan tipografi terpusat untuk konsistensi UI.

## 📂 Struktur Direktori (lib/)

Proyek ini menggunakan struktur yang ramping untuk memudahkan pemeliharaan:

- `main.dart` : Konfigurasi tema aplikasi dan kerangka navigasi utama.
- `login_screen.dart` : Halaman autentikasi dan validasi user.
- `home_screen.dart` : Tampilan katalog produk dalam bentuk grid.
- `detail_screen.dart` : Tampilan detail informasi produk.
- `profile_screen.dart` : Informasi akun dan fungsi keluar aplikasi.

## 🚀 Cara Menjalankan

1. Pastikan Flutter SDK sudah terpasang.
2. Clone repository ini.
3. Jalankan perintah berikut di terminal:
   ```bash
   flutter pub get
   flutter run
   ```
