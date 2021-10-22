import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/http_exception.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;
  Timer _authTimer;

  bool get isAuth {
    return (_token != null && _expiryDate != null && _expiryDate.isAfter(DateTime.now()));
  }

  get userId {
    return _userId;
  }

  get token {
    return _token;
  }

  Future<void> _authenticate(String email, String password, String urlSegment) async {
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyBxsmmQPGeGhq4aoPkikeI4tlb4YWmwDL8');
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      print(json.decode(response.body));
      final responseData = json.decode(response.body);

      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      //store the token
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(Duration(seconds: int.parse(responseData['expiresIn'])));
      _autoLogout();
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  void logout() {
    _token == null;
    _expiryDate = null;
    _expiryDate == null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer == null;
    };
    notifyListeners();
  }

  void _autoLogout() {
    //set timer if token expires
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), () => logout());
  }
}

//
// Future<void> signup(String email, String password) async {
//     final url = Uri.parse(
//         'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyBxsmmQPGeGhq4aoPkikeI4tlb4YWmwDL8');
//     final response = await http.post(
//       url,
//       body: json.encode(
//         {
//           'email': email,
//           'password': password,
//           'returnSecureToken': true,
//         },
//       ),
//     );
//     print(json.decode(response.body));
//     return response;
//   }

//
// Future<void> signIn(String email, String password) async {
//   final url = Uri.parse(
//       'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyBxsmmQPGeGhq4aoPkikeI4tlb4YWmwDL8');
//   final response = await http.post(
//     url,
//     body: json.encode(
//       {
//         'email': email,
//         'password': password,
//         'returnSecureToken': true,
//       },
//     ),
//   );
//   print(json.decode(response.body));
//   return response;
// }
