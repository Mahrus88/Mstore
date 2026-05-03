import 'package:flutter/material.dart';
import 'main.dart'; 
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // DATA AKUN TERSEDIA (Simulasi Database)
  final String emailAdmin = "mahrus@mstore.com"; // Email lu sebagai Admin
  final String passAdmin = "admin123";
  
  final String emailUser = "user@mstore.com";  // Email user biasa
  final String passUser = "user123";

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _prosesLogin() {
    if (_formKey.currentState!.validate()) {
      String emailInput = _emailController.text;
      String passInput = _passwordController.text;

      // LOGIKA PENGECEKAN AKUN (Materi If-Else)
      if (emailInput == emailAdmin && passInput == passAdmin) {
        // LOGIN SEBAGAI ADMIN
        _pindahKeHome(isAdmin: true);
      } else if (emailInput == emailUser && passInput == passUser) {
        // LOGIN SEBAGAI USER BIASA
        _pindahKeHome(isAdmin: false);
      } else {
        // JIKA EMAIL ATAU PASSWORD SALAH
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Email atau Password Salah!"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _pindahKeHome({required bool isAdmin}) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MainNavigation()),
    );
    
    // Notifikasi selamat datang sesuai role
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isAdmin ? "Selamat Datang, Admin Mahrus!" : "Selamat Datang di MStore"),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.shopping_bag_rounded, size: 100, color: Colors.blue),
                const SizedBox(height: 20),
                const Text(
                  "MStore Login",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 40),
                
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: "Email",
                    prefixIcon: const Icon(Icons.email_outlined),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  validator: (value) => value!.isEmpty ? "Isi email dulu bro" : null,
                ),
                const SizedBox(height: 20),
                
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Password",
                    prefixIcon: const Icon(Icons.lock_outline),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  validator: (value) => value!.isEmpty ? "Password jangan kosong" : null,
                ),
                
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _prosesLogin,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white),
                    child: const Text("MASUK", style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 20),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Belum punya akun?"),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const RegisterScreen()),
                        );
                      },
                      child: const Text("Daftar Sekarang", style: TextStyle(fontWeight: FontWeight.bold)),
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