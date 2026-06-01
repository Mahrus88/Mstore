// lib/profile_screen.dart
import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'cart_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
// ignore: unused_import
import 'pesanan_saya_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String emailUser = SesiUser.emailAktif;
    String namaUser =
        emailUser.contains('@') ? emailUser.split('@')[0] : emailUser;
    namaUser = namaUser.isNotEmpty
        ? namaUser[0].toUpperCase() + namaUser.substring(1)
        : "User";

    return Scaffold(
      backgroundColor: const Color(0xFFFDFBF7),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header profil
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 30),
                decoration: const BoxDecoration(
                  color: Color(0xFF8D6E63),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(28),
                    bottomRight: Radius.circular(28),
                  ),
                ),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 48,
                          backgroundColor: Colors.white.withOpacity(0.3),
                          child: const Icon(Icons.person,
                              size: 52, color: Colors.white),
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Color(0xFF3E2723),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.camera_alt_rounded,
                                size: 16, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(namaUser,
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                    const SizedBox(height: 4),
                    Text(emailUser,
                        style: const TextStyle(
                            fontSize: 13, color: Colors.white70)),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    _buildMenuCard([
                      _buildMenuItem(
                        icon: Icons.shopping_bag_outlined,
                        title: "Pesanan Saya",
                        subtitle: "Lihat riwayat pesanan",
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const PesananSayaScreen()),
                        ),
                      ),
                      _buildDivider(),
                      _buildMenuItem(
                        icon: Icons.location_on_outlined,
                        title: "Alamat Pengiriman",
                        subtitle: "Kelola alamat tersimpan",
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AlamatScreen()),
                        ),
                      ),
                    ]),
                    const SizedBox(height: 12),
                    _buildMenuCard([
                      _buildMenuItem(
                        icon: Icons.person_outline_rounded,
                        title: "Edit Profil",
                        subtitle: "Ubah nama & informasi akun",
                        onTap: () => _showEditProfil(context, namaUser),
                      ),
                      _buildDivider(),
                      _buildMenuItem(
                        icon: Icons.lock_reset_rounded,
                        title: "Ubah Password",
                        subtitle: "Perbarui kata sandi",
                        onTap: () => _showUbahPassword(context),
                      ),
                      _buildDivider(),
                      _buildMenuItem(
                        icon: Icons.notifications_outlined,
                        title: "Notifikasi",
                        subtitle: "Pengaturan pemberitahuan",
                        onTap: () {},
                      ),
                    ]),
                    const SizedBox(height: 12),
                    _buildMenuCard([
                      _buildMenuItem(
                        icon: Icons.logout_rounded,
                        title: "Keluar Akun",
                        titleColor: Colors.redAccent,
                        iconColor: Colors.redAccent,
                        onTap: () => _showDialogLogout(context),
                      ),
                    ]),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2))
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildDivider() =>
      const Divider(height: 1, indent: 56, color: Color(0xFFF0EBE8));

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    String? subtitle,
    Color? titleColor,
    Color? iconColor,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: (iconColor ?? const Color(0xFF8D6E63)).withOpacity(0.12),
          borderRadius: BorderRadius.circular(10),
        ),
        child:
            Icon(icon, color: iconColor ?? const Color(0xFF8D6E63), size: 20),
      ),
      title: Text(title,
          style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: titleColor ?? const Color(0xFF3E2723))),
      subtitle: subtitle != null
          ? Text(subtitle,
              style: const TextStyle(fontSize: 11, color: Colors.grey))
          : null,
      trailing: const Icon(Icons.arrow_forward_ios_rounded,
          size: 14, color: Colors.grey),
      onTap: onTap,
    );
  }

  void _showEditProfil(BuildContext context, String namaAwal) {
    final namaController = TextEditingController(text: namaAwal);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Edit Profil",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3E2723))),
            const SizedBox(height: 20),
            TextField(
              controller: namaController,
              decoration: InputDecoration(
                labelText: "Nama",
                prefixIcon: const Icon(Icons.person_outline_rounded),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  // Simpan nama ke SharedPreferences
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setString(
                      'nama_user', namaController.text.trim());
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Profil berhasil diperbarui!"),
                      backgroundColor: Color(0xFF8D6E63),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8D6E63),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text("SIMPAN",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showUbahPassword(BuildContext context) {
    final oldPass = TextEditingController();
    final newPass = TextEditingController();
    final confirmPass = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Ubah Password",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3E2723))),
            const SizedBox(height: 20),
            TextField(
              controller: oldPass,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Password Lama",
                prefixIcon: const Icon(Icons.lock_outline_rounded),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: newPass,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Password Baru",
                prefixIcon: const Icon(Icons.lock_reset_rounded),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: confirmPass,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Konfirmasi Password Baru",
                prefixIcon: const Icon(Icons.lock_rounded),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Cari akun yang sedang login
                  final index = AkunState.listAkun
                      .indexWhere((a) => a.email == SesiUser.emailAktif);
                  if (index == -1) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Akun tidak ditemukan."),
                          backgroundColor: Colors.red),
                    );
                    return;
                  }
                  if (oldPass.text != AkunState.listAkun[index].password) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Password lama salah!"),
                          backgroundColor: Colors.red,
                          behavior: SnackBarBehavior.floating),
                    );
                    return;
                  }
                  if (newPass.text.length < 6) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Password baru minimal 6 karakter!"),
                          backgroundColor: Colors.red,
                          behavior: SnackBarBehavior.floating),
                    );
                    return;
                  }
                  if (newPass.text != confirmPass.text) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Konfirmasi password tidak cocok!"),
                          backgroundColor: Colors.red,
                          behavior: SnackBarBehavior.floating),
                    );
                    return;
                  }
                  // Update password
                  AkunState.listAkun[index] = AkunModel(
                    email: AkunState.listAkun[index].email,
                    password: newPass.text,
                  );
                  AkunState.simpanAkun();
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Password berhasil diperbarui!"),
                      backgroundColor: Color(0xFF8D6E63),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8D6E63),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text("SIMPAN PASSWORD",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDialogLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        backgroundColor: const Color(0xFFFDFBF7),
        title: Row(
          children: const [
            Icon(Icons.logout_rounded, color: Color(0xFF8D6E63)),
            SizedBox(width: 10),
            Text("Konfirmasi Keluar",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3E2723),
                    fontSize: 18)),
          ],
        ),
        content: const Text(
            "Apakah Anda yakin ingin keluar dari akun MStore Bakery?",
            style: TextStyle(color: Colors.black54, fontSize: 14)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("BATAL",
                style: TextStyle(
                    color: Color(0xFF8D6E63), fontWeight: FontWeight.bold)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3E2723),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () async {
              Navigator.pop(ctx);
              SesiUser.emailAktif = "Pengguna MStore";
              CartData.kosongkan();
              await AkunState.hapusSesi();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
            child: const Text("YA, KELUAR",
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

// ── Halaman Pesanan Saya ──
class PesananSayaScreen extends StatelessWidget {
  const PesananSayaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFBF7),
      appBar: AppBar(
        title: const Text("Pesanan Saya",
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF8D6E63),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.shopping_bag_outlined,
                size: 80, color: Color(0xFFBCAAA4)),
            SizedBox(height: 16),
            Text("Belum ada pesanan",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF5D4037))),
            SizedBox(height: 6),
            Text("Yuk mulai belanja dan buat pesanan pertamamu!",
                style: TextStyle(fontSize: 12, color: Colors.black45)),
          ],
        ),
      ),
    );
  }
}

