import 'package:flutter/material.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:groceryapp/constant.dart';


final _controller = PageController(
  initialPage: 0,
);

int _currentpage=0;
List<Widget> _pages = [
  Column(
    children: <Widget>[
      Expanded(child: Image.asset('images/deliverfood.png')),
      Text('Get delivery at your Doorstep' , style:Kpageviewtextstyle,),

    ],
  ),
  Column(
    children: <Widget>[
      Expanded(child: Image.asset('images/enteraddress.png')),
      Text('Set your delivery location' , style:Kpageviewtextstyle),

    ],
  ),
  Column(
    children: <Widget>[
      Expanded(child:Image.asset('images/orderfood.png')),
      Text('Order your food now' , style:Kpageviewtextstyle),

    ],
  ),
];


class Onboardscreen extends StatefulWidget {

  static const String id = 'on-board-screen';
  @override
  _OnboardscreenState createState() => _OnboardscreenState();
}

class _OnboardscreenState extends State<Onboardscreen> {
  @override
  Widget build(BuildContext context) {
    return  Column(
      children: <Widget>[
        Expanded(
          child: PageView(
            controller: _controller,
            children: _pages,
            onPageChanged: (index){
              setState(() {
                _currentpage = index;
              });
            },
          ),
        ),
        SizedBox(height: 20,),
        DotsIndicator(
          dotsCount: _pages.length,
          position: _currentpage.toDouble(),
          decorator: DotsDecorator(
            size: const Size.square(9.0),
            activeSize: const Size(18.0, 9.0),
            activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
            activeColor:Theme.of(context).primaryColor ,
          ),
        ),
        SizedBox(height: 20,)
      ],
    );
  }
}
