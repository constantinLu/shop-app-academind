import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/http_exception.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;
  Timer _authTimer;

  bool get isAuth {
    return (_token != null &&
        _expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()));
  }

  get userId {
    return _userId;
  }

  get token {
    return _token;
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
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
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));
      _autoLogout();
      notifyListeners();
      //need to work with Futures
      final prefs = await SharedPreferences
          .getInstance(); // returns A future which returns a shared preferences
      //json encode({''}) - can always be used if complex type is needed
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'expiryDate': _expiryDate.toIso8601String()
      });
      prefs.setString('userData',
          userData); //store the string in the prefs to retrive it later
    } catch (error) {
      throw error;
    }
  }


  // store data in the phone prefs
  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedUserData =
        jsonDecode(prefs.getString('userData')) as Map<String, Object>;
    //extract the expiry date an check it if it still valid.

    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);
    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    //update the auth values
    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _expiryDate = expiryDate;
    notifyListeners();
    _autoLogout();
    return true;
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  void logout() async {
    _token == null;
    _expiryDate = null;
    _expiryDate == null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer == null;
    };
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    //prefs.remove('userData'); - only removes this key.
    prefs.clear();
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
