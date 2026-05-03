import 'package:flutter/material.dart';
import 'login_screen.dart'; // Import untuk akses variabel registeredName

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // --- TAMBAHAN: Ambil nama dari variabel pendaftaran ---
    String namaTampil = registeredName ?? "Mahrus Ali";
    String emailTampil = registeredEmail ?? "mahrus@mstore.com";

    return Scaffold(
      appBar: AppBar(title: const Text("Profil Saya"), backgroundColor: Colors.blue),
      body: Column(
        children: [
          const SizedBox(height: 30),
          const Center(child: CircleAvatar(radius: 50, child: Icon(Icons.person, size: 50))),
          const SizedBox(height: 15),
          
          // --- DIUBAH DIKIT: Biar namanya dinamis ---
          Text(namaTampil, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          Text(emailTampil, style: const TextStyle(color: Colors.grey)),
          
          const SizedBox(height: 30),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text("Logout / Ganti Akun", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            onTap: () {
              // --- TAMBAHAN: Dibungkus showDialog biar nanya dulu ---
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Konfirmasi"),
                  content: const Text("Apakah anda yakin ingin keluar?"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("BATAL"),
                    ),
                    TextButton(
                      onPressed: () {
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
    );
  }
}