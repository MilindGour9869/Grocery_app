import 'dart:io';

import 'package:email_validator/email_validator.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:groceryvendor/provider/auth_provider.dart';
import 'package:groceryvendor/screens/home_screen.dart';
import 'package:provider/provider.dart';

class RegisterForm extends StatefulWidget {
  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {

  final _formKey = GlobalKey<FormState>();
  var _emailTextController = TextEditingController();
  var _passwordController = TextEditingController();
  var _CpasswordController = TextEditingController();
  var _addressController = TextEditingController();
  var _nameController = TextEditingController();
  var _dialogController = TextEditingController();
  String email;
  String password;
  String mobile;
  String Shopname;
  bool _isLoading = false;

  Future<String> uploadFile(filePath) async {
    File file = File(filePath);
    FirebaseStorage _storage = FirebaseStorage.instance;

    try {
      await _storage.ref('uploads/ShopProfilePic/${_nameController.text}').putFile(file);
    } on FirebaseException catch (e) {
      print(e.code);
      // e.g, e.code == 'canceled'
    }

    String downloadURL = await _storage.ref('uploads/ShopProfilePic/${_nameController.text}')
        .getDownloadURL();

    return downloadURL;
  }

  ScaffoldMesssage(message){
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final _authData = Provider.of<AuthProvider>(context);
    return _isLoading?CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
    ):
    Form(
      key: _formKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: TextFormField(
              controller: _nameController,
              validator: (value){
                if(value==null ||value.isEmpty )
                  {
                    return 'Add Shop Name';

                  }
                setState(() {
                  _nameController.text=value;

                });
                setState(() {
                  Shopname=value;
                });

                return null;
              },
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.add_business),
                labelText:'Buisness Name',
                contentPadding: EdgeInsets.zero,
                enabledBorder: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 2,
                    color: Theme.of(context).primaryColor,
                  ),

                ),

                focusColor: Theme.of(context).primaryColor,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: TextFormField(
              maxLength: 10,
              keyboardType: TextInputType.number,
              validator: (value){
                if(value==null ||value.isEmpty )
                {
                  return 'Mobile Number';

                }
                setState(() {
                  mobile=value;
                });
                return null;
              },
              decoration: InputDecoration(
                prefixText: '+91',
                prefixIcon: Icon(Icons.phone_android),
                labelText:'Mobile Number',
                contentPadding: EdgeInsets.zero,
                enabledBorder: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 2,
                    color: Theme.of(context).primaryColor,
                  ),

                ),

                focusColor: Theme.of(context).primaryColor,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: TextFormField(
              keyboardType: TextInputType.emailAddress,
              controller: _emailTextController,
//             keyboardType: TextInputType.emailAddress,
              validator: (value){
                if(value==null ||value.isEmpty )
                {
                  return 'Email Address';

                }
                final bool _isValid = EmailValidator.validate(_emailTextController.text);
                if(!_isValid)
                  {
                    return 'Invalid Email';
                  }
                setState(() {
                  this.email=value;
                });

                return null;
              },
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.email),
                labelText:'Email address',
                contentPadding: EdgeInsets.zero,
                enabledBorder: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 2,
                    color: Theme.of(context).primaryColor,
                  ),

                ),

                focusColor: Theme.of(context).primaryColor,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: TextFormField(
              obscureText:true,
              controller: _passwordController,
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
                  this.password=value;
                });
                return null;
              },
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.vpn_key_outlined),
                labelText:'Password',
                contentPadding: EdgeInsets.zero,
                enabledBorder: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 2,
                    color: Theme.of(context).primaryColor,
                  ),

                ),

                focusColor: Theme.of(context).primaryColor,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: TextFormField(
              obscureText: true,
              controller: _CpasswordController,
              validator: (value){
                if(value==null ||value.isEmpty )
                {
                  return 'Enter Confirm Password';

                }
                if(value.length <6)
                {
                  return 'Minimum 6 character  required';

                }

                if(_passwordController.text != _CpasswordController.text)
                  {
                    return 'Wrong Password';


                  }
                return null;
              },
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.vpn_key_outlined),
                labelText:'Confirm Password',
                contentPadding: EdgeInsets.zero,
                enabledBorder: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 2,
                    color: Theme.of(context).primaryColor,
                  ),

                ),

                focusColor: Theme.of(context).primaryColor,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: TextFormField(
              maxLines:6,
              controller: _addressController,
              validator: (value){
                if(value==null ||value.isEmpty )
                {
                  return 'Shop Location';

                }
                return null;
              },
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.contact_mail_outlined),
                labelText:'Press Loaction Icon for Location',
                suffixIcon: IconButton(
                  icon: Icon(Icons.location_searching),
                  onPressed: () async{
                    _addressController.text = 'Locating ....please wait';
                    await _authData.getCurrentLoaction().then((value) {
                      if(value!=null)
                        {  print(_authData.shopAddress);
                          _addressController.text='${_authData.shopAddress}\n${_authData.placeName}';
                        }
                      else{
                        if (_formKey.currentState.validate())
                        {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Couldnt get location')),
                          );
                        }

                      }
                    });


                  },
                ),
                enabledBorder: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 2,
                    color: Theme.of(context).primaryColor,
                  ),

                ),

                focusColor: Theme.of(context).primaryColor,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: TextFormField(
              onChanged: (value){
                _dialogController.text=value;

              },
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.add_business),
                labelText:'Shop Dialog',
                contentPadding: EdgeInsets.zero,
                enabledBorder: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 2,
                    color: Theme.of(context).primaryColor,
                  ),

                ),

                focusColor: Theme.of(context).primaryColor,
              ),
            ),
          ),
          SizedBox(height: 10,),
          Row(
            children: [
              Expanded(child: FlatButton(
                color: Theme.of(context).primaryColor,
                onPressed: (){
                  if(_authData.isPicAvail==true)
                    {
                      if (_formKey.currentState.validate())
                      {
                        setState(() {
                          _isLoading=true;
                        });
                      _authData.VendorRegistration(email, password).then((credential){
                        if(credential.user.uid != null)
                          {
                            uploadFile(_authData.image.path).then((url){
                              if(url!=null)
                                {
                                  _authData.saveVendorDataToDb(
                                    url: url,
                                    mobile: mobile,
                                    Shopname: Shopname,
                                    Dialog:_dialogController.text

                                  );
                                    setState(() {

                                      _isLoading=false;
                                    });
                                    Navigator.pushReplacementNamed(context, HomeScreen.id);




                                }
                              else
                                {
                                  ScaffoldMesssage('Failed to upload image');
                                }
                            });
                          }
                        else{
                          ScaffoldMesssage(_authData.emailerror);

                        }

                      });
                      }
                    }
                  else
                    {
                      if (_formKey.currentState.validate())
                      {
                        ScaffoldMesssage('Required : Add Shop Image ');
                      }
                    }

                },
                child: Text('Register' , style: TextStyle(color: Colors.white),),
              ))
            ],
          )






        ],
      ),
    );
  }
}
