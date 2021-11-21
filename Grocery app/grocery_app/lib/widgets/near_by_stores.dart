import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:groceryapp/provider/store_provider.dart';
import 'package:groceryapp/services/store_service.dart';
import 'package:paginate_firestore/bloc/pagination_listeners.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:provider/provider.dart';

import '../constant.dart';

class NearByStores extends StatelessWidget {




  @override
  Widget build(BuildContext context) {

    StoreService _storeService = StoreService();
    PaginateRefreshedChangeListener refreshChangeListener = PaginateRefreshedChangeListener();


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
        stream: _storeService.getNearByStores(),
        builder: (BuildContext context , AsyncSnapshot<QuerySnapshot> snapshot)
        {

          if(!snapshot.hasData)
            return Container(
              height: 30,
              width: 30,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
              ),
            );

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
            return Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Stack(
                  children: [

                    Image.asset('images/city.png' ,color: Colors.black12, ),
                    Positioned(
                      right: 10,
                      top: 80,
                      child: Container(
                        child: Column(
                          children: [
                            Text('Made By : ' , style: TextStyle(color: Colors.black45),),
                            Text('Spidy', style: TextStyle(fontWeight: FontWeight.w900 , fontFamily: 'Anton' , letterSpacing: 2 , color: Colors.grey),)

                          ],
                        ),
                      ),
                    )


                  ],
                ),
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment:  CrossAxisAlignment.start,
              children: [
                RefreshIndicator(

                  child: PaginateFirestore(

                    bottomLoader: SizedBox(
                      height: 30,
                      width: 30,
                      child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue)),
                    ),

                    header: SliverToBoxAdapter(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0 ,left: 8 , bottom: 10 , top: 5),
                              child: Text('All Near By Stores' , style: TextStyle( fontSize: 18 , fontWeight: FontWeight.w900),),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0 ,left: 8 , bottom: 6),
                              child: Text('Find Out Quality Products Near You' , style: KStoreCardStyle),
                            )

                          ],
                        ),
                    ),
                    footer: SliverToBoxAdapter(child: Stack(
                      children: [
                        Center(child: Text('**That\s all folks**' , style: TextStyle(color: Colors.grey),)),
                        Image.asset('images/city.png' , ),
                        Positioned(
                          right: 10,
                          top: 80,
                          child: Container(
                            child: Column(
                              children: [
                                Text('Made By : ' , style: TextStyle(color: Colors.black45),),
                                Text('Spidy', style: TextStyle(fontWeight: FontWeight.w900 , fontFamily: 'Anton' , letterSpacing: 2 , color: Colors.grey),)

                              ],
                            ),
                          ),
                        )


                      ],
                    ),),

                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilderType: PaginateBuilderType.listView,

                    itemBuilder: (index,context,document)
                    {

                      return Padding(

                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                  height:100,
                                  width: 110,
                                  child: Card(child:ClipRRect(
                                      borderRadius: BorderRadius.circular(4),
                                      child: Image.network(document['ImageUrl'], fit: BoxFit.fill,)
                                  )
                                  )
                              ),
                              SizedBox(width: 10,),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: Text(document['shopName'] , style: TextStyle(fontWeight: FontWeight.w900 , fontSize: 14),
                                      maxLines: 2 , overflow: TextOverflow.ellipsis,),
                                  ),

                                  SizedBox(height: 3,),
                                  Text(document['dialog'] , style: KStoreCardStyle,),
                                  SizedBox(height: 3,),
                                  Container(
                                    width: MediaQuery.of(context).size.width-250,
                                    child: Text(document['address'] , style: KStoreCardStyle, overflow: TextOverflow.ellipsis,),
                                  ),
                                  SizedBox(height: 3,),
                                  Text('${getDistance(document['location'])}Km' , style: KStoreCardStyle,overflow: TextOverflow.ellipsis),
                                  SizedBox(height: 3,),
                                  Row(
                                    children: [
                                      Icon(Icons.star , size: 12, color: Colors.grey,),
                                      SizedBox(width: 4,),
                                      Text('3.2' , style: KStoreCardStyle,)
                                    ],
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    },
                    query:_storeService.getPaginateNearstores(),
                    listeners: [
                      refreshChangeListener,
                    ],






                  ),
                  onRefresh:  () async {
                    refreshChangeListener.refreshed = true;
                  },),
              ],
            ),
          );
        },


      ),
    );
  }
}
