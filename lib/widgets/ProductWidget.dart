import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:state_management/providers/Product.dart';
import 'package:state_management/widgets/ProductDetailWidget.dart';

class ProductWidget extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  ProductWidget(this.id, this.title, this.imageUrl);

  void _changePage(BuildContext context) {
    Navigator.pushNamed(context, ProductDetailWidget.routeName,
        arguments: {"id": id});
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _changePage(context);
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: GridTile(
          child: Image.network(
            this.imageUrl,
            fit: BoxFit.cover,
          ),
          footer: GridTileBar(
            leading: IconButton(
              color: Theme.of(context).accentColor,
              icon: Icon(Icons.favorite),
              onPressed: () {},
            ),
            backgroundColor: Colors.black87,
            title: Text(
              this.title,
              textAlign: TextAlign.center,
            ),
            trailing: IconButton(
              color: Theme.of(context).accentColor,
              icon: Icon(Icons.shopping_cart),
              onPressed: () {},
            ),
          ),
        ),
      ),
    );
  }
}
