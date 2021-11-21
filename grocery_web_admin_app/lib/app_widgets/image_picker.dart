import 'dart:io';

import 'package:flutter/material.dart';
import 'package:grocerywebadminapp/app_provider/auth_provider.dart';
import 'package:image_picker/image_picker.dart';

import 'package:provider/provider.dart';


class ImagePicker extends StatefulWidget {
  File imagepicker;
  void removeimage(File img){
    this.imagepicker = img;

  }



  @override
  State<ImagePicker> createState() => _ImagePickerState();
}

class _ImagePickerState extends State<ImagePicker> {


  File _image;






  @override
  Widget build(BuildContext context) {




    final _authData = Provider.of<AuthProvider>(context);
    return InkWell(
        onTap:(){
          _authData.getImage().then((image) {

            setState(() {
              _image=image;
            });







            if(image!=null)
              _authData.isPicAvail=true;
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
    );



  }


}












