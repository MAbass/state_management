import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:state_management/providers/OrderItem.dart';
import 'package:state_management/widgets/OrderItemWidget.dart';

class OrderScreen extends StatefulWidget {
  static final String routeName = "/order";

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  Future _future;

  Future _obtainsFuture() {
    return Provider.of<Orders>(context, listen: false).fetchAllOrders();
  }

  @override
  void initState() {
    _future = _obtainsFuture();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Order"),
      ),
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
              child: Text("An error is occured"),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return Consumer<Orders>(
              builder: (ctx, orderData, child) {
                return ListView.builder(
                    itemCount: orderData.orders.length,
                    itemBuilder: (ctx, index) {
                      print((orderData.orders[index]));
                      return OrderItemWidget((orderData.orders[index]));
                    });
              },
            );
          }
          return Center(
            child: Text("An error is encountered!!"),
          );
        },
      ),
    );
  }
}
