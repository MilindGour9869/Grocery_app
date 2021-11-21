import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:groceryapp/screens/welcome_screen.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class  ProfileScreen extends StatelessWidget {
@override
Widget build(BuildContext context) {
return Scaffold(
body: Center(child:
            RaisedButton(onPressed: (){

              FirebaseAuth.instance.signOut().then((value){
                pushNewScreenWithRouteSettings(
                  context,
                  settings: RouteSettings(name: Welcomescreen.id),
                  screen:Welcomescreen(),
                  withNavBar: false,
                  pageTransitionAnimation: PageTransitionAnimation.cupertino,
                );

              });


            },
            child: Text('Sign out'),) ),
);
}
}