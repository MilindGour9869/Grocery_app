import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class FirebaseServices{

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference banners = FirebaseFirestore.instance.collection('slider');
  FirebaseStorage storage = FirebaseStorage.instance;
  CollectionReference vendors = FirebaseFirestore.instance.collection('vendors');
  CollectionReference category = FirebaseFirestore.instance.collection('category');


  Future<QuerySnapshot> getAdminCredential()
{ var result = FirebaseFirestore.instance.collection('Admin').get();
  return result;

}

Future<String> uploadBannerImageToDb(url)async{

    if(url!=null)
      {
        firestore.collection('slider').add({
          'image':url,
        });

        return url;
      }
}

  Future<String> uploadCategoryImageToDb(url , catName)async{

    if(url!=null)
    {
      category.doc(catName).set({
        'image':url,
        'Category Name':catName,
      });

      return url;
    }
  }




  deleteBannerImageFromDb(id)async{
    firestore.collection('slider').doc(id).delete();
  }

   updateVendorsStatus({id, bool accverified , bool istoppicked , bool shopOpen}){
    vendors.doc(id).update(
      {
        'accverified' : accverified?false:true,
        'isTopPicked' : istoppicked?false:true,
        'shopOpen'    : shopOpen?false:true,
      }

    );

   }


  Future<void> confirmDeleteDialog({title , message , context , id}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),

              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),

            TextButton(
              child: Text('delete'),
              onPressed: () {

                deleteBannerImageFromDb(id);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> showMyDialog({title , message , context}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),

              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}