import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/http_exception.dart';
import 'package:flutter_complete_guide/providers/product.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  List<Product> _items = [];

  // Product(
  //     id: 'p1',
  //     title: 'Red Shirt',
  //     description: 'A red shirt - it is pretty red!',
  //     price: 29.99,
  //     imageUrl: 'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
  //     isFavorite: true),
  // Product(
  //   id: 'p2',
  //   title: 'Trousers',
  //   description: 'A nice pair of trousers.',
  //   price: 59.99,
  //   imageUrl:
  //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
  // ),
  // Product(
  //   id: 'p3',
  //   title: 'Yellow Scarf',
  //   description: 'Warm and cozy - exactly what you need for the winter.',
  //   price: 19.99,
  //   imageUrl: 'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
  // ),
  // Product(
  //   id: 'p4',
  //   title: 'A Pan',
  //   description: 'Prepare any meal you want.',
  //   price: 49.99,
  //   imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
  // ),
  //];

  List<Product> get items {
    return [..._items];
    //getting a copy with spread operator.
  }

  List<Product> get favoriteItems {
    return _items.where((product) => product.isFavorite).toList();
    //getting a copy with spread operator.
  }

  Future<void> getProducts() async {
    final url = Uri.parse(
        'https://iarmaroc-68817-default-rtdb.europe-west1.firebasedatabase.app/products.json'); //only for firebase
    try {
      final response = await http.get(url);
      print(json.decode(response.body)); // map in another map;
      final extractedData = json.decode(response.body)
          as Map<String, dynamic>; // we have a map as id and dynamic (which is actually another map);
      final List<Product> loadedProducts = [];
      if (extractedData == null || extractedData.isEmpty) {
        _items;
      }
      extractedData.forEach((prodId, prodData) {
        final product = Product(
            id: prodId,
            title: prodData['title'],
            description: prodData['description'],
            price: prodData['price'] as double,
            imageUrl: prodData['imageUrl']);
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
        'https://iarmaroc-68817-default-rtdb.europe-west1.firebasedatabase.app/products.json'); //only for firebase
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
          'isFavorite': product.isFavorite,
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
      print(error);
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
        'https://iarmaroc-68817-default-rtdb.europe-west1.firebasedatabase.app/products/$productId.json'); //only for firebase
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

  @Deprecated('use optimistic delete')
  Future<void> deleteProductOptimistic(String productId) async {
    //async automatically returns a future.
    final url = Uri.parse(
        'https://iarmaroc-68817-default-rtdb.europe-west1.firebasedatabase.app/products/${productId}.json'); //only for firebase
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
