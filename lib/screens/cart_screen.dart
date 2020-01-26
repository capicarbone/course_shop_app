import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart' show Cart;
import '../widgets/cart_item.dart';
import '../providers/orders.dart';

class CartScreen extends StatefulWidget {
  static const routeName = '/cart';

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  var _isSaving = false;

  @override
  Widget build(BuildContext context) {
    var cartData = Provider.of<Cart>(context);
    

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      '\$${cartData.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                          color:
                              Theme.of(context).primaryTextTheme.title.color),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  _isSaving
                      ? Container(
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                          width: 100,
                        )
                      : FlatButton(
                          child: Text('Order Now'),
                          onPressed: () async {
                            setState(() {
                              _isSaving = true;
                            });

                            try {
                              await Provider.of<Orders>(context, listen: false)
                                  .addOrder(cartData.items.values.toList(),
                                      cartData.totalAmount);

                              cartData.clear();
                            } catch (error) {
                              print(error);
                            }

                            setState(() {
                              _isSaving = false;
                            });
                          },
                          textColor: Theme.of(context).primaryColor,
                        )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cartData.items.length,
              itemBuilder: (_, i) {
                var item = cartData.items.values.toList()[i];
                return CartItem(
                  item.id,
                  cartData.items.keys.toList()[i],
                  item.title,
                  item.price,
                  item.quantity,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
