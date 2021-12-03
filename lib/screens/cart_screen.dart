import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app_flutter_advanced/providers/cart.dart';
import 'package:shop_app_flutter_advanced/widgets/cart_item.dart';
import 'package:shop_app_flutter_advanced/providers/orders.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart_screen';

  @override
  Widget build(BuildContext context) {
    Cart cartData = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 17),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      cartData.totalAmount.toString(),
                    ),
                    backgroundColor: Colors.orange,
                  ),
                  OrderButton(cartData),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (ctx, i) {
                return CartItems(
                    cartData.items.values.toList()[i]!.id,
                    cartData.items.values.toList()[i]!.price,
                    cartData.items.values.toList()[i]!.quantity,
                    cartData.items.values.toList()[i]!.title,
                    cartData.items.keys.toList()[i]);
              },
              itemCount: cartData.items.length,
            ),
          )
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  final Cart cartData;

  OrderButton(this.cartData);

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: (widget.cartData.totalAmount <= 0 || _isLoading)
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });
              await Provider.of<Orders>(context, listen: false).addOrder(
                  widget.cartData.items.values.toList(),
                  widget.cartData.totalAmount);
              widget.cartData.clearCart();
              setState(() {
                _isLoading = false;
              });
            },
      child: _isLoading ? CircularProgressIndicator() : Text('Order Now'),
    );
  }
}
