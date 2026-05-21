import 'package:flutter/material.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  // Fungsi pop-up tanya konfirmasi keluar untuk Pelanggan
  void _konfirmasiLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Konfirmasi Keluar", style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text("Apakah Anda yakin ingin keluar dari akun Anda?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal", style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
              );
            },
            child: const Text("Keluar", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFBF7),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 50),
            Container(
              padding: const EdgeInsets.all(5),
              decoration: const BoxDecoration(
                color: Color(0xFF8D6E63),
                shape: BoxShape.circle,
              ),
              child: const CircleAvatar(
                radius: 55,
                backgroundColor: Colors.white,
                child: Icon(Icons.person_rounded, size: 70, color: Color(0xFF8D6E63)),
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              "Mahrus Ali",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF4E342E)),
            ),
            const Text(
              "Pelanggan Setia MStore",
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 30),
            Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: const Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.email_outlined, color: Color(0xFF8D6E63)),
                    title: Text("Email"),
                    subtitle: Text("mahrus@bakery.com"),
                  ),
                  Divider(height: 1),
                  ListTile(
                    leading: Icon(Icons.card_membership_rounded, color: Color(0xFF8D6E63)),
                    title: Text("Status Member"),
                    subtitle: Text("Gold Member"),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton.icon(
                onPressed: () => _konfirmasiLogout(context), // Menggunakan konfirmasi tanya dulu
                icon: const Icon(Icons.logout_rounded),
                label: const Text("KELUAR DARI APLIKASI", style: TextStyle(fontWeight: FontWeight.bold)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red[700],
                  side: BorderSide(color: Colors.red[300]!),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}