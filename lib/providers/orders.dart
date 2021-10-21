import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({@required this.id, @required this.amount, @required this.products, @required this.dateTime});
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url = Uri.parse('https://iarmaroc-68817-default-rtdb.europe-west1.firebasedatabase.app/orders.json');
    final dateTime = DateTime.now();
    final response = await http.post(
      url,
      body: json.encode({
        'amount': total,
        'dateTime': dateTime.toIso8601String(),
        'products': cartProducts
            .map(
              (cp) => {'id': cp.id, 'title': cp.title, 'quantity': cp.quantity, 'price': cp.price},
            )
            .toList(),
      }),
    );
    _orders.add(
      OrderItem(
        id: json.decode(response.body)['name'],
        amount: total,
        products: cartProducts,
        dateTime: dateTime,
      ),
    );
    notifyListeners();
  }

  Future<void> getOrders() async {
    final url = Uri.parse('https://iarmaroc-68817-default-rtdb.europe-west1.firebasedatabase.app/orders.json');
    final response = await http.get(url);
    print(json.decode(response.body));

    final List<OrderItem> loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return;
    }
    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(
        OrderItem(
          id: orderId,
          amount: orderData['amount'],
          dateTime: DateTime.parse(orderData['dateTime']),
          products: (orderData['products'] as List<dynamic>)
              .map(
                (item) => CartItem(
                    id: item['id'], price: item['price'] as double, title: item['title'], quantity: item['quantity']),
              )
              .toList(),
        ),
      ); //here is a list of dynamic values
    });
    _orders = loadedOrders;
    notifyListeners();
  }
}
