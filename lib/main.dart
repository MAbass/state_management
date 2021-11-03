import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:state_management/providers/Cart.dart';
import 'package:state_management/providers/OrderItem.dart';
import 'package:state_management/providers/Products.dart';
import 'package:state_management/providers/User.dart';
import 'package:state_management/screens/CartScreen.dart';
import 'package:state_management/screens/EditProductScreen.dart';
import 'package:state_management/screens/HomePage.dart';
import 'package:state_management/screens/OrderScreen.dart';
import 'package:state_management/screens/UserProduct.dart';
import 'package:state_management/screens/auth_screen.dart';
import 'package:state_management/widgets/ProductDetailWidget.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Auth()),
        ChangeNotifierProxyProvider<Auth, Orders>(
          update: (BuildContext context, Auth auth, orders) {
            return Orders(auth);
          },
          create: (BuildContext context) {
            return Orders(Provider.of<Auth>(context, listen: false));
          },
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          update: (BuildContext context, Auth auth, previous) {
            return Products(auth);
          },
          create: (BuildContext context) {
            return Products(Provider.of<Auth>(context, listen: false));
          },
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) {
            return Cart();
          },
        )
      ],
      child: Consumer<Auth>(builder: (ctx, auth, _) {
        print(auth.isAuth);
        return MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primaryColor: Colors.deepPurpleAccent,
            accentColor: Colors.deepOrange,
            primarySwatch: Colors.blue,
          ),
          home: auth.isAuth ? HomePage() : AuthScreen(),
          routes: {
            // "/": (ctx) => auth.isAuth ? HomePage() : AuthScreen(),
            ProductItemDetailWidget.routeName: (ctx) =>
                ProductItemDetailWidget(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrderScreen.routeName: (ctx) => OrderScreen(),
            UserProductScreen.routeName: (ctx) => UserProductScreen(),
            EditProductScreen.routeName: (ctx) => EditProductScreen(),
          },
        );
      }),
    );
  }
}
