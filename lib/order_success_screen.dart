// lib/order_success_screen.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'login_screen.dart';

class OrderSuccessScreen extends StatelessWidget {
  final String invoiceNumber;
  final String tanggal;
  final String waktu;
  final String metodePembayaran;

  const OrderSuccessScreen({
    super.key,
    required this.invoiceNumber,
    required this.tanggal,
    required this.waktu,
    required this.metodePembayaran,
  });

  static const String nomorWA = "083861780827";

  Future<void> _bukaWhatsApp(BuildContext context, String invoice) async {
    final String pesan =
        "Halo MStore Bakery! 🍞\n\nSaya ingin menanyakan status pesanan saya:\n\n"
        "No. Invoice: *$invoice*\n"
        "Tanggal: $tanggal\n\n"
        "Mohon informasinya, terima kasih!";
    final Uri waUrl = Uri.parse(
        "https://wa.me/$nomorWA?text=${Uri.encodeComponent(pesan)}");
    if (await canLaunchUrl(waUrl)) {
      await launchUrl(waUrl, mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("WhatsApp tidak ditemukan."),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFBF7),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(
                horizontal: 24.0, vertical: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Ikon sukses
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        color: const Color(0xFF8D6E63).withOpacity(0.06),
                        shape: BoxShape.circle,
                      ),
                    ),
                    Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        color: const Color(0xFF8D6E63).withOpacity(0.12),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.check_circle_rounded,
                          size: 75, color: Color(0xFF8D6E63)),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Text(
                  "Pesanan Berhasil!",
                  style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3E2723),
                      letterSpacing: 0.3),
                ),
                const SizedBox(height: 12),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    "Terima kasih telah berbelanja di MStore Bakery. Adonan roti terbaikmu sedang dipanggang hangat!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 13,
                        color: Colors.black45,
                        height: 1.6),
                  ),
                ),
                const SizedBox(height: 30),

                // ✅ Struk digital dengan metode pembayaran
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.0),
                    border: Border.all(color: const Color(0xFFEFEBE9)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.02),
                          blurRadius: 15,
                          offset: const Offset(0, 8)),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.receipt_long_rounded,
                              size: 18, color: Color(0xFF8D6E63)),
                          SizedBox(width: 8),
                          Text("Detail Transaksi",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF3E2723))),
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.0),
                        child:
                            Divider(height: 1, color: Color(0xFFF5F0EA)),
                      ),
                      _buildRow("No. Invoice", invoiceNumber,
                          isBold: true),
                      const SizedBox(height: 10),
                      _buildRow("Tanggal", tanggal),
                      const SizedBox(height: 10),
                      _buildRow("Waktu Bayar", waktu),
                      const SizedBox(height: 10),
                      // ✅ Metode pembayaran ditampilkan
                      _buildRow("Metode Bayar", metodePembayaran),
                      const SizedBox(height: 10),
                      _buildRow(
                          "Metode Pengiriman", "Kurir Kilat MStore"),
                      const SizedBox(height: 10),
                      _buildRow("Status", "Lunas / Diproses",
                          statusColor: Colors.green),
                    ],
                  ),
                ),
                const SizedBox(height: 25),

                // Estimasi
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 18, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFAF6F0),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFEFEBE9)),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.access_time_filled_rounded,
                          color: Color(0xFF8D6E63), size: 18),
                      SizedBox(width: 10),
                      Text(
                        "Estimasi tiba hangat: 30 - 45 Menit",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF5D4037),
                            fontSize: 12),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 35),

                // Tombol kembali belanja
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const MainNavigation()),
                        (route) => false,
                      );
                    },
                    icon: const Icon(Icons.storefront_rounded, size: 20),
                    label: const Text("BELANJA LAGI",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            letterSpacing: 0.5)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3E2723),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Tombol WhatsApp
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: TextButton.icon(
                    onPressed: () =>
                        _bukaWhatsApp(context, invoiceNumber),
                    icon: const Icon(
                      Icons.chat_bubble_outline_rounded,
                      size: 18,
                      color: Color(0xFF25D366),
                    ),
                    label: const Text(
                      "Tanya Status via WhatsApp",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: Color(0xFF25D366)),
                    ),
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: const BorderSide(
                            color: Color(0xFF25D366), width: 1.5),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value,
      {bool isBold = false, Color? statusColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style:
                const TextStyle(fontSize: 12, color: Colors.black45)),
        Flexible(
          child: Text(value,
              textAlign: TextAlign.end,
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: isBold || statusColor != null
                      ? FontWeight.bold
                      : FontWeight.normal,
                  color: statusColor ?? const Color(0xFF3E2723))),
        ),
      ],
    );
  }
}