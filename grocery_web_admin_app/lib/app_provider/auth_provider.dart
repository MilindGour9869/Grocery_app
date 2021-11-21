


import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:image_picker/image_picker.dart';


class AuthProvider extends ChangeNotifier {


  File image;
  String picImageError = '';
  bool isPicAvail = false;





  Future<File> getImage() async {
    final picker = ImagePicker();
    final pickedFile = await  picker.pickImage(source: ImageSource.gallery , imageQuality: 20);

    if(pickedFile.path!=null)
    { print('nkszx');
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





}













