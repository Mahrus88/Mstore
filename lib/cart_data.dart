// lib/cart_data.dart
import 'package:flutter/foundation.dart';

class CartItem {
  final String name;
  final double price;
  final String image;
  int quantity;

  CartItem({
    required this.name,
    required this.price,
    required this.image,
    this.quantity = 1,
  });

  double get subtotal => price * quantity;
}

class CartData extends ChangeNotifier {
  static final CartData _instance = CartData._internal();
  factory CartData() => _instance;
  CartData._internal();

  static final List<CartItem> items = [];

  static void tambahItem(String name, double price, String image) {
    final index = items.indexWhere((e) => e.name == name);
    if (index != -1) {
      items[index].quantity++;
    } else {
      items.add(CartItem(name: name, price: price, image: image));
    }
    _instance.notifyListeners();
  }

  static void hapusItem(int index) {
    items.removeAt(index);
    _instance.notifyListeners();
  }

  static void tambahQty(int index) {
    items[index].quantity++;
    _instance.notifyListeners();
  }

  static void kurangQty(int index) {
    if (items[index].quantity > 1) {
      items[index].quantity--;
    } else {
      items.removeAt(index);
    }
    _instance.notifyListeners();
  }

  static double get totalHarga =>
      items.fold(0, (sum, item) => sum + item.subtotal);

  static int get totalItem =>
      items.fold(0, (sum, item) => sum + item.quantity);

  static void kosongkan() {
    items.clear();
    _instance.notifyListeners();
  }
}