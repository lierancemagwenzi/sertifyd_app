import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:horizon/testing/pages1/Login.dart';


class SplashScreen extends StatefulWidget {

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  double height;
  double width;

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 3), () {


      Navigator.push(
          context,
          CupertinoPageRoute(
              builder: (context) => LoginPage1(
              )));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    height=MediaQuery.of(context).size.height;
    width=MediaQuery.of(context).size.width;

    return WillPopScope(

      onWillPop: () async{

        return false;
      },
      child: Scaffold(
        body: Container(
       height: height,
       width: width,
       color: Color(0xff0562a7),

        ),

      ),
    );
  }
}
