import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:state_management/providers/Product.dart';
import 'package:state_management/providers/Products.dart';

class ProductDetailWidget extends StatelessWidget {
  static final String routeName = '/product-detail';

  @override
  Widget build(BuildContext context) {
    final argumentPassed = ModalRoute.of(context)!.settings.arguments as Map;
    final productProvider = Provider.of<Products>(context, listen: false);
    final Product product = productProvider.findById(argumentPassed['id']);
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
      ),
      body: Center(
        child: Text("Inside the product detail"),
      ),
    );
  }
}
