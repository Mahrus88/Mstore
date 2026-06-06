// lib/favorit_screen.dart
import 'package:flutter/material.dart';
import 'favorite_data.dart';
import 'utils.dart';
import 'detail_screen.dart';
import 'cart_data.dart';
import 'image_helper.dart';

class FavoritScreen extends StatefulWidget {
  const FavoritScreen({super.key});

  @override
  State<FavoritScreen> createState() => _FavoritScreenState();
}

class _FavoritScreenState extends State<FavoritScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _muatFavorit();
  }

  Future<void> _muatFavorit() async {
    await FavoriteData.muatFavorit();
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFBF7),
      appBar: AppBar(
        title: const Text("Favorit Saya",
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF8D6E63),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                  color: Color(0xFF8D6E63)))
          : FavoriteData.favorites.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.favorite_border_rounded,
                          size: 80, color: Color(0xFFBCAAA4)),
                      SizedBox(height: 16),
                      Text("Belum ada produk favorit",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF5D4037))),
                      SizedBox(height: 6),
                      Text(
                          "Tap ikon ❤️ di produk untuk menambahkan ke favorit",
                          style: TextStyle(
                              fontSize: 12, color: Colors.black45)),
                    ],
                  ),
                )
              : GridView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: FavoriteData.favorites.length,
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemBuilder: (context, index) {
                    final produk = FavoriteData.favorites[index];
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
                                  child: buildGambarProduk(
                                    path: produk['image'],
                                    height: 130,
                                    width: double.infinity,
                                  ),
                                ),
                                Positioned(
                                  top: 10,
                                  right: 10,
                                  child: GestureDetector(
                                    onTap: () async {
                                      await FavoriteData.toggleFavorit(
                                          produk);
                                      setState(() {});
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              "${produk['name']} dihapus dari favorit"),
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
                                      padding: const EdgeInsets.all(6),
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
                                      child: const Icon(
                                          Icons.favorite_rounded,
                                          size: 16,
                                          color: Colors.red),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10, right: 10, bottom: 10),
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 8),
                                  Text(produk['name'],
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                          color: Color(0xFF3E2723))),
                                  const SizedBox(height: 2),
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
                                  const SizedBox(height: 4),
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
    );
  }
}