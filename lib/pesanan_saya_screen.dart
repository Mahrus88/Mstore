// lib/pesanan_saya_screen.dart
import 'package:flutter/material.dart';
import 'order_data.dart';
import 'utils.dart';

class PesananSayaScreen extends StatefulWidget {
  const PesananSayaScreen({super.key});

  @override
  State<PesananSayaScreen> createState() => _PesananSayaScreenState();
}

class _PesananSayaScreenState extends State<PesananSayaScreen> {
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

  Color _statusColor(String status) {
    switch (status) {
      case "Diproses": return Colors.orange;
      case "Dikirim": return Colors.blue;
      case "Selesai": return Colors.green;
      default: return Colors.grey;
    }
  }

  IconData _statusIcon(String status) {
    switch (status) {
      case "Diproses": return Icons.hourglass_top_rounded;
      case "Dikirim": return Icons.local_shipping_rounded;
      case "Selesai": return Icons.check_circle_rounded;
      default: return Icons.info_rounded;
    }
  }

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
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                  color: Color(0xFF8D6E63)))
          : OrderData.daftarPesanan.isEmpty
              ? Center(
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
                      Text(
                          "Yuk mulai belanja dan buat pesanan pertamamu!",
                          style: TextStyle(
                              fontSize: 12, color: Colors.black45)),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: OrderData.daftarPesanan.length,
                  itemBuilder: (context, index) {
                    final order = OrderData.daftarPesanan[index];
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Text(order.invoiceNumber,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: Color(0xFF3E2723))),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: _statusColor(order.status)
                                        .withOpacity(0.12),
                                    borderRadius:
                                        BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(_statusIcon(order.status),
                                          size: 12,
                                          color: _statusColor(
                                              order.status)),
                                      const SizedBox(width: 4),
                                      Text(order.status,
                                          style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                              color: _statusColor(
                                                  order.status))),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text("${order.tanggal}  ${order.waktu}",
                                style: const TextStyle(
                                    fontSize: 11, color: Colors.grey)),
                            const Divider(height: 20),
                            ...order.items.map((item) => Padding(
                                  padding:
                                      const EdgeInsets.only(bottom: 6),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "${item.name} x${item.quantity}",
                                          style: const TextStyle(
                                              fontSize: 12,
                                              color: Color(0xFF5D4037)),
                                          overflow:
                                              TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Text(
                                        formatRupiah(item.subtotal),
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
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Total Bayar",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                        color: Color(0xFF3E2723))),
                                Text(formatRupiah(order.totalBayar),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: Color(0xFF3E2723))),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                const Icon(Icons.payment_rounded,
                                    size: 14, color: Colors.grey),
                                const SizedBox(width: 6),
                                Text(order.metodePembayaran,
                                    style: const TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey)),
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