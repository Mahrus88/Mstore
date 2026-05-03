import 'package:flutter/material.dart';
import 'main.dart'; 
import 'register_screen.dart';

// --- TAMBAHAN: Variabel untuk nampung data pendaftaran (Semester 4 - Variabel Global) ---
String? registeredEmail;
String? registeredPassword;
String? registeredName;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Data Admin lu tetap ada di sini
  final String emailAdmin = "mahrus@mstore.com";
  final String passAdmin = "admin123";

  void _prosesLogin() {
    if (_formKey.currentState!.validate()) {
      String emailInput = _emailController.text;
      String passInput = _passwordController.text;

      // --- LOGIKA AWAL TETAP ADA, CUMA DITAMBAH ELSE IF ---
      if (emailInput == emailAdmin && passInput == passAdmin) {
        _masukKeAplikasi(isAdmin: true, nama: "Mahrus Ali");
      } 
      // TAMBAHAN: Cek akun yang baru daftar
      else if (emailInput == registeredEmail && passInput == registeredPassword) {
        _masukKeAplikasi(isAdmin: false, nama: registeredName ?? "User");
      } 
      else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Email atau Password salah!"), backgroundColor: Colors.red),
        );
      }
    }
  }

  // Fungsi navigasi lu tetap sama
  void _masukKeAplikasi({required bool isAdmin, required String nama}) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MainNavigation()),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Selamat Datang, $nama!"), backgroundColor: Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Tampilan UI lu tetap sama, cuma perbaikan kecil di warna teks bawah
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Icon(Icons.shopping_bag_rounded, size: 100, color: Colors.blue),
                const SizedBox(height: 40),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: "Email", border: OutlineInputBorder()),
                  validator: (value) => value!.isEmpty ? "Isi email dulu" : null,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: "Password", border: OutlineInputBorder()),
                  validator: (value) => value!.isEmpty ? "Isi password dulu" : null,
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _prosesLogin,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white),
                    child: const Text("MASUK"),
                  ),
                ),
                const SizedBox(height: 20),
                
                // Perbaikan kecil: Memisahkan warna teks agar "Daftar Sekarang" jadi biru
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Belum punya akun? "),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterScreen()));
                      },
                      child: const Text(
                        "Daftar Sekarang",
                        style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}