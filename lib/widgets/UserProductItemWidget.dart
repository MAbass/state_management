import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:state_management/providers/Products.dart';
import 'package:state_management/screens/EditProductScreen.dart';

class UserProductItem extends StatelessWidget {
  String title;
  String imageUrl;
  String description;
  String id;
  double price;

  UserProductItem(
      this.id, this.title, this.imageUrl, this.price, this.description);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, EditProductScreen.routeName,
                      arguments: {
                        "id": id,
                        "title": title,
                        "imageUrl": imageUrl,
                        "price": price,
                        "description": description,
                      });
                },
                icon: Icon(
                  Icons.edit,
                  color: Colors.green,
                )),
            IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (ctx) {
                        return AlertDialog(
                          title: Text("Are you sure?"),
                          content: Text("Do you sure to remove the product?"),
                          actions: [
                            FlatButton(
                                onPressed: () {
                                  Navigator.of(context).pop(false);
                                },
                                child: Text("No")),
                            FlatButton(
                                onPressed: () {
                                  Navigator.of(context).pop(true);
                                  Provider.of<Products>(context, listen: false)
                                      .deleteProduct(id);
                                },
                                child: Text("Yes")),
                          ],
                        );
                      });
                },
                icon: Icon(
                  Icons.delete,
                  color: Colors.red,
                )),
          ],
        ),
      ),
    );
  }
}
