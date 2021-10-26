import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:state_management/providers/Products.dart';
import 'package:state_management/screens/HomePage.dart';
import 'package:state_management/widgets/ProductDetailWidget.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) {
        return Products();
      },
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primaryColor: Colors.purple,
          accentColor: Colors.deepOrange,
          primarySwatch: Colors.blue,
        ),
        // home: HomePage(),
        routes: {
          "/": (ctx) => HomePage(),
          ProductDetailWidget.routeName: (ctx) => ProductDetailWidget(),
        },
      ),
    );
  }
}
