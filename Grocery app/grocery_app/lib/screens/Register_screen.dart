import 'package:flutter/material.dart';

class Registerscreen extends StatelessWidget {

  static const String id = 'registration-screen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(3.0),
          child: Column(
            children: <Widget>[
              Hero(
                tag: 'logo',
                  child: Image.asset('images/logo.png')),
              TextField(),
            ],
          ),
        ),
      ),
    );
  }
}
