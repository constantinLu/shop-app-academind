import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/cart.dart';
import 'package:flutter_complete_guide/providers/product.dart';
import 'package:flutter_complete_guide/widgets/product_detail_screen.dart';
import 'package:provider/provider.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<Product>(context, listen: true);
    final cartProvider = Provider.of<Cart>(context, listen: false);
    return Consumer<Product>(
      //only when you want some part to be wrapped to the listener. //can be used only in isFavoriteButton
      builder: (ctx, product, child) => ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: GridTile(
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(ProductDetailScreen.ROUTE_NAME, arguments: product.id);
            },
            child: Image.network(product.imageUrl, fit: BoxFit.cover),
          ),
          footer: GridTileBar(
            backgroundColor: Colors.black87,
            leading: IconButton(
              color: Theme.of(context).colorScheme.secondary,
              onPressed: () {
                productProvider.toggleFavoriteStatus();
              },
              icon: Icon(productProvider.isFavorite ? Icons.favorite : Icons.favorite_border),
            ),
            title: Text(
              product.title,
              textAlign: TextAlign.center,
              textScaleFactor: 0.7,
            ),
            trailing: IconButton(
              color: Theme.of(context).colorScheme.secondary,
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                cartProvider.addItem(product.id, product.price, product.title);
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("Product added to the cart"),
                  duration: Duration(seconds: 2),
                  action: SnackBarAction(
                    label: 'UNDO',
                    onPressed: () {
                      cartProvider.removeSingleItem(productProvider.id);
                    },
                  ), //
                ));
              },
            ),
          ),
        ),
      ),
    );
  }
}
