// lib/login_screen.dart
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart';
import 'register_screen.dart';
import 'profile_screen.dart';
import 'cart_screen.dart';
import 'cart_data.dart';
import 'order_data.dart';
import 'favorit_screen.dart';

class SesiUser {
  static String emailAktif = "Pengguna MStore";
}

class AkunModel {
  final String email;
  final String password;
  const AkunModel({required this.email, required this.password});

  Map<String, dynamic> toJson() => {'email': email, 'password': password};
  factory AkunModel.fromJson(Map<String, dynamic> json) =>
      AkunModel(email: json['email'], password: json['password']);
}

class AkunState {
  static List<AkunModel> listAkun = [
    const AkunModel(email: "admin@bakery.com", password: "admin123"),
    const AkunModel(email: "mahrus@bakery.com", password: "mahrus123"),
  ];

  static bool _sudahDimuat = false;

  static Future<void> muatAkun() async {
    if (_sudahDimuat) return;
    _sudahDimuat = true;
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString('daftar_akun');
    if (data != null) {
      final List decoded = jsonDecode(data);
      final List<AkunModel> akunTersimpan =
          decoded.map((e) => AkunModel.fromJson(e)).toList();
      for (var akun in akunTersimpan) {
        bool sudahAda = listAkun.any((a) => a.email == akun.email);
        if (!sudahAda) listAkun.add(akun);
      }
    }
  }

  static Future<void> simpanAkun() async {
    final prefs = await SharedPreferences.getInstance();
    final List<AkunModel> akunCustom = listAkun
        .where((a) =>
            a.email != "admin@bakery.com" &&
            a.email != "mahrus@bakery.com")
        .toList();
    final String data =
        jsonEncode(akunCustom.map((e) => e.toJson()).toList());
    await prefs.setString('daftar_akun', data);
  }

  static Future<void> tambahAkun(String email, String password) async {
    listAkun.add(AkunModel(email: email, password: password));
    await simpanAkun();
  }

  static Future<void> simpanSesi(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('sesi_aktif', email);
  }

  static Future<String?> muatSesi() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('sesi_aktif');
  }

  static Future<void> hapusSesi() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('sesi_aktif');
  }
}

// ── Login Screen ──
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
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.emailOtomatis != null) {
      _emailController.text = widget.emailOtomatis!;
    }
    _inisialisasi();
  }

  Future<void> _inisialisasi() async {
    await AkunState.muatAkun();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _prosesLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      await Future.delayed(const Duration(milliseconds: 600));

      String emailInput = _emailController.text.trim();
      String passwordInput = _passwordController.text.trim();

      bool loginBerhasil = false;
      bool isAdmin = false;

      for (var akun in AkunState.listAkun) {
        if (akun.email == emailInput && akun.password == passwordInput) {
          loginBerhasil = true;
          isAdmin = akun.email == "admin@bakery.com";
          break;
        }
      }

      setState(() => _isLoading = false);
      if (!mounted) return;

      if (loginBerhasil) {
        SesiUser.emailAktif = emailInput;
        await AkunState.simpanSesi(emailInput);

        if (isAdmin) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Selamat Datang, Admin MStore!"),
              backgroundColor: Color(0xFF8D6E63),
              behavior: SnackBarBehavior.floating,
            ),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => const AdminDashboard()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Login Berhasil! Selamat Berbelanja."),
              backgroundColor: Color(0xFF8D6E63),
              behavior: SnackBarBehavior.floating,
            ),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => const MainNavigation()),
          );
        }
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
            title: const Text("Login Gagal",
                style: TextStyle(
                    color: Colors.red, fontWeight: FontWeight.bold)),
            content: const Text(
                "Email atau Kata Sandi salah. Silakan periksa kembali."),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8D6E63)),
                child: const Text("Coba Lagi",
                    style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        );
      }
    }
  }

  void _tampilkanLupaPassword() {
    final resetController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16)),
        title: const Text("Lupa Password",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF3E2723))),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
                "Masukkan email Anda untuk mereset password.",
                style:
                    TextStyle(color: Colors.black54, fontSize: 13)),
            const SizedBox(height: 16),
            TextFormField(
              controller: resetController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: "Email Terdaftar",
                prefixIcon: const Icon(Icons.email_outlined),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("BATAL",
                style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                      "Link reset password telah dikirim ke email Anda."),
                  backgroundColor: Color(0xFF8D6E63),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8D6E63)),
            child: const Text("KIRIM",
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
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
                  child: const Icon(Icons.bakery_dining_rounded,
                      size: 80, color: Color(0xFF8D6E63)),
                ),
                const SizedBox(height: 20),
                const Text("MStore Bakery",
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4E342E))),
                const SizedBox(height: 8),
                const Text("Masuk untuk mulai berbelanja",
                    style: TextStyle(color: Colors.grey, fontSize: 13)),
                const SizedBox(height: 40),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return "Email tidak boleh kosong";
                    if (!value.contains('@'))
                      return "Format email tidak valid";
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: "Email Pengguna",
                    prefixIcon: const Icon(Icons.email_outlined,
                        color: Color(0xFF8D6E63)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                          color: Color(0xFF8D6E63), width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return "Kata sandi tidak boleh kosong";
                    if (value.length < 6)
                      return "Kata sandi minimal 6 karakter";
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: "Kata Sandi",
                    prefixIcon: const Icon(Icons.lock_outline_rounded,
                        color: Color(0xFF8D6E63)),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: const Color(0xFF8D6E63),
                      ),
                      onPressed: () => setState(() =>
                          _isPasswordVisible = !_isPasswordVisible),
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                          color: Color(0xFF8D6E63), width: 2),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: _tampilkanLupaPassword,
                    child: const Text("Lupa Password?",
                        style: TextStyle(
                            color: Color(0xFF8D6E63),
                            fontWeight: FontWeight.w600,
                            fontSize: 13)),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _prosesLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8D6E63),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      elevation: 3,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2.5),
                          )
                        : const Text("MASUK KE TOKO",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                letterSpacing: 0.5)),
                  ),
                ),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Belum punya akun? ",
                        style: TextStyle(color: Colors.black54)),
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const RegisterScreen()),
                      ),
                      child: const Text("Daftar Sekarang",
                          style: TextStyle(
                              color: Color(0xFF8D6E63),
                              fontWeight: FontWeight.bold)),
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

