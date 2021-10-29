import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:state_management/providers/Cart.dart';
import 'package:state_management/providers/OrderItem.dart';
import 'package:state_management/widgets/CartItemWidget.dart';
import 'package:state_management/widgets/Drawer.dart';

class CartScreen extends StatelessWidget {
  static final String routeName = "/badge";

  @override
  Widget build(BuildContext context) {
    final Cart cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Cart"),
      ),
      drawer: AppDrawer(),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(12),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    child: Row(
                      children: [
                        Chip(
                          label: Text("${cart.totalAmount}"),
                          backgroundColor: Theme.of(context).primaryColor,
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        FlatButton(
                          onPressed: () {
                            Provider.of<Orders>(context, listen: false)
                                .addOrder(cart.items.values.toList(),
                                    cart.totalAmount);
                            cart.clear();
                          },
                          child: Text("ORDER NOW"),
                          color: Theme.of(context).primaryColor,
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
              child: ListView.builder(
                  itemCount: cart.itemCount,
                  itemBuilder: (ctx, index) {
                    return CartItemWidget(
                        cart.items.keys.elementAt(index),
                        cart.items.values.elementAt(index).id,
                        cart.items.values.elementAt(index).title,
                        cart.items.values.elementAt(index).price,
                        cart.items.values.elementAt(index).quantity);
                  }))
        ],
      ),
    );
  }
}
