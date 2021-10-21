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
                  OrderButton(cartProvider: cartProvider)
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

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cartProvider,
  }) : super(key: key);

  final Cart cartProvider;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        //automatically is disabled if flutter does not not function to reference on.
        onPressed: (widget.cartProvider.totalAmount <= 0) || (_isLoading)
            ? null
            : () async {
                setState(() {
                  _isLoading = true;
                });
                await Provider.of<Orders>(context, listen: false)
                    .addOrder(widget.cartProvider.items.values.toList(), widget.cartProvider.totalAmount);

                setState(() {
                  _isLoading = false;
                });
                widget.cartProvider.clear();
              },
        child: _isLoading ? CircularProgressIndicator() : Text('ORDER NOW'));
  }
}
