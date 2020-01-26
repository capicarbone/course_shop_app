import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:shop_app/models/http_exception.dart';


class Product extends ChangeNotifier {
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
      

  void _setFavoriteValue(bool value) {
    isFavorite = value;
    notifyListeners();
  }

  Future<void> toggleFavoriteStatus() async {
    final url = 'https://shop-app-67cec.firebaseio.com/products/$id.json';
    _setFavoriteValue(!isFavorite);    
  
    final response = await http.patch(url, body: json.encode( {
      'isFavorite' : isFavorite
    }));  

    if (response.statusCode >= 400){                      
      _setFavoriteValue(!isFavorite);
      throw HttpException('Record could not modified');
    }      
    
    
  }
}
