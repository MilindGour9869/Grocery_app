import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:groceryvendor/provider/product_provider.dart';
import 'package:groceryvendor/service/firebase_service.dart';
import 'package:provider/provider.dart';

FirebaseServices _services = FirebaseServices();

class CategoryList extends StatefulWidget {
  @override
  _CategoryListState createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  @override
  Widget build(BuildContext context) {
    var _productprovider = Provider.of<ProductProvider>(context);
    return Dialog(
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            color: Theme.of(context).primaryColor,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Select Category',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.close,
                        color: Colors.white,
                      ))
                ],
              ),
            ),
          ),
          StreamBuilder<QuerySnapshot>(
              stream: _services.category.snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text("Something went wrong");
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                return Expanded(
                    child: ListView(
                  children: snapshot.data.docs.map((DocumentSnapshot document) {
                    print(document['image'].toString());
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(document['image']),
                      ),
                      title: Text(document['Category Name']),
                      onTap: () {
                        _productprovider.SelecteCategory(
                            document['Category Name'] , document['image']);
                        Navigator.pop(context);
                      },
                    );
                  }).toList(),
                ));
              }),
        ],
      ),
    );
  }
}

class SubCategoryList extends StatefulWidget {
  @override
  _SubCategoryListState createState() => _SubCategoryListState();
}

class _SubCategoryListState extends State<SubCategoryList> {
  @override
  Widget build(BuildContext context) {
    var _productprovider = Provider.of<ProductProvider>(context);

    return Dialog(
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            color: Theme.of(context).primaryColor,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Select SubCategory',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.close,
                        color: Colors.white,
                      ))
                ],
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<DocumentSnapshot>(
              future: _services.category
                  .doc(_productprovider.selectedCategory)
                  .get(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text("Something went wrong");
                }

                if (snapshot.connectionState == ConnectionState.done) {
                  if (!snapshot.hasData) {
                    return Text('No Added subcategory');
                  }

                  Map<String, dynamic> data = snapshot.data.data();
                  print('weedked');

                  print(snapshot.data.data());

                  return Column(
                    children: [
                      Container(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Row(
                                mainAxisAlignment : MainAxisAlignment.center,

                                children: [
                                  Text('Main Category : ' , style: TextStyle(fontSize: 18)),
                                  Text(
                                    _productprovider.selectedCategory,
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                  )
                                ],
                              ),
                            ),
                            Divider(
                              thickness: 3,
                            )
                          ],
                        ),
                      ),

                      data['subcat']==null?Center(child: Text('No Sub Category Added')):Expanded(
                        child: Container(
                          child: Expanded(
                            child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemBuilder: (BuildContext context, int index) {
                                return ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    leading: CircleAvatar(
                                      child: Text('${index + 1}'),
                                    ),
                                    title: Text(data['subcat'][index]['name']),
                                    onTap: () {
                                      _productprovider.SelecteSubCategory(
                                          data['subcat'][index]['name']);
                                      Navigator.pop(context);
                                    });
                              },
                              itemCount: data['subcat'] == null
                                  ? 0
                                  : data['subcat'].length,
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
          )
        ],
      ),
    );
  }
}
