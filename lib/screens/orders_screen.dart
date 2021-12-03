import 'package:flutter/material.dart';
import 'package:shop_app_flutter_advanced/providers/orders.dart';
import 'package:provider/provider.dart';
import 'package:shop_app_flutter_advanced/widgets/app_drawer.dart';
import 'package:shop_app_flutter_advanced/widgets/order_item.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders_screen';

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  Future? _orders;

  Future obtainOrders() {
    return Provider.of<Orders>(context, listen: false).fetchOders();
  }

  @override
  void initState() {
    _orders = obtainOrders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final orderData = Provider.of<Orders>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('Your Orders'),
        ),
        drawer: AppDrawer(),
        body: FutureBuilder(
          future: _orders,
          builder: (context, dataSnapShot) {
            if (dataSnapShot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (dataSnapShot.error != null) {
                //do error handling
                return Center(
                  child: Text('no data'),
                );
              } else {
                return Consumer<Orders>(
                  builder: (_, orderData, __) {
                    return ListView.builder(
                      itemBuilder: (ctx, index) {
                        return OrderItems(orderData.orders[index]);
                      },
                      itemCount: orderData.orders.length,
                    );
                  },
                );
              }
            }
          },
        ));
  }
}
