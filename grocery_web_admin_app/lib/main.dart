
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:grocerywebadminapp/app_provider/auth_provider.dart';
import 'package:grocerywebadminapp/app_screen/app_manage_banner.dart';
import 'package:grocerywebadminapp/screen/adminUser_screen.dart';
import 'package:grocerywebadminapp/screen/category_screen.dart';
import 'package:grocerywebadminapp/screen/home_screen.dart';
import 'package:grocerywebadminapp/screen/login_screen.dart';
import 'package:grocerywebadminapp/screen/vendor_screen.dart';
import 'package:provider/provider.dart';
import 'web_app_screen/manage_banner.dart';
import 'package:grocerywebadminapp/screen/notification_screen.dart';
import 'package:grocerywebadminapp/screen/orders_screen.dart';
import 'package:grocerywebadminapp/screen/setting_screen.dart';

import 'package:grocerywebadminapp/screen/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  runApp(MultiProvider(
    providers:[
      ChangeNotifierProvider(create: (_)=>AuthProvider(),)
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Grocery Admin Web Panel',
      theme: ThemeData(
        primaryColor:Color(0xFF84c225),
      ),
      home: Splashscreen(),
      routes:{
        Splashscreen.id :(context)=>Splashscreen(),
        HomeScreen.id:(context)=>HomeScreen(),
        LoginScreen.id:(context)=>LoginScreen(),
//        BannerScreen.id:(context)=>BannerScreen(),
        CategoryScreen.id:(context)=>CategoryScreen(),
        OrdersScreen.id:(context)=>OrdersScreen(),
        NotificationScreen.id:(context)=>NotificationScreen(),
        AdminUserScreen.id:(context)=>AdminUserScreen(),
        SettingScreen.id:(context)=>SettingScreen(),
        AppBannerScreen.id :(context)=>AppBannerScreen(),
        VendorScreen.id:(context)=>VendorScreen(),







      },
    );
  }
}


