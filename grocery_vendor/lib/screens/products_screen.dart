import 'package:flutter/material.dart';
import 'package:groceryvendor/screens/add_products_screen.dart';
import 'package:groceryvendor/widget/published_products.dart';
import 'package:groceryvendor/widget/unpublished_product.dart';

class ProductsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: Column(
          children: [
            Material(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 5.0),
                      child: Container(
                        child: Row(
                          children: [
                            Text('Products' , style: TextStyle(fontWeight: FontWeight.bold),),
                            SizedBox(width: 10,),
                            CircleAvatar(
                              backgroundColor: Colors.black54,
                              maxRadius: 10,
                              child: FittedBox(
                                child: Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Text('20' , style: TextStyle(color: Colors.white ),),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),


                    FlatButton.icon(
                      icon: Icon(Icons.add , color: Colors.white,),
                      label:Text('Add Products' , style: TextStyle(color: Colors.white),),
                      color: Theme.of(context).primaryColor,

                      onPressed: (){

                        Navigator.pushNamed(context, AddProducts.id);

                      },
                    )
                  ],
                ),
              ),
            ),
            TabBar(
              unselectedLabelColor:Colors.black54 ,
              labelColor:Theme.of(context).primaryColor ,
              indicatorColor: Theme.of(context).primaryColor,
              tabs: [
                Tab(text: 'PUBLISHED',),
                Tab(text: 'UNPUBLISHED',)
              ],
            ),
            Expanded(
              child: Container(
                child: TabBarView(
                  children: [
                    PublishedProducts(),
                    UnPublishedProducts(),

                  ],

                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
