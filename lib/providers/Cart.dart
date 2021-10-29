import 'package:flutter/cupertino.dart';
import 'package:random_string/random_string.dart';

class CartItem {
  String id = "";
  String title = "";
  int quantity = 0;
  double price = 0.0;

  CartItem(String id, String title, int quantity, double price) {
    this.id = id;
    this.title = title;
    this.quantity = quantity;
    this.price = price;
  }
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = new Map();

  Map<String, CartItem> get items {
    return _items;
  }

  int get itemCount {
    return _items == null ? 0 : _items.length;
  }

  double get totalAmount {
    double total = 0.0;
    _items.forEach((key, value) {
      total += value.price * value.quantity;
    });
    return total;
  }

  void addCartToItem(
      String productId, String title, int quantity, double price) {
    int lastQuantity = 1;
    if (_items.containsKey(productId)) {
      lastQuantity = _items[productId]!.quantity;
      _items.update(productId,
          (value) => CartItem(value.id, title, lastQuantity + quantity, price));
    } else {
      _items.putIfAbsent(productId,
          () => CartItem(randomString(8).toString(), title, quantity, price));
    }
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId]!.quantity > 1) {
      _items.update(
          productId,
          (existingCartItem) => CartItem(
              existingCartItem.id,
              existingCartItem.title,
              existingCartItem.quantity - 1,
              existingCartItem.price));
    }
    if (_items[productId]!.quantity == 1) {
      _items.remove(productId);
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    this._items.remove(productId);
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}