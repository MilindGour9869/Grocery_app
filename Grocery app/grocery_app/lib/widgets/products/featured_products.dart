import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:groceryapp/services/product_service.dart';
import 'package:groceryapp/widgets/products/products_card_widget.dart';

class FeaturedProduct extends StatelessWidget {

  ProductService _service = ProductService();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
        future: _service.product.get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }

          return ListView(
            children: snapshot.data.docs.map((DocumenntSnapshot){
              return new ProductCard();
            }).toList(),
          );
        });
        }
}
