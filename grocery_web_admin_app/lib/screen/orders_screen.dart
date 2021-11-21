import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:grocerywebadminapp/services/side_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:grocerywebadminapp/screen/login_screen.dart';
class OrdersScreen extends StatelessWidget {

  static const String id = 'orders-screen';
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
        title: const Text('Grocery App Admin Panel'),

      ),
      sideBar: _sideBar.sideBarMenu(context, OrdersScreen.id) ,
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.all(10),
          child: Text(
            'Orders',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 36,
            ),
          ),
        ),
      ),
    );
  }
}
