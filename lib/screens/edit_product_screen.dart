import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import '../providers/product.dart';
import '../providers/products.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-products';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();

  var _isInit = true;

  var _editedProduct =
      Product(id: null, title: '', price: 0, description: '', imageUrl: '');

  @override
  void initState() {
    super.initState();

    _imageUrlFocusNode.addListener(_updateImageUrl);
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;

      if (productId != null) {
        _editedProduct =
            Provider.of<Products>(context, listen: false).findById(productId);
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }

    _isInit = false;
    super.didChangeDependencies();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    super.dispose();
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlFocusNode.dispose();
  }

  void _saveForm() {
    final isValid = _form.currentState.validate();

    if (!isValid) {
      return;
    }

    _form.currentState.save();

    var productsData = Provider.of<Products>(context);
    if (_editedProduct.id != null) {
      // Editing
      productsData.updateProduct(_editedProduct.id, _editedProduct);
    } else {
      productsData.addProduct(_editedProduct);
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child: ListView(
            children: <Widget>[
              TextFormField(
                initialValue: _editedProduct.title,
                decoration: InputDecoration(labelText: 'Title'),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please provide a value.';
                  }

                  return null;
                },
                onSaved: (value) {
                  _editedProduct = Product(
                      title: value,
                      price: _editedProduct.price,
                      description: _editedProduct.description,
                      imageUrl: _editedProduct.imageUrl,
                      id: _editedProduct.id,
                      isFavorite: _editedProduct.isFavorite);
                },
              ),
              TextFormField(
                initialValue: _editedProduct.price.toString(),
                decoration: InputDecoration(labelText: 'Price'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                focusNode: _priceFocusNode,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter a price.';
                  }

                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number.';
                  }

                  if (double.tryParse(value) <= 0) {
                    return 'Please enter a valid price.';
                  }

                  return null;
                },
                onSaved: (value) {
                  _editedProduct = Product(
                      title: _editedProduct.title,
                      price: double.parse(value),
                      description: _editedProduct.description,
                      imageUrl: _editedProduct.imageUrl,
                      id: _editedProduct.id,
                      isFavorite: _editedProduct.isFavorite);
                },
              ),
              TextFormField(
                initialValue: _editedProduct.description,
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 3,
                focusNode: _descriptionFocusNode,
                keyboardType: TextInputType.multiline,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter a description.';
                  }

                  if (value.length < 10) {
                    return 'Should be at least 10 characters long';
                  }

                  return null;
                },
                onSaved: (value) {
                  _editedProduct = Product(
                      title: _editedProduct.title,
                      price: _editedProduct.price,
                      description: value,
                      imageUrl: _editedProduct.imageUrl,
                      id: _editedProduct.id,
                      isFavorite: _editedProduct.isFavorite);
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                    width: 100,
                    height: 100,
                    margin: EdgeInsets.only(top: 8, right: 10),
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.grey)),
                    child: _imageUrlController.text.isEmpty
                        ? Text('Enter a URL')
                        : FittedBox(
                            child: Image.network(
                              _imageUrlController.text,
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'Image URL'),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      controller: _imageUrlController,
                      focusNode: _imageUrlFocusNode,
                      onFieldSubmitted: (_) {
                        _saveForm();
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter an image URL.';
                        }

                        if (value.startsWith('http') &&
                            !value.startsWith('https')) {
                          return 'Please enter a valid URL.';
                        }

                        if (!value.endsWith('.png') &&
                            !value.endsWith('.jpg') &&
                            !value.endsWith('.jpeg')) {
                          return 'Please enter a valid image URL.';
                        }

                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                            title: _editedProduct.title,
                            price: _editedProduct.price,
                            description: _editedProduct.description,
                            imageUrl: value,
                            id: _editedProduct.id,
                            isFavorite: _editedProduct.isFavorite);
                      },
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}