import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:groceryvendor/screens/edit_view_product_screen.dart';
import 'package:groceryvendor/service/firebase_service.dart';

class UnPublishedProducts extends StatelessWidget {

  FirebaseServices _services = FirebaseServices();


  @override
  Widget build(BuildContext context) {

    return Container(
      child: StreamBuilder(
        stream: _services.products.where('published',isEqualTo: false).snapshots(),
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
                DataColumn(label: Expanded(child: Text('Image'))),
                DataColumn(label: Expanded(child: Text('Preview'))),
                DataColumn(label: Expanded(child: Text('Actions'))),


              ],



              rows:productDetails(snapshot.data , context),



            ),
          );
        },
      ),
    );
  }

  List<DataRow> productDetails(QuerySnapshot snapshot , context)
  {
    List<DataRow> newList = snapshot.docs.map((DocumentSnapshot document){
      if(document!=null)
        {
         return DataRow(
           cells: [
             DataCell(Container(child: ListTile(
               title: Expanded(child: Text(document['productName'] )),
               subtitle: Text(document['sku']),
             ))),

             DataCell(Container(child:Padding(
               padding: const EdgeInsets.all(3.0),
               child: Image.network(document['productUrl']),
             ) )),
             DataCell(
              IconButton(
                onPressed: (){
                  Navigator.push(context,MaterialPageRoute(builder: (context)=>EditViewProduct(document['productID'])));

                },
                icon:  Icon(Icons.info_outlined),
              )
             ),

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

          if(value=='Publish')
            {
              _services.publishProduct(id: data['productID'], value: value);
            }
          if(value=='Delete')
            {
              _services.DeleteProduct();
            }

        },
        itemBuilder: (BuildContext context)=><PopupMenuEntry<String>>[
          const PopupMenuItem<String>(

              value: 'Publish',
              child:ListTile(
                leading: Icon(Icons.check),
                title: Text('Publish'),
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
