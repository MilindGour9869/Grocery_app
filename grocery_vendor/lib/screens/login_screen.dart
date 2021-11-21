

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:groceryvendor/provider/auth_provider.dart';
import 'package:groceryvendor/screens/home_screen.dart';
import 'package:groceryvendor/screens/registration_screen.dart';
import 'package:groceryvendor/screens/reset-password.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {

  static const String id = 'login-screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  Icon icon;
  bool _visible=true;

  final _formkey=GlobalKey<FormState>();
  String email;
  String password;
  var _emailTextController = TextEditingController();
  bool _loading = false;

  @override
  Widget build(BuildContext context) {

    final _authData = Provider.of<AuthProvider>(context);
    return SafeArea(
      child: Scaffold(

        resizeToAvoidBottomInset: false,
        body: Form(
          key: _formkey,
          child: Padding(
            padding: const EdgeInsets.all(40.0),
            child: Center(

              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('LOGIN' , style: TextStyle(fontFamily: 'Anton' , fontSize: 30),),
                            SizedBox(width: 20,),
                            Image.asset('images/logo.png' ,height: 80,),
                          ],
                        ) ,
                        SizedBox(height: 20,),
                        TextFormField(
                          controller: _emailTextController,
                          validator: (value){
                            if(value.isEmpty)
                             { return 'Enter Email';}

                            final bool _isValid = EmailValidator.validate(_emailTextController.text);
                            if(!_isValid)
                            {
                              return 'Invalid Email';
                            }
                            setState(() {
                              email=value;
                            });

                            return null;
                          },
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(),
                            contentPadding: EdgeInsets.zero,
                            hintText: 'Email',
                            prefixIcon: Icon(Icons.email_outlined) ,
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color:Theme.of(context).primaryColor , width: 2)
                            ),
                            focusColor: Theme.of(context).primaryColor,
                          ),
                        ),

                        SizedBox(height: 20,),


                        TextFormField(
                        validator: (value){
                                  if(value==null ||value.isEmpty )
                                    {
                                           return 'Enter Password';

                                    }
                                   if(value.length<6)
                                      {
                                             return 'Minimum 6 character  required';

                                        }
                                   setState(() {
                                     password=value;
                                   });
                        return null;
                        },
                          obscureText: _visible ? true:false,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(icon:_visible? Icon(Icons.visibility) : Icon(Icons.visibility_off) ,
                              onPressed: ()
                            { setState(() {
                              _visible=!_visible;
                            }); },),
                            enabledBorder: OutlineInputBorder(),
                            contentPadding: EdgeInsets.zero,
                            hintText: 'Password',
                            prefixIcon: Icon(Icons.vpn_key_outlined) ,
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color:Theme.of(context).primaryColor , width: 2)
                            ),
                            focusColor: Theme.of(context).primaryColor,
                          ),
                        ),
                        SizedBox(height: 10,),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [

                            InkWell(onTap:(){

                              Navigator.pushNamed(context, ResetPassword.id);


                            },
                              child: Text('Forgot Password ?' , textAlign: TextAlign.end, style: TextStyle(color: Colors.blue , fontWeight: FontWeight.bold), ),
                            ),
                          ],
                        ) ,
                        SizedBox(height: 20,),



                        Row(
                          children: [
                            Expanded(child: FlatButton(onPressed: (){

                              if(_formkey.currentState.validate())
                                {
                                  setState(() {
                                    _loading=true;
                                  });
                                  _authData.loginVendor(email, password).then((credential){
                                    if(credential!=null)

                                      {
                                        setState(() {
                                          _loading=false;
                                        });
                                        Navigator.pushReplacementNamed(context, HomeScreen.id);
                                      }
                                    else
                                      {
                                        setState(() {
                                          _loading=false;
                                        });
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Login Failed')));
                                      }

                                  });

                                }

                            }, child: _loading?LinearProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              backgroundColor: Colors.transparent,
                            ):Text('LOGIN' , style: TextStyle(color: Colors.white , fontWeight: FontWeight.bold),) , color: Theme.of(context).primaryColor,)),
                          ],
                        ),
                        Row(
                          children: [
                            FlatButton(
                              padding: EdgeInsets.zero,

                              onPressed: (){
                                Navigator.pushNamed(context, RegistrationScreen.id);
                              },

                              child:RichText(
                                text:TextSpan(
                                    text: '' ,
                                    children:[
                                      TextSpan(text: 'Dont\'t han=ve an account ?' , style: TextStyle(color:Colors.black54),),
                                      TextSpan(text: 'Register', style: TextStyle(color: Colors.redAccent))
                                    ]

                                )), ),
                          ],
                        )


                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
