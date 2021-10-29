import 'package:flutter/material.dart';

class UserProductItem extends StatelessWidget {
  String title;
  String imageUrl;

  UserProductItem(this.title, this.imageUrl);

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
            IconButton(onPressed: () {}, icon: Icon(Icons.edit, color: Colors.green,)),
            IconButton(onPressed: () {}, icon: Icon(Icons.delete, color: Colors.red,)),
          ],
        ),
      ),
    );
  }
}
