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

  String authToken = null;

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchOrders() async {
    final url = 'https://shop-app-67cec.firebaseio.com/orders.json?auth=$authToken';

    _orders = [];

    final response = await http.get(url);
    final data = json.decode(response.body) as Map<String, dynamic>;

    print(data);

    if (data == null ) {
      return;
    }

    data.forEach((id, values) {
      var products = values['products'] as List<dynamic>;
      var order = OrderItem(
        id: id,
        amount: values['amount'],
        dateTime: DateTime.parse(values['dateTime']),
        products: products
            .map(
              (pValues) => CartItem(
                  id: pValues['id'],
                  price: pValues['price'],
                  title: pValues['title'],
                  quantity: pValues['quantity']),
            )
            .toList(),
      );

      _orders.add(order);      
    });

    _orders = _orders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url = 'https://shop-app-67cec.firebaseio.com/orders.json?auth=$authToken';

    var timestamp = DateTime.now();

    final response = await http.post(url,
        body: json.encode({
          'amount': total,
          'dateTime': timestamp.toIso8601String(),
          'products': cartProducts
              .map((item) => {
                    'id': item.id,
                    'title': item.title,
                    'quantity': item.quantity,
                    'price': item.price,                    
                  })
              .toList()
        }));

    var data = json.decode(response.body);
    print(data);

    _orders.insert(
      0,
      OrderItem(
        id: data['name'],
        amount: total,
        products: cartProducts,
        dateTime: timestamp,
      ),
    );
    notifyListeners();
  }
}
