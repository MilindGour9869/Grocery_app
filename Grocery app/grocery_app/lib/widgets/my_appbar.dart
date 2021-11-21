import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:groceryapp/provider/location_provider.dart';
import 'package:groceryapp/screens/map_screen.dart';
import 'package:groceryapp/screens/welcome_screen.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyAppBar extends StatefulWidget {
  @override
  _MyAppBarState createState() => _MyAppBarState();
}

class _MyAppBarState extends State<MyAppBar> {
  String _location='error';
  String _address = 'error';


  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    getPrefs();

  }
  getPrefs()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String location = prefs.getString('location');
    String address = prefs.getString('address');
    print(location);
    setState(() {
      _location=location;
      _address=address;
    });
  }
  @override
  Widget build(BuildContext context){

    final LocationData = Provider.of<LocationProvider>(context);

    return SliverAppBar(
      automaticallyImplyLeading: false,
      elevation: 0,


      title: FlatButton(
        onPressed: ()async{
          await LocationData.getCurrentPosition();

          if(LocationData.permissionallowed==true)
          {
            LocationData.getCurrentPosition().then((value){

//              Navigator.pushNamed(context, Mapscreen.id);
//              //8 930
//              setState(() {
//                LocationData.loading=false;
//              });

              pushNewScreenWithRouteSettings(
                context,
                settings: RouteSettings(name: Mapscreen.id),
                screen:Mapscreen(),
                withNavBar: false,
                pageTransitionAnimation: PageTransitionAnimation.cupertino,
              );


            });
          }
          else{
            print('\n permission error \n');
            //8 930
            setState(() {
              LocationData.loading=false;
            });
          }

        },
        child: Column(


          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(


              children: [
                Text(_location==null?'error':_location, style: TextStyle(color: Colors.white , fontWeight: FontWeight.bold ),overflow: TextOverflow.ellipsis,),
                SizedBox(width: 10,),

                Icon(Icons.edit_outlined , color: Colors.white, size: 15,),

              ],
            ),

            Text(_address==null?'error':_address ,style: TextStyle(color: Colors.white ),overflow: TextOverflow.ellipsis, ),
          ],
        ),
      ),
//      actions: [
//        IconButton(onPressed: (){
//          FirebaseAuth.instance.signOut();
//          Navigator.pushReplacementNamed(context, Welcomescreen.id);
//        },
//            icon: Icon(Icons.power_settings_new , color: Colors.white,)),
//        IconButton(onPressed: (){}, icon: Icon(Icons.edit_outlined , color: Colors.white,),
//        )
//      ],
      centerTitle: false,
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'search' ,
              prefixIcon: Icon(Icons.search , color: Colors.grey,),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.zero,
              filled: true,
              fillColor: Colors.white,

            ),
          ),
        ),
      ),
    );
  }
}
