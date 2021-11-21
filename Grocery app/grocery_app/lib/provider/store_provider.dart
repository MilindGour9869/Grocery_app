import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:groceryapp/screens/welcome_screen.dart';
import 'package:groceryapp/services/store_service.dart';
import 'package:groceryapp/services/user_services.dart';

class StoreProvider extends ChangeNotifier{
  User user = FirebaseAuth.instance.currentUser;
  UserServices _userServices = UserServices();

  StoreService _storeService = StoreService();
  var userLatitude=0.0;
  var userLongitude =0.0;



  DocumentSnapshot document;


  getSelectedShop(storeSnap){
  this.document = storeSnap;
  notifyListeners();

  }


  Future<void> getUserLocation(context)async{

    _userServices.getUserById(user.uid).then((result){
      if(user!=null)
      {
        userLatitude=result['latitude'];
        userLongitude=result['longitude'];
        notifyListeners();
      }
      else
      {
        print('null user found , going to welcomescreen');
        Navigator.pushReplacementNamed(context, Welcomescreen.id);
      }
  });
}}