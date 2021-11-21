import 'package:cloud_firestore/cloud_firestore.dart';

class StoreService {

  getTopPickedStore() {
    return FirebaseFirestore.instance.collection('vendors').where(
        'accverified', isEqualTo: true).where('isTopPicked' ,isEqualTo: true).where('shopOpen',isEqualTo: true).orderBy('shopName').snapshots();
  }

  getNearByStores(){
    return FirebaseFirestore.instance.collection('vendors').where(
        'accverified', isEqualTo: true).orderBy('shopName').snapshots();
  }

  getPaginateNearstores()
  {
    return FirebaseFirestore.instance.collection('vendors').where(
        'accverified', isEqualTo: true).orderBy('shopName');
  }


}