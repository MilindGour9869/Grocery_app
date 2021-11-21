//
//
//
//
//
//
// import 'dart:html';
//import 'package:ars_dialog/ars_dialog.dart';
//import 'package:flutter/material.dart';
//import 'package:flutter_admin_scaffold/admin_scaffold.dart';
//import 'package:grocerywebadminapp/services/firebase_service.dart';
//import 'package:grocerywebadminapp/services/side_bar.dart';
//import 'package:firebase_auth/firebase_auth.dart';
//import 'package:grocerywebadminapp/screen/login_screen.dart';
//import 'package:grocerywebadminapp/widgets/banner_widget.dart';
//import 'package:firebase/firebase.dart' as fb;
//
//class BannerScreen extends StatefulWidget {
//
//  static const String id = 'web-banner-screen';
//
//  @override
//  State<BannerScreen> createState() => _BannerScreenState();
//}
//
//class _BannerScreenState extends State<BannerScreen> {
//  SideBarWidget _sideBar = SideBarWidget();
//  var _fileNameTextController = TextEditingController();
//  bool _imageSelected = true;
//  String _url;
//  FirebaseServices _services = FirebaseServices();
//
//
//
//  @override
//  Widget build(BuildContext context) {
//
//    ProgressDialog progressDialog = ProgressDialog(context,
//        message:Text("LOADING..."),
//        title:Text("please wait")
//    );
//
//
//    return AdminScaffold(
//      backgroundColor: Colors.white,
//      appBar: AppBar(
//        actions: [
//          RaisedButton(
//            onPressed: () {
//              FirebaseAuth.instance.signOut().then((value) {
//                Navigator.pushReplacementNamed(context, LoginScreen.id);
//              });
//            },
//            child: Center(child: Text('Sign Out' , style: TextStyle(color: Colors.grey ))),
//
//          ),
//
//        ],
//        iconTheme: IconThemeData(
//          color: Colors.white,
//        ),
//        backgroundColor: Colors.black87,
//        title: const Text('Grocery App Admin Panel' , style: TextStyle(color: Colors.white),),
//
//      ),
//      sideBar: _sideBar.sideBarMenu(context, BannerScreen.id) ,
//      body: SingleChildScrollView(
//        child: Container(
//          alignment: Alignment.topLeft,
//          padding: const EdgeInsets.all(10),
//          child: Column(
//            children: [
//              Text(
//                'Banner',
//                style: TextStyle(
//                  fontWeight: FontWeight.w700,
//                  fontSize: 36,
//                ),
//              ),
//              Text('Add or Delete Banner Images in homescreen'),
//              Divider(
//                thickness: 5,
//              ),
//
//              BannerWidget(),
//
//              Divider(
//                thickness: 5,
//              ),
//              Container(
//                color: Colors.grey,
//                width: MediaQuery.of(context).size.width,
//                height: 105,
//                child: Column(
//
//                  children: [
//                    SizedBox(height: 5,),
//                    AbsorbPointer(
//                      absorbing: true,
//                      child: SizedBox(
//                          width :300,
//                          child: TextField(
//                            controller: _fileNameTextController,
//                            decoration: InputDecoration(
//                              filled: true,
//                              fillColor: Colors.white,
//                            ),
//                          )),
//                    ),
//                    Row(
//                      children: [
//
//                        SizedBox(width: 10,),
//                        FlatButton(onPressed: (){
//                          uploadStorage();
//                        },
//                          child: Text('Upload Image' , style: TextStyle(color: Colors.white),),
//                          color: Colors.black54,),
//                        SizedBox(width: 10,),
//                        AbsorbPointer(
//                          absorbing: _imageSelected,
//                          child: FlatButton(onPressed: (){
//                            progressDialog.show();
//                            _services.uploadBannerImageToDb(_url).then((downloadUrl) {
//                              if(downloadUrl!=null)
//                                {
//                                  progressDialog.dismiss();
//                                  _services.showMyDialog(
//                                    title: 'Image uploaded',
//                                    message: 'to firebase',
//                                    context: context,
//                                  );
//
//                                }
//                            });
//
//                          },
//                            child: Text('Save Image' , style: TextStyle(color: Colors.white),),
//                            color: Colors.black54,),
//                        ),
//                        SizedBox(width: 10,),
//                        FlatButton(onPressed: (){},
//                          child: Text('Add New Banner' , style: TextStyle(color: Colors.white),),
//                          color: Colors.black54,)
//                      ],
//                    ),
//                  ],
//                ),
//              )
//            ],
//          ),
//        ),
//      ),
//    );
//  }
//
//  void uploadImage({@required Function(File file) onSelected})
//  {
//    InputElement uploadInput = FileUploadInputElement()..accept='image/*';
//    uploadInput.click();
//    uploadInput.onChange.listen((event) {
//      final file =uploadInput.files.first;
//      final reader = FileReader();
//      reader.readAsDataUrl(file);
//      reader.onLoadEnd.listen((event) {
//        onSelected(file);
//      });
//
//    });
//  }
//
//  void uploadStorage(){
//
//    final dateTime = DateTime.now();
//    final path = 'bannerImage/$dateTime';
//    uploadImage(onSelected: (file){
//      if(file != null)
//        {
//        setState((){
//          _fileNameTextController.text = file.name;
//          _imageSelected = false;
//          _url = path;
//        });
//        fb.storage().refFromURL('gs://flutter-grocery-app-147d3.appspot.com').child(path).put(file);
//
//        }
//    });
//  }
//
//
//
//}
//
//
//
////for web , ListView => Row , width of TextField in SizedBox width => 300
//// for web , video: 25 , min: 12:00 , UI is different in App becoz of size