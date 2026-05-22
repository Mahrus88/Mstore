import 'package:flutter/material.dart';
import 'detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedCategory = "Semua";

  // Data menu MStore Bakery dengan link gambar baru yang super stabil untuk web
  final List<Map<String, dynamic>> menuBakery = [
    // --- KATEGORI KUE TART ---
    {
      "name": "Dark Cocoa Dream", 
      "price": 24.00, 
      "rating": 4.9, 
      "tag": "Terlaris", 
      "desc": "Kue tart cokelat murni berlapis krim cokelat Belgia yang sangat lumer dan manisnya pas.",
      "category": "Kue Tart",
      "image": "https://images.unsplash.com/photo-1578985545062-69928b1d9587?q=80&w=500&auto=format&fit=crop"
    },
    {
      "name": "Strawberry Chiffon", 
      "price": 28.50, 
      "rating": 4.8, 
      "tag": "Populer", 
      "desc": "Kue sifon yang sangat lembut dengan balutan krim vanila dan buah stroberi segar di atasnya.",
      "category": "Kue Tart",
      "image": "https://images.unsplash.com/photo-1464349172961-10442a8a2596?q=80&w=500&auto=format&fit=crop"
    },
    {
      "name": "Matcha Crepe Cake", 
      "price": 32.00, 
      "rating": 4.7, 
      "tag": "Rekomendasi", 
      "desc": "Lapisan crepe tipis legendaris dengan olesan krim teh hijau Jepang asli yang harum.",
      "category": "Kue Tart",
      "image": "https://images.unsplash.com/photo-1536680465769-a36969fdadf7?q=80&w=500&auto=format&fit=crop"
    },

    // --- KATEGORI DONAT ---
    {
      "name": "Hibiscus Glaze Donut", 
      "price": 3.75, 
      "rating": 4.7, 
      "tag": "Populer", 
      "desc": "Donat kentang empuk dengan lapisan gula glaze rasa bunga hibiscus yang manis dan segar.",
      "category": "Donat",
      "image": "https://images.unsplash.com/photo-1551024601-bec78aea704b?q=80&w=500&auto=format&fit=crop"
    },
    {
      "name": "Almond Snow Donut", 
      "price": 4.00, 
      "rating": 4.8, 
      "tag": "Baru", 
      "desc": "Donat donat dengan taburan kacang almond panggang renyah dan taburan gula putih halus.",
      "category": "Donat",
      "image": "https://images.unsplash.com/photo-1612240498936-65f5101365d2?q=80&w=500&auto=format&fit=crop"
    },
    {
      "name": "Choco Caviar Donut", 
      "price": 4.25, 
      "rating": 4.9, 
      "tag": "Terlaris", 
      "desc": "Donat bomboloni isi cokelat lumer padat dengan toping bola-bola cokelat renyah di atasnya.",
      "category": "Donat",
      "image": "https://images.unsplash.com/photo-1514517604298-cf80e0fb7f1e?q=80&w=500&auto=format&fit=crop"
    },

    // --- KATEGORI CROISSANT ---
    {
      "name": "Butter Croissant", 
      "price": 4.50, 
      "rating": 4.8, 
      "tag": "Segar dari Oven", 
      "desc": "Roti croissant klasik Perancis yang super renyah di luar namun sangat lembut di dalam.",
      "category": "Croissant",
      "image": "https://images.unsplash.com/photo-1555507036-ab1f4038808a?q=80&w=500&auto=format&fit=crop"
    },
    {
      "name": "Almond Croissant", 
      "price": 5.50, 
      "rating": 4.9, 
      "tag": "Rekomendasi", 
      "desc": "Croissant gurih yang diisi dengan krim almond manis melimpah dan taburan irisan almond.",
      "category": "Croissant",
      "image": "https://images.unsplash.com/photo-1626027170564-92eb5f46487e?q=80&w=500&auto=format&fit=crop"
    },
  ];

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> filteredMenu = _selectedCategory == "Semua"
        ? menuBakery
        : menuBakery.where((item) => item['category'] == _selectedCategory).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFFBF8F4),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Toko
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text("MStore Bakery", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF3E2723))),
                      SizedBox(height: 2),
                      Text("Dipanggang Segar Setiap Pagi", style: TextStyle(color: Color(0xFF8D6E63), fontSize: 11)),
                    ],
                  ),
                  const CircleAvatar(
                    backgroundColor: Color(0xFF8D6E63),
                    radius: 18,
                    child: Icon(Icons.person_rounded, color: Colors.white, size: 20),
                  )
                ],
              ),
              const SizedBox(height: 16),

              // Filter Kategori Bahasa Indonesia
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildCategoryChip("Semua"),
                    _buildCategoryChip("Kue Tart"),
                    _buildCategoryChip("Donat"),
                    _buildCategoryChip("Croissant"),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Grid List Menu
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredMenu.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.76, 
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemBuilder: (context, index) {
                  final produk = filteredMenu[index];
                  return GestureDetector(
                    onTap: () {
                      // Berpindah ke detail dan mengirim data produk
                      Navigator.push(context, MaterialPageRoute(builder: (context) => DetailScreen(product: produk)));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.all(6),
                              width: double.infinity,
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(14)),
                              child: Image.network(
                                produk['image'],
                                fit: BoxFit.cover,
                                errorBuilder: (context, err, stack) => const Center(child: Icon(Icons.bakery_dining_rounded, size: 40, color: Color(0xFF8D6E63))),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(produk['name'], maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF3E2723))),
                                const SizedBox(height: 2),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("\$${produk['price'].toStringAsFixed(2)}", style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF8D6E63), fontSize: 13)),
                                    Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: const BoxDecoration(color: Color(0xFF3E2723), shape: BoxShape.circle),
                                      child: const Icon(Icons.add_rounded, size: 14, color: Colors.white),
                                    )
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String label) {
    bool isSelected = _selectedCategory == label;
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        selectedColor: const Color(0xFF8D6E63),
        backgroundColor: const Color(0xFFF5F0EA),
        labelStyle: TextStyle(color: isSelected ? Colors.white : const Color(0xFF5D4037), fontWeight: FontWeight.bold, fontSize: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        onSelected: (val) {
          setState(() {
            _selectedCategory = label;
          });
        },
      ),
    );
  }
}