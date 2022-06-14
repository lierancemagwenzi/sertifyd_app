import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:horizon/testing/pages1/Register.dart';

class LoginScreen extends StatefulWidget {

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  double _sigmaX = 0.6; // from 0-10
  double _sigmaY = 0.6; // from 0-10
  double _opacity = 0.2; // from 0-1.0
  double _width = 350;
  double _height = 300;

  double height;
  double width;
  @override
  Widget build(BuildContext context) {

    height=MediaQuery.of(context).size.height;
    width=MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
bottomNavigationBar:                SafeArea(

  child:   InkWell(


    onTap: (){

      Navigator.pushReplacement(
          context,
          CupertinoPageRoute(
              builder: (context) => RegisterScreen(
              )));
    },
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Don't have an account ?",style: Theme.of(context).textTheme.headline6.copyWith(color: Color(0xffa4a7a6),fontSize: 14.0),),
        SizedBox(width: 10.0,),
        Text("Join Us",style: Theme.of(context).textTheme.headline6.copyWith(color: Color(0xff2eafe1),fontSize: 14.0,fontWeight: FontWeight.bold),),
      ],
    ),
  ),
),

body: BackdropFilter(
  filter: new ImageFilter.blur(sigmaX: 7.0, sigmaY: 7.0),

  child:   Padding(
    padding: const EdgeInsets.symmetric(horizontal:15.0),
    child:   Column(children: [

    SizedBox(
      height: height*0.1,
    ),
  //   Container(
  //   height: height*0.1,
  //   width: width,
  //   decoration: new BoxDecoration(
  //       color: Colors.white,
  //       image: DecorationImage(image: AssetImage("assets/images/gpay.png"),fit: BoxFit.contain)
  //   ),
  //
  //
  // ),

      Container(
        height: height*0.1,
        decoration: new BoxDecoration(
          image: new DecorationImage(
            image: new ExactAssetImage('assets/images/gpay.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: new BackdropFilter(
          filter: new ImageFilter.blur(sigmaX: 7.0, sigmaY: 7.0),
          child: new Container(
            decoration: new BoxDecoration(color: Colors.white.withOpacity(0.0)),
          ),
        ),
      ),
      SizedBox(
        height: height*0.1,
      ),
      Center(child: Text("Welcome Back",style: Theme.of(context).textTheme.headline5.copyWith(color: Colors.black,fontWeight: FontWeight.bold),)),
    SizedBox(height: 10.0,),
      Center(child: Text("You can search course,apply and find international courses",style: Theme.of(context).textTheme.headline5.copyWith(color: Colors.black,fontWeight: FontWeight.normal,fontSize: 16.0),textAlign: TextAlign.center,))


    ,
      SizedBox(
        height: height*0.1,
      ),
      TextInput("+27820000000", Icon(
        Icons.phone,
        color: Color(0xffa4a7a6),
      ), true),
      SizedBox(height: 30.0,),


      TextInput("****************", Icon(
        Icons.lock,
        color: Color(0xffa4a7a6),
      ), true),

      SizedBox(height: 20,),

      _submitButton(),    SizedBox(height: 20,),
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [   Text("Forgot Password?",style: Theme.of(context).textTheme.headline6.copyWith(color: Color(0xff2eafe1),fontSize: 14.0),),],),
      SizedBox(height: 20,),
    ],),
  ),
),

    );
  }
  Widget _submitButton() {
    return InkWell(

      onTap: (){

      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey.shade200,
                  offset: Offset(2, 4),
                  blurRadius: 5,
                  spreadRadius: 2)
            ],
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Color(0xff0562a7),Color(0xff0562a7)])),
        child: Text(
          'Sign In',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }


  TextInput(String hint,Icon prefix,bool ispassword){
    return    TextFormField(
      obscureText: ispassword,
      decoration: InputDecoration(
          prefixIcon: prefix,
          border: OutlineInputBorder(
            // width: 0.0 produces a thin "hairline" border
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              borderSide: BorderSide(color: Color(0xffa4a7a6))
            //borderSide: const BorderSide(),
          ),
          enabledBorder: OutlineInputBorder(
// width: 0.0 produces a thin "hairline" border
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              borderSide: BorderSide(color: Color(0xffa4a7a6))
            //borderSide: const BorderSide(),
          ),
          focusedBorder: OutlineInputBorder(
            // width: 0.0 produces a thin "hairline" border
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              borderSide: BorderSide(color: Color(0xffa4a7a6))
            //borderSide: const BorderSide(),
          ),
          hintStyle: TextStyle(color: Color(0xffa4a7a6)),
          filled: true,
          fillColor: Colors.white24,
          hintText: hint),
    );
  }

}
