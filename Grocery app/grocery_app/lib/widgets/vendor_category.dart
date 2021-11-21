import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:groceryapp/provider/store_provider.dart';
import 'package:groceryapp/services/product_service.dart';
import 'package:provider/provider.dart';


class VendorCategory extends StatefulWidget {
  @override
  _VendorCategoryState createState() => _VendorCategoryState();
}

class _VendorCategoryState extends State<VendorCategory> {

 List _catlist=[];
 ProductService _service = ProductService();
  @override
  void didChangeDependencies() {


    var _storeData = Provider.of<StoreProvider>(context);


    
    FirebaseFirestore.instance.collection('products').where('seller.sellerUid' , isEqualTo: _storeData.document['uid']).get().then((QuerySnapshot snapshot) {


       snapshot.docs.forEach((doc) {

         _catlist.add(doc['category']['mainCategory']);
       });
    });
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _service.category.get(),
        builder: (BuildContext context ,  AsyncSnapshot<QuerySnapshot> snapshot)
        {
          if(snapshot.hasError)
            {
              return Text('Something went wrong');
            }
          if(!snapshot.hasData)
          {
            return Container();
          }
//          if(_catlist.length==0)
//          {
//            return CircularProgressIndicator();
//          }
          return SingleChildScrollView(
            child: Column(
              children: [
//                Padding(
//                  padding: const EdgeInsets.all(8.0),
//                  child: Material(
//                    elevation: 4,
//                    child: Container(
//                      height: 60,
//                        width: MediaQuery.of(context).size.width,
//                      decoration: BoxDecoration(
//                        borderRadius: BorderRadius.circular(6),
//                        image: DecorationImage(
//                          fit: BoxFit.cover,
//                          image: AssetImage()
//                        )
//                      ),
//
//                    ),
//                  ),
//                ),

                Wrap(
                  direction: Axis.horizontal,
                  children: snapshot.data.docs.map((DocumentSnapshot document){
                    return _catlist.contains(document['Category Name'])?
                        Container(
                          width: 120,
                          height: 150,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey,
                                width: .5,

                              )
                            ),
                            child: Column(
                              children: [
                                Center(child: Image.network(document['image'])),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0 , right: 8),
                                  child: Text(document['Category Name']),
                                )

                              ],
                            ),
                          ),
                        ):Text('');
                  }).toList(),
                ),
              ],
            ),
          );


        }
    );
  }
}
