import 'package:chips_choice/chips_choice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grocerywebadminapp/services/firebase_service.dart';
import 'package:grocerywebadminapp/widgets/vendor_details_box.dart';

class VendorDatatable extends StatefulWidget {

  @override
  State<VendorDatatable> createState() => _VendorDatatableState();
}

class _VendorDatatableState extends State<VendorDatatable> {
  FirebaseServices _services = FirebaseServices();



//  List<String> tag = [];

//  bool op0 ,op1 =false, op2 =false , op3=false;
    bool op0 ,op1 =null, op2 =null , op3=null;

  List<String> options = [
     'Account Verified', 'Top Picked',
    'Shop Open', 'Top Rating',
  ];

  List<String> tag = [];





  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [



    ChipsChoice<String>.multiple(
    value: tag,
    onChanged: (val) => setState(() {

      tag = val;
      print(val);
      print(tag);
      print(val.contains('All Vendors'));

//      if(val.contains('All Vendors')==true){
//        op1=true;
//        op2=true;
//        op3=true;
//      }

      if(val.contains('Account Verified')==true)
        {
          op1=true;
          print('\n');
          print(op1);
          print(op2);
          print(op3);
        }
      else
        {
          op1 = null;
        }


      if(val.contains('Top Picked')==true)
        {
          op2=true;
          print('\n');
          print(op1);
          print(op2);
          print(op3);
        }
      else
        {
          op2 = null;
        }


      if(val.contains('Shop Open')==true){
        op3=true;
        print('\n');
        print(op1);
        print(op2);
        print(op3);
      }
      else
        {
          op3=null;
        }





    }),
    choiceItems: C2Choice.listFrom<String, String>(
    source: options,
    value: (i, v) => v,
    label: (i, v) => v,
    ),
      choiceActiveStyle: C2ChoiceStyle(
        brightness: Brightness.dark,
        color: Colors.black54,
      ),
    ),

        Divider(
          thickness: 5,
        ),


        StreamBuilder(
            stream: _services.vendors.where('accverified' , isEqualTo: op1 ).where('isTopPicked', isEqualTo: op2).where('shopOpen' , isEqualTo: op3).snapshots(),
            // ignore: missing_return
            builder: (context,snapshot)
            {

                if(snapshot.hasError){
                  return Text('Has error');
                }

                if(snapshot.connectionState==ConnectionState.waiting)
                  {
                    return CircularProgressIndicator();
                  }

                if(snapshot.connectionState==ConnectionState.active)
                {
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(

                        showBottomBorder: true,
                        dataRowHeight: 60,
                        headingRowColor: MaterialStateProperty.all(Colors.grey[200]),

                        columns: <DataColumn>[
                          DataColumn(label: Text('Shop Name')),
                          DataColumn(label: Text('Account Verified')),
                          DataColumn(label: Text('Top Picked')),
                          DataColumn(label: Text('Shop Open')),

                          DataColumn(label: Text('Rating')),

                          DataColumn(label: Text('Total Sales')),
                          DataColumn(label: Text('Email')),
                          DataColumn(label: Text('Mobile no.')),
                          DataColumn(label: Text('View Details')),

                        ],



                        rows: _vendorDetailsRows(snapshot.data , _services),



                    ),
                  );


                }
        }

        ),
      ],
    );
  }

  List<DataRow> _vendorDetailsRows(QuerySnapshot snapshot , FirebaseServices services){
    List<DataRow> newList = snapshot.docs.map((DocumentSnapshot document) {
      return DataRow(cells: [
        DataCell(Text(document['shopName'])),

        DataCell(
        IconButton(
          onPressed: (){


            services.updateVendorsStatus(
                id :document['uid'],
                accverified : document['accverified'],
                istoppicked : !document['isTopPicked'],
                shopOpen: !document['shopOpen'],
            );  },
          icon : document['accverified']?
              Icon(
                Icons.check_circle,
                color: Colors.green,
              ):
              Icon(
                Icons.remove_circle,
                color: Colors.red,
              ),

        )

      ), //accverified
        DataCell(
            IconButton(
              onPressed: (){

                services.updateVendorsStatus(

                    id :document['uid'],
                    istoppicked : document['isTopPicked'],
                    accverified: !document['accverified'],
                  shopOpen: !document['shopOpen'],
                );


              },
              icon : document['isTopPicked']?
              Icon(
                Icons.check_circle,
                color: Colors.green,
              ):
              Icon(
                null
              ),

            )

        ),

        DataCell(
            IconButton(
              onPressed: (){


                services.updateVendorsStatus(
                    id :document['uid'],
                    shopOpen: document['shopOpen'],
                    accverified : !document['accverified'],
                    istoppicked : !document['isTopPicked'],


                );  },
              icon : document['shopOpen']?
              Icon(
                Icons.check_circle,
                color: Colors.green,
              ):
              Icon(
                Icons.remove_circle,
                color: Colors.red,
              ),

            )

        ),//isTopPicked

        DataCell(Row(
          children: [
            Text('3.2 ',),
            Icon(Icons.star , color: Colors.grey,)
          ],
        )),
        DataCell(Text('20000')),
        DataCell(Text(document['email'])),
        DataCell(Text(document['mobile'])),
        DataCell(
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: (){

              showDialog(context: context, builder: (BuildContext context){

                return VendorDetailsBox(document['uid']);
              });
            },

          )
        ),








      ]);
    }).toList();

    return newList;



  }
}
