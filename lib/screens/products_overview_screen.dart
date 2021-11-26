import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/cart.dart';
import 'package:flutter_complete_guide/providers/products.dart';
import 'package:flutter_complete_guide/screens/cart_screen.dart';
import 'package:flutter_complete_guide/widgets/app_drawer.dart';
import 'package:flutter_complete_guide/widgets/badge.dart';
import 'package:flutter_complete_guide/widgets/products_grid.dart';
import 'package:provider/provider.dart';

enum FilterOptions { FAVORITES, ALL }

class ProductsOverviewScreen extends StatefulWidget {
  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showOnlyFavorites = false;
  var _isInit = true;
  var _isLoading = true;

  // @override
  // void initState() {
  //   //final products = Provider.of<Products>(context).getProducts(); // WON`T WORK.
  //   //Future.delayed(Duration.zero).then((_) => Provider.of<Products>(context).getProducts()); //HACK, BUT WORKING
  //
  //   super.initState();
  // }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context).getProducts().then((value) => {
            setState(() {
              _isLoading = false;
            }),
          });
    }
    _isInit = false; //kind of an work around as well .
    super.didChangeDependencies();
  }


  // @override
  // void dispose() {
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Iarmaroc"),
        actions: [
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                selectedValue == FilterOptions.FAVORITES ? _showOnlyFavorites = true : _showOnlyFavorites = false;
              });
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(child: Text('Only Favorites'), value: FilterOptions.FAVORITES),
              PopupMenuItem(child: Text('Show All'), value: FilterOptions.ALL),
            ],
          ),
          Consumer<Cart>(
            builder: (_, cartProvider, ch) => Badge(
              child: ch,
              value: cartProvider.itemCount.toString(),
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.ROUTE_NAME);
              },
            ),
          )
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductsGrid(_showOnlyFavorites),
    );
  }
}
