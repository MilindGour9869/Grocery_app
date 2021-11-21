import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:groceryvendor/provider/product_provider.dart';
import 'package:groceryvendor/widget/category_list.dart';
import 'package:provider/provider.dart';

class AddProducts extends StatefulWidget {

  static const String id = 'add-products';

  @override
  State<AddProducts> createState() => _AddProductsState();
}

class _AddProductsState extends State<AddProducts> {

  final _formkey= GlobalKey<FormState>();

  var _categoryTextController = TextEditingController();
  var _subcategoryTextController = TextEditingController();
  var _comparedPriceTextController = TextEditingController();
  var _brandTextController = TextEditingController();
  var _lowStockTextController = TextEditingController();
  var _stockTextController = TextEditingController();

  String productName;
  String description;
  double price;
  double comparedPrice;
  String sku;
  String weight;
  double tax;




  File _image;
  bool _visible = false;
  bool _track = false;

  List<String> collection =[
    'Recently added', 'Featured Product' , 'Best Quality'
  ];

  String dropdownvalue;
  @override
  Widget build(BuildContext context) {
    var _productprovider = Provider.of<ProductProvider>(context);

    return DefaultTabController(
      length: 2,
      initialIndex: 1,//to view inventory first soo that autoclear for texteditingcontroller does work in first place
      child: Scaffold(
        appBar: AppBar(),
        body: Form(
          key: _formkey,
          child: Column(
            children: [
              Material(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Container(
                          child: Text('Products / Add' , style: TextStyle(fontWeight: FontWeight.bold),),
                        ),
                      ),


                      FlatButton.icon(
                        icon: Icon(Icons.save , color: Colors.white,),
                        label:Text('Save' , style: TextStyle(color: Colors.white),),
                        color: Theme.of(context).primaryColor,

                        onPressed: (){

                          if(_formkey.currentState.validate())
                            {
                              if(_categoryTextController.text.isNotEmpty)
                                {
                                  if(_subcategoryTextController.text.isNotEmpty)
                                    {
                                      if(_image!=null)
                                      { EasyLoading.show(status: 'Saving...');
                                      _productprovider.uploadProductImage(_image.path , productName).then((url){
                                        if(url!=null)
                                        { EasyLoading.dismiss();
                                        _productprovider.saveProductDataToDb(

                                          context: context,//1
                                          collection: dropdownvalue,
                                          brand: _brandTextController.text,
                                          comparedPrice: int.parse(_comparedPriceTextController.text),
                                          sku: sku,//5
                                          description: description,
                                          price: price,
                                          productName: productName,
                                          tax: tax,
                                          stockQty: int.parse(_stockTextController.text),//10
                                          lowStockqty: int.parse(_lowStockTextController.text),
                                          weight: weight,//12



                                        );

                                        setState(() {
                                          _formkey.currentState.reset();
                                          _comparedPriceTextController.clear();
                                          _subcategoryTextController.clear();
                                          _categoryTextController.clear();
                                          _brandTextController.clear();
                                          dropdownvalue=null;

                                          _track=false;
                                          _image=null;
                                          _visible=false;

                                          _stockTextController.clear();
                                          _lowStockTextController.clear();

                                        });


                                        }
                                        else
                                        {
                                          _productprovider.Alertdialog(
                                              context: context,
                                              title: 'Data Not Uploaded',
                                              message: 'Upload error'
                                          );
                                        }
                                      });


                                      }
                                      else
                                      {
                                        _productprovider.Alertdialog(
                                            context: context,
                                            title: 'Add Product Image',
                                            message: 'No Product Image selected'
                                        );
                                      }
                                    }
                                  else{
                                    _productprovider.Alertdialog(
                                        context: context,
                                        title: 'subCategory not selected',
                                        message: 'Click edit Icon'
                                    );

                                  }
                                }
                              else
                                {
                                  _productprovider.Alertdialog(
                                      context: context,
                                      title: 'Category not selected',
                                      message: 'Click edit Icon'
                                  );
                                }

                            }

                        },
                      )
                    ],
                  ),
                ),
              ),

              TabBar(
                unselectedLabelColor:Colors.black54 ,
                labelColor:Theme.of(context).primaryColor ,
                indicatorColor: Theme.of(context).primaryColor,
                tabs: [
                  Tab(text: 'PUBLISHED',),
                  Tab(text: 'UNPUBLISHED',)
                ],
              ),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: TabBarView(
                      children: [
                        ListView(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                children: [
                                  TextFormField(
                                    validator:(value)
                                     {
                                       if(value.isEmpty)
                                         {
                                           return 'Enter Product Name';

                                         }

                                       setState(() {
                                         productName = value;
                                       });

                                       return null;
                                     },

                                    decoration: InputDecoration(
                                      labelText: 'Product Name',
                                      labelStyle: TextStyle(color: Colors.grey),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color:Colors.grey[300]
                                        )
                                      )

                                    ),
                                  ),
                                  TextFormField(
                                    validator:(value)
                                    {
                                      if(value.isEmpty)
                                      {
                                        return 'Enter description';

                                      }

                                      setState(() {
                                        description = value;
                                      });

                                      return null;
                                    },
                                    keyboardType: TextInputType.multiline,
                                    maxLines: 2,
                                    maxLength: 50,
                                    decoration: InputDecoration(

                                        labelText: 'About Product',
                                        labelStyle: TextStyle(color: Colors.grey),
                                        enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color:Colors.grey[300]
                                            )
                                        )

                                    ),
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: InkWell(
                                      onTap: (){
                                        _productprovider.getProductImage().then((image) {
                                          setState(() {
                                            _image=image;
                                          });

                                        });

                                      },
                                      child: SizedBox(
                                        height: 150,
                                        width: 150,
                                        child:Card(
                                          child: _image==null?Center(child: Text('Add Shop Image' , style: TextStyle(color: Colors.grey),)):Image.file(_image , fit: BoxFit.fill,),
                                        )

                                      ),
                                    ),
                                  ),

                                  TextFormField(
                                    validator:(value)
                                    {
                                      if(value.isEmpty)
                                      {
                                        return 'Enter Price';

                                      }

                                      setState(() {
                                        price= double.parse(value);
                                      });

                                      return null;
                                    },
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                        labelText: 'Price in Rs',
                                        labelStyle: TextStyle(color: Colors.grey),
                                        enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color:Colors.grey[300]
                                            )
                                        )

                                    ),
                                  ),
                                  TextFormField(
                                    controller: _comparedPriceTextController,
                                    validator:(value)
                                    { if(price>double.parse(value))
                                      {
                                        return 'Compared Price should be Higher';
                                      }

                                      setState(() {
                                        comparedPrice= double.parse(value);
                                      });

                                      return null;
                                    },
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                        labelText: 'Compared Price',
                                        labelStyle: TextStyle(color: Colors.grey),
                                        enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color:Colors.grey[300]
                                            )
                                        )

                                    ),
                                  ),

                                  Container(
                                    child: Row(
                                      children: [
                                        Text('collection' , style: TextStyle(color: Colors.grey), ),
                                        SizedBox(width: 10,),
                                        DropdownButton<String>(items: collection.map<DropdownMenuItem<String>>((String value){
                                          return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value));

                                        }).toList(),
                                          hint: Text('Select Collection'),
                                          value: dropdownvalue,
                                          icon: Icon(Icons.arrow_drop_down_circle),
                                          onChanged: (String value){
                                          setState(() {
                                            dropdownvalue=value;
                                          });
                                          },

                                        )
                                      ],
                                    ),
                                  ),

                                  TextFormField(
                                    controller: _brandTextController,
                                    decoration: InputDecoration(
                                        labelText: 'Brand',
                                        labelStyle: TextStyle(color: Colors.grey),
                                        enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color:Colors.grey[300]
                                            )
                                        )

                                    ),
                                  ),
                                  TextFormField(
                                    validator:(value)
                                    {
                                      if(value.isEmpty)
                                      {
                                        return 'Enter SKU';

                                      }

                                      setState(() {
                                        sku= value;
                                      });

                                      return null;
                                    },
                                    decoration: InputDecoration(
                                        labelText: 'SKU',
                                        labelStyle: TextStyle(color: Colors.grey),
                                        enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color:Colors.grey[300]
                                            )
                                        )

                                    ),
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Text('catergory' , style: TextStyle(color: Colors.grey , fontSize: 16),),
                                        SizedBox(width: 10,),
                                        Expanded(
                                          child: AbsorbPointer(
                                            absorbing: true,
                                            child: TextFormField(
                                              controller: _categoryTextController,
                                              validator:(value)
                                              {
                                                if(value.isEmpty)
                                                {
                                                  return 'Enter Category Name';

                                                }
                                                return null;
                                              },
                                              decoration: InputDecoration(
                                                  hintText: 'not selected',
                                                  labelStyle: TextStyle(color: Colors.grey),
                                                  enabledBorder: UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color:Colors.grey[300]
                                                      )
                                                  )

                                              ),
                                            ),
                                          ),
                                        ),
                                        IconButton(onPressed: (){
                                          showDialog(context: context,
                                              builder: (BuildContext context){
                                            return CategoryList();
                                              }).whenComplete((){
                                                setState(() {
                                                  _categoryTextController.text=_productprovider.selectedCategory;
                                                  _visible=true;
                                                });
                                          });

                                        }, icon:Icon(Icons.edit_outlined)),

                                      ],
                                    ),
                                  ),
                                  Visibility(
                                    visible: _visible,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Text('SubCatergory' , style: TextStyle(color: Colors.grey , fontSize: 16),),
                                          SizedBox(width: 10,),
                                          Expanded(
                                            child: AbsorbPointer(
                                              absorbing: true,
                                              child: TextFormField(
                                                controller: _subcategoryTextController,
                                                validator:(value)
                                                {
                                                  if(value.isEmpty)
                                                  {
                                                    return 'Enter SubCategory Name';

                                                  }
                                                  return null;
                                                },
                                                decoration: InputDecoration(
                                                    hintText: 'not selected',
                                                    labelStyle: TextStyle(color: Colors.grey),
                                                    enabledBorder: UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color:Colors.grey[300]
                                                        )
                                                    )

                                                ),
                                              ),
                                            ),
                                          ),
                                          IconButton(onPressed: (){
                                            print('weedjje');
                                            print(_categoryTextController);

                                            if(_categoryTextController.text.isEmpty)
                                              { print('in if');
                                              }
                                            showDialog(context: context,
                                                builder: (BuildContext context){
                                                  return SubCategoryList();
                                                }).whenComplete((){
                                              setState(() {
                                                _subcategoryTextController.text=_productprovider.selectedSubCategory;
                                              });
                                            });

                                          }, icon:Icon(Icons.edit_outlined)),

                                        ],
                                      ),
                                    ),
                                  ),

                                  TextFormField(
                                    validator:(value)
                                    {
                                      if(value.isEmpty)
                                      {
                                        return 'Enter Weight';

                                      }

                                      setState(() {
                                        weight= value;
                                      });

                                      return null;
                                    },
                                    decoration: InputDecoration(
                                        labelText: 'Weight in kg/gm',
                                        labelStyle: TextStyle(color: Colors.grey),
                                        enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color:Colors.grey[300]
                                            )
                                        )

                                    ),
                                  ),
                                  TextFormField(
                                    validator:(value)
                                    {
                                      if(value.isEmpty)
                                      {
                                        return 'Enter Tax Percentage';

                                      }

                                      setState(() {
                                        tax= double.parse(value);
                                      });

                                      return null;
                                    },
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                        labelText: 'Tax %',
                                        labelStyle: TextStyle(color: Colors.grey),
                                        enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color:Colors.grey[300]
                                            )
                                        )

                                    ),
                                  ),



                                ],
                              ),
                            )
                          ],
                        ),

                        SingleChildScrollView(
                          child: Column(
                            children: [
                              SwitchListTile(

                                value: _track,

                                onChanged: (selected){
                                  setState(() {
                                    _track=!_track;
                                  });
                                },
                                title: Text('Track Inventory'),
                                activeColor: Theme.of(context).primaryColor,
                                subtitle: Text('Switch ON to track Inventory',
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12
                                  ),),

                              ),

                              Visibility(
                                visible: _track,
                                child: SizedBox(
                                  height: 300,
                                  width: double.infinity,
                                  child: Column(
                                    children: [
                                      TextFormField(
                                        controller:_stockTextController,
                                        validator:(value)
                                        {
                                          if(value.isEmpty)
                                          {
                                            return 'Enter Stock Quantity';

                                          }



                                          return null;
                                        },
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                            labelText: 'Inventory Quantity',
                                            labelStyle: TextStyle(color: Colors.grey),
                                            enabledBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color:Colors.grey[300]
                                                )
                                            )

                                        ),
                                      ),
                                      TextFormField(
                                        controller: _lowStockTextController,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                            labelText: 'Inventory low stock quantity',
                                            labelStyle: TextStyle(color: Colors.grey),
                                            enabledBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color:Colors.grey[300]
                                                )
                                            )

                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),



            ],
          ),
        ),
      ),
    );
  }
}
