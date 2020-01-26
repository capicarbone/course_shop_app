import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart' show Cart;
import '../widgets/cart_item.dart';
import '../providers/orders.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

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
                  OderButton(cartData: cartData)
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

class OderButton extends StatefulWidget {
  const OderButton({
    Key key,
    @required this.cartData,
  }) : super(key: key);

  final Cart cartData;

  @override
  _OderButtonState createState() => _OderButtonState();
}

class _OderButtonState extends State<OderButton> {
  var _isSaving = false;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: _isSaving ? CircularProgressIndicator() : Text('Order Now'),
      onPressed: (widget.cartData.totalAmount <= 0 || _isSaving)
          ? null
          : () async {
              setState(() {
                _isSaving = true;
              });

              try {
                await Provider.of<Orders>(context, listen: false).addOrder(
                    widget.cartData.items.values.toList(),
                    widget.cartData.totalAmount);
                widget.cartData.clear();
                Navigator.of(context).pop();
              } catch (error) {
                Scaffold.of(context).showSnackBar(SnackBar(content: Text('Order creation failed.'),));
                print(error);
              }

              setState(() {
                _isSaving = false;
              });
            },
      textColor: Theme.of(context).primaryColor,
    );
  }
}
