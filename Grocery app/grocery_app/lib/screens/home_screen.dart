import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:groceryapp/provider/auth_provider.dart';
import 'package:groceryapp/provider/location_provider.dart';
import 'package:groceryapp/widgets/near_by_stores.dart';
import '../widgets/top_pick_store.dart';
import 'package:groceryapp/screens/welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:groceryapp/widgets/image_slider.dart';
import 'package:groceryapp/widgets/my_appbar.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'map_screen.dart';

class Homescreen extends StatefulWidget {


  static const String id= 'home-screen';

  @override
  _HomescreenState createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);


    return Scaffold(
//      appBar: PreferredSize(
//        preferredSize: Size.fromHeight(112),
//        child:MyAppBar() ,
//      ),

    backgroundColor: Colors.white,
      body:NestedScrollView(
        headerSliverBuilder: (BuildContext context , bool innerBoxisScrolled)
        {
          return <Widget>[
            MyAppBar(),
          ];
        },

        body: ListView(
          padding: EdgeInsets.only(top: 0),
          children: [
            ImageSlider(),

            Container(
                child: TopPickedStore()),
//           Container(height: 3,color: Theme.of(context).primaryColor,),
            NearByStores(),


//sign out and home page buuton :
//            RaisedButton(onPressed: (){
//              auth.error='';
//              FirebaseAuth.instance.signOut().then((value){
//                Navigator.pushReplacementNamed(context , Welcomescreen.id);
//              });
//
//
//            },
//            child: Text('Sign out'),) ,
//            RaisedButton(onPressed: (){
//             Navigator.pushReplacementNamed(context,Welcomescreen.id);
//
//
//            },
//              child: Text('homescreen'),),



          ],
        ),

      ),

    );
  }
}
