import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:groceryvendor/service/firebase_service.dart';

class PublishedProducts extends StatelessWidget {

  FirebaseServices _services = FirebaseServices();


  @override
  Widget build(BuildContext context) {

    return Container(
      child: StreamBuilder(
        stream: _services.products.where('published',isEqualTo: true).snapshots(),
        builder: (context , snapshot)
        {
          if(snapshot.hasError){
            return Text('Has error');
          }

          if(snapshot.connectionState==ConnectionState.waiting)
          {
            return Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            child: DataTable(

              showBottomBorder: true,
              dataRowHeight: 60,
              headingRowColor: MaterialStateProperty.all(Colors.grey[200]),

              columns: <DataColumn>[
                DataColumn(label: Expanded(child: Text('Product Name'))),
                DataColumn(label: Text('Image')),
                DataColumn(label: Text('Actions')),

              ],



              rows:productDetails(snapshot.data),



            ),
          );
        },
      ),
    );
  }

  List<DataRow> productDetails(QuerySnapshot snapshot)
  {
    List<DataRow> newList = snapshot.docs.map((DocumentSnapshot document){
      if(document!=null)
      {
        return DataRow(
            cells: [
              DataCell(Container(child: ListTile(
                title: Text(document['productName']),
                subtitle: Text(document['sku']),
              ))),
              DataCell(Container(child:Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.network(document['productUrl']),
              ) )),
              DataCell(PopUpButton(document.data())),

            ]

        );
      }
    }).toList();

    return newList;

  }


  Widget PopUpButton(data , {BuildContext context})
  {
    return PopupMenuButton<String>(

        onSelected: (String value){

          if(value=='Un Publish')
          {
            _services.publishProduct(id: data['productID'] , value: value);
          }
          if(value=='Delete')
          {
            _services.DeleteProduct();
          }

        },
        itemBuilder: (BuildContext context)=><PopupMenuEntry<String>>[
          const PopupMenuItem<String>(

            value: 'Un Publish',
            child:ListTile(
              leading: Icon(Icons.check),
              title: Text('Un Publish'),
            ), ),



          const PopupMenuItem<String>(

            value: 'Delete Product',
            child:ListTile(
              leading: Icon(Icons.delete),
              title: Text('Delete Product'),
            ), ),

        ]);
  }
}
