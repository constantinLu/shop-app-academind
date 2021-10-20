import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/products.dart';
import 'package:flutter_complete_guide/screens/edit_product_screen.dart';
import 'package:provider/provider.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  UserProductItem(this.id, this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    final providerData = Provider.of<Products>(context);
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
                Navigator.of(context)
                    .pushNamed(EditProductScreen.ROUTE_NAME, arguments: id); // in order to load the product
              },
              icon: Icon(Icons.edit),
              color: Theme.of(context).errorColor,
            ),
            IconButton(
                onPressed: () async {
                  final providerData = Provider.of<Products>(context, listen: false);
                  try {
                    await providerData.deleteProductOptimistic(id);
                  } catch (exception) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                      exception.message.toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.red),
                    )));
                  }
                },
                icon: Icon(Icons.delete),
                color: Theme.of(context).primaryColor),
          ],
        ),
      ),
    );
  }
}
