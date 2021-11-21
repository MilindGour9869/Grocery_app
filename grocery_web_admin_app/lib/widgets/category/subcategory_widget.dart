import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grocerywebadminapp/services/firebase_service.dart';

class SubCategorywidget extends StatefulWidget {

  final String categoryName;
  SubCategorywidget(this.categoryName);


  @override
  _SubCategorywidgetState createState() => _SubCategorywidgetState();
}

class _SubCategorywidgetState extends State<SubCategorywidget> {

  FirebaseServices _services = FirebaseServices();
  var _subCategoryController=TextEditingController();


  @override
  Widget build(BuildContext context) {
    print('catname ; ');
    print(widget.categoryName);
    return Dialog(
      child: Column(


        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Container(
//              height: MediaQuery.of(context).size.height*.3,

              width: 300,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: FutureBuilder<DocumentSnapshot>(
                  future: _services.category.doc(widget.categoryName).get(),
                  builder:
                      (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

                    if (snapshot.hasError) {
                      return Text("Something went wrong");
                    }

//                  if (snapshot.hasData && snapshot.data.exists) {
//                    return Text("Document does nk;kn;k not exist");
//                  }

                    if (snapshot.connectionState == ConnectionState.done) {

                      if(!snapshot.hasData)
                        {
                          return Text('No Added subcategory');
                        }

                         Map<String, dynamic> data = snapshot.data.data() ;
                        print('weedked');

                        print(snapshot.data.data());



                          return Column(

                            children: [
                              Container(

                                child: Column(

                                  children: [


                                    Row(
                                      children: [
                                        Text('Main Category : '),
                                        Text(widget.categoryName , style:TextStyle(fontWeight: FontWeight.bold),)
                                      ],
                                    ),
                                    Divider(thickness: 3,)
                                  ],
                                ),
                              ),

                              Expanded(
                                child: Container(


                                  child: Expanded(
                                    child: ListView.builder(
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      itemBuilder: (BuildContext context , int index){

                                      return ListTile(

                                        contentPadding: EdgeInsets.zero,
                                        leading: CircleAvatar(
                                          child: Text('${index+1}'),
                                        ),
                                        title: Text(data['subcat'][index]['name']),

                                      );

                                    },
                                     itemCount: data['subcat']==null?0:data['subcat'].length,

                                    ),
                                  ),

                                ),
                              )


                            ],
                          );

                    }

                    return Center(child: CircularProgressIndicator());
                  },
                ),
              ),

            ),
          ),
          Container(

            child: Column(

              children: [
                Divider(thickness: 3,),
                Container(

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,

                    children: [

                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                height: 50,
                                child: TextField(
                                  controller: _subCategoryController,
                                  decoration: InputDecoration(
                                    hintText:'Add Category Name',
                                    enabledBorder: OutlineInputBorder(),

                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        width: 2,
                                        color: Theme.of(context).primaryColor,
                                      ),

                                    ),

                                    focusColor: Theme.of(context).primaryColor,




                                  ),
                                ),
                              ),
                            ),

                          ),

                          FlatButton(
                            minWidth: 20,
                            onPressed: (){

                              if(_subCategoryController.text.isEmpty)
                              {
                                return  _services.showMyDialog(
                                    title: 'SubCategory Name not given',
                                    context: context,
                                    message: 'Add SubCategory Name'
                                );
                              }

                              DocumentReference doc = _services.category.doc(widget.categoryName);
                              doc.update({
                                'subcat' : FieldValue.arrayUnion([
                                  {
                                    'name' : _subCategoryController.text,

                                  }
                                ])
                              });
                              setState(() {

                              });

                              _subCategoryController.clear();






                            },
                            child: Icon(Icons.send),
                          )
                        ],
                      )
                    ],
                  ),
                )

              ],
            ),
          )

        ],
      ),
    );
  }
}
