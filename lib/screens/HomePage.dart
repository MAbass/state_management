import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:state_management/providers/Cart.dart';
import 'package:state_management/providers/Products.dart';
import 'package:state_management/screens/CartScreen.dart';
import 'package:state_management/widgets/Badge.dart';
import 'package:state_management/widgets/Drawer.dart';
import 'package:state_management/widgets/ProductWidget.dart';

enum FiltersOptions { Favorites, All }

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future _future;

  Future _obtainsFuture() {
    return Provider.of<Products>(context, listen: false).fetchAllProducts();
  }

  @override
  void initState() {
    _future = _obtainsFuture();
    /* Future.delayed(Duration.zero).then((_) {
      Provider.of<Products>(context).fetchAllProducts();
    });*/
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<Products>(context);
    var listProducts = productProvider.items;
    return Scaffold(
        appBar: AppBar(
          title: Text("Shop"),
          actions: [
            PopupMenuButton(
                onSelected: (FiltersOptions selectedValue) {
                  if (selectedValue == FiltersOptions.All) {
                    productProvider.showAll();
                  } else {
                    productProvider.showFavorites();
                  }
                },
                icon: Icon(Icons.more_vert),
                itemBuilder: (_) => [
                      PopupMenuItem(
                        child: Text("Only Favorites"),
                        value: FiltersOptions.Favorites,
                      ),
                      PopupMenuItem(
                        child: Text("Show all"),
                        value: FiltersOptions.All,
                      ),
                    ]),
            Consumer<Cart>(
              builder: (BuildContext context, cart, Widget childwidget) {
                return BadgeWidget(
                    childwidget, cart.itemCount.toString(), Colors.red);
              },
              child: IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.pushNamed(context, CartScreen.routeName);
                },
              ),
            )
          ],
        ),
        drawer: AppDrawer(),
        body: FutureBuilder(
          future: _future,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.error != null) {
              return Center(
                child: Text("An error is occured here"),
              );
            }
            if (snapshot.connectionState == ConnectionState.done) {
              return GridView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: listProducts.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 3 / 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10),
                  itemBuilder: (ctx, index) {
                    return ChangeNotifierProvider.value(
                      value: listProducts[index],
                      child: ProductItemWidget(),
                    );
                  });
            }
            return Center(
              child: Text("An error is occured"),
            );
          },
        ));
  }
}
