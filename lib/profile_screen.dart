import 'package:flutter/material.dart';
import 'login_screen.dart'; // Import login_screen untuk navigasi balik

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profil Saya"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),
            // Header Profil (Materi UI Dasar)
            const Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.blue,
                child: Icon(Icons.person, size: 60, color: Colors.white),
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              "Pengguna MStore",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const Text(
              "user@mstore.com",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 30),
            const Divider(), // Garis pembatas

            // Menu-menu di Profil
            ListTile(
              leading: const Icon(Icons.history, color: Colors.blue),
              title: const Text("Riwayat Pesanan"),
              onTap: () {
                // Fitur selanjutnya
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings, color: Colors.blue),
              title: const Text("Pengaturan"),
              onTap: () {
                // Fitur selanjutnya
              },
            ),

            const Divider(),

            // Tombol Logout / Ganti Akun
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text(
                "Logout / Ganti Akun",
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
              onTap: () {
                // Munculkan dialog konfirmasi (Materi AlertDialog)
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("Logout"),
                    content: const Text("Apakah anda yakin ingin keluar atau ganti akun?"),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("BATAL"),
                      ),
                      TextButton(
                        onPressed: () {
                          // Hapus tumpukan halaman dan balik ke Login (Navigator.pushReplacement)
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const LoginScreen()),
                          );
                        },
                        child: const Text("YA, KELUAR", style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}