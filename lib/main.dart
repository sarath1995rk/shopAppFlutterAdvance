import 'package:flutter/material.dart';
import 'package:shop_app_flutter_advanced/providers/auth.dart';
import 'package:shop_app_flutter_advanced/providers/cart.dart';
import 'package:shop_app_flutter_advanced/providers/orders.dart';
import 'package:shop_app_flutter_advanced/screens/auth_screen.dart';
import 'package:shop_app_flutter_advanced/screens/cart_screen.dart';
import 'package:shop_app_flutter_advanced/screens/edit_product_screen.dart';
import 'package:shop_app_flutter_advanced/screens/orders_screen.dart';
import 'package:shop_app_flutter_advanced/screens/product_detail_screen.dart';
import 'package:shop_app_flutter_advanced/screens/products_overview_screen.dart';
import 'package:provider/provider.dart';
import 'package:shop_app_flutter_advanced/providers/products_provider.dart';
import 'package:shop_app_flutter_advanced/screens/splash_screen.dart';
import 'package:shop_app_flutter_advanced/screens/user_products_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => Auth()),
        ChangeNotifierProxyProvider<Auth, ProductsProvider>(
          create: (ctx) => ProductsProvider('', [], ''),
          update: (ctx, authVal, previousProducts) => ProductsProvider(
              authVal.token,
              previousProducts!.items == null ? [] : previousProducts.items,
              authVal.userId),
        ),
        ChangeNotifierProvider(create: (ctx) => Cart()),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (ctx) => Orders([], '', ''),
          update: (ctx, auth, previousOrders) => Orders(
              previousOrders!.orders == null ? [] : previousOrders.orders,
              auth.token,
              auth.userId),
        ),
      ],
      child: Consumer<Auth>(
        builder: (_, val, child) {
          return MaterialApp(
            title: 'Shop App',
            theme: ThemeData(
                primarySwatch: Colors.purple,
                accentColor: Colors.deepOrange,
                fontFamily: 'Lato'),
            home: val.isAuth
                ? ProductOverviewScreen()
                : FutureBuilder(
                    future: val.tryAutoLogin(),
                    builder: (context, authResult) {
                      return authResult.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen();
                    }),

            // initialRoute: '/',
            routes: {
              ProductDetailScreen.routeName: (context) => ProductDetailScreen(),
              CartScreen.routeName: (context) => CartScreen(),
              OrdersScreen.routeName: (context) => OrdersScreen(),
              UserProductScreen.routeName: (context) => UserProductScreen(),
              EditProductScreen.routeName: (context) => EditProductScreen()
            },
          );
        },
      ),
    );
  }
}
