import 'dart:io';


import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:groceryvendor/provider/product_provider.dart';
import 'package:groceryvendor/screens/login_screen.dart';
import 'package:groceryvendor/service/firebase_service.dart';
import 'package:groceryvendor/widget/banner_widget.dart';

import 'package:provider/provider.dart';
//import 'package:firebase/firebase.dart' as fb;


class BannerScreen extends StatefulWidget {

  static const String id = 'app-banner-screen';

  @override
  _BannerScreenState createState() => _BannerScreenState();

}

class _BannerScreenState extends State<BannerScreen> {



  FirebaseServices _services = FirebaseServices();
  File _image;


  Future<String> uploadFile(filePath) async {
    File file = File(filePath);
    FirebaseStorage _storage = FirebaseStorage.instance;
    final dateTime = DateTime.now();


    try {
      await _storage.ref('VendorBanners/${dateTime}').putFile(file);
    } on FirebaseException catch (e) {
      print(e.code);
      // e.g, e.code == 'canceled'
    }

    String downloadURL = await _storage.ref('VendorBanners/${dateTime}')
        .getDownloadURL();

    return downloadURL;
  }




  @override
  Widget build(BuildContext context) {
    var  _productprovider= Provider.of<ProductProvider>(context);



    return Scaffold(
      backgroundColor: Colors.white,


      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Text(
                'Banner',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 36,
                ),
              ),
              Text('Add or Delete Banner Images From here'),
              Divider(
                thickness: 5,
              ),

              BannerWidget(),

              Divider(
                thickness: 5,
              ),

          InkWell(
              onTap:(){

                _productprovider.getProductImage().then((image){
                  setState(() {
                    _image=image;
                  });
                });

              },
              child:SizedBox(
                height: 200,
                width: MediaQuery.of(context).size.width,
                child: Card(
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: _image==null?Center(child: Text('Add Shop Image' , style: TextStyle(color: Colors.grey),)):Image.file(_image , fit: BoxFit.fill,)),
                ),
              )
          ),
              Divider(
                thickness: 5,
              ),
              FlatButton(onPressed: (){
                EasyLoading.show(status: 'Saving...');

                uploadFile(_image.path).then((url){
                  if(url!=null) {
                    EasyLoading.dismiss();
                    _services.saveVendorBannerImage(url ,_productprovider.shopName);
                    _productprovider.Alertdialog(title: 'Image Uploaded' , message: 'image is uploaded' ,context: context);

                    setState(() {
                      _image=null;
                    });




                  }}

                  );
              },
                  color: Theme.of(context).primaryColor,

                  child: Center(child: Text('Upload Image' , style: TextStyle(color: Colors.white),)))



            ],
          ),
        ),
      ),
    );
  }






}
