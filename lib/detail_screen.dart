import 'package:flutter/material.dart';
// Mengimport wadah data global yang baru kita buat
import 'cart_data.dart'; 

class DetailScreen extends StatelessWidget {
  final Map<dynamic, dynamic> product;
  const DetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    String urlGambar = product['image']?.toString() ?? '';

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
          onPressed: () {
            Navigator.pop(context);
          },
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
                    // Bingkai Gambar Utama
                    Container(
                      height: 240,
                      width: double.infinity,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F0EA),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: urlGambar.isNotEmpty
                          ? Image.network(
                              urlGambar,
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return const Center(child: CircularProgressIndicator(color: Color(0xFF8D6E63)));
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return const Center(child: Icon(Icons.bakery_dining_rounded, size: 70, color: Color(0xFF8D6E63)));
                              },
                            )
                          : const Center(child: Icon(Icons.bakery_dining_rounded, size: 70, color: Color(0xFF8D6E63))),
                    ),
                    const SizedBox(height: 20),

                    // Kategori & Rating
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF8D6E63).withOpacity(0.15), 
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            "Kategori: ${product['category'] ?? 'Umum'}",
                            style: const TextStyle(color: Color(0xFF5D4037), fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.star_rounded, color: Colors.amber, size: 18),
                            const SizedBox(width: 2),
                            Text("${product['rating'] ?? '4.5'}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Nama Menu
                    Text(
                      product['name']?.toString() ?? 'Nama Menu',
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF3E2723)),
                    ),
                    const SizedBox(height: 6),

                    // Harga
                    Text(
                      "Harga: \$${(product['price'] ?? 0.0).toString()}",
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF8D6E63)),
                    ),
                    const SizedBox(height: 16),
                    const Divider(color: Color(0xFFEFEBE9)),

                    // Deskripsi
                    const Text(
                      "Deskripsi Hidangan",
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF3E2723)),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      product['desc']?.toString() ?? 'Menu roti panggang lezat buatan MStore Bakery.',
                      style: const TextStyle(color: Colors.black54, fontSize: 13, height: 1.6),
                    ),
                  ],
                ),
              ),
            ),

            // --- TOMBOL TAMBAH KE KERANJANG YANG SUDAH AKTIF ---
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3E2723), 
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    // SEKARANG BENAR-BENAR MENYIMPAN DATA KE LIST GLOBAL
                    CartData.itemsKeranjang.add({
                      "name": product['name'],
                      "price": product['price'],
                      "image": urlGambar,
                    });

                    // Munculkan notifikasi sukses
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("${product['name']} berhasil dimasukkan ke keranjang belanja!"),
                        backgroundColor: const Color(0xFF8D6E63),
                      ),
                    );
                  },
                  child: const Text(
                    "MASUKKAN KE KERANJANG", 
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, letterSpacing: 0.5),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}