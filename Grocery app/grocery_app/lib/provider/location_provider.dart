import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
class LocationProvider with ChangeNotifier{

   static double Longitude;
 static   double Latitude;
   bool permissionallowed =false;
  static var selectedAddress ;




   bool loading = false;//8 900






         Future<void> getCurrentPosition() async {
            Position position = await Geolocator.getCurrentPosition(
                desiredAccuracy: LocationAccuracy.high);
            if (position != null) {
               Longitude = position.longitude;

               Latitude = position.latitude;
               //8 800
               final coordinates = new Coordinates(
                   LocationProvider.Latitude, LocationProvider.Longitude);



               final addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
               selectedAddress = addresses.first;

               permissionallowed = true;

               notifyListeners();
               print('\n getcurrentposition completed');
            }
            else {
               print('\n permission error \n');
            }
         }





   void onCameraMove(CameraPosition cameraPosition){

      LocationProvider.Latitude = cameraPosition.target.latitude;

      LocationProvider.Longitude = cameraPosition.target.longitude;
    print('on camera move \n');
    notifyListeners();
   }

   Future<void> getCameraMove()async{
      final coordinates = new Coordinates(LocationProvider.Latitude, LocationProvider.Longitude);
      print('\n');
      print(coordinates);
      print('\n getcameramove');
      print(Longitude);
      print('\n');
      final addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
      selectedAddress = addresses.first;
      notifyListeners();
      print('\n seletedaddess');
      print("${selectedAddress.featureName} : ${selectedAddress.addressLine}");
   }

  Future<void> savePrefs() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble('latitude', LocationProvider.Latitude);
    prefs.setDouble('longitude', LocationProvider.Longitude);
    prefs.setString('address', LocationProvider.selectedAddress.addressLine);
    prefs.setString('location', LocationProvider.selectedAddress.featureName);

  }




}