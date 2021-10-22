import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/http_exception.dart';
import 'package:flutter_complete_guide/providers/product.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  final String token;
  final String userId;
  List<Product> _items = [];

  Products(this.token, this.userId, this._items);

  List<Product> get items {
    return [..._items];
    //getting a copy with spread operator.~
  }

  List<Product> get favoriteItems {
    return _items.where((product) => product.isFavorite).toList();
    //getting a copy with spread operator.
  }
// ([bool filterByUser = false]) = means that between the [] is an optional positional argument.
  Future<void> getProducts([bool filterByUser = false]) async {
    final filter = filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    final url = Uri.parse(
        'https://iarmaroc-68817-default-rtdb.europe-west1.firebasedatabase.app/products.json?auth=$token&$filter'); //only for firebase
    try {
      final response = await http.get(url);
      //print(json.decode(response.body)); // map in another map;
      final extractedData = json.decode(response.body)
          as Map<String, dynamic>; // we have a map as id and dynamic (which is actually another map);
      final List<Product> loadedProducts = [];
      if (extractedData == null || extractedData.isEmpty) {
        _items;
      }
      final favoritesUrl = Uri.parse(
          'https://iarmaroc-68817-default-rtdb.europe-west1.firebasedatabase.app/userFavorites/$userId.json?auth=$token'); //only for firebase
      final favoriteResponse = await http.get(favoritesUrl);
      final favoriteData = json.decode(favoriteResponse.body);
      extractedData.forEach((prodId, prodData) {
        final product = Product(
            id: prodId,
            title: prodData['title'],
            description: prodData['description'],
            price: prodData['price'] as double,
            imageUrl: prodData['imageUrl'],
            isFavorite: favoriteData == null
                ? false
                : favoriteData[prodId] ?? false); //favoriteData[prodId] ?? false if is null return false
        loadedProducts.add(product);
      });
      //_items.addAll(loadedProducts);
      _items = loadedProducts;
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProduct(Product product) async {
    //async automatically returns a future.
    final url = Uri.parse(
        'https://iarmaroc-68817-default-rtdb.europe-west1.firebasedatabase.app/products.json?auth=$token'); //only for firebase
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
          'creatorId': userId
        }),
      );
      _items.add(Product(
          id: json.decode(response.body)['name'],
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl));
      notifyListeners();
    } catch (error) {
      //print(error);
      throw error;
    }
  }

  // EXAMPLE WITHOUT AWAIT.
  //   http
  //       .post(
  //         url,
  //         body: json.encode({
  //           'title': product.title,
  //           'description': product.description,
  //           'imageUrl': product.imageUrl,
  //           'price': product.price,
  //           'isFavorite': product.isFavorite,
  //         }),
  //       )
  //       .then((response) => {
  //             _items.add(Product(
  //               id: json.decode(response.body)['name'],
  //               title: product.title,
  //               description: product.description,
  //               price: product.price,
  //               imageUrl: product.imageUrl,
  //             )),
  //             notifyListeners(),
  //           })
  //       .catchError((error) {
  //     print(error);
  //     throw error;
  //   });
  // }

  Future<void> updateProduct(String productId, Product newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == productId);
    //async automatically returns a future.
    final url = Uri.parse(
        'https://iarmaroc-68817-default-rtdb.europe-west1.firebasedatabase.app/products/$productId.json?auth=$token'); //only for firebase
    try {
      if (prodIndex >= 0) {
        await http.patch(url,
            body: json.encode({
              'title': newProduct.title,
              'description': newProduct.description,
              'price': newProduct.price,
              'imageUrl': newProduct.imageUrl,
            }));
        _items[prodIndex] = newProduct;
        notifyListeners();
      } else {
        //throw error
        AlertDialog(title: Text('Ops Something wrong happened!'));
      }
    } catch (error) {
      throw error;
    }
  }

  Product findById(String productId) {
    return _items.firstWhere((prod) => prod.id == productId);
  }

  // Future<void> updateFavoritesProduct(String productId, bool isFavorite) async {
  //   //async automatically returns a future.
  //   final existingProductsIndex = _items.indexWhere((prod) => prod.id == productId);
  //   //async automatically returns a future.
  //   final url = Uri.parse(
  //       'https://iarmaroc-68817-default-rtdb.europe-west1.firebasedatabase.app/products/$productId.'); //only for firebase
  //   var existingProduct = _items[existingProductsIndex];
  //   _items[existingProductsIndex] = Product(
  //       id: existingProduct.id,
  //       title: existingProduct.title,
  //       description: existingProduct.description,
  //       price: existingProduct.price,
  //       imageUrl: existingProduct.imageUrl,
  //       isFavorite: isFavorite);
  //   try {
  //     if (existingProductsIndex >= 0) {
  //       await http.patch(url,
  //           body: json.encode({
  //             'isFavorite': isFavorite,
  //           }));
  //
  //       notifyListeners();
  //     } else {
  //       //throw error
  //       _items[existingProductsIndex] = existingProduct;
  //       AlertDialog(title: Text('Ops Something wrong happened!'));
  //     }
  //   } catch (error) {
  //     throw error;
  //   }
  //   existingProduct = null;
  // }

  @Deprecated('use optimistic delete')
  void deleteProduct(String productId) async {
    //async automatically returns a future.
    final url = Uri.parse(
        'https://iarmaroc-68817-default-rtdb.europe-west1.firebasedatabase.app/products/${productId}.json'); //only for firebase
    try {
      final response = await http.delete(url, body: productId);
    } catch (error) {
      throw error;
    }
    _items.removeWhere((prod) => prod.id == productId);
    notifyListeners();
  }

  Future<void> deleteProductOptimistic(String productId) async {
    //async automatically returns a future.
    final url = Uri.parse(
        'https://iarmaroc-68817-default-rtdb.europe-west1.firebasedatabase.app/products/${productId}.json?auth=$token'); //only for firebase
    final existingProductsIndex = _items.indexWhere((product) => product.id == productId);
    var existingProduct = _items[existingProductsIndex];

    final response = await http.delete(url);

    _items.removeAt(existingProductsIndex);
    notifyListeners();

    if (response.statusCode >= 400) {
      _items.insert(existingProductsIndex, existingProduct);
      notifyListeners();
      print('Deleted project was added back due to an error in the http request');
      throw HttpException('Ops! Could not delete the product');
    }
    existingProduct == null;
  }
}