// ── Admin Dashboard ──
class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          _AdminBeranda(),
          _AdminProduk(),
          _AdminAkun(),
          _AdminPesanan(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: const Color(0xFF8D6E63),
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        elevation: 12,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_rounded),
            label: "Dashboard",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2_rounded),
            label: "Produk",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_rounded),
            label: "Akun",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_rounded),
            label: "Pesanan",
          ),
        ],
      ),
    );
  }
}

// ── Tab 1: Beranda Admin ──
class _AdminBeranda extends StatelessWidget {
  const _AdminBeranda();

  String _formatRupiah(double harga) {
    final formatted = harga.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}.',
    );
    return 'Rp $formatted';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFBF7),
      appBar: AppBar(
        title: const Text("Admin Dashboard",
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF8D6E63),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            tooltip: "Keluar",
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  title: const Text("Keluar Admin?",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  content: const Text(
                      "Apakah Anda yakin ingin keluar dari panel admin?"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text("BATAL"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const LoginScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF8D6E63)),
                      child: const Text("KELUAR",
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header gradient
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF8D6E63), Color(0xFF5D4037)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Selamat Datang,",
                      style: TextStyle(
                          color: Colors.white70, fontSize: 13)),
                  const SizedBox(height: 4),
                  const Text("Admin MStore Bakery 🍞",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  const Text(
                      "Kelola semua aktivitas toko dari sini",
                      style: TextStyle(
                          color: Colors.white70, fontSize: 12)),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(Icons.circle,
                          color: Colors.greenAccent, size: 10),
                      const SizedBox(width: 6),
                      Text(
                        "Online • ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 11),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Statistik
            const Text("Statistik Toko",
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3E2723))),
            const SizedBox(height: 12),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.5,
              children: [
                _buildStatCard("Total Produk", "8",
                    Icons.inventory_2_rounded, const Color(0xFF8D6E63)),
                _buildStatCard(
                    "Total Akun",
                    "${AkunState.listAkun.length}",
                    Icons.people_rounded,
                    Colors.blue),
                _buildStatCard(
                    "Total Pesanan",
                    "${OrderData.daftarPesanan.length}",
                    Icons.receipt_long_rounded,
                    Colors.orange),
                _buildStatCard("Kategori", "3",
                    Icons.category_rounded, Colors.green),
              ],
            ),
            const SizedBox(height: 20),

            // Pesanan Terbaru
            const Text("Pesanan Terbaru",
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3E2723))),
            const SizedBox(height: 12),
            OrderData.daftarPesanan.isEmpty
                ? Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Center(
                      child: Text("Belum ada pesanan masuk",
                          style: TextStyle(color: Colors.grey)),
                    ),
                  )
                : Column(
                    children: OrderData.daftarPesanan
                        .take(3)
                        .map((order) => Container(
                              margin:
                                  const EdgeInsets.only(bottom: 10),
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.circular(14),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black
                                          .withOpacity(0.04),
                                      blurRadius: 8)
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(order.invoiceNumber,
                                          style: const TextStyle(
                                              fontWeight:
                                                  FontWeight.bold,
                                              fontSize: 13,
                                              color:
                                                  Color(0xFF3E2723))),
                                      const SizedBox(height: 4),
                                      Text(
                                          "${order.tanggal}  ${order.waktu}",
                                          style: const TextStyle(
                                              fontSize: 11,
                                              color: Colors.grey)),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        _formatRupiah(
                                            order.totalBayar),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF8D6E63),
                                            fontSize: 13),
                                      ),
                                      const SizedBox(height: 4),
                                      Container(
                                        padding: const EdgeInsets
                                            .symmetric(
                                                horizontal: 8,
                                                vertical: 2),
                                        decoration: BoxDecoration(
                                          color: Colors.orange
                                              .withOpacity(0.12),
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        child: Text(order.status,
                                            style: const TextStyle(
                                                fontSize: 10,
                                                color: Colors.orange,
                                                fontWeight:
                                                    FontWeight.bold)),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ))
                        .toList(),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
      String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 8),
          Text(value,
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: color)),
          Text(label,
              style: const TextStyle(
                  fontSize: 11, color: Colors.grey)),
        ],
      ),
    );
  }
}

