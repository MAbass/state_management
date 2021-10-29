import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:state_management/providers/Cart.dart';

class CartItemWidget extends StatelessWidget {
  String productId = "";
  String id = "";
  String title = "";
  double price = 0.0;
  int quantity = 0;

  CartItemWidget(
      String productId, String id, String title, double price, int quantity) {
    this.productId = productId;
    this.id = id;
    this.title = title;
    this.price = price;
    this.quantity = quantity;
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      confirmDismiss: (direction) {
        return showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                title: Text("Are you sure?"),
                content: Text("Do you sure to remove the item to your cart?"),
                actions: [
                  FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                      child: Text("No")),
                  FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                      child: Text("Yes")),
                ],
              );
            });
      },
      key: ValueKey(this.id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          size: 40,
          color: Colors.white,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 30),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(productId);
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: FittedBox(child: Text("${this.price}")),
              ),
            ),
            title: Text(title),
            subtitle: Text("Total:${(price * quantity).toStringAsFixed(3)}"),
            trailing: Text("${quantity}x"),
          ),
        ),
      ),
    );
  }
}
