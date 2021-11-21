import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:groceryvendor/provider/auth_provider.dart';
import 'package:groceryvendor/screens/login_screen.dart';
import 'package:provider/provider.dart';

class ResetPassword extends StatefulWidget {
  static const String id = 'reset=password';

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final _formkey=GlobalKey<FormState>();

  String email;

  String password;

  var _emailTextController = TextEditingController();
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    final _authData = Provider.of<AuthProvider>(context);
    return Scaffold(
      body: Form(
        key: _formkey,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
            children: [
              //Image.asset('images/resetPassword.png' , height: 180,),
              SizedBox(height: 10,),

              RichText(
                  text:TextSpan(
                text: 'Dont worry , To reset password , \nProvide your registered email to which we will send an email to reset the password' ,
                style: TextStyle(
                  color: Colors.red
                )

              )),
              SizedBox(height: 10,),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FlatButton(
                    color: Theme.of(context).primaryColor,

                    onPressed: (){
                      if(_formkey.currentState.validate())
                        {
                          _authData.resetPassword(email);
                          Navigator.pushReplacementNamed(context, LoginScreen.id);

                        }
                    },
                    child: _loading?LinearProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      backgroundColor: Colors.transparent,
                    ):Text('Reset Password' , style: TextStyle(color: Colors.white),),
                  ),
                ],
              ),
            ],
            ),
          ),
        ),
      ),
    );
  }
}
