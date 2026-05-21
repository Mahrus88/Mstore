import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart'; // Memastikan package device_preview diimport
import 'login_screen.dart';

void main() {
  runApp(
    DevicePreview(
      enabled: !kReleaseMode, // Mengaktifkan device preview di mode debug
      builder: (context) => const MyApp(), // Membungkus aplikasi utama Anda
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MStore Bakery',
      useInheritedMediaQuery: true, // Diperlukan agar Device Preview sinkron
      locale: DevicePreview.locale(context), // Mengatur locale dari Device Preview
      builder: DevicePreview.appBuilder, // Mengatur builder dari Device Preview
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      home: const LoginScreen(),
    );
  }
}