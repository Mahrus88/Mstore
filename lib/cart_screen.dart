import 'package:flutter/material.dart';
// 1. WAJIB IMPORT file cart_data.dart agar dompet datanya sama!
import 'cart_data.dart'; 

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    // Mengambil data langsung dari wadah global CartData
    final listBelanjaan = CartData.itemsKeranjang;

    return Scaffold(
      backgroundColor: const Color(0xFFFDFBF7),
      appBar: AppBar(
        title: const Text(
          "Keranjang Belanja", 
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: const Color(0xFF8D6E63),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: listBelanjaan.isEmpty
          ? _buildKeranjangKosong() // Jika isi keranjang masih 0
          : _buildDaftarBelanja(listBelanjaan), // Jika ada brings/kue yang masuk
    );
  }

  // Tampilan estetik jika keranjang benar-benar kosong
  Widget _buildKeranjangKosong() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.shopping_basket_outlined, size: 80, color: Color(0xFFBCAAA4)),
          SizedBox(height: 16),
          Text(
            "Keranjangmu masih kosong nih",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF5D4037)),
          ),
          SizedBox(height: 6),
          Text(
            "Yuk, balik ke Beranda dan pilih donat kesukaanmu!",
            style: TextStyle(fontSize: 12, color: Colors.black45),
          ),
        ],
      ),
    );
  }

  // Tampilan daftar kue yang berhasil dimasukkan oleh user
  Widget _buildDaftarBelanja(List<Map<dynamic, dynamic>> items) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              String urlGambar = item['image']?.toString() ?? '';

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                  side: const BorderSide(color: Color(0xFFEFEBE9)),
                ),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      // Miniatur Gambar Roti/Donat di Keranjang
                      Container(
                        width: 70,
                        height: 70,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F0EA),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: urlGambar.isNotEmpty
                            ? Image.network(urlGambar, fit: BoxFit.cover)
                            : const Icon(Icons.bakery_dining_rounded, color: Color(0xFF8D6E63)),
                      ),
                      const SizedBox(width: 14),

                      // Detail Nama & Harga Roti
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['name']?.toString() ?? 'Menu Roti',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF3E2723)),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "\$${item['price']?.toString() ?? '0.0'}",
                              style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF8D6E63), fontSize: 13),
                            ),
                          ],
                        ),
                      ),

                      // Tombol Hapus item jika salah pencet
                      IconButton(
                        icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
                        onPressed: () {
                          setState(() {
                            // Menghapus kue dari list global berdasarkan indeksnya
                            CartData.itemsKeranjang.removeAt(index);
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Item berhasil dihapus dari keranjang"),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        },
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        
        // Ringkasan Total Belanja di Bagian Bawah
        _buildPanelTotal(items),
      ],
    );
  }

  Widget _buildPanelTotal(List<Map<dynamic, dynamic>> items) {
    // Menghitung total harga semua kue yang ada di keranjang secara otomatis
    double totalHarga = 0;
    for (var item in items) {
      totalHarga += double.tryParse(item['price'].toString()) ?? 0.0;
    }

    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), spreadRadius: 1, blurRadius: 10, offset: const Offset(0, -5))
        ],
      ),
      child: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Total Pembayaran", style: TextStyle(fontSize: 14, color: Colors.black54)),
                Text(
                  "\$${totalHarga.toStringAsFixed(2)}",
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF3E2723)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3E2723),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  // Aksi berlanjut ke checkout pembayaran nanti
                },
                child: const Text("PROSES CHECKOUT", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              ),
            )
          ],
        ),
      ),
    );
  }
}