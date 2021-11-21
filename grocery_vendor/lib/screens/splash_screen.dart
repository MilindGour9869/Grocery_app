import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:groceryvendor/screens/login_screen.dart';
import 'package:groceryvendor/screens/registration_screen.dart';


import 'home_screen.dart';





class Splashscreen extends StatefulWidget {

  static const String id= 'splash-screen';
  @override
  _SplashscreenState createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {



  @override
  void initState() {
    // TODO: implement initState

    Timer(
        Duration(
          seconds: 3,
        ),
            (){
          FirebaseAuth.instance.authStateChanges().listen((User user){
            if(user==null)
            {
              Navigator.pushReplacementNamed(context,LoginScreen.id);
            }
            else{
              Navigator.pushReplacementNamed(context, HomeScreen.id);
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
            Text('Your Grocery' )
          ],
        ),
      ),
    );
  }
}