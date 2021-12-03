import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shop_app_flutter_advanced/providers/orders.dart';
import 'package:intl/intl.dart';

class OrderItems extends StatefulWidget {
  final OrderItem orderItem;

  OrderItems(this.orderItem);

  @override
  _OrderItemsState createState() => _OrderItemsState();
}

class _OrderItemsState extends State<OrderItems> {
  var _expandable = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 400),
      height: _expandable
          ? min(widget.orderItem.products.length * 20 + 250, 300)
          : 100,
      child: Card(
        margin: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text('\$${widget.orderItem.amount}'),
              subtitle: Text(DateFormat('dd/MM/yyyy hh:mm')
                  .format(widget.orderItem.dateTime)),
              trailing: IconButton(
                icon: Icon(_expandable ? Icons.expand_less : Icons.expand_more),
                onPressed: () {
                  setState(() {
                    _expandable = !_expandable;
                  });
                },
              ),
            ),
            if (_expandable)
              AnimatedContainer(
                duration: Duration(milliseconds: 400),
                height: _expandable
                    ? min(widget.orderItem.products.length * 20 + 100, 180)
                    : 0,
                padding: EdgeInsets.all(10),
                child: ListView(
                  children: widget.orderItem.products.map((pro) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          pro.title,
                          style: TextStyle(fontSize: 15),
                        ),
                        Text('${pro.quantity} x \$${pro.price}')
                      ],
                    );
                  }).toList(),
                ),
              )
          ],
        ),
      ),
    );
  }
}
