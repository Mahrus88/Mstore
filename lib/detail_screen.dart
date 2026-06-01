import 'package:flutter/material.dart';
import 'cart_data.dart';

class DetailScreen extends StatefulWidget {
  final Map<dynamic, dynamic> product;
  const DetailScreen({super.key, required this.product});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  int _qty = 1;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    String urlGambar = product['image']?.toString() ?? '';
    double harga = double.tryParse(product['price'].toString()) ?? 0;
    double totalHarga = harga * _qty;

    return Scaffold(
      backgroundColor: const Color(0xFFFDFBF7),
      appBar: AppBar(
        title: Text(
          product['name']?.toString() ?? 'Detail Produk',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: const Color(0xFF8D6E63),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Bingkai Gambar Utama Produk
                    Container(
                      height: 250,
                      width: double.infinity,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F0EA),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: urlGambar.isNotEmpty
                          ? Image.network(
                              urlGambar,
                              fit: BoxFit.cover,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return const Center(
                                      child: CircularProgressIndicator(
                                        color: Color(0xFF8D6E63),
                                      ),
                                    );
                                  },
                              errorBuilder: (context, error, stackTrace) =>
                                  const Center(
                                    child: Icon(
                                      Icons.image_not_supported_outlined,
                                      size: 70,
                                      color: Color(0xFF8D6E63),
                                    ),
                                  ),
                            )
                          : const Center(
                              child: Icon(
                                Icons.bakery_dining_rounded,
                                size: 70,
                                color: Color(0xFF8D6E63),
                              ),
                            ),
                    ),
                    const SizedBox(height: 20),

                    // Baris Informasi Rating & Kategori
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF8D6E63).withOpacity(0.12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            "Kategori: ${product['category'] ?? 'Umum'}",
                            style: const TextStyle(
                              color: Color(0xFF5D4037),
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              color: Colors.amber,
                              size: 20,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "${product['rating'] ?? '4.5'}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: Color(0xFF3E2723),
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "(${product['ratingCount'] ?? 0} ulasan)",
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.black38,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Informasi Detail Nama & Harga Produk
                    Text(
                      product['name']?.toString() ?? 'Nama Menu',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3E2723),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      formatRupiah(harga),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF8D6E63),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Divider(color: Color(0xFFEFEBE9)),

                    // Bagian Deskripsi
                    const Text(
                      "Deskripsi Hidangan",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3E2723),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      product['desc']?.toString() ??
                          'Menu roti panggang lezat buatan MStore Bakery.',
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 13,
                        height: 1.6,
                      ),
                    ),

                    // Bagian Tag Produk (Opsional)
                    if (product['tag'] != null) ...[
                      const SizedBox(height: 16),
                      const Divider(color: Color(0xFFEFEBE9)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.local_offer_rounded,
                            size: 16,
                            color: Color(0xFF8D6E63),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF3E2723),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              product['tag'].toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 16),
                    const Divider(color: Color(0xFFEFEBE9)),

                    // Atur Jumlah Pesanan (Kuantitas)
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Jumlah Pesanan",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF3E2723),
                          ),
                        ),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                if (_qty > 1) {
                                  setState(() => _qty--);
                                }
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 150),
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: _qty > 1
                                      ? const Color(0xFF3E2723)
                                      : const Color(0xFFF5F0EA),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: const Color(0xFFEFEBE9),
                                  ),
                                ),
                                child: Icon(
                                  Icons.remove_rounded,
                                  color: _qty > 1 ? Colors.white : Colors.grey,
                                  size: 18,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: Text(
                                "$_qty",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF3E2723),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => setState(() => _qty++),
                              child: Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF3E2723),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.add_rounded,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Panel Ringkasan Harga
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFAF6F0),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFEFEBE9)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Subtotal Produk",
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 13,
                            ),
                          ),
                          Text(
                            formatRupiah(totalHarga),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF3E2723),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Tombol Utama: Masukkan Ke Keranjang
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3E2723),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () {
                    // Panggil tambahItem sebanyak kuantitas yang dipilih
                    for (int i = 0; i < _qty; i++) {
                      CartData.tambahItem(
                        product['name']?.toString() ?? 'Produk',
                        harga,
                        urlGambar,
                      );
                    }

                    // Tampilkan notifikasi sukses yang informatif
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            const Icon(
                              Icons.check_circle_outline_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                "${product['name']} x$_qty ditambahkan ke keranjang!",
                                style: const TextStyle(fontSize: 13),
                              ),
                            ),
                          ],
                        ),
                        backgroundColor: const Color(0xFF8D6E63),
                        behavior: SnackBarBehavior.floating,
                        margin: const EdgeInsets.all(16),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Tambah Ke Keranjang  •  ${formatRupiah(totalHarga)}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Fungsi pembantu untuk memformat nilai angka double ke mata uang Rupiah secara lokal
String formatRupiah(double nominal) {
  final stringNominal = nominal.toStringAsFixed(0);
  final formatRegex = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
  final hasilFormat = stringNominal.replaceAllMapped(
    formatRegex,
    (Match match) => '${match[1]}.',
  );
  return 'Rp $hasilFormat';
}
