import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MainAppBar extends StatefulWidget {
  final name;
  const MainAppBar({Key key, this.name}) : super(key: key);
  @override
  _MainAppBarState createState() => _MainAppBarState();
}

class _MainAppBarState extends State<MainAppBar>
  with SingleTickerProviderStateMixin {
  AnimationController _controllerr;
  @override
  void initState() {
  super.initState();
  _controllerr = AnimationController(
    value: 0.0,
    duration: Duration(seconds: 25),
    upperBound: 1,
    lowerBound: -1,
    vsync: this,
  )..repeat();
  }

  @override
  void dispose() {
  _controllerr.dispose();

  super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _controllerr,
        builder: (BuildContext context, Widget child) {
          return ClipPath(
            clipper: ClipClass(_controllerr.value),
            child: Container(
              color: Colors.deepOrange,
              height: MediaQuery.of(context).size.width*0.4,
              child: Align(
                alignment: Alignment.topCenter,
                child: Container(
                  margin: EdgeInsets.only(top:20),
                  child: Text('AAROGYAM', style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Museo',
                    fontSize: 28,
                    color: Colors.white,),
                    textAlign: TextAlign.center,
                  )
                ),
              ),
            ),
          );
        });
  }
}

class ClipClass extends CustomClipper<Path>{
  double move = 0;
  double slice = math.pi;
  ClipClass(this.move);
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height * 0.8);
    double xCenter =
        size.width * 0.5 + (size.width * 0.6 + 1) * math.sin(move * slice);
    double yCenter = size.height * 0.8 + 69 * math.cos(move * slice);
    path.quadraticBezierTo(xCenter, yCenter, size.width, size.height * 0.8);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;

}


