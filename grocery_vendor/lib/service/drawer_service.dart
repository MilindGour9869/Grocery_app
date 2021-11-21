import 'package:flutter/material.dart';
import 'package:groceryvendor/screens/banner_screen.dart';
import 'package:groceryvendor/screens/dashboard_screen.dart';
import 'package:groceryvendor/screens/products_screen.dart';

class DrawerServices {

  Widget drawerScreen(title){
    if(title=='Products')
      {
        return ProductsScreen();
      }

    if(title=='Banner')
    {
      return BannerScreen();
    }

    return DashBoardScreen();
  }
}