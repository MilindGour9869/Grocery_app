import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grocerywebadminapp/widgets/category/subcategory_widget.dart';

class CategoryCard extends StatelessWidget {

  final DocumentSnapshot doc;
  CategoryCard(this.doc);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(4),
      onTap: (){
        showDialog(
            context: context,
            builder: (BuildContext context){
              return SubCategorywidget(doc['Category Name']);
            }
            );

      },
      child: SizedBox(
        height: 120,
        width: 120,
        child: Card(

          elevation: 4,
          child:Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                      height: 70,
                      width: double.infinity,
                      child: Image.network(doc['image'])),

                  FittedBox(fit : BoxFit.cover,child: Text(doc['Category Name'])),


                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
