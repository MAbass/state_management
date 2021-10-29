import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:state_management/providers/Product.dart';
import 'package:state_management/providers/Products.dart';

class ProductItemDetailWidget extends StatelessWidget {
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
      body: Column(
        children: [
          Container(
            height: 300,
            width: double.infinity,
            child: Image.network(
              product.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            width: 350,
            height: 50,
            child: FittedBox(
              child: Text(
                "${product.description}",
                style: TextStyle(fontSize: 20),
                softWrap: true,
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "\$${product.price}",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
          ),
        ],
      ),
    );
  }
}
