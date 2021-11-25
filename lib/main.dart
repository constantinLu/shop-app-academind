import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/auth.dart';
import 'package:flutter_complete_guide/providers/cart.dart';
import 'package:flutter_complete_guide/providers/orders.dart';
import 'package:flutter_complete_guide/providers/products.dart';
import 'package:flutter_complete_guide/screens/auth_screen.dart';
import 'package:flutter_complete_guide/screens/cart_screen.dart';
import 'package:flutter_complete_guide/screens/edit_product_screen.dart';
import 'package:flutter_complete_guide/screens/loading_screen.dart';
import 'package:flutter_complete_guide/screens/orders_screen.dart';
import 'package:flutter_complete_guide/screens/products_overview_screen.dart';
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
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (ctx) => Products('a', 'a', []),
          update: (ctx, auth, prevProducts) => Products(auth.token, auth.userId,
              prevProducts == null ? [] : prevProducts.items),
        ),
//

        ChangeNotifierProvider.value(
          value: Cart(),
        ),

        ChangeNotifierProxyProvider<Auth, Orders>(
            create: (ctx) => Orders('', '', []),
            update: (ctx, auth, prevOrders) => Orders(auth.token, auth.userId,
                prevOrders == null ? [] : prevOrders.orders)),
        // ChangeNotifierProvider.value(
        //   value: Orders(),
        // )
      ],
      child: Consumer<Auth>(
        builder: (ctx, authData, _) => MaterialApp(
          title: 'Iarma',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              primarySwatch: Colors.lightGreen,
              accentColor: Colors.white,
              fontFamily: 'Lato'),
          //textTheme: TextTheme(headline7: TextStyle(fontSize: 5), bodyText1: TextStyle(fontSize: 22), bodyText2: TextStyle(fontSize: 500))),
          home: authData.isAuth
              ? ProductsOverviewScreen()
              : FutureBuilder(
                  future: authData.tryAutoLogin(),
                  builder: (context, authResultSnapshot) =>
                      // see 277 video
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? LoadingScreen()
                          : AuthScreen(),
                ),
          routes: {
            ProductDetailScreen.ROUTE_NAME: (ctx) => ProductDetailScreen(),
            CartScreen.ROUTE_NAME: (ctx) => CartScreen(),
            OrdersScreen.ROUTE_NAME: (ctx) => OrdersScreen(),
            UserProductsScreen.ROUTE_NAME: (ctx) => UserProductsScreen(),
            EditProductScreen.ROUTE_NAME: (ctx) => EditProductScreen()
          },
        ),
      ),
    );
  }
}
