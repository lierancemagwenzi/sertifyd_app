import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:horizon/src/controllers/LoginController.dart';
import 'package:horizon/src/model/UserModel.dart';
import 'package:horizon/src/pages/ForgotPassword.dart';
import 'package:horizon/src/pages/Registration.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:password_strength/password_strength.dart';
import 'package:email_validator/email_validator.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key, this.title,this.message}) : super(key: key);

  final String title;

  String message;
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends StateMVC<LoginScreen> {

  LoginController _con;

  _LoginScreenState() : super(LoginController()) {
    _con = controller;
  }
  TextEditingController controller1=TextEditingController();

  PhoneNumber number = PhoneNumber(isoCode: 'ZA');

  final _formKey = GlobalKey<FormState>();
  double height;
  double width;
  String email;
  String password;
bool hidepassword=true;
  bool useemail=true;

  @override
  void initState() {
    _con.setinstalled();
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
    return WillPopScope(

      onWillPop: () async{

        return false;
      },
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
            color: Colors.white,
            image: DecorationImage(image: AssetImage("assets/bg/backbg.png"),fit: BoxFit.cover)),
        child: Scaffold(
          key: _con.scaffoldKey,
           backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal:20.0),
                child: SingleChildScrollView(

                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                     SizedBox(height: height*0.1,),
                     Center(
                       child: Container(
                         height: 150,
                         width: width*0.5,
                         decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/logo/logoo.png"),fit: BoxFit.contain)),
                       ),
                     )
,
                      useemail?  _entryField("Email",(input) => email = input,(input) => ! EmailValidator.validate(input.trim()) ? " Enter a valid email" : null,):phoneField(),

                        InkWell(

                          onTap: (){


                            setState(() {

                              email='';
                              controller1.text='';
                              useemail=!useemail;

                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            alignment: Alignment.centerRight,
                            child: Text(useemail?'Use phone instead?':'Use email instead?',
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w500)),
                          ),
                        ),

                        _passwordEntryField("Password",(input) => password = input,(input) =>input.isEmpty?"password is  required":null,),
                        SizedBox(
                          height: 10.0,
                        ),
                        InkWell(

                          onTap: (){
                            Navigator.pushReplacement(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) => ForgotPassword(
                                    )));
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            alignment: Alignment.centerRight,
                            child: Text('Forgot Password ?',
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w500)),
                          ),
                        ),
                        SizedBox(
                          height: 30.0,
                        ),


                        _submitButton(),

                        SizedBox(height: 20.0,),
                        InkWell(
                          onTap: () async {

                            Navigator.pushNamed(context, '/TestDocument');
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            child: Center(
                              child: Text(
                                "Verify a document?",
                                style: Theme.of(context).textTheme.caption.merge(TextStyle(color: Theme.of(context).accentColor,fontWeight: FontWeight.bold,fontSize: 12.0)),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 12.0,),

                        Column(
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
                                  Text("Don't have an account ?",style: Theme.of(context).textTheme.headline6.copyWith(color: Theme.of(context).accentColor,fontSize: 16.0,fontWeight: FontWeight.bold),),
                                  SizedBox(width: 10.0,),
                                  Text("Sign Up",style: Theme.of(context).textTheme.headline6.copyWith(fontSize: 20.0,fontWeight: FontWeight.bold,color: Theme.of(context).accentColor),),
                                ],
                              ),
                            ),
                            SizedBox(height: 40.0,)

                          ],)

                      ],),
                  ),
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
            style: TextStyle(color: Colors.black,fontSize: 12.0),
              onSaved: onsaved,
              validator:validator,
              obscureText: false,
              decoration:getInputDecoration(title,isPassword))
        ],
      ),
    );
  }


  Widget _passwordEntryField(String title,onsaved,validator,) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
              style: TextStyle(color: Colors.black,fontSize: 12.0),
              onSaved: onsaved,
              onChanged: (i){
           setState(() {

             password=i;
           });

              },
              validator:validator,
              obscureText: hidepassword,
              decoration:getPasswordInputDecoration(title))
        ],
      ),
    );
  }
  Widget phoneField(){

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Phone",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          color: Colors.white,
          child: InternationalPhoneNumberInput(
            onInputChanged: (PhoneNumber number) {
              email = number.phoneNumber;
              print(number.phoneNumber);
            },
            onInputValidated: (bool value) {
              print(value);
            },
            textStyle: TextStyle(color: Colors.black,fontSize: 12),
            inputDecoration: InputDecoration(
                border: InputBorder.none,
                fillColor: Colors.white,
                filled: true),
            ignoreBlank: false,
            autoFocusSearch: true,

            searchBoxDecoration:  InputDecoration(
                border: InputBorder.none,
                fillColor: Color(0xfff3f3f4),
                filled: true),
            selectorTextStyle: TextStyle(color: Colors.black),
            initialValue: number,
            textFieldController: controller1,
            inputBorder: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  getInputDecoration(String title,bool is_password){
    var Platform;
    return  InputDecoration(
        border: InputBorder.none,
        hintText: title,
        suffixIcon:is_password? InkWell(
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
  void _submit() {

    if(_con.loading){

      return;
    }
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      print("validated");
      _con.LoginUser(new UserModel(password: password,mobile: email),context);
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
          'Login',
          style: TextStyle(fontSize: 14, color: Colors.white),
        ),
      ),
    );
  }
}
