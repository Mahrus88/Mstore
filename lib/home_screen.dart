// lib/home_screen.dart
import 'package:flutter/material.dart';
import 'detail_screen.dart';
import 'cart_data.dart';
import 'favorite_data.dart';
import 'product_data.dart';
import 'utils.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedCategory = "Semua";
  String _searchQuery = "";
  final _searchController = TextEditingController();
  final List<Map<String, dynamic>> menuBakery = ProductData.menuBakery;

  List<Map<String, dynamic>> get filteredMenu {
    List<Map<String, dynamic>> hasil = _selectedCategory == "Semua"
        ? menuBakery
        : menuBakery
            .where((item) => item['category'] == _selectedCategory)
            .toList();
    if (_searchQuery.isNotEmpty) {
      hasil = hasil
          .where((item) => item['name']
              .toString()
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()))
          .toList();
    }
    return hasil;
  }

  @override
  void initState() {
    super.initState();
    FavoriteData.muatFavorit();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ✅ Helper load gambar lokal atau network
  Widget _buildGambar(String path, {double height = 160}) {
    if (path.startsWith('assets/')) {
      return Image.asset(
        path,
        fit: BoxFit.cover,
        height: height,
        width: double.infinity,
        errorBuilder: (ctx, err, stack) => Container(
          height: height,
          color: const Color(0xFFF5F0EA),
          child: const Center(
            child: Icon(Icons.bakery_dining_rounded,
                size: 50, color: Color(0xFF8D6E63)),
          ),
        ),
      );
    } else {
      return Image.network(
        path,
        fit: BoxFit.cover,
        height: height,
        width: double.infinity,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            height: height,
            color: const Color(0xFFF5F0EA),
            child: const Center(
              child: CircularProgressIndicator(
                  color: Color(0xFF8D6E63), strokeWidth: 2),
            ),
          );
        },
        errorBuilder: (ctx, err, stack) => Container(
          height: height,
          color: const Color(0xFFF5F0EA),
          child: const Center(
            child: Icon(Icons.bakery_dining_rounded,
                size: 50, color: Color(0xFF8D6E63)),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBF8F4),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
              horizontal: 16.0, vertical: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("MStore Bakery",
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF3E2723))),
                      SizedBox(height: 2),
                      Text("Dipanggang Segar Setiap Pagi",
                          style: TextStyle(
                              color: Color(0xFF8D6E63), fontSize: 11)),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ProfileScreen()),
                    ),
                    child: const CircleAvatar(
                      backgroundColor: Color(0xFF8D6E63),
                      radius: 20,
                      child: Icon(Icons.person_rounded,
                          color: Colors.white, size: 22),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Search Bar
              TextField(
                controller: _searchController,
                onChanged: (val) => setState(() => _searchQuery = val),
                decoration: InputDecoration(
                  hintText: "Cari produk bakery...",
                  hintStyle: const TextStyle(
                      fontSize: 13, color: Colors.grey),
                  prefixIcon: const Icon(Icons.search_rounded,
                      color: Color(0xFF8D6E63)),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.close_rounded,
                              color: Colors.grey),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _searchQuery = "");
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 0, horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Filter Kategori
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: ["Semua", "Kue Tart", "Donat", "Croissant"]
                      .map((e) => _buildCategoryChip(e))
                      .toList(),
                ),
              ),
              const SizedBox(height: 16),

              if (filteredMenu.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(40.0),
                    child: Column(
                      children: [
                        Icon(Icons.search_off_rounded,
                            size: 60, color: Colors.grey),
                        SizedBox(height: 12),
                        Text("Produk tidak ditemukan",
                            style: TextStyle(
                                color: Colors.grey, fontSize: 14)),
                      ],
                    ),
                  ),
                )
              else
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filteredMenu.length,
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.68,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemBuilder: (context, index) {
                    final produk = filteredMenu[index];
                    final isFavorit =
                        FavoriteData.isFavorit(produk['name']);
                    return GestureDetector(
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  DetailScreen(product: produk)),
                        );
                        setState(() {});
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 8,
                                offset: const Offset(0, 3))
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(18),
                                    topRight: Radius.circular(18),
                                  ),
                                  child: _buildGambar(produk['image'],
                                      height: 160),
                                ),
                                // Badge tag
                                Positioned(
                                  top: 10,
                                  left: 10,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF3E2723),
                                      borderRadius:
                                          BorderRadius.circular(6),
                                    ),
                                    child: Text(produk['tag'],
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 9,
                                            fontWeight:
                                                FontWeight.bold)),
                                  ),
                                ),
                                // Tombol favorit
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: GestureDetector(
                                    onTap: () async {
                                      await FavoriteData.toggleFavorit(
                                          produk);
                                      setState(() {});
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            FavoriteData.isFavorit(
                                                    produk['name'])
                                                ? "${produk['name']} ditambahkan ke favorit!"
                                                : "${produk['name']} dihapus dari favorit",
                                          ),
                                          backgroundColor:
                                              const Color(0xFF8D6E63),
                                          behavior:
                                              SnackBarBehavior.floating,
                                          duration:
                                              const Duration(seconds: 1),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.black
                                                  .withOpacity(0.1),
                                              blurRadius: 4)
                                        ],
                                      ),
                                      child: Icon(
                                        isFavorit
                                            ? Icons.favorite_rounded
                                            : Icons
                                                .favorite_border_rounded,
                                        size: 14,
                                        color: isFavorit
                                            ? Colors.red
                                            : Colors.grey,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(produk['name'],
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                          color: Color(0xFF3E2723))),
                                  const SizedBox(height: 3),
                                  Row(children: [
                                    const Icon(Icons.star_rounded,
                                        color: Colors.amber, size: 12),
                                    const SizedBox(width: 2),
                                    Text(
                                        "${produk['rating']} (${produk['ratingCount']})",
                                        style: const TextStyle(
                                            fontSize: 10,
                                            color: Colors.grey)),
                                  ]),
                                  const SizedBox(height: 6),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                          formatRupiah(produk['price']),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF8D6E63),
                                              fontSize: 12)),
                                      GestureDetector(
                                        onTap: () {
                                          CartData.tambahItem(
                                              produk['name'],
                                              produk['price'],
                                              produk['image']);
                                          setState(() {});
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  "${produk['name']} ditambahkan!"),
                                              backgroundColor:
                                                  const Color(0xFF8D6E63),
                                              behavior: SnackBarBehavior
                                                  .floating,
                                              duration: const Duration(
                                                  seconds: 1),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          padding:
                                              const EdgeInsets.all(5),
                                          decoration: const BoxDecoration(
                                              color: Color(0xFF3E2723),
                                              shape: BoxShape.circle),
                                          child: const Icon(
                                              Icons.add_rounded,
                                              size: 14,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ],
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
        labelStyle: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF5D4037),
            fontWeight: FontWeight.bold,
            fontSize: 12),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)),
        onSelected: (val) =>
            setState(() => _selectedCategory = label),
      ),
    );
  }
}