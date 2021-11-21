import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';


class ProductProvider extends ChangeNotifier{

  String selectedCategory = 'no selected';
  String selectedSubCategory = 'no selected';
  String categoryImage='';
  String shopName;
  String  productUrl;
  File image;
  String picImageError = '';



  Future<String> getCategoryImage(cat) async
  { CollectionReference category =  await FirebaseFirestore.instance.collection('category');


   DocumentSnapshot snapshot = await category.doc(cat).get();
     return snapshot['image'].toString();
  }


  ResetData()
  {
    this.selectedCategory = null;
    this.selectedSubCategory =null;
    this.categoryImage=null;
    this.shopName = null;
    this.productUrl = null;
    this.image =null;
    this.picImageError = null;
  }








  SelecteCategory(mainCategory , categoryimage)
  {
    this.selectedCategory=mainCategory;
    this.categoryImage=categoryimage;

    notifyListeners();
  }

  SelecteSubCategory(selected)
  {
    this.selectedSubCategory=selected;
    notifyListeners();
  }

  ShopName(selected)
  {
    this.shopName=selected;
    notifyListeners();
  }

  Future<File> getProductImage() async {
    final picker = ImagePicker();
    final pickedFile = await  picker.pickImage(source: ImageSource.gallery , imageQuality: 20);

    if(pickedFile.path!=null)
    {
      this.image = File(pickedFile.path);
      notifyListeners();
    }
    else
    {
      this.picImageError = 'no image selected';
      print('no img');
      notifyListeners();
    }

    return this.image;






  }

  Alertdialog({context , title ,  message})
  {
    showDialog(
        context: context,

        builder: (BuildContext context)
        {
          return AlertDialog(
            title: Text(title),
            content: SingleChildScrollView(
              child: ListBody(
                children:  <Widget>[
                  Text(message),

                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child:  Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }


  Future<String> uploadProductImage(filePath,productName) async {
    File file = File(filePath);
    var timeStamp = Timestamp.now().microsecondsSinceEpoch;
    FirebaseStorage _storage = FirebaseStorage.instance;

    try {
      await _storage.ref('ProductImages/${this.shopName}/${productName}${timeStamp}').putFile(file);
    } on FirebaseException catch (e) {
      print(e.code);
      // e.g, e.code == 'canceled'
    }

    String downloadURL = await _storage.ref('ProductImages/${this.shopName}/${productName}${timeStamp}')
        .getDownloadURL();

    this.productUrl=downloadURL;

    return downloadURL;
  }


  Future<void> saveProductDataToDb(
  { productName , description, price, comparedPrice,
    collection, brand, sku, weight,
    tax, stockQty , lowStockqty , context //12intotal
  } )
  async{
    var timeStamp = Timestamp.now().microsecondsSinceEpoch;
    User user = FirebaseAuth.instance.currentUser;
    CollectionReference _products = FirebaseFirestore.instance.collection('products');

    try{
      _products.doc(timeStamp.toString()).set({
        'seller' :{
          'shopName':this.shopName,
          'sellerUid': user.uid,
        },

        'category':{
          'mainCategory':this.selectedCategory ,
          'subCategory':this.selectedSubCategory,
          'categoryImage':this.categoryImage,
        },

        'productName':productName,
        'description':description,
        'price':price,
        'comparedPrice':comparedPrice,
        'collection':collection,
        'brand':brand,
        'sku':sku,
        'weight':weight,
        'tax':tax,
        'stockQty':stockQty,
        'lowStockQty':lowStockqty,

        'published':false,
        'productID':timeStamp.toString(),
        'productUrl':this.productUrl,





      });
      this.Alertdialog(
        title: 'Saved Data to DB',
        message: 'Data Saved',
        context: context,
      );
    }
    catch(e)
    { this.Alertdialog(
      title: 'error',
      message: 'Data Upload issue',
      context: context,
    );
      print(e);
    }

  }

  Future<void> updateProductDataToDb(
      { productName , description, price, comparedPrice,
        collection, brand, sku, weight,
        tax, stockQty , lowStockqty , context ,
        productUrl , productID , category , subcategory ,
        categoryimage,

      } )
  async{

    User user = FirebaseAuth.instance.currentUser;
    CollectionReference _products = FirebaseFirestore.instance.collection('products');

    try{
      _products.doc(productID).update({
        'seller' :{
          'shopName':this.shopName,
          'sellerUid': user.uid,
        },

        'category':{
          'mainCategory':category ,
          'subCategory':subcategory,
          'categoryImage':categoryimage,
        },

        'productName':productName,
        'description':description,
        'price':price,
        'comparedPrice':comparedPrice,
        'collection':collection,
        'brand':brand,
        'sku':sku,
        'weight':weight,
        'tax':tax,
        'stockQty':stockQty,
        'lowStockQty':lowStockqty,

        'published':false,
        'productID':productID,
        'productUrl':productUrl,





      });
      this.Alertdialog(
        title: ' Data Updated ',
        message: 'Data Updated & Saved to DB',
        context: context,
      );
    }
    catch(e)
    { this.Alertdialog(
      title: 'error',
      message: 'Data Upload issue',
      context: context,
    );
    print(e);
    }

  }
}