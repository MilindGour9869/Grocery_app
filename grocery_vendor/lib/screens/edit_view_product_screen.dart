import 'dart:io';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:groceryvendor/provider/product_provider.dart';
import 'package:groceryvendor/service/firebase_service.dart';
import 'package:groceryvendor/widget/category_list.dart';
import 'package:provider/provider.dart';

class EditViewProduct extends StatefulWidget {
  String productID;
  EditViewProduct(this.productID);
  @override
  _EditViewProductState createState() => _EditViewProductState();
}

class _EditViewProductState extends State<EditViewProduct> {
  FirebaseServices _services = FirebaseServices();

  final _formkey = GlobalKey<FormState>();

  var _categoryText = TextEditingController();
  var _subcategoryText = TextEditingController();
  var _comparedPriceText = TextEditingController();
  var _brandText = TextEditingController();
  var _lowStockText = TextEditingController();
  var _stockText = TextEditingController();
  var _skuText = TextEditingController();
  var _productNameText = TextEditingController();
  var _weightText = TextEditingController();
  var _priceText = TextEditingController();
  var _descriptionText = TextEditingController();
  var _taxText = TextEditingController();

  DocumentSnapshot doc;

  double discount = 12.0;
  String image;
  File _image;

  bool edit = true;
  String dropdownvalue;
  bool _visible = false;
  String categoryImage;

  List<String> collection = [
    'Recently added',
    'Featured Product',
    'Best Quality'
  ];

  @override
  void initState() {
    getProductDetails();
    // TODO: implement initState
    super.initState();
  }

  Future<void> getProductDetails() async {
    _services.products
        .doc(widget.productID)
        .get()
        .then((DocumentSnapshot document) {
      if (document.exists) {
        setState(() {
          doc = document;
          _brandText.text = document['brand'];
          _productNameText.text = document['productName'];
          _skuText.text = document['sku'];
          _weightText.text = document['weight'];
          _priceText.text = document['price'].toString();
          _comparedPriceText.text = document['comparedPrice'].toString();
          var diff = int.parse(_comparedPriceText.text) - double.parse(_priceText.text);
          discount = (diff / int.parse(_comparedPriceText.text)*100);
          image = document['productUrl'];
          _descriptionText.text = document['description'];
          _categoryText.text = document['category']['mainCategory'];
          _subcategoryText.text = document['category']['subCategory'];
          dropdownvalue = document['collection'];
          _stockText.text = document['stockQty'].toString();
          _lowStockText.text = document['lowStockQty'].toString();
          _taxText.text = document['tax'].toString();
        });

        print(document['brand']);
      } else {
        print('in esle');
      } //
    });
  }

