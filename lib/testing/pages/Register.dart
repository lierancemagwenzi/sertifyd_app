import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:horizon/testing/pages/Login.dart';

class RegisterPage extends StatefulWidget {

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  double height;
  double width;

  String phone;
  String password;
  String firstname;
  String lastname;

  bool checked=false;

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
                                builder: (context) => LoginPage(
                                )));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Already have an account ?",style: Theme.of(context).textTheme.headline6.copyWith(color: Colors.white,fontSize: 14.0),),
                          SizedBox(width: 10.0,),
                          Text("Sign In",style: Theme.of(context).textTheme.headline6.copyWith(color: Color(0xff2eafe1),fontSize: 14.0,fontWeight: FontWeight.bold),),
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




                SizedBox(height: height*0.02,),
                HeaderText(),
                SizedBox(height: 30,),
                InputFiled(Icon(Icons.phone,color: Color(0xffa4a7a6),), "Mobile", "Mobile phone",(input) => phone = input,(input) => input.trim().length < 12 ? "Mobile number is required" : null,false),

                SizedBox(height: 20,),
                InputFiled(Icon(Icons.person,color: Color(0xffa4a7a6),), "Firstname", "First Name",(input) => phone = input,(input) => input.trim().length < 12 ? "firstname number is required" : null,false),
                SizedBox(height: 20,),
                InputFiled(Icon(Icons.person,color: Color(0xffa4a7a6),), "Lastname", "Last name",(input) => phone = input,(input) => input.trim().length < 12 ? "last name is required" : null,false),
                SizedBox(height: 20,),

                InputFiled(Icon(Icons.lock,color:Color(0xffa4a7a6),), "Password", "Password",(input) => password = input,(input) => input.trim().length < 12 ? "Password is required" : null,true),

                SizedBox(height: 30,),
                TermsWidget(),

                SizedBox(height: 50,),

                _submitButton(),
                SizedBox(height: height*0.12,),
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
          'Sign Up',
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
              Text("Signup",style: Theme.of(context).textTheme.headline5.copyWith(color:  Color(0xff2eafe1),fontWeight: FontWeight.bold),),
            ],
          ),
          SizedBox(height: 10,),
          Row(
            children: [
              Text("Register your account!",style: Theme.of(context).textTheme.headline5.copyWith(color:  Color(0xffa4a7a6),fontWeight: FontWeight.normal,fontSize: 14.0),),
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



  TermsWidget(){

    return Row(children: [

InkWell(

  onTap: (){

    setState(() {
      checked=!checked;
    });
  },
  child:   Container(
  
    decoration: BoxDecoration(shape: BoxShape.circle, color: Color(0xff2eafe1)),
    child: checked
        ? Icon(
      Icons.check,
      size: 30.0,
      color: Colors.white,
    )
        : Icon(
      Icons.check_box_outline_blank,
      size: 30.0,
      color: Color(0xff2eafe1),
    ),
  ),


),SizedBox(width: 10.0,),RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
            text: 'I agree to the',
            style:  Theme.of(context).textTheme.headline5.copyWith(color:  Color(0xff78828a),fontWeight: FontWeight.bold,fontSize: 16.0),
            children: [
              TextSpan(
                text: ' Terms & conditions',

                style: TextStyle(color: Color(0xff0562a7), fontSize: 16,decoration: TextDecoration.underline,decorationThickness: 2.0),
              ),

            ]),
      )
    ],);
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
