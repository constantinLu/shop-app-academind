import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/products.dart';
import 'package:flutter_complete_guide/screens/edit_product_screen.dart';
import 'package:flutter_complete_guide/widgets/app_drawer.dart';
import 'package:flutter_complete_guide/widgets/user_product_item.dart';
import 'package:provider/provider.dart';

class UserProductsScreen extends StatelessWidget {
  const UserProductsScreen({Key key}) : super(key: key);

  static const ROUTE_NAME = "/user-products";

  //named function
  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).getProducts();
  }

  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.ROUTE_NAME);
            },
          )
        ],
      ),
      body: RefreshIndicator(
          onRefresh: () => _refreshProducts(context),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: ListView.builder(
          itemBuilder: (_, i) =>
              Column(
                children: [
                  UserProductItem(
                      productsProvider.items[i].id, productsProvider.items[i].title,
                      productsProvider.items[i].imageUrl),
                  Divider(),
                ],
              ),
          itemCount: productsProvider.items.length,
        ),
      ),
    ),drawer
    :
    AppDrawer
    (
    )
    ,
    );
  }
}