  @override
  Widget build(BuildContext context) {
    var _productprovider = Provider.of<ProductProvider>(context);


    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(
              Icons.edit_outlined,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() { edit = false;});
            },
          ),

        ],
      ),
      bottomSheet: Container(
        height: 60,
        child: Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  color: Colors.black87,
                  child: Center(
                      child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.white),
                  )),
                ),
              ),
            ),
            Expanded(
              child: AbsorbPointer(
                absorbing: edit,
                child: InkWell(
                  onTap: () async {
                    if (_formkey.currentState.validate()) {
                      EasyLoading.show(status: 'Updating..');
                      print(_categoryText.text);
                      categoryImage = await _productprovider
                          .getCategoryImage(_categoryText.text);

                      print(categoryImage);
                      if (_image != null) {
                        EasyLoading.dismiss();
                        _productprovider
                            .uploadProductImage(
                                _image.path, _productNameText.text)
                            .then((url) {
                          if (url != null) {
                            _productprovider.updateProductDataToDb(
                                context: context, //1
                                collection: dropdownvalue,
                                brand: _brandText.text,
                                comparedPrice: int.parse(_comparedPriceText.text),
                                sku: _skuText.text, //5
                                description: _descriptionText.text,
                                price: _priceText.text,
                                productName: _productNameText.text,
                                tax: _taxText.text,
                                stockQty: int.parse(_stockText.text), //10
                                lowStockqty: int.parse(_lowStockText.text),
                                weight: _weightText.text, //12

                                productUrl: url,
                                productID: widget.productID,
                                category: _categoryText.text,
                                subcategory: _subcategoryText.text,
                                categoryimage: categoryImage);
                          }
                        });
                      } else {
                        EasyLoading.dismiss();

                        _productprovider.updateProductDataToDb(
                            context: context, //1
                            collection: dropdownvalue,
                            brand: _brandText.text,
                            comparedPrice: int.parse(_comparedPriceText.text),
                            sku: _skuText.text, //5
                            description: _descriptionText.text,
                            price: _priceText.text,
                            productName: _productNameText.text,
                            tax: _taxText.text,
                            stockQty: int.parse(_stockText.text), //10
                            lowStockqty: int.parse(_lowStockText.text),
                            weight: _weightText.text, //12

                            productUrl: image,
                            productID: widget.productID,
                            category: _categoryText.text,
                            subcategory: _subcategoryText.text,
                            categoryimage: categoryImage);
                      }

                      setState(() {
                        _formkey.currentState.reset();
                      });
                      _productprovider.ResetData();
                    }
                  },
                  child: AbsorbPointer(
                    absorbing: edit,
                    child: Container(
                      color: Theme.of(context).primaryColor,
                      child: Center(
                          child: Text(
                        'Save',
                        style: TextStyle(color: Colors.white),
                      )),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      body: doc == null
          ? Center(child: CircularProgressIndicator())
          : Form(
              key: _formkey,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: ListView(
                  children: [
                    AbsorbPointer(
                      absorbing: edit,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                  height: 30,
                                  width: 80,
                                  child: TextFormField(
                                    controller: _brandText,
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                    decoration: InputDecoration(
                                      contentPadding:
                                          EdgeInsets.only(left: 10, right: 10),
                                      hintText: 'Brand',
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: OutlineInputBorder(),
                                      fillColor: Theme.of(context)
                                          .primaryColor
                                          .withOpacity(.2),
                                      filled: true,
                                    ),
                                  )),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('SKU : '),
                                  Container(
                                    width: 50,
                                    child: TextFormField(
                                      controller: _skuText,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.zero,
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                          SizedBox(
                            height: 20,
                            child: TextFormField(
                              controller: _productNameText,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 30),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.zero,
                                border: InputBorder.none,
                              ),
                            ),
                          ),

                          SizedBox(
                            height: 30,
                            child: TextFormField(
                              controller: _weightText,
                              style: TextStyle(fontSize: 20),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.zero,
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 80,
                                child: TextFormField(
                                  controller: _priceText,
                                  style: TextStyle(fontSize: 16),
                                  decoration: InputDecoration(
                                      contentPadding: EdgeInsets.zero,
                                      border: InputBorder.none,
                                      prefixText: 'Rs '),
                                ),
                              ),
                              Container(
                                width: 80,
                                child: TextFormField(
                                  controller: _comparedPriceText,
                                  style: TextStyle(
                                      fontSize: 14,
                                      decoration: TextDecoration.lineThrough),
                                  decoration: InputDecoration(
                                      contentPadding: EdgeInsets.zero,
                                      border: InputBorder.none,
                                      prefixText: 'Rs '),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color: Colors.red,
                                ),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 8.0, right: 8),
                                  child: Text(
                                    '${discount.toStringAsFixed(0)} % OFF',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              )
                            ],
                          ),
                          Text(
                            'Inclusive of all taxes',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),

                          Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                  onTap: () {
                                    _productprovider
                                        .getProductImage()
                                        .then((image) {
                                      setState(() {
                                        _image = image;
                                      });
                                    });
                                  },
                                  child: _image == null
                                      ? Image.network(
                                          image,
                                          height: 300,
                                        )
                                      : Image.file(
                                          _image,
                                          height: 300,
                                        ))),

//                  Padding(
//                    padding: const EdgeInsets.all(8.0),
//                    child: image!=null?Image.network(image , height: 300,):Text('en'),
//                  ),

                          Text(
                            'About Product',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: _descriptionText,
                              style: TextStyle(color: Colors.grey),
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          Container(
                            child: Row(
                              children: [
                                Text(
                                  'collection',
                                  style: TextStyle(color: Colors.grey),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                DropdownButton<String>(
                                  items: collection.map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                        value: value, child: Text(value));
                                  }).toList(),
                                  hint: Text('Select Collection'),
                                  value: dropdownvalue,
                                  icon: Icon(Icons.arrow_drop_down_circle),
                                  onChanged: (String value) {
                                    setState(() {
                                      dropdownvalue = value;
                                    });
                                  },
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Text(
                                  'catergory',
                                  style:
                                      TextStyle(color: Colors.grey, fontSize: 16),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: AbsorbPointer(
                                    absorbing: true,
                                    child: TextFormField(
                                      controller: _categoryText,
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Enter Category Name';
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                          hintText: 'not selected',
                                          labelStyle:
                                              TextStyle(color: Colors.grey),
                                          enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.grey[300]))),
                                    ),
                                  ),
                                ),
                                AbsorbPointer(
                                  absorbing: edit,
                                  child: IconButton(
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return CategoryList();
                                            }).whenComplete(() {
                                          setState(() {
                                            _categoryText.text =
                                                _productprovider.selectedCategory;
                                            _visible = true;
                                          });
                                        });
                                      },
                                      icon: Icon(Icons.edit_outlined)),
                                ),
                              ],
                            ),
                          ),
                          Visibility(
                            visible: _visible,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Text(
                                    'SubCatergory',
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 16),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: AbsorbPointer(
                                      absorbing: true,
                                      child: TextFormField(
                                        controller: _subcategoryText,
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return 'Enter SubCategory Name';
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                            hintText: 'not selected',
                                            labelStyle:
                                                TextStyle(color: Colors.grey),
                                            enabledBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.grey[300]))),
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        print('weedjje');
                                        print(_categoryText);

                                        if (_categoryText.text.isEmpty) {
                                          print('in if');
                                        }
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return SubCategoryList();
                                            }).whenComplete(() {
                                          setState(() {
                                            _subcategoryText.text =
                                                _productprovider
                                                    .selectedSubCategory;
                                          });
                                        });
                                      },
                                      icon: Icon(Icons.edit_outlined)),
                                ],
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Text('Stock : '),
                              Expanded(
                                child: TextFormField(
                                  controller: _stockText,
                                  style: TextStyle(color: Colors.grey),
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.zero,
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text('Stock : '),
                              Expanded(
                                child: TextFormField(
                                  controller: _lowStockText,
                                  style: TextStyle(color: Colors.grey),
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.zero,
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text('Tax % '),
                              Expanded(
                                child: TextFormField(
                                  controller: _taxText,
                                  style: TextStyle(color: Colors.grey),
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.zero,
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 50,),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
