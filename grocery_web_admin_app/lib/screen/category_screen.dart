import 'dart:io';

import 'package:ars_dialog/ars_dialog.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:grocerywebadminapp/app_provider/auth_provider.dart';
import 'package:grocerywebadminapp/app_widgets/image_picker.dart';
import 'package:grocerywebadminapp/services/firebase_service.dart';
import 'package:grocerywebadminapp/services/side_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:grocerywebadminapp/screen/login_screen.dart';
import 'package:grocerywebadminapp/widgets/category/category_list_widget.dart';
import 'package:provider/provider.dart';

class CategoryScreen extends StatefulWidget {

  static const String id = 'category-screen';


  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {

  SideBarWidget _sideBar = SideBarWidget();
  ImagePicker image = ImagePicker();

  FirebaseServices _services = FirebaseServices();
  var _catNameController = TextEditingController();




  Future<String> uploadFile(filePath) async {
    File file = File(filePath);
    FirebaseStorage _storage = FirebaseStorage.instance;
    final dateTime = DateTime.now();
    final path = 'CategoryImage/$dateTime';

    try {
      await _storage.ref('CategoryImage/${path}').putFile(file);
    } on FirebaseException catch (e) {
      print(e.code);
      // e.g, e.code == 'canceled'
    }

    String downloadURL = await _storage.ref('CategoryImage/${path}')
        .getDownloadURL();

    return downloadURL;
  }



  @override
  Widget build(BuildContext context) {

    ProgressDialog progressDialog = ProgressDialog(context,
        message:Text("LOADING..."),
        title:Text("please wait")
    );

    final _authData = Provider.of<AuthProvider>(context);

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
        title: const Text('Grocery App Admin Panel'  ,style: TextStyle(color: Colors.white),

      )),
      sideBar: _sideBar.sideBarMenu(context, CategoryScreen.id) ,
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Text(
                'Category',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 36,
                ),
              ),
              Text('Add New Category Products to cloud...'),
              Divider(
                thickness: 5,
              ),
              ImagePicker(),
              Divider(
                thickness: 5,
              ),
          TextFormField(
            controller: _catNameController,
            validator: (value){
              if(value==null ||value.isEmpty )
              {
                return 'Enter Category Name';

              }
              setState(() {
                _catNameController.text=value;

              });



              return null;
            },
            decoration: InputDecoration(

              labelText:'Category Name',
              enabledBorder: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 2,
                  color: Theme.of(context).primaryColor,
                ),

              ),

              focusColor: Theme.of(context).primaryColor,
            ),
          ),

              FlatButton(onPressed: (){
                if(_catNameController.text.isEmpty)
                {
                  return  _services.showMyDialog(
                      title: 'Category Name not given',
                      context: context,
                      message: 'Add Category Name'
                  );
                }
                progressDialog.show();

                uploadFile(_authData.image.path).then((url){
                  if(url!=null) {
                    progressDialog.dismiss();


                    _services.uploadCategoryImageToDb(url, _catNameController.text).then((value) {
                      print(_catNameController.text);

                      _services.showMyDialog(title: 'Image Uploaded' , message: 'image is uploaded' ,context: context);


                    });
                    _catNameController.clear();
                    image.removeimage(_authData.image);
                    setState(() {});





                  }});

              },
                  color: Theme.of(context).primaryColor,

                  child: Center(child: Text('Upload Image' , style: TextStyle(color: Colors.white),))),

              CategoryListWidget(),


            ],
          ),
        ),
      ),
    );
  }
}
