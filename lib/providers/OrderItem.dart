import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:random_string/random_string.dart';
import 'package:state_management/providers/Cart.dart';
import 'package:http/http.dart' as http;

import 'User.dart';

class OrderItem {
  String id;

  double amount;
  List<CartItem> products = [];

  DateTime dateTime;
  Auth auth;

  OrderItem(String id, double amount, List<CartItem> products) {
    this.id = id;
    this.amount = amount;
    this.products = products;
  }

  String toString() {
    List<String> productToString = [];
    for (CartItem cartItem in products) {
      productToString.add("{${cartItem.toString()}}");
    }
    return "Id:${this.id}, amount: ${this.amount} and products:${productToString}";
  }
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  Auth auth;

  Orders(this.auth);

  List<OrderItem> get orders {
    return _orders;
  }

  Future<void> fetchAllOrders() async {
    _orders = [];
    // print("Size of _orders:${_orders.length}");
    var url = Uri.parse(
        "https://flutter-test-e953f-default-rtdb.firebaseio.com/orders.json?auth=${auth.token}");

    final listOfOrders = await http.get(url);
    final result = json.decode(listOfOrders.body) as Map<String, dynamic>;
    // print(result);
    List<CartItem> cartItemList = [];
    result.forEach((key, value) {
      final orderItem = value as Map<String, dynamic>;
      final listProduct = orderItem['products'] as List<dynamic>;
      // print("List product: ${listProduct}");
      listProduct.forEach((cart) {
        cartItemList.add(CartItem(
            cart['id'], cart['title'], cart['quantity'], cart['price']));
      });
      print("Cart item list: ${cartItemList}");

      _orders.add(OrderItem(key, orderItem['amount'], cartItemList));
      // print(_orders);
      notifyListeners();
    });
  }

  Future<void> addOrder(List<CartItem> cartItems, double total) async {
    var url = Uri.parse(
        "https://flutter-test-e953f-default-rtdb.firebaseio.com/orders.json?auth=${auth.token}");
    await http
        .post(url,
            body: json.encode({
              "amount": total,
              "dateTime": DateTime.now().toIso8601String(),
              "products": cartItems
                  .map((cart) => {
                        "id": cart.id,
                        "title": cart.title,
                        "price": cart.price,
                        "quantity": cart.quantity,
                      })
                  .toList()
            }))
        .then((value) {
      _orders.insert(0, OrderItem(randomString(8), total, cartItems));
      notifyListeners();
    });
  }
}
