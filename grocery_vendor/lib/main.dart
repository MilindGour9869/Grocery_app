// import 'dart:async';
//import 'package:firebase_auth/firebase_auth.dart';




// import 'constant.dart';

import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:groceryvendor/provider/auth_provider.dart';
import 'package:groceryvendor/provider/product_provider.dart';
import 'package:groceryvendor/screens/add_products_screen.dart';
import 'package:groceryvendor/screens/auth_screen.dart';
import 'package:groceryvendor/screens/home_screen.dart';
import 'package:groceryvendor/screens/login_screen.dart';
import 'package:groceryvendor/screens/registration_screen.dart';
import 'package:groceryvendor/screens/reset-password.dart';
import 'package:groceryvendor/screens/splash_screen.dart';


import 'package:provider/provider.dart';


// @dart=2.9
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MultiProvider(
    providers:[
      ChangeNotifierProvider(create: (_)=>AuthProvider(),
      ),
      ChangeNotifierProvider(create: (_)=>ProductProvider(),
      )
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: EasyLoading.init(),
      theme: ThemeData(
          primaryColor: Color(0xFF84c225),
          fontFamily: 'Lato'
      ),
      initialRoute: Splashscreen.id,
      routes:{
        Splashscreen.id :(context)=>Splashscreen(),
        AuthScreen.id:(context)=>AuthScreen(),
        HomeScreen.id:(context)=>HomeScreen(),
        RegistrationScreen.id:(context)=>RegistrationScreen(),
        LoginScreen.id:(context)=>LoginScreen(),
        ResetPassword.id:(context)=>ResetPassword(),
        AddProducts.id:(context)=>AddProducts(),





      },
    );
  }
}



