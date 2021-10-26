import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:state_management/providers/Product.dart';
import 'package:state_management/providers/Products.dart';
import 'package:state_management/widgets/ProductWidget.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<Products>(context);
    final listProducts = productProvider.items;
    return Scaffold(
      appBar: AppBar(
        title: Text("Shop"),
      ),
      body: GridView.builder(
          padding: const EdgeInsets.all(10),
          itemCount: listProducts.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3 / 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10),
          itemBuilder: (ctx, index) {
            return ProductWidget(listProducts[index].id,
                listProducts[index].title, listProducts[index].imageUrl);
          }),
    );
  }
}
