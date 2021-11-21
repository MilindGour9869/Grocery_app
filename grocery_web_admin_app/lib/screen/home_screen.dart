import 'package:firebase_auth/firebase_auth.dart';
import 'package:grocerywebadminapp/screen/login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';

import 'package:grocerywebadminapp/services/side_bar.dart';



class HomeScreen extends StatelessWidget {

  static const String id = 'home-screen';
  SideBarWidget _sideBar = SideBarWidget();

  @override
  Widget build(BuildContext context) {



    return AdminScaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
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
        backgroundColor: Colors.black87,
        title: const Text('Grocery App Admin Panel' , style: TextStyle(color: Colors.white),),

      ),
      sideBar: _sideBar.sideBarMenu(context, HomeScreen.id) ,
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.all(10),
          child: Text(
            'Dashboard',
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



