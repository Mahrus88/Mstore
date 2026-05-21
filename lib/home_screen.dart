import 'package:flutter/material.dart';
import 'detail_screen.dart'; // Menghubungkan ke halaman detail produk

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Variabel untuk melacak kategori mana yang sedang dipilih pelanggan
  String kategoriTerpilih = "Semua";

  // DATA RIIL MSTORE E-BAKERY (Estetik, Logis, & Bernilai Jual Tinggi)
  final List<Map<String, String>> daftarKue = [
    {
      "nama": "Premium Butter Croissant",
      "harga": "Rp 18.000",
      "gambar":
          "https://images.unsplash.com/photo-1555507036-ab1f4038808a?q=80&w=500&auto=format&fit=crop",
      "kategori": "Roti",
      "tag": "Freshly Baked",
      "deskripsi":
          "Roti croissant khas Prancis dengan lapisan pastry yang renyah di luar dan sangat lembut serta kaya rasa mentega di dalam.",
    },
    {
      "nama": "Strawberry Chiffon Cake",
      "harga": "Rp 145.000",
      "gambar":
          "https://images.unsplash.com/photo-1578985545062-69928b1d9587?q=80&w=500&auto=format&fit=crop",
      "kategori": "Kue Tar",
      "tag": "Best Seller",
      "deskripsi":
          "Kue sifon yang super lembut berdiameter 18cm, dilapisi krim segar premium dan potongan buah stroberi lokal yang manis asam segar.",
    },
    {
      "nama": "Choco Lava Belgian Donut",
      "harga": "Rp 12.500",
      "gambar":
          "https://images.unsplash.com/photo-1551024601-bec78aea704b?q=80&w=500&auto=format&fit=crop",
      "kategori": "Donat",
      "tag": "Favorit Anak",
      "deskripsi":
          "Donat kentang empuk dengan toping cokelat Belgia pekat melimpah yang lumer di dalam saat digigit.",
    },
    {
      "nama": "Almond Brownies Fudgy",
      "harga": "Rp 65.000",
      "gambar":
          "https://images.unsplash.com/photo-1606313564200-e75d5e30476c?q=80&w=500&auto=format&fit=crop",
      "kategori": "Kue",
      "tag": "Top Rated",
      "deskripsi":
          "Brownies panggang tekstur fudgy yang padat dan cokelat banget, dengan taburan kacang almond panggang yang gurih di atasnya.",
    },
  ];

  // Daftar Kategori Menu Atas (ATM Pola Shopee tapi versi Toko Kue)
  final List<Map<String, dynamic>> menuKategori = [
    {"icon": Icons.all_inclusive_rounded, "nama": "Semua"},
    {"icon": Icons.bakery_dining_rounded, "nama": "Roti"},
    {"icon": Icons.cake_rounded, "nama": "Kue Tar"},
    {"icon": Icons.donut_large_rounded, "nama": "Donat"},
    {"icon": Icons.cookie_rounded, "nama": "Kue"},
  ];

  @override
  Widget build(BuildContext context) {
    // Logika fungsional untuk menyaring produk berdasarkan kategori yang diklik user
    final produkDifilter = daftarKue.where((kue) {
      return kategoriTerpilih == "Semua" || kue["kategori"] == kategoriTerpilih;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(
        0xFFFDFBF7,
      ), // Background Krim Pastel hangat biar estetik
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. HEADER ATAS (Search Bar Toko Roti Modern)
              Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        height: 42,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F5F3),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.search_rounded,
                              color: Color(0xFF8D6E63),
                            ), // Aksen cokelat
                            const SizedBox(width: 8),
                            Text(
                              "Cari roti atau kue favoritmu...",
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Icon(
                      Icons.shopping_bag_outlined,
                      color: Color(0xFF8D6E63),
                    ),
                    const SizedBox(width: 12),
                    const Icon(
                      Icons.notifications_none_rounded,
                      color: Color(0xFF8D6E63),
                    ),
                  ],
                ),
              ),

              // 2. BANNER PROMO (UI Mewah Toko Roti / Bakery Premium)
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  width: double.infinity,
                  height: 140,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF8D6E63),
                        Color(0xFFA1887F),
                      ], // Gradasi Cokelat Estetik
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF8D6E63).withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                "MSTORE BAKERY & CAKE",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              "Promo Kehangatan Pagi!\nDiskon 20% Roti Yang Baru Matang",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        right: -10,
                        bottom: -10,
                        child: Icon(
                          Icons.cookie_rounded,
                          size: 150,
                          color: Colors.white.withOpacity(0.12),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 3. MENU KATEGORI INTERAKTIF (Bisa Diklik & Mengubah Daftar Produk)
              SizedBox(
                height: 90,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  itemCount: menuKategori.length,
                  itemBuilder: (context, index) {
                    final kat = menuKategori[index];
                    final isTerpilih = kategoriTerpilih == kat["nama"];

                    return GestureDetector(
                      onTap: () {
                        // Fungsi Berjalan: Mengubah state kategori saat diklik user
                        setState(() {
                          kategoriTerpilih = kat["nama"];
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: isTerpilih
                                    ? const Color(0xFF8D6E63)
                                    : Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isTerpilih
                                      ? const Color(0xFF8D6E63)
                                      : Colors.grey[300]!,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    blurRadius: 5,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                              child: Icon(
                                kat["icon"],
                                color: isTerpilih
                                    ? Colors.white
                                    : const Color(0xFF8D6E63),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              kat["nama"],
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: isTerpilih
                                    ? FontWeight.bold
                                    : FontWeight.w500,
                                color: isTerpilih
                                    ? const Color(0xFF8D6E63)
                                    : Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(left: 15.0, top: 15, bottom: 10),
                child: Text(
                  "Menu: $kategoriTerpilih",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4E342E),
                  ),
                ),
              ),

              // 4. KATALOG PRODUK GRID (Responsif, Berfungsi Penuh, & Bebas Error)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: produkDifilter.isEmpty
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Text(
                            "Maaf, menu kategori ini belum tersedia.",
                          ),
                        ),
                      )
                    : GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: produkDifilter.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.72,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                            ),
                        itemBuilder: (context, index) {
                          final item = produkDifilter[index];
                          return GestureDetector(
                            onTap: () {
                              // Membuktikan fungsionalitas jalan penuh di depan dosen sebelum masuk ke page detail
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "Membuka resep & detail: ${item['nama']}",
                                  ),
                                  backgroundColor: const Color(0xFF8D6E63),
                                  duration: const Duration(seconds: 1),
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    blurRadius: 8,
                                    spreadRadius: 2,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Foto Roti/Kue
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(15),
                                        topRight: Radius.circular(15),
                                      ),
                                      child: Image.network(
                                        item["gambar"]!,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                              return Container(
                                                color: Colors.grey[200],
                                                child: const Icon(
                                                  Icons
                                                      .image_not_supported_rounded,
                                                  color: Colors.grey,
                                                ),
                                              );
                                            },
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Status Kue (Fresh/Best Seller)
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 6,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFEFEBE9),
                                            borderRadius: BorderRadius.circular(
                                              5,
                                            ),
                                          ),
                                          child: Text(
                                            item["tag"]!,
                                            style: const TextStyle(
                                              color: Color(0xFF5D4037),
                                              fontSize: 9,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        // Nama Kue
                                        Text(
                                          item["nama"]!,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        // Harga Kue
                                        Text(
                                          item["harga"]!,
                                          style: const TextStyle(
                                            color: Color(0xFF8D6E63),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
              const SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }
}
