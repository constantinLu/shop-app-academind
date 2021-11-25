import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/products.dart';
import 'package:provider/provider.dart';

class ProductDetailScreen extends StatelessWidget {
  static const ROUTE_NAME = '/product-detail';

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;
    final selectedProduct = Provider.of<Products>(context, listen: false)
        .findById(
            productId); //does not need to listen (will not rebuild when items
    // are changed).

    return Scaffold(
      // appBar: AppBar(
      //   title: Text(selectedProduct.title),
      // ),
      //body: SingleChildScrollView(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(selectedProduct.title),
              background: Hero(
                tag: selectedProduct.id,
                child: Image.network(
                  selectedProduct.imageUrl,
                  fit: BoxFit.cover,
                  //alignment: Alignment.center,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                SizedBox(height: 10),
                Text(
                  '\$${selectedProduct.price}',
                  style: TextStyle(color: Colors.grey, fontSize: 20),
                ),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.symmetric(),
                  width: double.infinity,
                  child: Text(
                    selectedProduct.description,
                    textAlign: TextAlign.center,
                    softWrap: true,
                  ),
                ),
                SizedBox(
                  height: 1000,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
