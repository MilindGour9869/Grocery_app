import 'dart:io';

import 'package:flutter/material.dart';
import 'package:groceryvendor/provider/auth_provider.dart';
import 'package:image_picker/image_picker.dart';

import 'package:provider/provider.dart';

// with null safety
//class ShopPicCard extends StatefulWidget {
////  late XFile? _image;
//
//  @override
//  _ShopPicCardState createState() => _ShopPicCardState();
//}
//
//class _ShopPicCardState extends State<ShopPicCard> {
//  final ImagePicker _picker = ImagePicker();
//  XFile _image;
//
//  String  _pickImageError='';
//
//  set _imageFile(XFile value) {
//    _image = value == null ? null : value;
//  }
//
//  void _onImageButtonPressed(ImageSource source,
//      {BuildContext context, bool isMultiImage = false}) async {
//    try {
//      final pickedFile = await _picker.pickImage(
//        source: ImageSource.gallery,
//
//        imageQuality: 100,
//
//
//      );
//      setState(() {
//        _imageFile = pickedFile;
//      });
//    } catch (e) {
//      setState(() {
//        _pickImageError = e.toString();
//      });
//    }
//
//
//}
//
//
//Widget previewImages()
//{
//  if (_image!= null) {
//    return Image.file(File(_image.path ) , fit: BoxFit.fill,);
//  }
//  else
//    {
//      return Center(child: Text('Add Shop Image' , style: TextStyle(color: Colors.grey),));
//    }
//}
//  @override
//Widget build(BuildContext context) {
//  return InkWell(
//    onTap: ()
//    {
//      _onImageButtonPressed(ImageSource.gallery  , context: context );
//    },
//
//    child: SizedBox(
//      height: 200,
//      width: 200,
//      child: Card(
//        child: ClipRRect(
//            borderRadius: BorderRadius.circular(4),
//            child: previewImages()),
//      ),
//    ),
//  );
//}
//}

// without null safety
class ImagePicker extends StatefulWidget {

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
        height: 150,
        width: 150,
        child: Card(
          child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: _image==null?Center(child: Text('Add Shop Image' , style: TextStyle(color: Colors.grey),)):Image.file(_image , fit: BoxFit.fill,)),
        ),
      )
    );
  }
}












