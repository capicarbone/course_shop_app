import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

import './cart.dart' show CartItem;

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem(
      {@required this.id,
      @required this.amount,
      @required this.products,
      @required this.dateTime});
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    
    final url = 'https://shop-app-67cec.firebaseio.com/orders.json';

    final response = await http.post(url, body: json.encode({
      'amount': total,
      'products' : cartProducts.map((item) => {
        'title': item.price,
        'quantity': item.quantity,
        'price': item.price,
        'dateTime': DateTime.now().toString()
      }).toList()
    }));

    var data = json.decode(response.body);
    print(data);

    _orders.insert(
      0,
      OrderItem(
        id: data['name'],
        amount: total,
        products: cartProducts,
        dateTime: DateTime.now(),
      ),
    );
    notifyListeners();
  }
  
}
