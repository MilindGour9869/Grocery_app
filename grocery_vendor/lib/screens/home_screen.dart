import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:groceryvendor/screens/dashboard_screen.dart';
import 'package:groceryvendor/screens/login_screen.dart';
import 'package:groceryvendor/screens/registration_screen.dart';
import 'package:groceryvendor/screens/home_screen.dart';
import 'package:groceryvendor/service/drawer_service.dart';
import 'package:groceryvendor/widget/drawer_menu_widget.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';

class HomeScreen extends StatefulWidget {

  static const String id = 'home-screen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  DrawerServices drawer = DrawerServices();

  GlobalKey<SliderMenuContainerState> _key =
  new GlobalKey<SliderMenuContainerState>();
  String title='';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SliderMenuContainer(
          appBarColor: Colors.white,
          key: _key,
          appBarHeight: 80,
          sliderMenuOpenSize: 200,
          title: Text(
            title,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
          ),
          trailing: Row(
            children: [
              IconButton(onPressed: (){}, icon: Icon(Icons.search)),
              IconButton(onPressed: (){}, icon: Icon(Icons.doorbell))
            ],
          ),
          sliderMenu: MenuWidget(
            onItemClick: (title) {
              _key.currentState.closeDrawer();
              setState(() {
                this.title = title;
                print(title);
              });

            },
          ),
          sliderMain: drawer.drawerScreen(title)),
    );
  }
}
