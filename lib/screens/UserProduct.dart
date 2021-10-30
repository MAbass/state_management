import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:state_management/providers/Products.dart';
import 'package:state_management/screens/EditProductScreen.dart';
import 'package:state_management/widgets/Drawer.dart';
import 'package:state_management/widgets/UserProductItemWidget.dart';

class UserProductScreen extends StatelessWidget {
  static final String routeName = "/user-product";

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Your products"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, EditProductScreen.routeName);
              },
              icon: Icon(Icons.add))
        ],
      ),
      drawer: AppDrawer(),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: ListView.builder(
            itemCount: productsData.items.length,
            itemBuilder: (ctx, index) {
              return UserProductItem(
                  productsData.items[index].id,
                  productsData.items[index].title,
                  productsData.items[index].imageUrl,
                  productsData.items[index].price,
                  productsData.items[index].description
              );
            }),
      ),
    );
  }
}
