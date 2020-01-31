import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/widgets.dart';

import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  final _apiKey = 'AIzaSyDzrSJr2Dgzrp4ItIf_FCHLJY5JnuJKJic';

  String _token;
  DateTime _expiryDate;
  String _userId;

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }

    return null;
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=$_apiKey';

    try {
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true
          }));

      final responseData = json.decode(response.body);

      print(responseData);

      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }

      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> signup(String email, String password) {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> signin(String email, String password) {
    return _authenticate(email, password, 'signInWithPassword');
  }
}
