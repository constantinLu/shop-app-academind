import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product(
      {@required this.id,
      @required this.title,
      @required this.description,
      @required this.price,
      @required this.imageUrl,
      this.isFavorite = false});

  void toggleFavoriteStatus(String token, String userId) async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    try {
      final url = Uri.parse(
          'https://iarmaroc-68817-default-rtdb.europe-west1.firebasedatabase.app/userFavorites/$userId/$id.json?auth=$token'); //only for firebase
      final response = await http.put(url, body: jsonEncode(isFavorite));

      if (response.statusCode >= 400) {
        _revertFavorite(oldStatus);
      }
    } catch (error) {
      _revertFavorite(oldStatus);
    }
  }

  void _revertFavorite(bool oldStatus) {
    isFavorite = oldStatus;
    notifyListeners();
  }
}
