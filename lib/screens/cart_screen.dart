import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/cart.dart';
import 'package:flutter_complete_guide/providers/orders.dart';
import 'package:flutter_complete_guide/widgets/cart_item_widget.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key key}) : super(key: key);

  static const ROUTE_NAME = "/cart";

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<Cart>(context); //needs to listen the cart provider because of clear().
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Cart"),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total', style: TextStyle(fontSize: 20)),
                  Spacer(),
                  Chip(
                    label: Text('\$' + cartProvider.totalAmount.toStringAsFixed(2),
                        style: TextStyle(
                          color: Colors.white,
                        )),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  TextButton(onPressed: () {
                    Provider.of<Orders>(context, listen: false).addOrder(cartProvider.items.values.toList(), cartProvider.totalAmount);
                    cartProvider.clear();
                  }, child: Text('ORDER NOW'))
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
              child: ListView.builder(
            itemBuilder: (ctx, i) => CartItemWidget(
                id: cartProvider.items.values.toList()[i].id,
                productId: cartProvider.items.keys.toList()[i],
                price: cartProvider.items.values.toList()[i].price,
                quantity: cartProvider.items.values.toList()[i].quantity,
                title: cartProvider.items.values.toList()[i].title),
            itemCount: cartProvider.itemCount,
          )),
        ],
      ),
    );
  }
}
