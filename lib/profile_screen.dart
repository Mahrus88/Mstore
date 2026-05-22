import 'package:flutter/material.dart';
import 'login_screen.dart'; // Wajib import untuk mengambil data SesiUser

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mengambil email pendaftar secara realtime
    String emailUser = SesiUser.emailAktif;
    
    // Logika mengambil teks nama depan dari email (Misal mahrus@bakery.com jadi Mahrus)
    String namaUser = emailUser.split('@')[0];
    namaUser = namaUser[0].toUpperCase() + namaUser.substring(1);

    return Scaffold(
      backgroundColor: const Color(0xFFFDFBF7),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Color(0xFF8D6E63),
                  child: Icon(Icons.person, size: 55, color: Colors.white),
                ),
              ),
              const SizedBox(height: 15),
              
              // SEKARANG MENAMPILKAN DATA DINAMIS PENDAFTAR
              Text(
                namaUser, 
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF3E2723)),
              ),
              const SizedBox(height: 4),
              Text(
                emailUser, 
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              
              const SizedBox(height: 30),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.shopping_bag_outlined, color: Color(0xFF8D6E63)),
                title: const Text("Pesanan Saya", style: TextStyle(fontWeight: FontWeight.w500)),
                trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.lock_reset_rounded, color: Color(0xFF8D6E63)),
                title: const Text("Ubah Password", style: TextStyle(fontWeight: FontWeight.w500)),
                trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                onTap: () {},
              ),
              
              // --- LISTTILE KELUAR AKUN DENGAN DIALOG KONFIRMASI ---
              ListTile(
                leading: const Icon(Icons.logout_rounded, color: Colors.redAccent),
                title: const Text("Keluar Akun", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
                onTap: () {
                  // Memunculkan kotak dialog pertanyaan konfirmasi logout
                  showDialog(
                    context: context,
                    barrierDismissible: false, // User wajib memilih salah satu opsi
                    builder: (BuildContext context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        backgroundColor: const Color(0xFFFDFBF7),
                        title: Row(
                          children: const [
                            Icon(Icons.logout_rounded, color: Color(0xFF8D6E63)),
                            SizedBox(width: 10),
                            Text(
                              "Konfirmasi Keluar",
                              style: TextStyle(
                                fontWeight: FontWeight.bold, 
                                color: Color(0xFF3E2723),
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                        content: const Text(
                          "Apakah Anda yakin ingin keluar dari akun MStore Bakery?",
                          style: TextStyle(color: Colors.black54, fontSize: 14),
                        ),
                        actions: [
                          // Opsi 1: Batal keluar, tutup dialog saja
                          TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: const Color(0xFF8D6E63),
                            ),
                            onPressed: () {
                              Navigator.pop(context); // Menutup pop-up dialog
                            },
                            child: const Text(
                              "BATAL",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          
                          // Opsi 2: Benar-benar keluar dari aplikasi
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF3E2723),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () {
                              Navigator.pop(context); // Tutup dialognya dulu
                              
                              // Menjalankan kode pembersihan sesi milik lu asli
                              SesiUser.emailAktif = "Pengguna MStore";
                              
                              // Lempar user balik ke halaman login utama
                              Navigator.pushReplacement(
                                context, 
                                MaterialPageRoute(builder: (context) => const LoginScreen()),
                              );
                            },
                            child: const Text(
                              "YA, KELUAR",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}