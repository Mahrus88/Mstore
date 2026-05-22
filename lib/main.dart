import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart'; // Memanggil package bingkai HP
import 'splash_screen.dart';

void main() {
  runApp(
    // Membungkus aplikasi dengan DevicePreview agar muncul bingkai HP di Chrome
    DevicePreview(
      enabled: true, // Biarkan true agar bingkai selalu muncul saat run di Chrome
      builder: (context) => const MyApp(), 
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MStore Bakery',
      debugShowCheckedModeBanner: false,
      // Konfigurasi wajib agar DevicePreview bisa mengatur layar di Chrome
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFFDFBF7),
        fontFamily: 'Sans-Serif',
      ),
      home: const SplashScreen(),
    );
  }
}