// ── Halaman Alamat Pengiriman ──
class AlamatScreen extends StatefulWidget {
  const AlamatScreen({super.key});

  @override
  State<AlamatScreen> createState() => _AlamatScreenState();
}

class _AlamatScreenState extends State<AlamatScreen> {
  final _alamatController = TextEditingController();
  List<String> _daftarAlamat = [];

  @override
  void initState() {
    super.initState();
    _muatAlamat();
  }

  Future<void> _muatAlamat() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _daftarAlamat = prefs.getStringList('daftar_alamat') ?? [];
    });
  }

  Future<void> _simpanAlamat() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('daftar_alamat', _daftarAlamat);
  }

  void _tambahAlamat() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Tambah Alamat",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3E2723))),
            const SizedBox(height: 16),
            TextField(
              controller: _alamatController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: "Masukkan alamat lengkap...",
                prefixIcon: const Padding(
                  padding: EdgeInsets.only(bottom: 40),
                  child: Icon(Icons.location_on_outlined,
                      color: Color(0xFF8D6E63)),
                ),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      const BorderSide(color: Color(0xFF8D6E63), width: 2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if (_alamatController.text.trim().isEmpty) return;
                  setState(() {
                    _daftarAlamat.add(_alamatController.text.trim());
                    _alamatController.clear();
                  });
                  await _simpanAlamat();
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Alamat berhasil ditambahkan!"),
                      backgroundColor: Color(0xFF8D6E63),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8D6E63),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text("SIMPAN ALAMAT",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFBF7),
      appBar: AppBar(
        title: const Text("Alamat Pengiriman",
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF8D6E63),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            onPressed: _tambahAlamat,
            tooltip: "Tambah Alamat",
          )
        ],
      ),
      body: _daftarAlamat.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.location_off_rounded,
                      size: 80, color: Color(0xFFBCAAA4)),
                  const SizedBox(height: 16),
                  const Text("Belum ada alamat tersimpan",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF5D4037))),
                  const SizedBox(height: 6),
                  const Text("Tap tombol + untuk menambah alamat baru",
                      style: TextStyle(fontSize: 12, color: Colors.black45)),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: _tambahAlamat,
                    icon: const Icon(Icons.add_rounded),
                    label: const Text("Tambah Alamat"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8D6E63),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _daftarAlamat.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: const BorderSide(color: Color(0xFFEFEBE9)),
                  ),
                  color: Colors.white,
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFF8D6E63).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.location_on_rounded,
                          color: Color(0xFF8D6E63), size: 20),
                    ),
                    title: Text(
                      "Alamat ${index + 1}",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: Color(0xFF3E2723)),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(_daftarAlamat[index],
                          style: const TextStyle(
                              fontSize: 12, color: Colors.black54)),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline_rounded,
                          color: Colors.redAccent),
                      onPressed: () async {
                        setState(() => _daftarAlamat.removeAt(index));
                        await _simpanAlamat();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Alamat dihapus"),
                            duration: Duration(seconds: 1),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: _daftarAlamat.isNotEmpty
          ? FloatingActionButton(
              onPressed: _tambahAlamat,
              backgroundColor: const Color(0xFF8D6E63),
              child: const Icon(Icons.add_rounded, color: Colors.white),
            )
          : null,
    );
  }
}
