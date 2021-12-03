import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shop_app_flutter_advanced/providers/product.dart';
import 'package:shop_app_flutter_advanced/providers/products_provider.dart';
import 'package:shop_app_flutter_advanced/widgets/icon_button.dart';
import 'package:provider/provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/add_product';

  const EditProductScreen({Key? key}) : super(key: key);

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editProduct =
      Product(id: 'null', price: 0, title: '', description: '', imageUrl: '');
  var _isInit = true;
  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': ''
  };
  var _isLoading = false;

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateUrlImage);

    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      if (ModalRoute.of(context)!.settings.arguments != null) {
        final productId = ModalRoute.of(context)!.settings.arguments as String;
        Product findProduct =
            Provider.of<ProductsProvider>(context, listen: false)
                .findById(productId);
        _editProduct = findProduct;
        _initValues = {
          'title': _editProduct.title,
          'description': _editProduct.description,
          'price': _editProduct.price.toString(),
          'imageUrl': ''
        };
        imageUrlController.text = _editProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    imageUrlController.dispose();
    _imageUrlFocusNode.removeListener(_updateUrlImage);
    _imageUrlFocusNode.dispose();

    super.dispose();
  }

  void _updateUrlImage() {
    if (!_imageUrlFocusNode.hasFocus) {
      if (imageUrlController.text.isEmpty ||
          (!imageUrlController.text.startsWith('http') &&
              !imageUrlController.text.startsWith('https'))) {
        return;
      }
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    final _valid = _form.currentState!.validate();
    if (!_valid) {
      return;
    }

    _form.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    if (_editProduct.id != 'null') {
      await Provider.of<ProductsProvider>(context, listen: false)
          .updateProduct(_editProduct.id, _editProduct);
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    } else {
      _editProduct.isFavourite = false;
      try {
        await Provider.of<ProductsProvider>(context, listen: false)
            .addProduct(_editProduct);
      } catch (error) {
        return showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                title: Text('An Error occurred'),
                content: Text(error.toString()),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Okay'))
                ],
              );
            });
      } finally {
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: [
          IconButton(onPressed: _saveForm, icon: const Icon(Icons.save))
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      initialValue: _initValues['title'],
                      decoration: InputDecoration(
                        labelText: 'Title',
                      ),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      onSaved: (val) {
                        _editProduct = Product(
                            title: val!,
                            imageUrl: _editProduct.imageUrl,
                            description: _editProduct.description,
                            price: _editProduct.price,
                            id: _editProduct.id,
                            isFavourite: _editProduct.isFavourite);
                      },
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'please provide a value';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['price'],
                      focusNode: _priceFocusNode,
                      decoration: InputDecoration(
                        labelText: 'Price',
                      ),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
                      },
                      onSaved: (val) {
                        _editProduct = Product(
                            title: _editProduct.title,
                            imageUrl: _editProduct.imageUrl,
                            description: _editProduct.description,
                            price: double.parse(val!),
                            id: _editProduct.id,
                            isFavourite: _editProduct.isFavourite);
                      },
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'Enter a price';
                        }
                        if (double.tryParse(val) == null) {
                          return 'Enter a valid number';
                        }
                        if (double.parse(val) <= 0) {
                          return 'greater than zero';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['description'],
                      focusNode: _descriptionFocusNode,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: 'description',
                      ),
                      keyboardType: TextInputType.multiline,
                      onSaved: (val) {
                        _editProduct = Product(
                            title: _editProduct.title,
                            imageUrl: _editProduct.imageUrl,
                            description: val!,
                            price: _editProduct.price,
                            id: _editProduct.id,
                            isFavourite: _editProduct.isFavourite);
                      },
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'enter a description';
                        }
                        if (val.length < 10) {
                          return 'characters greater than 10 ';
                        }
                        return null;
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          height: 100,
                          width: 100,
                          margin: EdgeInsets.only(top: 8, right: 10),
                          decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Colors.grey)),
                          child: imageUrlController.text.isEmpty
                              ? Text('Enter a url')
                              : FittedBox(
                                  child: Image.network(imageUrlController.text),
                                  fit: BoxFit.cover,
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            focusNode: _imageUrlFocusNode,
                            controller: imageUrlController,
                            keyboardType: TextInputType.url,
                            decoration: InputDecoration(labelText: 'Image url'),
                            textInputAction: TextInputAction.done,
                            onEditingComplete: () {
                              setState(() {});
                            },
                            onFieldSubmitted: (_) => _saveForm,
                            onSaved: (val) {
                              _editProduct = Product(
                                  title: _editProduct.title,
                                  imageUrl: val!,
                                  description: _editProduct.description,
                                  price: _editProduct.price,
                                  id: _editProduct.id,
                                  isFavourite: _editProduct.isFavourite);
                            },
                            validator: (val) {
                              if (val!.isEmpty) {
                                return 'enter a image url';
                              }
                              if (!val.startsWith('http') &&
                                  !val.startsWith('https')) {
                                return 'Enter a valid url';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildIcon(IconData iconName) {
    return Icon(iconName);
  }
}
