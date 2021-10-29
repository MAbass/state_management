import 'package:flutter/cupertino.dart';
import 'package:random_string/random_string.dart';
import 'package:state_management/providers/Cart.dart';

class OrderItem {
  String id = "";
  double amount = 0.0;
  List<CartItem> products = [];
  DateTime dateTime = DateTime.now();

  OrderItem(String id, double amount, List<CartItem> products) {
    this.id = id;
    this.amount = amount;
    this.products = products;
  }
}

class Orders with ChangeNotifier{
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return _orders;
  }

  void addOrder(List<CartItem> cartItems, double total) {
    _orders.insert(0, OrderItem(randomString(8), total, cartItems));
    notifyListeners();
  }
}
