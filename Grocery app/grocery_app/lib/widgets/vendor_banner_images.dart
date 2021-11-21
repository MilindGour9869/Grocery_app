import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:groceryapp/provider/store_provider.dart';
import 'package:provider/provider.dart';
class VendorBannerImages extends StatefulWidget {
  @override
  _VendorBannerImagesState createState() => _VendorBannerImagesState();
}

class _VendorBannerImagesState extends State<VendorBannerImages> {
  int _index =0;
  int _datalenght=1;


  @override
  void didChangeDependencies() {
    final storeData = Provider.of<StoreProvider>(context);
    getSliderImageFromDB(storeData);
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }



  Future getSliderImageFromDB(StoreProvider storeData)async{
    var _firestore = FirebaseFirestore.instance;
    QuerySnapshot snapshot = await _firestore.collection('vendorBanner').where('shopName', isEqualTo: storeData.document['shopName'] ).get();

    if(mounted)
    {
      setState(() {
        _datalenght=snapshot.docs.length;

      });
    }
    return snapshot.docs;
  }


  @override
  Widget build(BuildContext context) {

    final storeData = Provider.of<StoreProvider>(context);

    return Column(
      children: [
        if(_datalenght!=0)
          FutureBuilder(
              future: getSliderImageFromDB(storeData),
              builder: (_ , snapshot){
                return snapshot.data==null?Center(child: CircularProgressIndicator(),):Padding(
                  padding: const EdgeInsets.only(top:4.0),
                  child: CarouselSlider.builder(
                      itemCount: snapshot.data.length, itemBuilder: (context , int index , int a)
                  {
                    DocumentSnapshot sliderimage=snapshot.data[index];
                    Map getimage = sliderimage.data();

                    return SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Image.network(getimage['image'] , fit:BoxFit.fill));

                  },
                      options:CarouselOptions(
                          viewportFraction: 1,
                          initialPage: 0,
                          autoPlay: true,
                          height: 150,
                          onPageChanged:(int i , carouselPageChangedReason)
                          {
                            setState(() {
                              _index=i;
                            });

                          }


                      ) ),
                );
              }) ,
        DotsIndicator(
          dotsCount: _datalenght,
          position: _index.toDouble(),
          decorator: DotsDecorator(
            size: const Size.square(5.0),
            activeSize: const Size(18.0, 5.0),
            activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
            activeColor:Theme.of(context).primaryColor ,
          ),
        ),
      ],
    );
  }
}
