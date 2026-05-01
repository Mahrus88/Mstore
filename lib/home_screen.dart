import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("MStore Catalog"),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        // Membuat 2 kolom (matriks) sesuai blueprint
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: 6, // Jumlah produk dummy
        itemBuilder: (context, index) {
          return Card(
            elevation: 3,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Placeholder Gambar Produk
                Container(
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                  ),
                  child: const Center(child: Icon(Icons.image, size: 50, color: Colors.blue)),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Nama Produk", style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Text("Rp 150.000", style: TextStyle(color: Colors.blue)),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}