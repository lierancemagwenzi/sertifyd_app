import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:horizon/src/controllers/LoginController.dart';
import 'package:horizon/src/model/UserModel.dart';
import 'package:horizon/src/pages/Registration.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:password_strength/password_strength.dart';
import 'package:email_validator/email_validator.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';

class OTPVerificationScreen extends StatefulWidget {
  bool changepassword;
  UserModel userModel;
  OTPVerificationScreen({Key key, this.title,this.userModel,this.changepassword}) : super(key: key);

  final String title;

  String message;
  @override
  _OTPVerificationScreenState createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends StateMVC<OTPVerificationScreen> {

  LoginController _con;

  _OTPVerificationScreenState() : super(LoginController()) {
    _con = controller;
  }

  final _formKey = GlobalKey<FormState>();
  double height;
  double width;


  bool haserror=false;
  TextEditingController _controller=new TextEditingController();

  @override
  void initState() {


    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    width=MediaQuery.of(context).size.width;
    height=MediaQuery.of(context).size.height;
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
          color: Colors.white,
          image: DecorationImage(image: AssetImage("assets/bg/backbg.png"),fit: BoxFit.cover)),
      child: Scaffold(
        key: _con.scaffoldKey,
        backgroundColor: Colors.transparent,
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            InkWell(
              onTap: (){

                Navigator.pushReplacement(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => RegistrationScreen(
                        )));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account ?",style: Theme.of(context).textTheme.headline6.copyWith(color: Theme.of(context).accentColor,fontSize: 14.0),),
                  SizedBox(width: 10.0,),
                  Text("Sign Up",style: Theme.of(context).textTheme.headline6.copyWith(fontSize: 14.0,fontWeight: FontWeight.bold,color: Theme.of(context).accentColor),),
                ],
              ),
            ),
            SizedBox(height: 40.0,)

          ],),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal:20.0),
          child: Stack(
            children: [
              SingleChildScrollView(

                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: height*0.15,),
                      Center(
                        child: Container(
                          height: 150,
                          width: width*0.5,
                          decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/logo/logoo.png"),fit: BoxFit.contain)),
                        ),
                      )
                      ,


                      Center(child: AutoSizeText("A 4 digit verification code has been sent to ${widget.userModel.mobile}",style: Theme.of(context).textTheme.headline6.copyWith(fontWeight: FontWeight.normal,),maxLines: 2,textAlign: TextAlign.center,)),
                      SizedBox(
                        height: 20,
                      ),
                      OtpWidget(),

                      InkWell(

                        onTap: (){

                        _con.ResendOtp(widget.userModel.mobile, context);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          alignment: Alignment.centerRight,
                          child: Text('Resend OTP?',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w500)),
                        ),
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      _submitButton(),

                    ],),
                ),
              ),
              _con.loading?Center(child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Theme.of(context).accentColor),)):SizedBox(height: 0,width: 0,)

            ],
          ),
        ),

      ),
    );
  }


  Widget _entryField(String title,onsaved,validator, {bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
              onSaved: onsaved,
              validator:validator,
              obscureText: isPassword,
              decoration:getInputDecoration(title))
        ],
      ),
    );
  }


  getInputDecoration(String title){
    var Platform;
    return  InputDecoration(
        border: InputBorder.none,
        hintText: title,
        fillColor:  Colors.white,
        filled: true);
  }

  void _submit() {

    if(_con.loading){

      return ;
    }
    print("code"+widget.userModel.mobile.toString());
    setState(() {
      haserror = false;
    });
    if (_controller.text.length==4){

      _con.ConfirmOtp(new UserModel(code: int.parse(_controller.text),mobile: widget.userModel.mobile),context,widget.changepassword??false);
    }

    else{print("incorrect form");}
  }


  Widget _submitButton() {
    return InkWell(
      onTap: (){


        _submit();
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
                colors: [Theme.of(context).accentColor,Theme.of(context).accentColor])),
        child: Text(
          'Verify OTP',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }


  Widget OtpWidget(){

    return   Center(
      child: PinCodeTextField(
        autofocus: true,
        controller: _controller,
        hideCharacter: true,
        highlight: true,

        highlightColor: Theme.of(context).accentColor,
        defaultBorderColor: Colors.black,
        hasTextBorderColor: Colors.green,
        maxLength: 4,
        hasError: haserror,
        maskCharacter: "*",
        onTextChanged: (text) {
          setState(() {
            haserror = false;
          });
        },
        onDone: (text) {
          print("DONE $text");
          print("DONE CONTROLLER ${_controller.text}");
        },
        pinBoxWidth: 50,
        pinBoxHeight: 64,
        hasUnderline: true,
        wrapAlignment: WrapAlignment.spaceAround,
        pinBoxDecoration:
        ProvidedPinBoxDecoration.defaultPinBoxDecoration,
        pinTextStyle: TextStyle(fontSize: 22.0),
        pinTextAnimatedSwitcherTransition:
        ProvidedPinBoxTextAnimation.scalingTransition,
//                    pinBoxColor: Colors.green[100],
        pinTextAnimatedSwitcherDuration:
        Duration(milliseconds: 300),
//                    highlightAnimation: true,
        highlightAnimationBeginColor: Colors.black,
        highlightAnimationEndColor: Colors.white12,
        keyboardType: TextInputType.number,
      ),
    );
  }
}
