import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:groceryapp/provider/auth_provider.dart';
import 'package:groceryapp/provider/location_provider.dart';
import 'package:groceryapp/screens/home_screen.dart';
import 'package:groceryapp/screens/map_screen.dart';
import 'package:groceryapp/screens/onboard_screen.dart';
import 'package:provider/provider.dart';



class Welcomescreen extends StatefulWidget {




  static const String id= 'welcome-screen';

  @override
  _WelcomescreenState createState() => _WelcomescreenState();
}

class _WelcomescreenState extends State<Welcomescreen> {
  @override
  Widget build(BuildContext context) {

    final auth = Provider.of<AuthProvider>(context);
    final LocationData = Provider.of<LocationProvider>(context);


    bool _validphonenumber = false;
    var _phoneNumberController = TextEditingController();


    void showbottomsheet(context){
      showModalBottomSheet(context: context,

          builder:(context)=> StatefulBuilder(

              builder: (context , StateSetter mystate){
                return Container(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
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
                              mystate((){
                                _validphonenumber = true;
                              });
                            }
                            else {
                              mystate((){
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

                                    mystate((){
                                      auth.loading = true;
                                    });

                                    String number = '+91${_phoneNumberController.text}';
                                    auth.verifyphone(
                                        context:context,
                                        number :number ,

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
                );


              }
          ));
    }



    return Scaffold(
      body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Stack(
            children: [
              Positioned(
                right: 0.0,
                top: 10.0,
                child: FlatButton(
                  child: Text('SKIP' , style: TextStyle(color: Theme.of(context).primaryColor , fontWeight: FontWeight.bold),

                  ),
                  onPressed: (){}

                  ,
                ) ,
              ),

              Column(
                children: <Widget>[
                  Expanded(child: Onboardscreen()),
                  Text('Ready to order form your nearest shop ?' , style: TextStyle(color: Colors.grey),),
                  SizedBox(height: 20,),
                  FlatButton(
                    color: Theme.of(context).primaryColor ,
                    child: LocationData.loading?CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    )
                        :Text('Set Delivery location' , style: TextStyle(color: Colors.white),),
                    onPressed: ()async{
                      setState(() {
                        LocationData.loading=true;
                      });
                      await LocationData.getCurrentPosition();

                      if(LocationData.permissionallowed==true)
                        {
                          LocationData.getCurrentPosition().then((value){

                            Navigator.pushNamed(context, Mapscreen.id);
                           //8 930
                            setState(() {
                              LocationData.loading=false;
                            });


                          });
                        }
                      else{
                        print('\n permission error \n');
                        //8 930
                        setState(() {
                          LocationData.loading=false;
                        });
                      }

                    },
                  ),

                  FlatButton(
                    child: RichText( text : TextSpan(
                        text: 'Already a customer ?',
                        style: TextStyle(color: Colors.black),
                        children: [
                          TextSpan(
                              text: ' Login' , style: TextStyle(fontWeight: FontWeight.bold , color: Theme.of(context).primaryColor)
                          )
                        ]
                    ),


                    ),
                    onPressed: (){


                      showbottomsheet(context);
                    }

                    ,
                  ),
                ],
              ),
            ],
          )
      ),
    );
  }
}

