import 'package:ars_dialog/ars_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:grocerywebadminapp/screen/home_screen.dart';
import 'package:grocerywebadminapp/services/firebase_service.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login-screen';


  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
final _formKey = GlobalKey<FormState>();
  FirebaseServices _services = FirebaseServices();
  String username;
  String password;







  @override
  Widget build(BuildContext context) {


    return Scaffold(


      appBar: AppBar(


        title: Text('Grocery Admin Web Panel' , style: TextStyle(color: Colors.white),),
        centerTitle: true,

      ),

      body: SingleChildScrollView(
        child: FutureBuilder(
          // Initialize FlutterFire:
          future: _initialization,
          builder: (context, snapshot) {
            // Check for errors
            if (snapshot.hasError) {
              return Center(child: Text('Connection failed'));
            }

            // Once complete, show your application
            if (snapshot.connectionState == ConnectionState.done) {

              ProgressDialog progressDialog = ProgressDialog(context,
                  message:Text("LOADING..."),
                  title:Text("please wait")
              );




              _login()async{

                UserCredential userCredential = await FirebaseAuth.instance.signInAnonymously();
                progressDialog.dismiss();
                _services.getAdminCredential().then((value){
                  value.docs.forEach((doc) {
                    if(doc.get('username')==username)
                    {
                      if(doc.get('password')==password)
                      { progressDialog.dismiss();
                      if(userCredential.user.uid!=null)
                        {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context)=> HomeScreen()));
                        return;
                        }

                      }
                      else
                      { progressDialog.dismiss();
                      _showMyDialog(title: 'Invalid User' , message: ' Password is invalid' );


                      }

                    }
                    else
                    { progressDialog.dismiss();
                    _showMyDialog(title: 'Invalid User' , message: 'Username is invalid' );
                    }
                  });
                });



              }



              return Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [
                          Theme.of(context).primaryColor,
                          Colors.white,
                        ],

                        stops: [1.0,1.0],
                        begin: Alignment.topCenter,
                        end: Alignment(0.0,0.0)
                    )
                ),

                child: Center(
                  child: Container(
                    height: 400,
                    width: 300,
                    child: Card(
                      elevation: 6,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                child: Column(
                                  children: [

                                    Image.asset('images/logo.png' ,),
                                    Text('GROCERY ADMIN APP' , style: TextStyle(fontWeight: FontWeight.bold , fontSize: 20),),
                                    SizedBox(height: 5,),

                                    TextFormField(
                                      validator: (value){
                                        if(value.isEmpty)
                                        {return 'Enter User Name';}

                                        setState(() {
                                          username=value;
                                        });
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(Icons.person),
                                        labelText: 'User Name',
                                        contentPadding:EdgeInsets.only(left: 20 ,right: 20),
                                        border: OutlineInputBorder(),


                                      ),
                                    ),
                                    SizedBox(height: 20,),
                                    TextFormField(
                                      validator: (value){
                                        if(value.isEmpty)
                                        {return 'Enter Password';}
                                        if(value.length<6)
                                          return 'Minimum character 6';
                                        setState(() {
                                          password=value;
                                        });

                                        return null;
                                      },
                                      obscureText: true,
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(Icons.vpn_key_outlined),
                                        labelText: 'Password',
                                        contentPadding:EdgeInsets.only(left: 20 ,right: 20),
                                        border: OutlineInputBorder(),


                                      ),
                                    ),


                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  Expanded(child: FlatButton(onPressed: (){
                                    if(_formKey.currentState.validate())
                                    {
                                      progressDialog.show();
                                       print('logged In');
                                       _login();


                                    }


                                  }, child: Text('Login' , style: TextStyle(color: Colors.white),) , color: Theme.of(context).primaryColor,)),
                                ],
                              )
                            ],

                          ),
                        ),
                      ),
                    ),
                  ),
                ),// This trailing comma makes auto-formatting nicer for build methods.
              );
            }

            // Otherwise, show something whilst waiting for initialization to complete
            return CircularProgressIndicator();
          },
        ),
      ),
    );




  }

  Future<void> _showMyDialog({title , message}) async {
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
                Text('try again'),
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