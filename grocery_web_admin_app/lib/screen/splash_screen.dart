import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grocerywebadminapp/screen/home_screen.dart';
import 'package:grocerywebadminapp/screen/login_screen.dart';


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
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context)=> LoginScreen()));
            }
            else{
              print(user.uid);
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context)=> HomeScreen()));
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