import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:horizon/testing/pages/Register.dart';

class LoginPage extends StatefulWidget {

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  double height;
  double width;

  String phone;

  @override
  Widget build(BuildContext context) {
    height=MediaQuery.of(context).size.height;
    width=MediaQuery.of(context).size.width;
    return Scaffold(

body: Stack(children: [


  Container(
    width: width,
    height: height,
    color: Color(0xff0562a7),


    child: Stack(children: [
      Positioned(
          bottom:22.0,
          left: 0.0,
          right: 0.0,
          child: SafeArea(
              child: InkWell(


                onTap: (){

                  Navigator.pushReplacement(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => RegisterPage(
                          )));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account ?",style: Theme.of(context).textTheme.headline6.copyWith(color: Colors.white,fontSize: 14.0),),
                    SizedBox(width: 10.0,),
                    Text("Sign Up",style: Theme.of(context).textTheme.headline6.copyWith(color: Color(0xff2eafe1),fontSize: 14.0,fontWeight: FontWeight.bold),),
                  ],
                ),
              )))

    ],),
  ),

  Container(
      width: width,
      height: height*0.9,
      decoration: new BoxDecoration(
          color: Colors.white,
          borderRadius: new BorderRadius.only(
            bottomLeft: const Radius.circular(50.0),
            bottomRight: const Radius.circular(50.0),
          )
      ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: SingleChildScrollView(

        child: Column(children: [
        SizedBox(height: height*0.12,),
          _title(),
          // Container(
          //   height: 200,
          //   // width: double.maxFinite,
          //   decoration: BoxDecoration(
          //     image: DecorationImage(
          //       image: ExactAssetImage("assets/images/gpay.png"),
          //       fit: BoxFit.contain,
          //     ),
          //   ),
          //   child: ClipRRect( // make sure we apply clip it properly
          //     child: BackdropFilter(
          //       filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
          //       child: new Container(
          //     decoration: new BoxDecoration(color: Colors.white.withOpacity(0.0)),
          // ),
          //     ),
          //   ),
          // ),
          SizedBox(height: height*0.05,),
          HeaderText(),
          SizedBox(height: 30,),
        InputFiled(Icon(Icons.phone,color: Color(0xffa4a7a6),), "Mobile", "Mobile phone",(input) => phone = input,(input) => input.trim().length < 12 ? "Mobile number is required" : null,false),
          SizedBox(height: 20,),

          InputFiled(Icon(Icons.lock,color:Color(0xffa4a7a6),), "Password", "Password",(input) => phone = input,(input) => input.trim().length < 12 ? "Password is required" : null,true),

          SizedBox(height: 20,),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [   Text("Forgot Password?",style: Theme.of(context).textTheme.headline6.copyWith(color: Color(0xff2eafe1),fontSize: 14.0),),],),
          SizedBox(height: 20,),

          _submitButton()

        ],),
      ),
    ),
  ),

  _backButton()
],),

    );
  }

 InputFiled(Icon prefix,String title,String hint,onSaved,Validator,bool ispassword){
    return  TextFormField(
      style: TextStyle(color: Theme.of(context).hintColor),
      keyboardType: TextInputType.text,
      obscureText:ispassword ,
      decoration: getInputDecoration(hintText: hint, labelText:title,prefix: prefix),
      validator:Validator,
      onSaved: (input) => onSaved,
    );
 }


  InputDecoration getInputDecoration({String hintText, String labelText,Icon prefix}) {
    return new InputDecoration(
      hintText: hintText,
      labelText: labelText,
      prefixIcon:prefix ,
      hintStyle: Theme.of(context).textTheme.bodyText2.merge(
        TextStyle(color: Theme.of(context).focusColor),
      ),
      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color:Color(0xffa4a7a6).withOpacity(0.2),width: 2.0)),
      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color:Color(0xffa4a7a6).withOpacity(0.2),width: 2.0)),
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      labelStyle: Theme.of(context).textTheme.bodyText2.merge(
        TextStyle(color: Theme.of(context).hintColor),
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
            borderRadius: BorderRadius.all(Radius.circular(15)),
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
          'Login',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  HeaderText() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal:8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        Row(
          children: [
            Text("Login",style: Theme.of(context).textTheme.headline5.copyWith(color:  Color(0xff2eafe1),fontWeight: FontWeight.bold),),
          ],
        ),
          SizedBox(height: 10,),
          Row(
            children: [
              Text("To continue your account",style: Theme.of(context).textTheme.headline5.copyWith(color:  Color(0xffa4a7a6),fontWeight: FontWeight.normal,fontSize: 14.0),),
            ],
          ),
      ],),
    );
  }


  Widget _backButton() {
    return SafeArea(
      child: InkWell(

        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
                child: Icon(Icons.keyboard_arrow_left,size: 40.0, color: Colors.black),
              ),
              Text('Back',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500))
            ],
          ),
        ),
      ),
    );
  }


  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'Lets',
          style:  Theme.of(context).textTheme.headline5.copyWith(color:  Color(0xff78828a),fontWeight: FontWeight.bold,fontSize: 30.0),
          children: [
            TextSpan(
              text: 'Move',
              style: TextStyle(color: Color(0xff2eafe1), fontSize: 30),
            ),

          ]),
    );
  }
}
