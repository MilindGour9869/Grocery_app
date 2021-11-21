import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:groceryvendor/screens/login_screen.dart';



class DashBoardScreen extends StatefulWidget {
  @override
  _DashBoardScreenState createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: RaisedButton(onPressed: (){
        FirebaseAuth.instance.signOut();
        Navigator.pushReplacementNamed(context, LoginScreen.id);

      },
        color: Colors.orange,
        child: Text('SignOut'),

      )),
    );
  }
}

