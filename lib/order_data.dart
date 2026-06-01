// lib/order_data.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class OrderItem {
  final String name;
  final int quantity;
  final double price;

  OrderItem({
    required this.name,
    required this.quantity,
    required this.price,
  });

  double get subtotal => price * quantity;

  Map<String, dynamic> toJson() => {
        'name': name,
        'quantity': quantity,
        'price': price,
      };

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
        name: json['name'],
        quantity: json['quantity'],
        price: json['price'].toDouble(),
      );
}

class OrderModel {
  final String invoiceNumber;
  final String tanggal;
  final String waktu;
  final String alamat;
  final String metodePembayaran;
  final List<OrderItem> items;
  final double totalHarga;
  final double ongkir;
  String status;

  OrderModel({
    required this.invoiceNumber,
    required this.tanggal,
    required this.waktu,
    required this.alamat,
    required this.metodePembayaran,
    required this.items,
    required this.totalHarga,
    required this.ongkir,
    this.status = "Diproses",
  });

  double get totalBayar => totalHarga + ongkir;

  Map<String, dynamic> toJson() => {
        'invoiceNumber': invoiceNumber,
        'tanggal': tanggal,
        'waktu': waktu,
        'alamat': alamat,
        'metodePembayaran': metodePembayaran,
        'items': items.map((e) => e.toJson()).toList(),
        'totalHarga': totalHarga,
        'ongkir': ongkir,
        'status': status,
      };

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
        invoiceNumber: json['invoiceNumber'],
        tanggal: json['tanggal'],
        waktu: json['waktu'],
        alamat: json['alamat'],
        metodePembayaran: json['metodePembayaran'],
        items: (json['items'] as List)
            .map((e) => OrderItem.fromJson(e))
            .toList(),
        totalHarga: json['totalHarga'].toDouble(),
        ongkir: json['ongkir'].toDouble(),
        status: json['status'],
      );
}

class OrderData {
  static List<OrderModel> daftarPesanan = [];

  static Future<void> muatPesanan() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString('daftar_pesanan');
    if (data != null) {
      final List decoded = jsonDecode(data);
      daftarPesanan =
          decoded.map((e) => OrderModel.fromJson(e)).toList();
    }
  }

  static Future<void> simpanPesanan() async {
    final prefs = await SharedPreferences.getInstance();
    final String data =
        jsonEncode(daftarPesanan.map((e) => e.toJson()).toList());
    await prefs.setString('daftar_pesanan', data);
  }

  static Future<void> tambahPesanan(OrderModel order) async {
    daftarPesanan.insert(0, order); // Pesanan terbaru di atas
    await simpanPesanan();
  }
}