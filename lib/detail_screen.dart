// lib/detail_screen.dart
import 'package:flutter/material.dart';
import 'cart_data.dart';
import 'utils.dart';
import 'favorite_data.dart';

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
    bool isFavorit = FavoriteData.isFavorit(product['name']);

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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        // ✅ Tombol favorit di AppBar
        actions: [
          IconButton(
            icon: Icon(
              isFavorit ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              color: isFavorit ? Colors.red : Colors.white,
            ),
            onPressed: () async {
              await FavoriteData.toggleFavorit(Map<String, dynamic>.from(product));
              setState(() {});
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    FavoriteData.isFavorit(product['name'])
                        ? "${product['name']} ditambahkan ke favorit!"
                        : "${product['name']} dihapus dari favorit",
                  ),
                  backgroundColor: const Color(0xFF8D6E63),
                  behavior: SnackBarBehavior.floating,
                  duration: const Duration(seconds: 1),
                ),
              );
            },
          ),
        ],
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
                    // Gambar Produk
                    Container(
                      height: 240,
                      width: double.infinity,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F0EA),
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: urlGambar.isNotEmpty
                          ? Image.network(
                              urlGambar,
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return const Center(
                                  child: CircularProgressIndicator(
                                      color: Color(0xFF8D6E63)),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) =>
                                  const Center(
                                child: Icon(Icons.bakery_dining_rounded,
                                    size: 70, color: Color(0xFF8D6E63)),
                              ),
                            )
                          : const Center(
                              child: Icon(Icons.bakery_dining_rounded,
                                  size: 70, color: Color(0xFF8D6E63)),
                            ),
                    ),
                    const SizedBox(height: 20),

                    // Kategori & Rating
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF8D6E63).withOpacity(0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            "Kategori: ${product['category'] ?? 'Umum'}",
                            style: const TextStyle(
                                color: Color(0xFF5D4037),
                                fontSize: 12,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.star_rounded,
                                color: Colors.amber, size: 18),
                            const SizedBox(width: 2),
                            Text("${product['rating'] ?? '4.5'}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13)),
                            const SizedBox(width: 4),
                            Text("(${product['ratingCount'] ?? 0} ulasan)",
                                style: const TextStyle(
                                    fontSize: 11, color: Colors.grey)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Nama Produk
                    Text(
                      product['name']?.toString() ?? 'Nama Menu',
                      style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF3E2723)),
                    ),
                    const SizedBox(height: 6),

                    // Harga
                    Text(
                      formatRupiah(harga),
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF8D6E63)),
                    ),
                    const SizedBox(height: 16),
                    const Divider(color: Color(0xFFEFEBE9)),

                    // Deskripsi
                    const Text("Deskripsi Hidangan",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF3E2723))),
                    const SizedBox(height: 8),
                    Text(
                      product['desc']?.toString() ??
                          'Menu roti panggang lezat buatan MStore Bakery.',
                      style: const TextStyle(
                          color: Colors.black54, fontSize: 13, height: 1.6),
                    ),

                    if (product['tag'] != null) ...[
                      const SizedBox(height: 16),
                      const Divider(color: Color(0xFFEFEBE9)),
                      const SizedBox(height: 8),
                      Row(children: [
                        const Icon(Icons.local_offer_rounded,
                            size: 16, color: Color(0xFF8D6E63)),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF3E2723),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(product['tag'],
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ]),
                    ],
                    const SizedBox(height: 20),
                    const Divider(color: Color(0xFFEFEBE9)),
                    const SizedBox(height: 12),

                    // Qty Selector
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Jumlah",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF3E2723))),
                        Row(children: [
                          GestureDetector(
                            onTap: () {
                              if (_qty > 1) setState(() => _qty--);
                            },
                            child: Container(
                              width: 34,
                              height: 34,
                              decoration: BoxDecoration(
                                color: _qty > 1
                                    ? const Color(0xFF3E2723)
                                    : Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(Icons.remove_rounded,
                                  color: _qty > 1
                                      ? Colors.white
                                      : Colors.grey,
                                  size: 18),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16),
                            child: Text("$_qty",
                                style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF3E2723))),
                          ),
                          GestureDetector(
                            onTap: () => setState(() => _qty++),
                            child: Container(
                              width: 34,
                              height: 34,
                              decoration: BoxDecoration(
                                color: const Color(0xFF3E2723),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.add_rounded,
                                  color: Colors.white, size: 18),
                            ),
                          ),
                        ]),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Total Harga
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F0EA),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Total Harga",
                              style: TextStyle(
                                  color: Colors.black54, fontSize: 13)),
                          Text(formatRupiah(totalHarga),
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF3E2723))),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Tombol Tambah ke Keranjang
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3E2723),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    elevation: 3,
                  ),
                  onPressed: () {
                    for (int i = 0; i < _qty; i++) {
                      CartData.tambahItem(
                          product['name'], harga, urlGambar);
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            "${product['name']} x$_qty berhasil ditambahkan!"),
                        backgroundColor: const Color(0xFF8D6E63),
                        behavior: SnackBarBehavior.floating,
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
                        letterSpacing: 0.3),
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