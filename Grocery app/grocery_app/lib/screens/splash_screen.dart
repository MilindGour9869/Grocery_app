import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:groceryapp/provider/location_provider.dart';
import 'package:groceryapp/screens/main_screen.dart';


import '../constant.dart';
import 'home_screen.dart';
import 'welcome_screen.dart';




class Splashscreen extends StatefulWidget {

  static const String id= 'splash-screen';
  @override
  _SplashscreenState createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
LocationProvider locationData  = LocationProvider();


  @override
  void initState() {
    // TODO: implement initState

    Timer(
        Duration(
          seconds: 3,
        ),
            (){
          FirebaseAuth.instance.authStateChanges().listen((User user) {
            if(user==null)
            {
              Navigator.pushReplacementNamed(context, Welcomescreen.id);
            }
            else{
              Navigator.pushReplacementNamed(context, MainScreen.id);
            }
          }
          );
        }

    );
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('images/logo.png'),
            Text('Your Grocery' , style:Kpageviewtextstyle)
          ],
        ),
      ),
    );
  }
}