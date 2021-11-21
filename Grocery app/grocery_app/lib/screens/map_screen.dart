import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:groceryapp/provider/auth_provider.dart';
import 'package:groceryapp/provider/location_provider.dart';
import 'package:groceryapp/screens/home_screen.dart';
import 'package:groceryapp/screens/login_screen.dart';
import 'package:groceryapp/screens/main_screen.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';


class Mapscreen extends StatefulWidget {

  static const String id = 'map-screen';
  @override
  _MapscreenState createState() => _MapscreenState();
}

class _MapscreenState extends State<Mapscreen> {

  LatLng currentposition;
  GoogleMapController _mapController;
  // 8
  bool _locating = false; //8 1130
  bool _loggedIn = false;
  User user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    // TODO: implement initState


  }


  void getCurrentUser()
  {


    if(user!=null)
      { print('\n getCurrentuser called mapscreen');
     if(mounted)
       {
         setState(() {
           user = FirebaseAuth.instance.currentUser;
           _loggedIn=true;
         });
       }
      }




  }
  @override
  Widget build(BuildContext context) {
    final locationData = Provider.of<LocationProvider>(context);
    final _auth = Provider.of<AuthProvider>(context);

   if(mounted)
     {
       setState(() {
         currentposition = LatLng(LocationProvider.Latitude , LocationProvider.Longitude);
         print(currentposition);
       });
     }

    void onMapCreated(GoogleMapController controller)
    {
     if(mounted)
       {
         setState(() {
           _mapController = controller;
         });
       }
    }


    return SafeArea(child: Stack(
      children: [
        GoogleMap(

            initialCameraPosition:CameraPosition(

              target: currentposition,
              zoom: 14.4746,
            ),
          zoomControlsEnabled: false,
          zoomGesturesEnabled: true,
          minMaxZoomPreference: MinMaxZoomPreference(1.5,20),
          myLocationButtonEnabled: true,
          myLocationEnabled: true,
          mapType: MapType.normal,
          mapToolbarEnabled: true,
          onCameraMove: (CameraPosition position){
              setState(() {
                _locating=true;
              });
              print('oncamera move called');
              print(position);
              locationData.onCameraMove(position);
          },
          onMapCreated: onMapCreated,
          onCameraIdle: (){
              setState(() {
                _locating=false;
              });
             locationData.getCameraMove();

          },


        ) ,
        Center(
          child: Container(
              height: 50,
              margin: EdgeInsets.only(bottom: 20),
              child: Image.asset('images/marker.png')),
        ),

        Positioned(
            bottom: 0.0,
            child: Container(
              height: 230,
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: Column(
                //8
                crossAxisAlignment: CrossAxisAlignment.start,
                //8 1100
                children: [
                  _locating?LinearProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.deepOrange),
                    backgroundColor: Colors.transparent,
                  ):Container(),

//                  Padding(
//                    padding: const EdgeInsets.only(left:10.0 , right: 10),
//                    child: TextButton.icon(
//                      onPressed: (){},
//                      icon: Icon(Icons.location_searching , color: Theme.of(context).primaryColor,),
//                      label: Flexible(
//                        child: Text('${LocationProvider.selectedAddress.featureName}' ,
//                            style: TextStyle(fontWeight:FontWeight.bold),
//                            overflow: TextOverflow.ellipsis),
//                      ),
//
//                    ),
//                  ),

                  Padding(
                    padding: const EdgeInsets.only(left:20.0 , bottom: 10, top: 10),
                    child: Row(

                      children: [
                        Icon(Icons.location_searching , color: Theme.of(context).primaryColor, ),

                        SizedBox(width: 10,),
                        _locating ? Text(''):Text('${LocationProvider.selectedAddress.featureName}' ,
                            style: TextStyle(fontSize: 15, fontWeight:FontWeight.bold ,color:Colors.lightBlueAccent ),  overflow: TextOverflow.ellipsis),



                      ],
                    ),
                  ),





                  Padding(
                    padding: const EdgeInsets.only(left:20.0),
                    child: _locating ? Text(''):Text('${LocationProvider.selectedAddress.addressLine}' , style: TextStyle(fontSize: 12,color: Colors.black54),),
                  ),

                  SizedBox(height: 20,),

                  Padding(

                    padding: const EdgeInsets.all(10.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width-40,//20 from each side
                      child: AbsorbPointer(
                        absorbing: _locating?true:false,
                        child: FlatButton(onPressed: (){

                          if(_loggedIn==false)
                          {
                            Navigator.pushNamed(context,Loginscreen.id);
                          }
                          else
                          {  print('\n else called in mapp screen ');
                          _auth.updateUser(
                              id: user.uid,
                              number: user.phoneNumber,
                              latitude: LocationProvider.Latitude,
                              longitude: LocationProvider.Longitude,
                              address: LocationProvider.selectedAddress.addressLine
                          );

                          locationData.savePrefs();

                          pushNewScreenWithRouteSettings(
                            context,
                            settings: RouteSettings(name: MainScreen.id),
                            screen:MainScreen(),
                            withNavBar: true,
                            pageTransitionAnimation: PageTransitionAnimation.cupertino,
                          );


                          print(LocationProvider.selectedAddress.addressLine.toString());
                          }
                        },
                            color: _locating?Colors.grey:Theme.of(context).primaryColor,
                            child: Text('CONFIRM LOCATION')),

                      ),
                    ),
                  ),


                ],
              ),
            )),
      ],
    )
    );
  }
}