// ── Tab 2: Kelola Produk ──
class _AdminProduk extends StatelessWidget {
  const _AdminProduk();

  final List<Map<String, dynamic>> produkList = const [
    {"name": "Dark Cocoa Dream", "harga": 240000.0, "kategori": "Kue Tart", "image": "assets/images/dark_cocoa.jpg"},
    {"name": "Strawberry Chiffon", "harga": 285000.0, "kategori": "Kue Tart", "image": "assets/images/strawberry_chiffon.jpg"},
    {"name": "Matcha Crepe Cake", "harga": 320000.0, "kategori": "Kue Tart", "image": "assets/images/matcha_crepe.jpg"},
    {"name": "Hibiscus Glaze Donut", "harga": 37500.0, "kategori": "Donat", "image": "assets/images/hibiscus_donut.jpg"},
    {"name": "Almond Snow Donut", "harga": 40000.0, "kategori": "Donat", "image": "assets/images/almond_snow.jpg"},
    {"name": "Choco Caviar Donut", "harga": 42500.0, "kategori": "Donat", "image": "assets/images/choco_caviar.jpg"},
    {"name": "Butter Croissant", "harga": 45000.0, "kategori": "Croissant", "image": "assets/images/butter_croissant.jpg"},
    {"name": "Almond Croissant", "harga": 55000.0, "kategori": "Croissant", "image": "assets/images/almond_croissant.jpg"},
  ];

  String _formatRupiah(double harga) {
    final formatted = harga.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}.',
    );
    return 'Rp $formatted';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFBF7),
      appBar: AppBar(
        title: const Text("Kelola Produk",
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF8D6E63),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: produkList.length,
        itemBuilder: (context, index) {
          final produk = produkList[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: const BorderSide(color: Color(0xFFEFEBE9)),
            ),
            color: Colors.white,
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  produk['image'],
                  width: 56,
                  height: 56,
                  fit: BoxFit.cover,
                  errorBuilder: (ctx, err, stack) => Container(
                    width: 56,
                    height: 56,
                    color: const Color(0xFFF5F0EA),
                    child: const Icon(Icons.bakery_dining_rounded,
                        color: Color(0xFF8D6E63)),
                  ),
                ),
              ),
              title: Text(produk['name'],
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: Color(0xFF3E2723))),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(produk['kategori'],
                      style: const TextStyle(
                          fontSize: 11, color: Colors.grey)),
                  const SizedBox(height: 2),
                  Text(_formatRupiah(produk['harga']),
                      style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF8D6E63),
                          fontWeight: FontWeight.bold)),
                ],
              ),
              trailing: PopupMenuButton(
                icon: const Icon(Icons.more_vert_rounded,
                    color: Colors.grey),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                itemBuilder: (ctx) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(children: [
                      Icon(Icons.edit_rounded,
                          size: 18, color: Color(0xFF8D6E63)),
                      SizedBox(width: 8),
                      Text("Edit Produk"),
                    ]),
                  ),
                  const PopupMenuItem(
                    value: 'hapus',
                    child: Row(children: [
                      Icon(Icons.delete_rounded,
                          size: 18, color: Colors.red),
                      SizedBox(width: 8),
                      Text("Hapus Produk",
                          style: TextStyle(color: Colors.red)),
                    ]),
                  ),
                ],
                onSelected: (val) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(val == 'edit'
                          ? "Edit ${produk['name']}"
                          : "Hapus ${produk['name']}"),
                      backgroundColor: const Color(0xFF8D6E63),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content:
                  Text("Fitur tambah produk akan segera hadir!"),
              backgroundColor: Color(0xFF8D6E63),
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
        backgroundColor: const Color(0xFF3E2723),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: const Text("Tambah Produk",
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}

