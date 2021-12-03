import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app_flutter_advanced/providers/products_provider.dart';
import 'package:shop_app_flutter_advanced/screens/edit_product_screen.dart';
import 'package:shop_app_flutter_advanced/widgets/app_drawer.dart';
import 'package:shop_app_flutter_advanced/widgets/user_product_item.dart';

class UserProductScreen extends StatelessWidget {
  static const routeName = '/user_product_screen';

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<ProductsProvider>(context, listen: false)
        .fetchProduct(true);
  }

  @override
  Widget build(BuildContext context) {
    // final ProductsProvider productsData =
    //     Provider.of<ProductsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(EditProductScreen.routeName);
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (context, snapshot) {
          return snapshot.connectionState == ConnectionState.waiting
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : RefreshIndicator(
                  onRefresh: () => _refreshProducts(context),
                  child: Consumer<ProductsProvider>(
                    builder: (_, productsData, __) {
                      return Padding(
                        padding: const EdgeInsets.all(8),
                        child: ListView.builder(
                          itemBuilder: (ctx, index) {
                            return Column(
                              children: <Widget>[
                                UserProductItem(
                                    productsData.items[index].id,
                                    productsData.items[index].title,
                                    productsData.items[index].imageUrl),
                                Divider()
                              ],
                            );
                          },
                          itemCount: productsData.items.length,
                        ),
                      );
                    },
                  ),
                );
        },
      ),
      drawer: AppDrawer(),
    );
  }
}
