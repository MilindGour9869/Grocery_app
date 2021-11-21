import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:groceryapp/provider/location_provider.dart';
import '../screens/home_screen.dart';
import 'package:groceryapp/services/user_services.dart';

class AuthProvider with ChangeNotifier{
  String smsOtp;
  String verificationId;
  String error = '';
 FirebaseAuth _auth = FirebaseAuth.instance;
 bool loading = false ;
 UserServices _userServices = UserServices();
 LocationProvider locationData = LocationProvider();
  Future<void> verifyphone({BuildContext context, String number  })async{


    this.loading=true;
    notifyListeners();

    final PhoneVerificationCompleted verificationCompleted = (PhoneAuthCredential credential) async {
      // ANDROID ONLY!
      // Sign the user in (or link) with the auto-generated credential
      await _auth.signInWithCredential(credential);
      print('\n');
      print(credential);
      print('\n');
      this.loading=false;
      notifyListeners();
    };
    print('\n');
    print('\n');
    print(verificationCompleted);
    print('\n');

    final PhoneVerificationFailed  verificationFailed= (FirebaseAuthException e) async{
      this.loading=false;
      print('\n');
      print('\n');
      print(e.code);
      print('\n');
      print('\n');
      this.error=e.toString();
      notifyListeners();

    };

    final PhoneCodeSent smsotpSend= (String verId, int resendToken) async //call back fun is created
    {
      this.verificationId = verId;

      smsOtpDialog(context, number );
    };

try{
_auth.verifyPhoneNumber(
  phoneNumber: number,
  verificationCompleted: verificationCompleted,
  verificationFailed: verificationFailed,
  codeSent: smsotpSend,
  timeout: const Duration(seconds: 60),
  codeAutoRetrievalTimeout: (String verId) {
    this.verificationId=verId;
  },
);

}catch(e)
    {  print(e);
    this.error=e.toString();
    notifyListeners();
  }
}

Future<bool> smsOtpDialog(BuildContext context , String number  ){
    return showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Column(
              children: [
                Text('Verification code'),
                SizedBox(height: 6,),
                Text('Enter 6 digit number as on sms ' , style: TextStyle(color: Colors.grey, fontSize: 12),)
              ],
            ),
            content: Container(
              height: 85,
              child:TextField(
                textAlign: TextAlign.center,
                keyboardType: TextInputType.phone,
                maxLength: 6,
                onChanged: (value){
                  this.smsOtp = value;
                },
              )
            ),

            actions:[
              TextButton(

                  onPressed: ()async{

                    try{
                      PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smsOtp);
                      final User user =  (await _auth.signInWithCredential(credential)).user ;



                      _userServices.getUserById(user.uid).then((snapshot) async {

                        if (snapshot.exists)
                        { print(user.uid);
                         await updateUser(id: user.uid , number: number , latitude: LocationProvider.Latitude , longitude: LocationProvider.Longitude , address:LocationProvider.selectedAddress.addressLine);
                          print('\n');
                          print(LocationProvider.selectedAddress.addressLine.toString());
                        locationData.savePrefs();
                        }
                        else
                        {  print('\n in else');
                          await locationData.getCurrentPosition().then((value){

                            _createUser(id:user.uid , number: user.phoneNumber , latitude:LocationProvider.Latitude, longitude: LocationProvider.Longitude, address: LocationProvider.selectedAddress.addressLine);




                            print('\n createruser called');
                            print('\n');
                            print(LocationProvider.Longitude);
                            locationData.savePrefs();
                        });
                        print('\n in else');

                        }

                      });


                                if(user!=null)

                          { //after login , destoring welcome screen becoz not come again after login

                          this.loading=false; // to make animation circle stop
                          print('\n');
                          print('\n');
                          print('user != null');
                          print('\n');

                          Navigator.pushReplacementNamed(context, Homescreen.id);



                        }
                      else {
                                  print('login failed \n');
                                }


                    }catch(e){
                     print(e.toString());
                     this.error='\n Invalid otp';
                     Navigator.of(context).pop();


                    }

                    },
                  child: Text('DONE'))
            ],
          );
        });
}
 void _createUser({String id , String number , double latitude , double longitude , String address})
 {
   print('\n creater user called \n');
   _userServices.createUserData({'id':id, 'number':number, 'latitude':latitude , 'longitude' : longitude ,'address' : address });// fun call & also passing arguments


 }

  void updateUser({String id , String number , double latitude , double longitude , String address})
  {  print('\n update user called \n');
    _userServices.updateUserData({'id':id, 'number':number, 'latitude':latitude , 'longitude' : longitude  ,'address' : address }); // fun call & also passing arguments

  }




}




