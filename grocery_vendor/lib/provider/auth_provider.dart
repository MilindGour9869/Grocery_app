


import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:geocoder/geocoder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';

class AuthProvider extends ChangeNotifier {

  double shopLatitude;
  double shopLongitude;
  String shopAddress;
  String placeName;

  File image;
  String picImageError = '';
  bool isPicAvail = false;

  String emailerror ;
  String email;



  Future<File> getImage() async {
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



Future getCurrentLoaction() async{
  Location location = new Location();

  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;

  _serviceEnabled = await location.serviceEnabled();
  if (!_serviceEnabled) {
    _serviceEnabled = await location.requestService();
    if (!_serviceEnabled) {
      return;
    }
  }

  _permissionGranted = await location.hasPermission();
  if (_permissionGranted == PermissionStatus.denied) {
    _permissionGranted = await location.requestPermission();
    if (_permissionGranted != PermissionStatus.granted) {
      return;
    }
  }

  _locationData = await location.getLocation();
  this.shopLatitude = _locationData.latitude;
  this.shopLongitude = _locationData.longitude;
  notifyListeners();

  final coordinates = new Coordinates(_locationData.latitude, _locationData.longitude);
  var _addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
  var shopaddress = _addresses.first;
  this.shopAddress = shopaddress.addressLine;
  this.placeName = shopaddress.featureName;
  notifyListeners();
  return shopaddress;



}


Future<UserCredential> VendorRegistration (email,password )async{
    this.email =email;
    notifyListeners();
  UserCredential userCredential;
  try {
     userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password
    );
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      this.emailerror ='The password provided is too weak.';
      notifyListeners();
      print('The password provided is too weak.');
    } else if (e.code == 'email-already-in-use') {
      this.emailerror = 'The account already exists for that email.';
      notifyListeners();
      print('The account already exists for that email.');
    }
  } catch (e) {
    this.emailerror = e.toString();
    notifyListeners();
    print(e);
  }

  return userCredential;

}

Future<UserCredential> loginVendor (email,password )async{
    this.email =email;
    notifyListeners();
    UserCredential userCredential;
    try {
      userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password
      );
    } on FirebaseAuthException catch (e) {
      this.emailerror = e.code;
      notifyListeners();
    } catch (e) {
      this.emailerror = e.code;
      notifyListeners();
      print(e);
    }

    return userCredential;

  }

  Future<UserCredential> resetPassword (email )async{
    this.email =email;
    notifyListeners();
    UserCredential userCredential;
    try {
     await FirebaseAuth.instance.sendPasswordResetEmail(
          email: email,

      );
    } on FirebaseAuthException catch (e) {
      this.emailerror = e.code;
      notifyListeners();
    } catch (e) {
      this.emailerror = e.code;
      notifyListeners();
      print(e);
    }

    return userCredential;

  }

Future<void> saveVendorDataToDb({String url , String mobile , String Shopname , String Dialog}) {
    User user = FirebaseAuth.instance.currentUser;
    DocumentReference _vendors = FirebaseFirestore.instance.collection('vendors').doc(user.uid);

    _vendors.set(
      {
       'uid':user.uid,
        'accverified' : true,
        'shopName' : Shopname ,
        'mobile' : mobile,
        'ImageUrl' : url,
        'email' : this.email,
        'dialog':Dialog,
        'address' : '${this.shopAddress} ${this.placeName}' ,
        'location' : GeoPoint(this.shopLatitude , this.shopLongitude) ,
        'shopOpen' : true ,
        'rating' :0.0,
        'totalRating' : 0,
        'isTopPicked' : true,

      }
    );
return null;
}



}













