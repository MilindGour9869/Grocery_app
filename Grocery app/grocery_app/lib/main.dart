// import 'dart:async';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:groceryapp/provider/auth_provider.dart';
import 'package:groceryapp/provider/location_provider.dart';
import 'package:groceryapp/provider/store_provider.dart';
import 'package:groceryapp/screens/home_screen.dart';
import 'package:groceryapp/screens/login_screen.dart';
import 'package:groceryapp/screens/main_screen.dart';
import 'package:groceryapp/screens/map_screen.dart';
import 'package:groceryapp/screens/vendor_home_screen.dart';
import 'package:groceryapp/screens/welcome_screen.dart';
import 'package:provider/provider.dart';



// import 'constant.dart';

import 'package:flutter/material.dart';
import 'package:groceryapp/screens/onboard_screen.dart';
import 'package:firebase_core/firebase_core.dart';

import 'screens/Register_screen.dart';
import 'screens/splash_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp( MultiProvider(providers: [
    ChangeNotifierProvider(
      create:(_)=>AuthProvider(),
      
    ) , 
    ChangeNotifierProvider(create: (_)=>LocationProvider()),
    ChangeNotifierProvider(create: (_)=>StoreProvider())
  ],
  child: MyApp(),));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color(0xFF84c225),
        fontFamily: 'Lato'
      ),
      initialRoute: Splashscreen.id,
      routes:{
        Splashscreen.id :(context)=>Splashscreen(),
        Welcomescreen.id :(context)=>Welcomescreen(),
        Homescreen.id :(context)=>Homescreen(),
        Mapscreen.id:(context)=>Mapscreen(),
        Onboardscreen.id:(context)=>Onboardscreen(),
        Registerscreen.id:(context)=>Registerscreen(),
        Loginscreen.id:(context)=>Loginscreen(),
        MainScreen.id:(context)=>MainScreen(),
        VendorHomeScreen.id:(context)=>VendorHomeScreen(),



      },
    );
  }
}



