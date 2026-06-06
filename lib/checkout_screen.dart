// lib/checkout_screen.dart
import 'package:flutter/material.dart';
import 'dart:math';
import 'cart_data.dart';
import 'utils.dart';
import 'order_success_screen.dart';
import 'order_data.dart';
import 'image_helper.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _alamatController = TextEditingController();
  final _catatanController = TextEditingController();
  String _metodePembayaran = "Transfer Bank";
  String _kotaTerpilih = "Pilih Kota";
  bool _isLoading = false;

  final List<String> _metodePembayaranList = [
    "Transfer Bank",
    "COD (Bayar di Tempat)",
    "Dompet Digital (OVO/GoPay/Dana)",
  ];

  final Map<String, double> _ongkirPerKota = {
    "Pilih Kota": 0,
    "Pamekasan": 10000,
    "Sumenep": 15000,
    "Sampang": 15000,
    "Bangkalan": 20000,
    "Surabaya": 25000,
    "Malang": 30000,
    "Sidoarjo": 25000,
    "Gresik": 25000,
    "Mojokerto": 28000,
    "Pasuruan": 30000,
  };

  double get biayaOngkir => _ongkirPerKota[_kotaTerpilih] ?? 0;
  double get totalBayar => CartData.totalHarga + biayaOngkir;

  @override
  void dispose() {
    _alamatController.dispose();
    _catatanController.dispose();
    super.dispose();
  }

  void _prosesCheckout() async {
    if (_kotaTerpilih == "Pilih Kota") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Mohon pilih kota pengiriman terlebih dahulu."),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    if (_alamatController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Mohon isi alamat pengiriman."),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    if (_alamatController.text.trim().length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Alamat terlalu singkat, mohon isi lebih lengkap."),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));

    final String invoiceNumber =
        "MST-${10000 + Random().nextInt(90000)}";
    final DateTime sekarang = DateTime.now();
    final String tanggal =
        "${sekarang.day}/${sekarang.month}/${sekarang.year}";
    final String waktu =
        "${sekarang.hour.toString().padLeft(2, '0')}:${sekarang.minute.toString().padLeft(2, '0')}";

    final order = OrderModel(
      invoiceNumber: invoiceNumber,
      tanggal: tanggal,
      waktu: waktu,
      alamat: "${_alamatController.text.trim()}, $_kotaTerpilih",
      metodePembayaran: _metodePembayaran,
      items: CartData.items
          .map((e) => OrderItem(
                name: e.name,
                quantity: e.quantity,
                price: e.price,
              ))
          .toList(),
      totalHarga: CartData.totalHarga,
      ongkir: biayaOngkir,
    );

    await OrderData.tambahPesanan(order);
    setState(() => _isLoading = false);
    if (!mounted) return;

    CartData.kosongkan();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => OrderSuccessScreen(
          invoiceNumber: invoiceNumber,
          tanggal: tanggal,
          waktu: waktu,
          metodePembayaran: _metodePembayaran,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFBF7),
      appBar: AppBar(
        title: const Text("Checkout",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: const Color(0xFF8D6E63),
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Ringkasan Pesanan
                  _buildSectionTitle("Ringkasan Pesanan"),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 8),
                      ],
                    ),
                    child: Column(
                      children: CartData.items.asMap().entries.map((entry) {
                        final item = entry.value;
                        final isLast =
                            entry.key == CartData.items.length - 1;
                        return Column(
                          children: [
                            ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 4),
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: buildGambarProduk(
                                  path: item.image,
                                  width: 46,
                                  height: 46,
                                ),
                              ),
                              title: Text(item.name,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                      color: Color(0xFF3E2723))),
                              subtitle: Text("x${item.quantity}",
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.grey)),
                              trailing: Text(formatRupiah(item.subtotal),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                      color: Color(0xFF8D6E63))),
                            ),
                            if (!isLast)
                              const Divider(
                                  height: 1, indent: 14, endIndent: 14),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Kota Pengiriman
                  _buildSectionTitle("Kota Pengiriman"),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 8),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 4),
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        canvasColor: Colors.white,
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _kotaTerpilih,
                          isExpanded: true,
                          dropdownColor: Colors.white,
                          style: const TextStyle(
                              color: Color(0xFF3E2723), fontSize: 13),
                          icon: const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: Color(0xFF8D6E63)),
                          items: _ongkirPerKota.keys.map((kota) {
                            return DropdownMenuItem<String>(
                              value: kota,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(kota,
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: kota == "Pilih Kota"
                                              ? Colors.grey
                                              : const Color(0xFF3E2723),
                                          fontWeight: FontWeight.w500)),
                                  if (kota != "Pilih Kota")
                                    Text(
                                      formatRupiah(
                                          _ongkirPerKota[kota]!),
                                      style: const TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF8D6E63),
                                          fontWeight: FontWeight.w500),
                                    ),
                                ],
                              ),
                            );
                          }).toList(),
                          onChanged: (val) =>
                              setState(() => _kotaTerpilih = val!),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Alamat Pengiriman
                  _buildSectionTitle("Alamat Pengiriman"),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 8),
                      ],
                    ),
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      children: [
                        TextField(
                          controller: _alamatController,
                          maxLines: 3,
                          decoration: InputDecoration(
                            hintText:
                                "Masukkan alamat lengkap (nama jalan, nomor rumah, RT/RW)...",
                            hintStyle: const TextStyle(
                                fontSize: 12, color: Colors.grey),
                            prefixIcon: const Padding(
                              padding: EdgeInsets.only(bottom: 40),
                              child: Icon(Icons.location_on_outlined,
                                  color: Color(0xFF8D6E63)),
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12)),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                  color: Color(0xFF8D6E63), width: 2),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _catatanController,
                          decoration: InputDecoration(
                            hintText: "Catatan untuk kurir (opsional)",
                            hintStyle: const TextStyle(
                                fontSize: 13, color: Colors.grey),
                            prefixIcon: const Icon(Icons.note_outlined,
                                color: Color(0xFF8D6E63)),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12)),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                  color: Color(0xFF8D6E63), width: 2),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Metode Pembayaran
                  _buildSectionTitle("Metode Pembayaran"),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 8),
                      ],
                    ),
                    child: Column(
                      children: _metodePembayaranList
                          .asMap()
                          .entries
                          .map((entry) {
                        final metode = entry.value;
                        final isLast = entry.key ==
                            _metodePembayaranList.length - 1;
                        return Column(
                          children: [
                            RadioListTile<String>(
                              value: metode,
                              groupValue: _metodePembayaran,
                              activeColor: const Color(0xFF8D6E63),
                              title: Text(metode,
                                  style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500)),
                              onChanged: (val) => setState(
                                  () => _metodePembayaran = val!),
                            ),
                            if (!isLast)
                              const Divider(
                                  height: 1, indent: 14, endIndent: 14),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Rincian Biaya
                  _buildSectionTitle("Rincian Biaya"),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 8),
                      ],
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _buildBiayaRow(
                            "Subtotal (${CartData.totalItem} item)",
                            formatRupiah(CartData.totalHarga)),
                        const SizedBox(height: 8),
                        _buildBiayaRow(
                          "Ongkos Kirim${_kotaTerpilih != 'Pilih Kota' ? ' ($_kotaTerpilih)' : ''}",
                          _kotaTerpilih == "Pilih Kota"
                              ? "Pilih kota dulu"
                              : formatRupiah(biayaOngkir),
                        ),
                        const Divider(height: 24),
                        _buildBiayaRow(
                          "Total Pembayaran",
                          _kotaTerpilih == "Pilih Kota"
                              ? "-"
                              : formatRupiah(totalBayar),
                          isBold: true,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),

          // Tombol Pesan
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _prosesCheckout,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3E2723),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    elevation: 2,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2.5),
                        )
                      : Text(
                          _kotaTerpilih == "Pilih Kota"
                              ? "PILIH KOTA DULU"
                              : "PESAN SEKARANG  •  ${formatRupiah(totalBayar)}",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Text(title,
            style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color(0xFF3E2723))),
      );

  Widget _buildBiayaRow(String label, String value,
          {bool isBold = false}) =>
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  color: isBold
                      ? const Color(0xFF3E2723)
                      : Colors.black54,
                  fontSize: 13,
                  fontWeight:
                      isBold ? FontWeight.bold : FontWeight.normal)),
          Text(value,
              style: TextStyle(
                  fontWeight:
                      isBold ? FontWeight.bold : FontWeight.normal,
                  fontSize: isBold ? 16 : 13,
                  color: const Color(0xFF3E2723))),
        ],
      );
}