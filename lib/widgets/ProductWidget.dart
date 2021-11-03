import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:state_management/providers/Cart.dart';
import 'package:state_management/providers/Product.dart';
import 'package:state_management/providers/User.dart';
import 'package:state_management/widgets/ProductDetailWidget.dart';

class ProductItemWidget extends StatefulWidget {
  @override
  State<ProductItemWidget> createState() => _ProductItemWidgetState();
}

class _ProductItemWidgetState extends State<ProductItemWidget> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final Product product = Provider.of<Product>(context);
    void _changePage(BuildContext context) {
      Navigator.pushNamed(context, ProductItemDetailWidget.routeName,
          arguments: {"id": product.id});
    }

    final Cart cart = Provider.of<Cart>(context);
    // print(product.toString());
    final auth = Provider.of<Auth>(context, listen: false);
    return InkWell(
      onTap: () {
        _changePage(context);
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: GridTile(
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
          footer: GridTileBar(
            leading: isLoading
                ? Transform.scale(
                    scale: 0.5,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.0,
                      color: Theme.of(context).accentColor,
                    ),
                  )
                : IconButton(
                    color: Theme.of(context).accentColor,
                    icon: Icon(product.isFavorite
                        ? Icons.favorite
                        : Icons.favorite_border),
                    onPressed: () async {
                      setState(() {
                        isLoading = true;
                      });
                      await product.toggleFavoriteStatus(
                          auth.token, auth.userId);
                      setState(() {
                        isLoading = false;
                      });
                    },
                  ),
            backgroundColor: Colors.black87,
            title: Text(
              product.title,
              textAlign: TextAlign.center,
            ),
            trailing: IconButton(
              color: Theme.of(context).accentColor,
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                // print(product.id);
                cart.addCartToItem(product.id, product.title, 1, product.price);
                Scaffold.of(context).hideCurrentSnackBar();
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text("Added item to cart"),
                  duration: Duration(seconds: 2),
                  action: SnackBarAction(
                    label: 'UNDO',
                    onPressed: () {
                      cart.removeSingleItem(product.id);
                    },
                  ),
                ));
              },
            ),
          ),
        ),
      ),
    );
  }
}
