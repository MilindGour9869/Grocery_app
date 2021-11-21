import 'dart:io';

import 'package:ars_dialog/ars_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:grocerywebadminapp/app_provider/auth_provider.dart';
import 'package:grocerywebadminapp/app_widgets/image_picker.dart';
import 'package:grocerywebadminapp/screen/login_screen.dart';
import 'package:grocerywebadminapp/services/firebase_service.dart';
import 'package:grocerywebadminapp/services/side_bar.dart';
import 'package:grocerywebadminapp/widgets/banner_widget.dart';
import 'package:provider/provider.dart';
//import 'package:firebase/firebase.dart' as fb;


class AppBannerScreen extends StatefulWidget {

  static const String id = 'app-banner-screen';

  @override
  _AppBannerScreenState createState() => _AppBannerScreenState();

}

class _AppBannerScreenState extends State<AppBannerScreen> {


  SideBarWidget _sideBar = SideBarWidget();
  ImagePicker image = ImagePicker();
  FirebaseServices _services = FirebaseServices();


  Future<String> uploadFile(filePath) async {
    File file = File(filePath);
    FirebaseStorage _storage = FirebaseStorage.instance;
        final dateTime = DateTime.now();
    final path = 'bannerImage/$dateTime';

    try {
      await _storage.ref('bannerImage/${path}').putFile(file);
    } on FirebaseException catch (e) {
      print(e.code);
      // e.g, e.code == 'canceled'
    }

    String downloadURL = await _storage.ref('bannerImage/${path}')
        .getDownloadURL();

    return downloadURL;
  }




  @override
  Widget build(BuildContext context) {
    final _authData = Provider.of<AuthProvider>(context);

    ProgressDialog progressDialog = ProgressDialog(context,
        message:Text("LOADING..."),
        title:Text("please wait")
    );

    return AdminScaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [
          RaisedButton(
            onPressed: () {
              FirebaseAuth.instance.signOut().then((value) {
                Navigator.pushReplacementNamed(context, LoginScreen.id);
              });
            },
            child: Center(child: Text('Sign Out' , style: TextStyle(color: Colors.grey ))),

          ),

        ],
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Colors.black87,
        title: const Text('Grocery App Admin Panel' , style: TextStyle(color: Colors.white),),

      ),
      sideBar: _sideBar.sideBarMenu(context, AppBannerScreen.id) ,
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
              Text('Add or Delete Banner Images in homescreen'),
              Divider(
                thickness: 5,
              ),

              BannerWidget(),

              Divider(
                thickness: 5,
              ),

              ImagePicker(),
              Divider(
                thickness: 5,
              ),
              FlatButton(onPressed: (){
                    progressDialog.show();

                    uploadFile(_authData.image.path).then((url){
                      if(url!=null) {
                        progressDialog.dismiss();
                        _services.uploadBannerImageToDb(url).then((value) {
                          _services.showMyDialog(title: 'Image Uploaded' , message: 'image is uploaded' ,context: context);
                        });

                      }});
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
