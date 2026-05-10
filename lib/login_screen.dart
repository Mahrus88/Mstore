import 'package:flutter/material.dart';
import 'main.dart'; 
import 'register_screen.dart';

// Variabel Global untuk menyimpan data pendaftaran
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
  
  // Variabel untuk logika visibilitas password
  bool _isObscure = true;

  // Data Admin
  final String emailAdmin = "mahrus@mstore.com";
  final String passAdmin = "admin123";

  void _prosesLogin() {
    if (_formKey.currentState!.validate()) {
      String emailInput = _emailController.text;
      String passInput = _passwordController.text;

      // Verifikasi kredensial akun
      if (emailInput == emailAdmin && passInput == passAdmin) {
        _masukKeAplikasi(isAdmin: true, nama: "Mahrus Ali");
      } 
      else if (emailInput == registeredEmail && passInput == registeredPassword) {
        _masukKeAplikasi(isAdmin: false, nama: registeredName ?? "User");
      } 
      else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Email atau Password salah!"), 
            backgroundColor: Colors.red
          ),
        );
      }
    }
  }

  void _masukKeAplikasi({required bool isAdmin, required String nama}) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MainNavigation()),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Selamat Datang, $nama!"), 
        backgroundColor: Colors.green
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
                // Logo dengan dekorasi shadow sederhana
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.2),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: const Icon(Icons.shopping_bag_rounded, size: 100, color: Colors.blue),
                ),
                const SizedBox(height: 20),
                const Text(
                  "MStore Login",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 40),
                
                // Input Email
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: "Email",
                    prefixIcon: const Icon(Icons.email_outlined),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (value) => value!.isEmpty ? "Email wajib diisi" : null,
                ),
                const SizedBox(height: 20),
                
                // Input Password dengan fitur Show/Hide
                TextFormField(
                  controller: _passwordController,
                  obscureText: _isObscure,
                  decoration: InputDecoration(
                    labelText: "Password",
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(_isObscure ? Icons.visibility_off : Icons.visibility),
                      onPressed: () {
                        setState(() {
                          _isObscure = !_isObscure;
                        });
                      },
                    ),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (value) => value!.isEmpty ? "Password wajib diisi" : null,
                ),
                
                const SizedBox(height: 30),
                
                // Tombol Masuk dengan desain Rounded
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: _prosesLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      elevation: 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    child: const Text(
                      "MASUK", 
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1.2)
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                
                // Teks Pendaftaran
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Belum punya akun? "),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context, 
                          MaterialPageRoute(builder: (context) => const RegisterScreen())
                        );
                      },
                      child: const Text(
                        "Daftar Sekarang",
                        style: TextStyle(
                          color: Colors.blue, 
                          fontWeight: FontWeight.bold
                        ),
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