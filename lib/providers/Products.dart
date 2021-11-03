import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:state_management/providers/User.dart';

import './Product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    /*Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),*/
  ];

  final Auth auth;

  Products(this.auth);

  bool _selectedFavorites = false;

  List<Product> get items {
    if (_selectedFavorites == true) {
      return _items.where((element) => element.isFavorite).toList();
    }
    return _items;
  }

  void showFavorites() {
    _selectedFavorites = true;
    notifyListeners();
  }

  void showAll() {
    _selectedFavorites = false;
    notifyListeners();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> fetchAllProducts() async {
    var url = Uri.parse(
        "https://flutter-test-e953f-default-rtdb.firebaseio.com/products.json?auth=${auth.token}");
    try {
      // print("Auth token: ${auth.token}");
      final response = await http.get(url);
      final data = json.decode(response.body) as Map<String, dynamic>;
      List<Product> listProducts = [];
      // print(data);
      data.forEach((key, value) {
        listProducts.add(Product(
            id: key,
            title: value['title'],
            description: value['description'],
            price: value['price'],
            imageUrl: value['imageUrl'],
            isFavorite: value['isFavorite']));
      });
      _items = listProducts;
      // print(_items);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> addProduct(Product product) async {
    var url = Uri.parse(
        "https://flutter-test-e953f-default-rtdb.firebaseio.com/products.json?auth=${auth.token}");
    try {
      await http
          .post(url,
              body: json.encode({
                "title": product.title,
                "description": product.description,
                "price": product.price,
                "imageUrl": product.imageUrl,
                "isFavorite": false,
              }))
          .then((value) {
        print("Value: ${value.body}");
        final producToAdd = new Product(
            id: json.decode(value.body)['name'],
            title: product.title,
            description: product.description,
            price: product.price,
            imageUrl: product.imageUrl);
        print("Product adding: ${producToAdd.toString()}");
        _items.add(producToAdd);
        notifyListeners();
      });
    } catch (error) {
      print("Error: ${error}");
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product productChange) async {
    var url = Uri.parse(
        "https://flutter-test-e953f-default-rtdb.firebaseio.com/products/$id.json?auth=${auth.token}");

    int productIndex = _items.indexWhere((prod) => prod.id == id);
    if (productIndex >= 0) {
      await http.patch(url,
          body: json.encode({
            "title": productChange.title,
            "description": productChange.description,
            "price": productChange.price,
            "imageUrl": productChange.imageUrl,
          }));
      print("Product: ${_items[productIndex].toString()}");
      _items[productIndex] = productChange;
    }
    notifyListeners();
  }

  void deleteProduct(String id) {
    final product = _items.firstWhere((prod) => prod.id == id);
    print("Id: ${id}");
    var url = Uri.parse(
        "https://flutter-test-e953f-default-rtdb.firebaseio.com/products/$id.json?auth=${auth.token}");
    http.delete(url).then((_) {
      print("Deleting a product");
      _items.removeWhere((prod) => prod.id == product.id);
      notifyListeners();
    }).catchError((error) {
      print(error);
    });
  }
}
