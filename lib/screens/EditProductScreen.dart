import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:random_string/random_string.dart';
import 'package:state_management/providers/Product.dart';
import 'package:state_management/providers/Products.dart';

class EditProductScreen extends StatefulWidget {
  static final String routeName = "/edit-product";

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _imageUrlController = TextEditingController();
  final _imageURLFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  var product = Product(
      id: "", title: "", description: "", price: 0, imageUrl: "");

/*
  final _titleFocusNode = FocusNode();
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
*/
  final Map<String, dynamic> _initValues = {
    "title": "",
    "id": "",
    "imageUrl": "",
    "price": "",
    "description": ""
  };

  @override
  void initState() {
    _imageURLFocusNode.addListener(_imageURLFunction);
  }

  @override
  void didChangeDependencies() {
    if (ModalRoute.of(context)!.settings.arguments != null) {
      final arguments = ModalRoute.of(context)!.settings.arguments as Map;
      debugPrint(arguments.toString());
      String id = "";
      id = arguments["id"];
      if (id != "") {
        _initValues["title"] = arguments["title"];
        _initValues["id"] = arguments["id"];
        _initValues["imageUrl"] = arguments["imageUrl"];
        _initValues["price"] = arguments["price"].toString();
        _initValues["description"] = arguments["description"];
        _imageUrlController.text = _initValues["imageUrl"];
      }
    }
  }

  @override
  void dispose() {
    _imageURLFocusNode.removeListener(_imageURLFunction);
    _imageURLFocusNode.dispose();
    super.dispose();
  }

  void _imageURLFunction() {
    if (!_imageURLFocusNode.hasFocus) {
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    final _isValid = _formKey.currentState!.validate();
    if (!_isValid) {
      return;
    }
    setState(() {
      _isLoading = true;
    });
    _formKey.currentState!.save();
    if (ModalRoute.of(context)!.settings.arguments != null) {
      Product productChange = new Product(
          id: _initValues["id"],
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl);
      await Provider.of<Products>(context, listen: false)
          .updateProduct(_initValues["id"], productChange);
      Navigator.of(context).pop();
      return;
    }
    try {
      await Provider.of<Products>(context, listen: false).addProduct(product);
      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      print("Error in edit screen: ${error}");
      await showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: Text("Error occured"),
              content: Text("An error is encountered"),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("Okay"))
              ],
            );
          });
    } finally {
      Navigator.of(context).pop();
    }
  }

  /*
  @override
  void dispose() {
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
  }
*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit product"),
        actions: [IconButton(onPressed: _saveForm, icon: Icon(Icons.save))],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Form(
              key: _formKey,
              child: ListView(
                children: [
                  TextFormField(
                    initialValue: _initValues["title"],
                    decoration: InputDecoration(labelText: "Title"),
                    // focusNode: _titleFocusNode,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Provide the title";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      product = Product(
                          id: product.id,
                          title: value.toString(),
                          description: product.description,
                          price: product.price,
                          imageUrl: product.imageUrl);
                    },
                  ),
                  TextFormField(
                    initialValue: _initValues["price"],
                    decoration: InputDecoration(
                      labelText: "Price",
                    ),
                    onSaved: (value) {
                      product = Product(
                          id: product.id,
                          title: product.title,
                          description: product.description,
                          price: double.parse(value.toString()),
                          imageUrl: product.imageUrl);
                    },
                    // focusNode: _priceFocusNode,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please provide a value";
                      }
                      if (double.parse(value) == null) {
                        return "Please give a valid number";
                      }
                      if (double.parse(value) <= 0) {
                        return "Please give a positive number";
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    initialValue: _initValues["description"],
                    decoration: InputDecoration(
                      labelText: "Description",
                    ),
                    onSaved: (value) {
                      product = Product(
                          id: product.id,
                          title: product.title,
                          description: value.toString(),
                          price: product.price,
                          imageUrl: product.imageUrl);
                    },
                    // focusNode: _descriptionFocusNode,
                    maxLines: 3,
                    keyboardType: TextInputType.multiline,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please provide a value";
                      }
                      if (value.length < 5) {
                        return "The minimum character is 5";
                      }
                      return null;
                    },
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        margin:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.grey)),
                        child: _imageUrlController.text.isEmpty
                            ? Text("Enter a url")
                            : FittedBox(
                                child: Image.network(
                                  _imageUrlController.text,
                                  fit: BoxFit.cover,
                                ),
                              ),
                      ),
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(labelText: "Image URL"),
                          keyboardType: TextInputType.url,
                          textInputAction: TextInputAction.done,
                          controller: _imageUrlController,
                          focusNode: _imageURLFocusNode,
                          onSaved: (value) {
                            product = Product(
                                id: product.id,
                                title: product.title,
                                description: product.description,
                                price: product.price,
                                imageUrl: value.toString());
                          },
                          onFieldSubmitted: (_) {
                            _saveForm();
                          },
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
