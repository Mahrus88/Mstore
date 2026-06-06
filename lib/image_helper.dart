// lib/image_helper.dart
import 'package:flutter/material.dart';

Widget buildGambarProduk({
  required String path,
  double? width,
  double? height,
  BoxFit fit = BoxFit.cover,
}) {
  if (path.startsWith('assets/')) {
    return Image.asset(
      path,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (ctx, err, stack) => Container(
        width: width,
        height: height,
        color: const Color(0xFFF5F0EA),
        child: const Center(
          child: Icon(Icons.bakery_dining_rounded,
              size: 30, color: Color(0xFF8D6E63)),
        ),
      ),
    );
  } else if (path.isNotEmpty) {
    return Image.network(
      path,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (ctx, err, stack) => Container(
        width: width,
        height: height,
        color: const Color(0xFFF5F0EA),
        child: const Center(
          child: Icon(Icons.bakery_dining_rounded,
              size: 30, color: Color(0xFF8D6E63)),
        ),
      ),
    );
  } else {
    return Container(
      width: width,
      height: height,
      color: const Color(0xFFF5F0EA),
      child: const Center(
        child: Icon(Icons.bakery_dining_rounded,
            size: 30, color: Color(0xFF8D6E63)),
      ),
    );
  }
}