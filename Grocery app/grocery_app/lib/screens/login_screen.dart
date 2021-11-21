import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:groceryapp/provider/auth_provider.dart';
import 'package:groceryapp/provider/location_provider.dart';
import 'package:groceryapp/screens/home_screen.dart';
import 'package:provider/provider.dart';

class Loginscreen extends StatefulWidget {
  static const String id = 'login-screen';
  @override
  _LoginscreenState createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {
  bool _validphonenumber = false;
  var _phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    final auth = Provider.of<AuthProvider>(context);
    final LocationData = Provider.of<LocationProvider>(context);

    return Scaffold(
      body: Container(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(

              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[

                Visibility(
                    visible: auth.error=='Invalid otp' ? true:false,
                    child: Column(children: [
                      Text(auth.error , style: TextStyle(color: Colors.red , fontSize: 12),),
                      SizedBox(height: 3,),
                    ],)
                ),
                Text('LOGIN' , style: TextStyle(fontSize: 25 , fontWeight: FontWeight.bold),),
                SizedBox(height: 5,),
                Text('Enter your Phone Number to proceed' , style: TextStyle(fontSize: 12 , color: Colors.grey),),
                SizedBox(height:30),
                TextField(decoration: InputDecoration(
                  prefixText: '+91 ',
                  labelText: 'Enter 10 digit Phone Number',
                ),
                  autofocus: true,
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  controller: _phoneNumberController,
                  onChanged: (value){
                    if(value.length == 10)
                    {
                      setState((){
                        _validphonenumber = true;
                      });
                    }
                    else {
                      setState((){
                        _validphonenumber = false;
                      });
                    }
                  },
                ),
                SizedBox(height: 10,),
                Row(

                  children: <Widget>[
                    Expanded(
                      child: AbsorbPointer(
                        absorbing: _validphonenumber ? false:true,
                        child: FlatButton(
                          onPressed: (){

                            setState((){
                              auth.loading = true;
                            });

                            String number = '+91${_phoneNumberController.text}';
                             auth.verifyphone(
                              context:context,
                              number :number,

                             ).then((value){
                              _phoneNumberController.clear();




                            });

                          },
                          color:_validphonenumber ? Theme.of(context).primaryColor : Colors.grey,
                          child: auth.loading?CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),

                          )
                              :Text(_validphonenumber ?'Get OTP':'Enter Phone Number' , style: TextStyle(color: Colors.white),),

                        ),
                      ),
                    )
                  ],
                )


              ],
            ),
          ),
      ),
    );
  }
}

