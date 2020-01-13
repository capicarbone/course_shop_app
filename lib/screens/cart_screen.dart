import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';

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
                  Text('Total',
                  style: TextStyle(fontSize: 20),), 
                  Spacer(),                           
                  Chip(label: Text('\$${cartData.totalAmount}', style: TextStyle(color: Theme.of(context).primaryTextTheme.title.color),), backgroundColor: Theme.of(context).primaryColor,),
                  FlatButton(child: Text('Order Now'), onPressed: () {}, textColor: Theme.of(context).primaryColor,)
                
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
