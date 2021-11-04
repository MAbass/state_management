import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product(
      {@required this.id,
      @required this.title,
      @required this.description,
      @required this.price,
      @required this.imageUrl,
      this.isFavorite = false});

  Future<void> toggleFavoriteStatus(String authToken, String userId) async {
    var url = Uri.parse(
        "https://flutter-test-e953f-default-rtdb.firebaseio.com/userProducts/$userId/$id.json?auth=${authToken}");
    await http.put(url, body: json.encode(isFavorite)).then((value) {
      this.isFavorite = !isFavorite;
    });
    notifyListeners();
  }

  @override
  String toString() {
    return 'Product{id: $id, title: $title, description: $description, price: $price, imageUrl: $imageUrl, isFavorite: $isFavorite}';
  }
}
