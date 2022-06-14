import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:horizon/src/controllers/LoginController.dart';
import 'package:horizon/src/model/UserModel.dart';
import 'package:horizon/src/pages/Registration.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:password_strength/password_strength.dart';
import 'package:email_validator/email_validator.dart';

class NewPasswordScreen extends StatefulWidget {
  UserModel userModel;
  NewPasswordScreen({Key key, this.title,this.userModel}) : super(key: key);

  final String title;


  String message;
  @override
  _NewPasswordScreenState createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends StateMVC<NewPasswordScreen> {

  LoginController _con;

  _NewPasswordScreenState() : super(LoginController()) {
    _con = controller;
  }

  final _formKey = GlobalKey<FormState>();
  double height;
  double width;
  String email;
  String password;
bool hidepassword=true;
  @override
  void initState() {

    if(widget.message!=null){

      Future.delayed(const Duration(seconds: 1), () {

        _con.scaffoldKey?.currentState?.showSnackBar(SnackBar(
          content: Text(widget.message??''),
        ));

      });
    }
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
                      _entryField("Password",(input) => password = input,(input) => estimatePasswordStrength(input)<0.6?"password is too weak":null,isPassword: true),


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

              onChanged:(i){
                setState(() {
                  password=i;
                });

              },
              obscureText: hidepassword,
              decoration:getPasswordInputDecoration(title))
        ],
      ),
    );
  }

  getPasswordInputDecoration(String title,){
    var Platform;
    return  InputDecoration(
        border: InputBorder.none,
        hintText: title,
        suffixIcon:password!=null&&password.length>0?InkWell(
            onTap: (){

              setState(() {

                hidepassword=!hidepassword;
              });
            },

            child: Icon(hidepassword?Icons.remove_red_eye:Icons.close,color: Theme.of(context).accentColor,)):null,
        hintStyle: TextStyle(color: Colors.grey.withOpacity(0.9),fontSize: 12),
        fillColor:  Colors.white,
        filled: true);
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

      return;
    }
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      print("validated");
      _con.changePassword(new UserModel(mobile: widget.userModel.mobile,password: password),context);
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
          'Change Password',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }
}