// ── Tab 3: Kelola Akun ──
class _AdminAkun extends StatefulWidget {
  const _AdminAkun();

  @override
  State<_AdminAkun> createState() => _AdminAkunState();
}

class _AdminAkunState extends State<_AdminAkun> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFBF7),
      appBar: AppBar(
        title: Text(
            "Kelola Akun (${AkunState.listAkun.length})",
            style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF8D6E63),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: AkunState.listAkun.length,
        itemBuilder: (context, index) {
          final akun = AkunState.listAkun[index];
          final bool isAdmin = akun.email == "admin@bakery.com";
          final String namaAkun = akun.email.contains('@')
              ? akun.email.split('@')[0]
              : akun.email;
          final String namaFormatted =
              namaAkun[0].toUpperCase() + namaAkun.substring(1);

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: const BorderSide(color: Color(0xFFEFEBE9)),
            ),
            color: Colors.white,
            child: ListTile(
              contentPadding: const EdgeInsets.all(14),
              leading: CircleAvatar(
                radius: 24,
                backgroundColor: isAdmin
                    ? const Color(0xFF8D6E63)
                    : const Color(0xFF8D6E63).withOpacity(0.12),
                child: Icon(
                  isAdmin
                      ? Icons.admin_panel_settings_rounded
                      : Icons.person_rounded,
                  color: isAdmin
                      ? Colors.white
                      : const Color(0xFF8D6E63),
                  size: 22,
                ),
              ),
              title: Text(namaFormatted,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Color(0xFF3E2723))),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(akun.email,
                      style: const TextStyle(
                          fontSize: 11, color: Colors.grey)),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: isAdmin
                          ? Colors.orange.withOpacity(0.12)
                          : Colors.green.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      isAdmin ? "Admin" : "Pelanggan",
                      style: TextStyle(
                          fontSize: 10,
                          color: isAdmin
                              ? Colors.orange
                              : Colors.green,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              trailing: !isAdmin
                  ? IconButton(
                      icon: const Icon(
                          Icons.delete_outline_rounded,
                          color: Colors.redAccent),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(16)),
                            title: const Text("Hapus Akun?",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold)),
                            content:
                                Text("Hapus akun ${akun.email}?"),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(ctx),
                                child: const Text("BATAL"),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    AkunState.listAkun
                                        .removeAt(index);
                                    AkunState.simpanAkun();
                                  });
                                  Navigator.pop(ctx);
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          "Akun berhasil dihapus"),
                                      backgroundColor:
                                          Color(0xFF8D6E63),
                                      behavior:
                                          SnackBarBehavior.floating,
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red),
                                child: const Text("HAPUS",
                                    style: TextStyle(
                                        color: Colors.white)),
                              ),
                            ],
                          ),
                        );
                      },
                    )
                  : null,
            ),
          );
        },
      ),
    );
  }
}

// ── Tab 4: Semua Pesanan ──
class _AdminPesanan extends StatefulWidget {
  const _AdminPesanan();

  @override
  State<_AdminPesanan> createState() => _AdminPesananState();
}

