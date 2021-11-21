import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {

  final DocumentSnapshot document;

  ProductCard(this.document);

  @override
  Widget build(BuildContext context) {
    return Container(

      height: 150,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        border:Border(
          bottom: BorderSide(
            width: 1, color: Colors.grey[300]
          )
        )
      ),
      child: Padding(
        padding:
            const EdgeInsets.only(top: 8.0, bottom: 8, left: 10, right: 10),
        child: Row(
          children: [
            Material(
              elevation: 5,
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                height: 140,
                width: 130,
                child: Image.asset('images/logo.png'),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 8.0 , top: 7),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Column(

                      children: [
                        Text(
                          'Brand',
                          style: TextStyle(fontSize: 10),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'ProductName',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width-160,
                          padding: EdgeInsets.only(top: 10,bottom: 10,right: 6,left: 6),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color:Colors.grey[200]
                          ),
                          child: Text(
                            '1kg',
                            style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12, color: Colors.grey[600]),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Text('\$30' , style: TextStyle( fontWeight: FontWeight.bold,),),
                            SizedBox(width: 5,),
                            Text('\$35' , style: TextStyle(decoration: TextDecoration.lineThrough,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                                fontSize: 12),),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width-160,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Card(
                                color: Colors.pink,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 7.0 , left: 30 , right: 30 , bottom: 7),
                                  child: Text('Add' , style: TextStyle(fontSize: 12 , fontWeight: FontWeight.bold),),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}
