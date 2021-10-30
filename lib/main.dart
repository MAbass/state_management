import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:state_management/providers/Cart.dart';
import 'package:state_management/providers/OrderItem.dart';
import 'package:state_management/providers/Products.dart';
import 'package:state_management/screens/CartScreen.dart';
import 'package:state_management/screens/EditProductScreen.dart';
import 'package:state_management/screens/HomePage.dart';
import 'package:state_management/screens/OrderScreen.dart';
import 'package:state_management/screens/UserProduct.dart';
import 'package:state_management/widgets/ProductDetailWidget.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (BuildContext context) {
            return Orders();
          },
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) {
            return Products();
          },
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) {
            return Cart();
          },
        )
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primaryColor: Colors.deepPurpleAccent,
          accentColor: Colors.deepOrange,
          primarySwatch: Colors.blue,
        ),
        // home: HomePage(),
        routes: {
          "/": (ctx) => HomePage(),
          ProductItemDetailWidget.routeName: (ctx) => ProductItemDetailWidget(),
          CartScreen.routeName: (ctx) => CartScreen(),
          OrderScreen.routeName: (ctx) => OrderScreen(),
          UserProductScreen.routeName: (ctx) => UserProductScreen(),
          EditProductScreen.routeName: (ctx) => EditProductScreen(),
        },
      ),
    );
  }
}
