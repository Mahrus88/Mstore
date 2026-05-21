import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Menu"),
        backgroundColor: const Color(0xFF8D6E63),
      ),
      body: const Center(
        child: Text("Halaman Detail Roti & Kue MStore"),
      ),
    );
  }
}