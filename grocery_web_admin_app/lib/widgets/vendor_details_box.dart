import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grocerywebadminapp/services/firebase_service.dart';

class VendorDetailsBox extends StatefulWidget {

  String uid;
  VendorDetailsBox(this.uid);

  @override
  State<VendorDetailsBox> createState() => _VendorDetailsBoxState();
}

class _VendorDetailsBoxState extends State<VendorDetailsBox> {

  FirebaseServices _services = FirebaseServices();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(

        future: _services.vendors.doc(widget.uid).get(),
        builder:  (BuildContext context ,AsyncSnapshot<DocumentSnapshot> snapshot){

          if(snapshot.hasError){
            return Text('Has error');
          }

          if(snapshot.connectionState==ConnectionState.waiting)
          {
            return Center(child: CircularProgressIndicator());
          }

          return Dialog(
            child: Container(
              height: MediaQuery.of(context).size.height*.3,
              width: MediaQuery.of(context).size.width,
              child: ListView(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 100,
                        width: 100,
                        child: Image.network(snapshot.data['ImageUrl'] , fit: BoxFit.cover,),


                      ),
                      SizedBox(width: 20,),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            snapshot.data['shopName'],
                            style: TextStyle(fontWeight: FontWeight.bold , fontSize: 25),
                          ),
                          Text(snapshot.data['dialog'])
                        ],
                      )
                    ],


                  ),
                  Divider(
                    thickness: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('Email: ${snapshot.data['email']}', style: TextStyle(color: Colors.black45),),
                        SizedBox(height: 15,),
                        Text('Mobile No. : ${snapshot.data['mobile']}' , style: TextStyle(color: Colors.black45),),
                        SizedBox(height: 15,),
                        Text('Address: ${snapshot.data['address']}' , style: TextStyle(color: Colors.black45 ,), textAlign: TextAlign.center,),

                      ],
                    ),
                  )

                ],
              ),
            ),
          );
        } );
  }
}
