import 'package:flutter/material.dart';
import 'package:groceryvendor/screens/login_screen.dart';
import 'package:groceryvendor/widget/image_picker.dart';
import 'package:groceryvendor/widget/registration_form.dart';



class RegistrationScreen extends StatelessWidget {
  static const String id = 'registration-screen';


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
//        resizeToAvoidBottomInset: false,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(

                  children: [
                  ImagePicker(),
                    SizedBox(height: 10,),

                    RegisterForm(),
                    Row(
                      children: [
                        FlatButton(
                          padding: EdgeInsets.zero,

                          onPressed: (){
                            Navigator.pushNamed(context, LoginScreen.id);
                          },

                          child:RichText(
                              text:TextSpan(
                                  text: '' ,
                                  children:[
                                    TextSpan(text: 'Already Have An Account ?' , style: TextStyle(color:Colors.black54),),
                                    TextSpan(text: ' Login ', style: TextStyle(color: Colors.redAccent))
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
    );
  }
}
