import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'register_screen.dart';
import 'profile_screen.dart';

// 1. CLASS MODEL DATA (Dibungkus rapi dalam blueprint objek)
class AkunModel {
  final String email;
  final String password;
  const AkunModel({required this.email, required this.password});
}

// 2. STATE MANAGER SEMENTARA (Mengunci data agar Chrome tidak bingung/Exit Code 8)
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

      // Membaca data dari AkunState statis
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
            content: const Text("Email atau Kata Sandi salah.\nPastikan data sesuai dengan yang didaftarkan."),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Coba Lagi", style: TextStyle(color: Color(0xFF8D6E63))),
              )
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
                  decoration: BoxDecoration(
                    color: const Color(0xFF8D6E63).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.bakery_dining_rounded, size: 80, color: Color(0xFF8D6E63)),
                ),
                const SizedBox(height: 20),
                const Text(
                  "MStore Bakery",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF4E342E)),
                ),
                const Text("Kehangatan di setiap gigitan", style: TextStyle(color: Color(0xFF8D6E63), fontSize: 14)),
                const SizedBox(height: 40),

                TextFormField(
                  controller: _emailController,
                  validator: (value) => value!.isEmpty ? "Email tidak boleh kosong" : null,
                  decoration: InputDecoration(
                    labelText: "Email Pengguna",
                    prefixIcon: const Icon(Icons.email_outlined),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                ),
                const SizedBox(height: 20),

                TextFormField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  validator: (value) => value!.isEmpty ? "Password tidak boleh kosong" : null,
                  decoration: InputDecoration(
                    labelText: "Kata Sandi",
                    prefixIcon: const Icon(Icons.lock_outline_rounded),
                    suffixIcon: IconButton(
                      icon: Icon(_isPasswordVisible ? Icons.visibility_off : Icons.visibility, color: const Color(0xFF8D6E63)),
                      onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                    ),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                ),
                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: _prosesLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8D6E63),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      elevation: 5,
                    ),
                    child: const Text("MASUK KE TOKO", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 25),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Belum punya akun? "),
                    GestureDetector(
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterScreen())),
                      child: const Text("Daftar Sekarang", style: TextStyle(color: Color(0xFF8D6E63), fontWeight: FontWeight.bold, decoration: TextDecoration.underline)),
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

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  void _konfirmasiLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Konfirmasi Keluar", style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text("Apakah Anda yakin ingin keluar dari Panel Admin?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), 
            child: const Text("Batal", style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
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
      appBar: AppBar(
        title: const Text("MStore Admin Panel", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF8D6E63),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded), 
            onPressed: () => _konfirmasiLogout(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Ringkasan Toko Hari Ini", 
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF4E342E)),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white, 
                      borderRadius: BorderRadius.circular(12), 
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start, 
                      children: [
                        Icon(Icons.monetization_on_outlined, color: Colors.green[700], size: 28),
                        const SizedBox(height: 8),
                        const Text("Total Omset", style: TextStyle(color: Colors.grey, fontSize: 12)),
                        Text("Rp 1.420.000", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.green[700])),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white, 
                      borderRadius: BorderRadius.circular(12), 
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start, 
                      children: [
                        Icon(Icons.shopping_basket_outlined, color: Colors.orange[700], size: 28),
                        const SizedBox(height: 8),
                        const Text("Pesanan", style: TextStyle(color: Colors.grey, fontSize: 12)),
                        Text("18 Masuk", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.orange[700])),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),
            const Text(
              "Manajemen Produk & Stok", 
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF4E342E)),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView(
                children: [
                  _buildAdminProductTile("Premium Butter Croissant", "Stok: 25 pcs", "Rp 18.000"),
                  _buildAdminProductTile("Strawberry Chiffon Cake", "Stok: 5 pcs", "Rp 145.000"),
                  _buildAdminProductTile("Choco Lava Belgian Donut", "Stok: 40 pcs", "Rp 12.500"),
                  _buildAdminProductTile("Almond Brownies Fudgy", "Stok: 12 pcs", "Rp 65.000"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminProductTile(String name, String stock, String price) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: const Icon(Icons.bakery_dining_rounded, color: Color(0xFF8D6E63)),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        subtitle: Text(stock, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        trailing: Text(price, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF8D6E63), fontSize: 14)),
      ),
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
  final List<Widget> _pages = [const HomeScreen(), const ProfileScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: const Color(0xFF8D6E63),
        unselectedItemColor: Colors.grey,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: "Beranda"),
          BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: "Akun"),
        ],
      ),
    );
  }
}