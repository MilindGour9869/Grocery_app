import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:groceryvendor/provider/product_provider.dart';
import 'package:provider/provider.dart';

class MenuWidget extends StatefulWidget {
  final Function(String) onItemClick;

  const MenuWidget({Key key, this.onItemClick}) : super(key: key);

  @override
  State<MenuWidget> createState() => _MenuWidgetState();
}

class _MenuWidgetState extends State<MenuWidget> {

  User user = FirebaseAuth.instance.currentUser;
  var vendorData;



  @override
  void initState() {
     getVendorData();
    // TODO: implement initState
    super.initState();
  }

  Future<DocumentSnapshot>getVendorData()async{





var result =  await FirebaseFirestore.instance.collection('vendors').doc(user.uid).get();

print(result.data());


setState(() {
  vendorData=result;

});

return result;
  }

  @override
  Widget build(BuildContext context) {

  var  _productprovider= Provider.of<ProductProvider>(context);
  _productprovider.ShopName(vendorData==null?'':vendorData.data()['shopName']);
  //setState() or markNeedsBuild() called during build. //problem is due to above line ...Not Solved , solve it later




    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(top: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 4,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FittedBox(
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: Colors.grey,
                    child: CircleAvatar(
                      radius: 30,
                      backgroundImage: vendorData!=null?NetworkImage(vendorData.data()['ImageUrl']):null,

                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(vendorData==null?'Shopname':vendorData.data()['shopName'],

                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                    ),
                  ),
                ],
              ),
            ),
          ),


          SizedBox(
            height: 10,
          ),
          sliderItem('Dashboard', Icons.dashboard),
          sliderItem('Products', Icons.shopping_bag),
          sliderItem('Banner', Icons.photo),
          sliderItem('Coupon', Icons.card_giftcard),
          sliderItem('Orders', Icons.list),
          sliderItem('Reports', Icons.stacked_bar_chart),
          sliderItem('Setting', Icons.settings),
          sliderItem('LogOut', Icons.arrow_back_ios)
        ],
      ),
    );




  }

  Widget sliderItem(String title, IconData icons) => ListTile(
      title: Text(
        title,
        style:
        TextStyle(color: Colors.black, ),
      ),
      leading: Icon(
        icons,
        color: Colors.black,
      ),
      onTap: () {
        widget.onItemClick(title);
        print(title);

      });
}