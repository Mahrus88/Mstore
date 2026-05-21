# MStore Bakery - Mobile Bakery Shop Prototype

MStore Bakery adalah aplikasi prototipe toko roti berbasis mobile yang dibangun menggunakan framework Flutter. Aplikasi ini dirancang untuk mensimulasikan alur belanja online menu bakery dan kue, mulai dari proses autentikasi, pendaftaran akun baru, hingga penelusuran katalog produk secara interaktif.

## ✨ Fitur Utama

* **Autentikasi & Registrasi Akun:** Halaman pendaftaran akun baru dengan fitur transfer data otomatis ke halaman login, lengkap dengan validasi input yang aman.
* **Multi-Role Access:** Simulasi hak akses yang membedakan tampilan antara akun Pembeli dan panel dashboard Khusus Admin.
* **Katalog Menu (Home):** Etalase berbagai macam produk roti dan kue yang disusun menggunakan tata letak Grid View yang responsif dan menarik.
* **Navigasi Tab:** Navigasi cepat antar menu utama (Beranda & Akun) menggunakan Bottom Navigation Bar.
* **Informasi Detail:** Penjelasan spesifik mengenai produk roti termasuk gambar, harga, stok, dan deskripsi lengkap.
* **Manajemen Akun:** Halaman profil pengguna yang dilengkapi dengan fungsi Logout untuk kembali ke layar awal secara aman.

## 🛠️ Komponen Teknis

Aplikasi ini diimplementasikan dengan memanfaatkan komponen inti Flutter:
* **Sistem Navigasi:** Penggunaan Navigator untuk mengelola tumpukan halaman (stack navigation).
* **Manajemen Formulir:** Validasi data pengguna pada input field secara real-time.
* **State Management Sementara:** Pemanfaatan class model statis untuk menyimpan data akun yang baru didaftarkan agar bisa langsung digunakan untuk login secara real-time.
* **Layouting & Theming:** Penggunaan widget Material Design seperti Card, Scaffold, dan GridView dengan skema warna bertema warm bakery (cokelat & krem) yang konsisten.

## 📂 Struktur Direktori (lib/)

Proyek ini menggunakan struktur yang ramping untuk memudahkan pemeliharaan:
* `main.dart` : Konfigurasi tema aplikasi dan kerangka navigasi utama.
* `login_screen.dart` : Halaman autentikasi, simulasi database akun statis, dan dashboard manajemen untuk Admin.
* `register_screen.dart` : Halaman pendaftaran pengguna baru untuk menambahkan akun ke database statis.
* `home_screen.dart` : Tampilan katalog produk roti dan kue dalam bentuk grid.
* `detail_screen.dart` : Tampilan detail informasi spesifikasi produk roti.
* `profile_screen.dart` : Informasi akun pengguna dan fungsi keluar aplikasi.

---

## 🚀 Panduan Instalasi & Menjalankan Proyek

### Persyaratan Sistem
Sebelum menjalankan proyek ini, pastikan perangkat Anda telah terinstal:
* Flutter SDK (Versi terbaru direkomendasikan)
* Dart SDK
* Android Studio / VS Code lengkap dengan ekstensi Flutter & Dart
* Google Chrome (untuk mode Flutter Web) atau Emulator Android

### Langkah-Langkah Menjalankan Proyek

1. **Clone Repository**
   Buka terminal atau command prompt, lalu jalankan perintah berikut:
   ```bash
   git clone [https://github.com/Mahrus88/Mstore.git](https://github.com/Mahrus88/Mstore.git)