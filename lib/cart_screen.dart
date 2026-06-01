// lib/cart_screen.dart
import 'package:flutter/material.dart';
import 'cart_data.dart';
import 'home_screen.dart';
import 'checkout_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFBF7),
      appBar: AppBar(
        title: const Text("Keranjang Belanja",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: const Color(0xFF8D6E63),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (CartData.items.isNotEmpty)
            TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    title: const Text("Kosongkan Keranjang?",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    content: const Text(
                        "Semua item akan dihapus dari keranjang."),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text("BATAL"),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() => CartData.kosongkan());
                          Navigator.pop(ctx);
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red),
                        child: const Text("HAPUS SEMUA",
                            style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                );
              },
              child: const Text("Hapus Semua",
                  style: TextStyle(color: Colors.white, fontSize: 12)),
            ),
        ],
      ),
      body: CartData.items.isEmpty
          ? _buildKeranjangKosong()
          : _buildDaftarBelanja(),
    );
  }

  Widget _buildKeranjangKosong() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_basket_outlined,
              size: 80, color: Color(0xFFBCAAA4)),
          SizedBox(height: 16),
          Text("Keranjangmu masih kosong nih",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF5D4037))),
          SizedBox(height: 6),
          Text("Yuk, balik ke Beranda dan pilih produk kesukaanmu!",
              style: TextStyle(fontSize: 12, color: Colors.black45)),
        ],
      ),
    );
  }

  Widget _buildDaftarBelanja() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: CartData.items.length,
            itemBuilder: (context, index) {
              final item = CartData.items[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                  side: const BorderSide(color: Color(0xFFEFEBE9)),
                ),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      // Gambar produk
                      Container(
                        width: 70,
                        height: 70,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F0EA),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: item.image.isNotEmpty
                            ? Image.network(item.image, fit: BoxFit.cover)
                            : const Icon(Icons.bakery_dining_rounded,
                                color: Color(0xFF8D6E63)),
                      ),
                      const SizedBox(width: 14),

                      // Nama & Harga
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Color(0xFF3E2723))),
                            const SizedBox(height: 4),
                            Text(formatRupiah(item.price),
                                style: const TextStyle(
                                    color: Color(0xFF8D6E63),
                                    fontSize: 12)),
                            const SizedBox(height: 8),
                            // Kontrol qty
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () => setState(
                                      () => CartData.kurangQty(index)),
                                  child: Container(
                                    width: 28,
                                    height: 28,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF5F0EA),
                                      borderRadius:
                                          BorderRadius.circular(6),
                                      border: Border.all(
                                          color: const Color(0xFFEFEBE9)),
                                    ),
                                    child: const Icon(
                                        Icons.remove_rounded,
                                        size: 16,
                                        color: Color(0xFF3E2723)),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  child: Text("${item.quantity}",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                          color: Color(0xFF3E2723))),
                                ),
                                GestureDetector(
                                  onTap: () => setState(
                                      () => CartData.tambahQty(index)),
                                  child: Container(
                                    width: 28,
                                    height: 28,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF3E2723),
                                      borderRadius:
                                          BorderRadius.circular(6),
                                    ),
                                    child: const Icon(Icons.add_rounded,
                                        size: 16, color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Subtotal + Hapus
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(formatRupiah(item.subtotal),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF3E2723),
                                  fontSize: 13)),
                          const SizedBox(height: 8),
                          // ✅ TOMBOL HAPUS DENGAN KONFIRMASI
                          GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(16)),
                                  title: const Text(
                                    "Hapus Item?",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF3E2723)),
                                  ),
                                  content: Text(
                                    "Hapus \"${item.name}\" dari keranjang?",
                                    style: const TextStyle(
                                        color: Colors.black54,
                                        fontSize: 13),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(ctx),
                                      child: const Text("BATAL",
                                          style: TextStyle(
                                              color: Color(0xFF8D6E63),
                                              fontWeight:
                                                  FontWeight.bold)),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        setState(() =>
                                            CartData.hapusItem(index));
                                        Navigator.pop(ctx);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                "${item.name} dihapus dari keranjang"),
                                            duration: const Duration(
                                                seconds: 1),
                                            behavior: SnackBarBehavior
                                                .floating,
                                          ),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(
                                                    8)),
                                      ),
                                      child: const Text("HAPUS",
                                          style: TextStyle(
                                              fontWeight:
                                                  FontWeight.bold)),
                                    ),
                                  ],
                                ),
                              );
                            },
                            child: const Icon(
                                Icons.delete_outline_rounded,
                                color: Colors.redAccent,
                                size: 22),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        _buildPanelTotal(),
      ],
    );
  }

  Widget _buildPanelTotal() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            spreadRadius: 1,
            blurRadius: 12,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("${CartData.totalItem} item dipilih",
                    style: const TextStyle(
                        fontSize: 13, color: Colors.black54)),
                Text(formatRupiah(CartData.totalHarga),
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3E2723))),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3E2723),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  elevation: 2,
                ),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CheckoutScreen()),
                ),
                child: const Text("PROSES CHECKOUT",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        letterSpacing: 0.5)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}