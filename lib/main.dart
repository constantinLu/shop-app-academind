import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/auth.dart';
import 'package:flutter_complete_guide/providers/cart.dart';
import 'package:flutter_complete_guide/providers/orders.dart';
import 'package:flutter_complete_guide/providers/products.dart';
import 'package:flutter_complete_guide/screens/auth_screen.dart';
import 'package:flutter_complete_guide/screens/cart_screen.dart';
import 'package:flutter_complete_guide/screens/edit_product_screen.dart';
import 'package:flutter_complete_guide/screens/orders_screen.dart';
import 'package:flutter_complete_guide/screens/user_products_screen.dart';
import 'package:flutter_complete_guide/widgets/product_detail_screen.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProvider.value(
          value: Products(),
        ),
        ChangeNotifierProvider.value(
          value: Cart(),
        ),
        ChangeNotifierProvider.value(
          value: Orders(),
        )
      ],
      child: MaterialApp(
        title: 'Iarma',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.lightGreen, accentColor: Colors.white, fontFamily: 'Lato'),
        //textTheme: TextTheme(headline7: TextStyle(fontSize: 5), bodyText1: TextStyle(fontSize: 22), bodyText2: TextStyle(fontSize: 500))),
        home: AuthScreen(),
        routes: {
          ProductDetailScreen.ROUTE_NAME: (ctx) => ProductDetailScreen(),
          CartScreen.ROUTE_NAME: (ctx) => CartScreen(),
          OrdersScreen.ROUTE_NAME: (ctx) => OrdersScreen(),
          UserProductsScreen.ROUTE_NAME: (ctx) => UserProductsScreen(),
          EditProductScreen.ROUTE_NAME: (ctx) => EditProductScreen()
        },
      ),
    );
  }
}
