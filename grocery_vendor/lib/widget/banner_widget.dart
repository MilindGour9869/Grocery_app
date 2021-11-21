import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:groceryvendor/service/firebase_service.dart';


class BannerWidget extends StatelessWidget {
  FirebaseServices _services = FirebaseServices();



  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _services.vendorBanner.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }



        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        return Container(
          color: Colors.white,
          width: MediaQuery.of(context).size.width,
          height: 200,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: snapshot.data.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data = document.data() as Map<String, dynamic>;
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Stack(
                    children: [
                      SizedBox(
                        height: 200,
                        child: new Card(
                          elevation: 10,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: Image.network(document['image'] , fit: BoxFit.fill,)),
                        ),
                      ),
                      Positioned(
                          top: 10,
                          right: 10,
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            child: IconButton(
                              onPressed: (){
                                _services.DeleteVendorBannerImage(

                                  id: document.id,
                                );

                              },
                              icon: Icon(Icons.delete , color: Colors.red,),
                            ),
                          )
                      )],
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
