import 'package:flutter/material.dart';
import 'package:shop_app_flutter_advanced/providers/cart.dart';
import 'package:shop_app_flutter_advanced/providers/products_provider.dart';
import 'package:shop_app_flutter_advanced/screens/cart_screen.dart';
import 'package:shop_app_flutter_advanced/widgets/app_drawer.dart';
import 'package:shop_app_flutter_advanced/widgets/badge.dart';

import 'package:shop_app_flutter_advanced/widgets/product_grid.dart';
import 'package:provider/provider.dart';

enum FilterOptions { Favourites, All }

class ProductOverviewScreen extends StatefulWidget {
  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var _isInit = true;
  var _isLoading = false;
  @override
  void initState() {
    // Provider.of<ProductsProvider>(context, listen: false).fetchProduct();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      try {
        Provider.of<ProductsProvider>(context).fetchProduct().then((value) {
          setState(() {
            _isLoading = false;
          });
        });
      } catch (error) {
        setState(() {
          _isLoading = false;
        });
      }
    }

    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> _refreshProducts() async {
    Provider.of<ProductsProvider>(context, listen: false).fetchProduct();
  }

  @override
  Widget build(BuildContext context) {
    final providerData = Provider.of<ProductsProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Shop App'),
        actions: [
          PopupMenuButton(
              onSelected: (FilterOptions selectedValue) {
                if (selectedValue == FilterOptions.Favourites) {
                  providerData.showFavouriteOnly();
                } else {
                  providerData.showAll();
                }
              },
              itemBuilder: (_) => [
                    PopupMenuItem(
                      child: Text('Only Favourites'),
                      value: FilterOptions.Favourites,
                    ),
                    PopupMenuItem(
                      child: Text('Show All'),
                      value: FilterOptions.All,
                    )
                  ]),
          Consumer<Cart>(
            builder: (_, val, ch) {
              return Badge(ch!, val.itemCount.toString(), Colors.green);
            },
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          )
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: _refreshProducts, child: ProductsGrid()),
    );
  }
}
