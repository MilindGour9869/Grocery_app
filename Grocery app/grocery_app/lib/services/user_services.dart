import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:groceryapp/models/user_model.dart';

class UserServices{

  String collection = 'user';
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //create new user
  Future<void> createUserData(Map<String,dynamic> value)async // getting argumnets from authprovider class by fun() creatuser , sending map variable data
  {
    String id = value['id'];
    await _firestore.collection(collection).doc(id).set(value);
  }

  //update user data
  Future<void> updateUserData(Map<String,dynamic> value)async
  {
    String id = value['id'];
    await _firestore.collection(collection).doc(id).update(value);
  }

  //get user by id
  Future<DocumentSnapshot> getUserById(String id)async
  {

    var result = await _firestore.collection(collection).doc(id).get();
    return result;



  }
}