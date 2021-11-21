import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:grocerywebadminapp/screen/login_screen.dart';
import 'package:grocerywebadminapp/services/side_bar.dart';
import 'package:grocerywebadminapp/widgets/vendor_datatable_widget.dart';

class VendorScreen extends StatefulWidget {

  static const String id = 'vendor-screen';
  @override
  _VendorScreenState createState() => _VendorScreenState();
}

class _VendorScreenState extends State<VendorScreen> {


  SideBarWidget _sideBar = SideBarWidget();
  @override
  Widget build(BuildContext context) {
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
      sideBar: _sideBar.sideBarMenu(context, VendorScreen.id) ,
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Text(
                'Vendors',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 36,
                ),
              ),
              Text('Menage Vendors'),

              Divider(
                thickness: 5,
              ),
              VendorDatatable(),
              Divider(
                thickness: 5,
              ),




            ],
          ),
        ),
      ),
    );
  }
}
