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
import 'utils.dart';

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
  // ✅ Akun default tidak di-reset
  static List<AkunModel> listAkun = [
    const AkunModel(email: "admin@bakery.com", password: "admin123"),
    const AkunModel(email: "mahrus@bakery.com", password: "mahrus123"),
  ];

  static bool _sudahDimuat = false; // ✅ Cegah load berulang

  static Future<void> muatAkun() async {
    if (_sudahDimuat) return; // ✅ Kalau sudah dimuat skip
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
                    style:
                        TextStyle(color: Colors.grey, fontSize: 13)),
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
                    prefixIcon: const Icon(
                        Icons.lock_outline_rounded,
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
                                color: Colors.white,
                                strokeWidth: 2.5),
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFBF7),
      appBar: AppBar(
        title: const Text("Admin Panel",
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF8D6E63),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const LoginScreen()),
              );
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header selamat datang
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF8D6E63),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text("Selamat Datang,",
                      style: TextStyle(
                          color: Colors.white70, fontSize: 13)),
                  SizedBox(height: 4),
                  Text("Admin MStore Bakery 🍞",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Text("Kelola toko Anda dari sini",
                      style: TextStyle(
                          color: Colors.white70, fontSize: 12)),
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
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    "Total Produk",
                    "8",
                    Icons.inventory_2_rounded,
                    const Color(0xFF8D6E63),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    "Total Akun",
                    "${AkunState.listAkun.length}",
                    Icons.people_rounded,
                    Colors.blue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    "Kategori",
                    "3",
                    Icons.category_rounded,
                    Colors.orange,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    "Total Pesanan",
                    "${OrderData.daftarPesanan.length}",
                    Icons.shopping_bag_rounded,
                    const Color(0xFF3E2723),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Menu Admin
            const Text("Menu Admin",
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3E2723))),
            const SizedBox(height: 12),
            _buildAdminMenu(
              icon: Icons.people_rounded,
              title: "Kelola Akun Pengguna",
              subtitle:
                  "${AkunState.listAkun.length} akun terdaftar",
              onTap: () => _showDaftarAkun(context),
            ),
            const SizedBox(height: 10),
            _buildAdminMenu(
              icon: Icons.inventory_2_rounded,
              title: "Daftar Produk",
              subtitle: "8 produk aktif",
              onTap: () => _showDaftarProduk(context),
            ),
            const SizedBox(height: 10),
            _buildAdminMenu(
              icon: Icons.shopping_bag_rounded,
              title: "Semua Pesanan",
              subtitle: "Lihat semua pesanan masuk",
              onTap: () => _showSemuaPesanan(context),
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
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
        ],
      ),
    );
  }

  Widget _buildAdminMenu({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFF8D6E63).withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon,
                  color: const Color(0xFF8D6E63), size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Color(0xFF3E2723))),
                  const SizedBox(height: 2),
                  Text(subtitle,
                      style: const TextStyle(
                          fontSize: 11, color: Colors.grey)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded,
                size: 14, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  void _showDaftarAkun(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        minChildSize: 0.4,
        expand: false,
        builder: (ctx, scrollController) => Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text("Daftar Akun Pengguna",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3E2723))),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: AkunState.listAkun.length,
                itemBuilder: (context, index) {
                  final akun = AkunState.listAkun[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: const Color(0xFF8D6E63)
                          .withOpacity(0.12),
                      child: Icon(
                        akun.email == "admin@bakery.com"
                            ? Icons.admin_panel_settings_rounded
                            : Icons.person_rounded,
                        color: const Color(0xFF8D6E63),
                        size: 20,
                      ),
                    ),
                    title: Text(akun.email,
                        style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500)),
                    subtitle: Text(
                      akun.email == "admin@bakery.com"
                          ? "Admin"
                          : "Pelanggan",
                      style: TextStyle(
                          fontSize: 11,
                          color:
                              akun.email == "admin@bakery.com"
                                  ? Colors.orange
                                  : Colors.green),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDaftarProduk(BuildContext context) {
    final List<Map<String, dynamic>> produk = [
      {"name": "Dark Cocoa Dream", "harga": "Rp 240.000", "kategori": "Kue Tart"},
      {"name": "Strawberry Chiffon", "harga": "Rp 285.000", "kategori": "Kue Tart"},
      {"name": "Matcha Crepe Cake", "harga": "Rp 320.000", "kategori": "Kue Tart"},
      {"name": "Hibiscus Glaze Donut", "harga": "Rp 37.500", "kategori": "Donat"},
      {"name": "Almond Snow Donut", "harga": "Rp 40.000", "kategori": "Donat"},
      {"name": "Choco Caviar Donut", "harga": "Rp 42.500", "kategori": "Donat"},
      {"name": "Butter Croissant", "harga": "Rp 45.000", "kategori": "Croissant"},
      {"name": "Almond Croissant", "harga": "Rp 55.000", "kategori": "Croissant"},
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        minChildSize: 0.4,
        expand: false,
        builder: (ctx, scrollController) => Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text("Daftar Produk",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3E2723))),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: produk.length,
                itemBuilder: (context, index) {
                  final p = produk[index];
                  return ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFF8D6E63)
                            .withOpacity(0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                          Icons.bakery_dining_rounded,
                          color: Color(0xFF8D6E63),
                          size: 20),
                    ),
                    title: Text(p['name'],
                        style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500)),
                    subtitle: Text(p['kategori'],
                        style: const TextStyle(
                            fontSize: 11, color: Colors.grey)),
                    trailing: Text(p['harga'],
                        style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF8D6E63),
                            fontWeight: FontWeight.bold)),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSemuaPesanan(BuildContext context) async {
    await OrderData.muatPesanan();
    if (!context.mounted) return;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        minChildSize: 0.4,
        expand: false,
        builder: (ctx, scrollController) => Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text("Semua Pesanan",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3E2723))),
            ),
            const Divider(height: 1),
            Expanded(
              child: OrderData.daftarPesanan.isEmpty
                  ? const Center(
                      child: Text("Belum ada pesanan masuk",
                          style: TextStyle(color: Colors.grey)))
                  : ListView.builder(
                      controller: scrollController,
                      padding: const EdgeInsets.all(16),
                      itemCount: OrderData.daftarPesanan.length,
                      itemBuilder: (context, index) {
                        final order =
                            OrderData.daftarPesanan[index];
                        return ListTile(
                          leading: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: const Color(0xFF8D6E63)
                                  .withOpacity(0.12),
                              borderRadius:
                                  BorderRadius.circular(10),
                            ),
                            child: const Icon(
                                Icons.receipt_long_rounded,
                                color: Color(0xFF8D6E63),
                                size: 20),
                          ),
                          title: Text(order.invoiceNumber,
                              style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500)),
                          subtitle: Text(
                              "${order.tanggal}  •  ${order.items.length} item",
                              style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey)),
                          trailing: Text(
                            formatRupiah(order.totalBayar),
                            style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF8D6E63),
                                fontWeight: FontWeight.bold),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Main Navigation ──
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