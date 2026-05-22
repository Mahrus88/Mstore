import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'register_screen.dart';
import 'profile_screen.dart';
import 'cart_screen.dart';

// Menyimpan data email user yang sedang login aktif secara global
class SesiUser {
  static String emailAktif = "Pengguna MStore";
}

class AkunModel {
  final String email;
  final String password;
  const AkunModel({required this.email, required this.password});
}

class AkunState {
  static List<AkunModel> listAkun = [
    const AkunModel(email: "admin@bakery.com", password: "admin123"),
    const AkunModel(email: "mahrus@bakery.com", password: "mahrus123"),
  ];

  static void tambahAkun(String email, String password) {
    listAkun.add(AkunModel(email: email, password: password));
  }
}

class LoginScreen extends StatefulWidget {
  final String? emailOtomatis; 
  const LoginScreen({super.key, this.emailOtomatis});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.emailOtomatis != null) {
      _emailController.text = widget.emailOtomatis!;
    }
  }

  void _prosesLogin() {
    if (_formKey.currentState!.validate()) {
      String emailInput = _emailController.text.trim();
      String passwordInput = _passwordController.text.trim();

      bool loginBerhasil = false;
      bool isAdmin = false;

      for (var akun in AkunState.listAkun) {
        if (akun.email == emailInput && akun.password == passwordInput) {
          loginBerhasil = true;
          if (akun.email == "admin@bakery.com") {
            isAdmin = true;
          }
          break;
        }
      }

      if (loginBerhasil) {
        // CATAT SESI LOGIN AKTIF DI SINI
        SesiUser.emailAktif = emailInput;

        if (isAdmin) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Selamat Datang, Admin MStore!"), backgroundColor: Color(0xFF8D6E63)),
          );
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AdminDashboard()));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Login Berhasil! Selamat Berbelanja."), backgroundColor: Color(0xFF8D6E63)),
          );
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MainNavigation()));
        }
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Login Gagal", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            content: const Text("Email atau Kata Sandi salah."),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text("Coba Lagi"))
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFBF7),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(color: const Color(0xFF8D6E63).withOpacity(0.1), shape: BoxShape.circle),
                  child: const Icon(Icons.bakery_dining_rounded, size: 80, color: Color(0xFF8D6E63)),
                ),
                const SizedBox(height: 20),
                const Text("MStore Bakery", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF4E342E))),
                const SizedBox(height: 40),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: "Email Pengguna", border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(labelText: "Kata Sandi", border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: _prosesLogin,
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF8D6E63), foregroundColor: Colors.white),
                    child: const Text("MASUK KE TOKO"),
                  ),
                ),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Belum punya akun? "),
                    GestureDetector(
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterScreen())),
                      child: const Text("Daftar Sekarang", style: TextStyle(color: Color(0xFF8D6E63), fontWeight: FontWeight.bold)),
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

// Sisa kode AdminDashboard dan MainNavigation tetap sama seperti sebelumnya...
class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("MStore Admin Panel"), backgroundColor: const Color(0xFF8D6E63)),
      body: const Center(child: Text("Panel Admin Aktif")),
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});
  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;
  final List<Widget> _pages = [const HomeScreen(), const CartScreen(), const ProfileScreen()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: const Color(0xFF8D6E63),
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: "Beranda"),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart_rounded), label: "Keranjang"),
          BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: "Akun"),
        ],
      ),
    );
  }
}