import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:groceryapp/constant.dart';
import 'package:groceryapp/provider/store_provider.dart';
import 'package:groceryapp/screens/vendor_home_screen.dart';
import 'package:groceryapp/screens/welcome_screen.dart';
import 'package:groceryapp/services/store_service.dart';
import 'package:groceryapp/services/user_services.dart';
import 'package:groceryapp/widgets/near_by_stores.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class TopPickedStore extends StatelessWidget {



  @override
  Widget build(BuildContext context) {

    StoreService _storeService = StoreService();


    final storeData = Provider.of<StoreProvider>(context);
    storeData.getUserLocation(context);
    String getDistance(location){
      var Distance = Geolocator.distanceBetween(storeData.userLatitude, storeData.userLongitude, location.latitude, location.longitude);
      Distance = Distance/1000;
      return Distance.toStringAsFixed(2);

    }
    return Container(
      child:StreamBuilder<QuerySnapshot>
        (
        stream: _storeService.getTopPickedStore(),
        builder: (BuildContext context , AsyncSnapshot<QuerySnapshot> snapshot)
        {


          if(!snapshot.hasData)
            return Container(
                height: 30,
                width: 30,
                child: CircularProgressIndicator());

          List shopDistance=[];
          for(int i=0; i<=snapshot.data.docs.length -1;i++)
            {
              var distance = Geolocator.distanceBetween(storeData.userLatitude, storeData.userLongitude, snapshot.data.docs[i]['location'].latitude, snapshot.data.docs[i]['location'].longitude);
              distance=distance/1000;
              shopDistance.add(distance);


            }

          shopDistance.sort();
          if(shopDistance[0]>10)
            {
              return Container(child: Center(child: Text('**Currently We are Not Availabel in Your Area , Please try another Location**' , style: KStoreCardStyle,)),);
            }

          return Container(
            height: 210,
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0 , left: 8),
              child: Column(
                children: [

                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0 , top: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(height:30 ,child: Image.asset('images/like.gif')),
                        SizedBox(width: 10,),
                        Text('Top Picked Stores For You . . .' , style: TextStyle(fontWeight: FontWeight.w900 , fontSize: 20 ),)
                      ],
                    ),
                  ),
                  Flexible(
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: snapshot.data.docs.map((DocumentSnapshot document) {
                        if(double.parse(getDistance(document['location']))<=10)
                        return InkWell(
                          onTap: (){
                            storeData.getSelectedShop(document);


                            pushNewScreenWithRouteSettings(
                              context,
                              settings: RouteSettings(name: VendorHomeScreen.id),
                              screen:  VendorHomeScreen(),
                              withNavBar: true,
                              pageTransitionAnimation: PageTransitionAnimation.cupertino,
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: 80,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  SizedBox(
                                      height:80,
                                      width: 80,
                                      child: Card(child:ClipRRect(
                                          borderRadius: BorderRadius.circular(4),
                                          child: Image.network(document['ImageUrl'], fit: BoxFit.fill,)))),
                                  Container(
                                    height: 35,
                                    child: Text(document['shopName'] , style: TextStyle(fontWeight: FontWeight.bold , fontSize: 14, ),
                                           maxLines: 2, overflow: TextOverflow.ellipsis,),
                                  ),

                                  Text('${getDistance(document['location'])}Km' , style: KStoreCardStyle)
                                ],
                              ),
                            ),
                          ),
                        );
                        else
                          {
                            return Container(color:Colors.orange,);
                          }
                      }).toList(),
                    ),
                  )
                ],
              ),
            ),
          );
        },


      ),
    );
  }
}

