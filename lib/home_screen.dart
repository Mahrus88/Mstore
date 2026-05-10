import 'package:flutter/material.dart';
import 'login_screen.dart'; // Untuk ambil nama registeredName

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Nama dinamis untuk header
    String userDisplay = registeredName ?? "Mahrus Ali";

    // Data Produk
    final List<Map<String, dynamic>> products = [
      {"name": "Macbook M3", "price": "25.9jt", "icon": Icons.laptop_mac, "color": Colors.blue, "tag": "Diskon"},
      {"name": "iPhone 15", "price": "20.4jt", "icon": Icons.phone_iphone, "color": Colors.orange, "tag": "Terlaris"},
      {"name": "AirPods Pro", "price": "3.2jt", "icon": Icons.headphones, "color": Colors.red, "tag": "Baru"},
      {"name": "Watch Ultra", "price": "12.4jt", "icon": Icons.watch, "color": Colors.green, "tag": ""},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Warna background modern
      body: CustomScrollView(
        slivers: [
          // 1. App Bar Modern dengan Welcome Text
          SliverAppBar(
            expandedHeight: 120,
            floating: true,
            backgroundColor: Colors.blue,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 20, bottom: 15),
              title: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Halo, $userDisplay", style: const TextStyle(fontSize: 12, color: Colors.white70)),
                  const Text("Mau belanja apa hari ini?", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            actions: [
              IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none, color: Colors.white)),
              const SizedBox(width: 10),
            ],
          ),

          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 2. Search Bar di bawah AppBar
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: TextField(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: "Cari gadget terbaru...",
                      prefixIcon: const Icon(Icons.search, color: Colors.blue),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),

                // 3. Banner Promo (Biar nggak kosong)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(20),
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Colors.blue, Colors.blueAccent]),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("PROMO MEI!", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            Text("Diskon hingga 50%", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                            Text("Khusus Mahasiswa UIM", style: TextStyle(color: Colors.white70, fontSize: 12)),
                          ],
                        ),
                      ),
                      Icon(Icons.shopping_cart_checkout, size: 80, color: Colors.white.withOpacity(0.3)),
                    ],
                  ),
                ),

                const Padding(
                  padding: EdgeInsets.only(left: 20, top: 25, bottom: 15),
                  child: Text("Kategori", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),

                // 4. Horizontal Categories
                SizedBox(
                  height: 90,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.only(left: 20),
                    children: [
                      _buildCategory(Icons.laptop, "Laptop"),
                      _buildCategory(Icons.smartphone, "HP"),
                      _buildCategory(Icons.watch, "Jam"),
                      _buildCategory(Icons.headphones, "Audio"),
                      _buildCategory(Icons.camera_alt, "Kamera"),
                    ],
                  ),
                ),

                const Padding(
                  padding: EdgeInsets.only(left: 20, top: 20, bottom: 15),
                  child: Text("Rekomendasi Untukmu", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),

          // 5. Grid Produk Modern
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 15,
                crossAxisSpacing: 15,
                childAspectRatio: 0.75,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final item = products[index];
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)],
                    ),
                    child: Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: item['color'].withOpacity(0.1),
                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                                ),
                                child: Icon(item['icon'], size: 50, color: item['color']),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 4),
                                  Text(item['price'], style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        if (item['tag'] != "")
                          Positioned(
                            top: 10,
                            left: 10,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(10)),
                              child: Text(item['tag'], style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                            ),
                          ),
                      ],
                    ),
                  );
                },
                childCount: products.length,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 30)),
        ],
      ),
    );
  }

  // Widget Helper untuk Kategori
  Widget _buildCategory(IconData icon, String label) {
    return Container(
      width: 70,
      margin: const EdgeInsets.only(right: 15),
      child: Column(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: Colors.white,
            child: Icon(icon, color: Colors.blue),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}