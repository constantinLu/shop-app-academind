import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/products.dart';
import 'package:flutter_complete_guide/widgets/product_item.dart';
import 'package:provider/provider.dart';

class ProductsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //setup a connection wich has a parent that adds a provider. (MainClass is the provider).
    final products = Provider.of<Products>(context, listen: true).items;
    //needs to be updated.
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: products.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10),
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value( //used value because is not a new object
        key: Key(products[i].id.toString()),
        value: products[i], // return the current product
        child: ProductItem(),
      ),
    );
  }
}
