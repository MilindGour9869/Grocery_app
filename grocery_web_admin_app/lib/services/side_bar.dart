import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:grocerywebadminapp/app_screen/app_manage_banner.dart';

import 'package:grocerywebadminapp/screen/adminUser_screen.dart';
import 'package:grocerywebadminapp/screen/category_screen.dart';
import 'package:grocerywebadminapp/screen/home_screen.dart';
import 'package:grocerywebadminapp/screen/login_screen.dart';
import 'package:grocerywebadminapp/screen/vendor_screen.dart';
import '../web_app_screen/manage_banner.dart';
import 'package:grocerywebadminapp/screen/notification_screen.dart';
import 'package:grocerywebadminapp/screen/orders_screen.dart';
import 'package:grocerywebadminapp/screen/setting_screen.dart';

class SideBarWidget {

  sideBarMenu(context , SelectedRoute)
  {
    return SideBar(
      activeBackgroundColor: Colors.black54,
      activeIconColor: Colors.white,
      activeTextStyle: TextStyle(color: Colors.white),
      items: const [
        MenuItem(
          title: 'Dashboard',
          route: HomeScreen.id,
          icon: Icons.dashboard,
        ),
        MenuItem(
          title: 'Banners',
          route: AppBannerScreen.id,
          icon: Icons.photo,
        ),
        MenuItem(
          title: 'Vendors',
          route: VendorScreen.id,
          icon: Icons.group,
        ),
        MenuItem(
          title: 'Category',
          route: CategoryScreen.id,
          icon: Icons.category,
        ),
        MenuItem(
          title: 'Orders',
          route: OrdersScreen.id,
          icon: CupertinoIcons.shopping_cart,
        ),
        MenuItem(
          title: 'Send Notification',
          route: NotificationScreen.id,
          icon: Icons.notifications,
        ),
        MenuItem(
          title: 'Admin User',
          route: AdminUserScreen.id,
          icon: Icons.person_rounded,
        ),
        MenuItem(
          title: 'Setting',
          route: SettingScreen.id,
          icon: Icons.settings,
        ),
        MenuItem(
          title: 'Exit',
          route: LoginScreen.id,
          icon: Icons.exit_to_app,
        ),

      ],
      selectedRoute: SelectedRoute,
      onSelected: (item) {
        if (item.route != null) {
          Navigator.of(context).pushNamed(item.route);
        }
      },
      header: Container(
        height: 50,
        width: double.infinity,
        color: Color(0xff444444),
        child: Center(
          child: Text(
            'MENU',
            style: TextStyle(
              letterSpacing: 2,
              color: Colors.blueGrey,
              fontWeight: FontWeight.bold
            ),
          ),
        ),
      ),
      footer: Container(
        height: 50,
        width: double.infinity,
        color: Color(0xff444444),
        child: Center(
          child: Image.asset('images/logo.png'),
        ),
      ),
    );
  }
}