class _AdminPesananState extends State<_AdminPesanan> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _muatPesanan();
  }

  Future<void> _muatPesanan() async {
    await OrderData.muatPesanan();
    setState(() => _isLoading = false);
  }

  String _formatRupiah(double harga) {
    final formatted = harga.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}.',
    );
    return 'Rp $formatted';
  }

  Color _statusColor(String status) {
    switch (status) {
      case "Diproses": return Colors.orange;
      case "Dikirim": return Colors.blue;
      case "Selesai": return Colors.green;
      default: return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFBF7),
      appBar: AppBar(
        title: Text(
            "Semua Pesanan (${OrderData.daftarPesanan.length})",
            style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF8D6E63),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => _muatPesanan(),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                  color: Color(0xFF8D6E63)))
          : OrderData.daftarPesanan.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.receipt_long_rounded,
                          size: 80, color: Color(0xFFBCAAA4)),
                      SizedBox(height: 16),
                      Text("Belum ada pesanan masuk",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF5D4037))),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: OrderData.daftarPesanan.length,
                  itemBuilder: (context, index) {
                    final order =
                        OrderData.daftarPesanan[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 14),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: const BorderSide(
                            color: Color(0xFFEFEBE9)),
                      ),
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            // Invoice + Status (bisa diubah)
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Text(order.invoiceNumber,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: Color(0xFF3E2723))),
                                PopupMenuButton<String>(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(12)),
                                  child: Container(
                                    padding: const EdgeInsets
                                        .symmetric(
                                            horizontal: 10,
                                            vertical: 4),
                                    decoration: BoxDecoration(
                                      color: _statusColor(
                                              order.status)
                                          .withOpacity(0.12),
                                      borderRadius:
                                          BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(order.status,
                                            style: TextStyle(
                                                fontSize: 11,
                                                fontWeight:
                                                    FontWeight.bold,
                                                color: _statusColor(
                                                    order.status))),
                                        const SizedBox(width: 4),
                                        Icon(
                                            Icons
                                                .keyboard_arrow_down_rounded,
                                            size: 14,
                                            color: _statusColor(
                                                order.status)),
                                      ],
                                    ),
                                  ),
                                  itemBuilder: (ctx) => const [
                                    PopupMenuItem(
                                        value: "Diproses",
                                        child: Text("⏳ Diproses")),
                                    PopupMenuItem(
                                        value: "Dikirim",
                                        child: Text("🚚 Dikirim")),
                                    PopupMenuItem(
                                        value: "Selesai",
                                        child: Text("✅ Selesai")),
                                  ],
                                  onSelected: (newStatus) {
                                    setState(() {
                                      OrderData
                                          .daftarPesanan[index]
                                          .status = newStatus;
                                      OrderData.simpanPesanan();
                                    });
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            "Status diubah ke $newStatus"),
                                        backgroundColor:
                                            const Color(0xFF8D6E63),
                                        behavior:
                                            SnackBarBehavior.floating,
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                                "${order.tanggal}  ${order.waktu}  •  ${order.metodePembayaran}",
                                style: const TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey)),
                            const SizedBox(height: 4),
                            Text("📍 ${order.alamat}",
                                style: const TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey)),
                            const Divider(height: 20),

                            // Item pesanan
                            ...order.items.map((item) => Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 4),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment
                                            .spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "${item.name} x${item.quantity}",
                                          style: const TextStyle(
                                              fontSize: 12,
                                              color:
                                                  Color(0xFF5D4037)),
                                          overflow:
                                              TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Text(
                                        _formatRupiah(
                                            item.subtotal),
                                        style: const TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF8D6E63),
                                            fontWeight:
                                                FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                )),
                            const Divider(height: 16),

                            // Total
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Total Bayar",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                        color: Color(0xFF3E2723))),
                                Text(
                                  _formatRupiah(order.totalBayar),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: Color(0xFF3E2723)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}

// ── Main Navigation Pelanggan ──
class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    const HomeScreen(),
    const CartScreen(),
    const FavoritScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: ListenableBuilder(
        listenable: CartData(),
        builder: (context, _) {
          return BottomNavigationBar(
            currentIndex: _currentIndex,
            selectedItemColor: const Color(0xFF8D6E63),
            unselectedItemColor: Colors.grey,
            backgroundColor: Colors.white,
            elevation: 12,
            type: BottomNavigationBarType.fixed,
            onTap: (index) =>
                setState(() => _currentIndex = index),
            items: [
              const BottomNavigationBarItem(
                icon: Icon(Icons.home_rounded),
                label: "Beranda",
              ),
              BottomNavigationBarItem(
                icon: Stack(
                  children: [
                    const Icon(Icons.shopping_cart_rounded),
                    if (CartData.totalItem > 0)
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle),
                          constraints: const BoxConstraints(
                              minWidth: 14, minHeight: 14),
                          child: Text(
                            '${CartData.totalItem}',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
                label: "Keranjang",
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.favorite_rounded),
                label: "Favorit",
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.person_rounded),
                label: "Akun",
              ),
            ],
          );
        },
      ),
    );
  }
}