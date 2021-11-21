import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseServices{

  CollectionReference category = FirebaseFirestore.instance.collection('category');
  CollectionReference products = FirebaseFirestore.instance.collection('products');
  CollectionReference vendorBanner = FirebaseFirestore.instance.collection('vendorBanner');

  Future<void>publishProduct({id , value}){
    products.doc(id).update({
      'published' : value=='Publish'?true:false,
    });
  }


  Future<void>DeleteProduct({id , value}){
    products.doc(id).delete();
  }

  Future<void>DeleteVendorBannerImage({id}){
    vendorBanner.doc(id).delete();
  }

  Future<void>saveVendorBannerImage(url , shopName){
    vendorBanner.add({
      'image' : url,
      'shopName' : shopName,

    });
  }

}