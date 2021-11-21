import 'package:flutter/material.dart';
import 'package:groceryapp/provider/store_provider.dart';
import 'package:groceryapp/widgets/products/featured_products.dart';
import 'package:groceryapp/widgets/vendor_banner_images.dart';
import 'package:groceryapp/widgets/vendor_category.dart';
import 'package:provider/provider.dart';

class VendorHomeScreen extends StatelessWidget {

  static const String id='vendor-home-screen';
  @override
  Widget build(BuildContext context) {

    final storeData = Provider.of<StoreProvider>(context);

    return Scaffold(
        body:NestedScrollView(
        headerSliverBuilder: (BuildContext context , bool innerBoxisScrolled)
    {
      return [
        SliverAppBar(
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          actions: [
            IconButton(onPressed: (){}, icon: Icon(Icons.search))
          ],
          title: Text('${storeData.document['shopName']}' , style: TextStyle(fontWeight: FontWeight.bold , color: Colors.white),),

        ),
      ];
    },

    body: ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: [
        VendorBannerImages(),
        VendorCategory(),
        FeaturedProduct(),
        FeaturedProduct(),
        FeaturedProduct(),
        FeaturedProduct(),




      ],
    ),
    ));
  }
}
