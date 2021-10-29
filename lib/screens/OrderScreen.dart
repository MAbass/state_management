import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:state_management/providers/OrderItem.dart';
import 'package:state_management/widgets/OrderItemWidget.dart';

class OrderScreen extends StatelessWidget {
  static final String routeName = "/order";

  @override
  Widget build(BuildContext context) {
    Orders orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Order"),
      ),
      body: ListView.builder(
          itemCount: orderData.orders.length,
          itemBuilder: (ctx, index) {
            return OrderItemWidget((orderData.orders[index]));
          }),
    );
  }
}
