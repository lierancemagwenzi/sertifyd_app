import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:horizon/src/controllers/LoginController.dart';
import 'package:horizon/src/model/UserModel.dart';
import 'package:horizon/src/pages/Registration.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:password_strength/password_strength.dart';
import 'package:email_validator/email_validator.dart';

class ForgotPassword extends StatefulWidget {
  ForgotPassword({Key key, this.title,this.message}) : super(key: key);

  final String title;

  String message;
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends StateMVC<ForgotPassword> {

  LoginController _con;

  _ForgotPasswordState() : super(LoginController()) {
    _con = controller;
  }

  final _formKey = GlobalKey<FormState>();
  double height;
  double width;
  String email;
  String password;
  TextEditingController controller1=TextEditingController();

  PhoneNumber number = PhoneNumber(isoCode: 'ZA');

  bool useemail=true;

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
    return WillPopScope(

      onWillPop: ()async{

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
                    Text("Don't have an account ?",style: Theme.of(context).textTheme.headline6.copyWith(color: Theme.of(context).accentColor,fontSize: 12.0),),
                    SizedBox(width: 10.0,),
                    Text("Sign Up",style: Theme.of(context).textTheme.headline6.copyWith(fontSize: 12.0,fontWeight: FontWeight.bold,color: Theme.of(context).accentColor),),
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
                      useemail?  _entryField("Email",(input) => email = input,(input) => ! EmailValidator.validate(input) ? " Enter a valid email" : null,):phoneField(),
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
              style: TextStyle(color: Colors.black,fontSize: 12),
              onSaved: onsaved,
              validator:validator,
              obscureText: isPassword,
              decoration:getInputDecoration(title))
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
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12,color: Colors.black),
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


  getInputDecoration(String title){
    var Platform;
    return  InputDecoration(
        border: InputBorder.none,
        hintText: title,
        hintStyle: TextStyle(color: Colors.grey,fontSize: 12),
        fillColor:  Colors.white,
        filled: true);
  }

    void _submit() {

    if(_con.loading){

      return;
    }
      if(_formKey.currentState.validate()){
        _formKey.currentState.save();
        _con.CheckUser(new UserModel(mobile: email),context);
      }


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
          'Check Account',
          style: TextStyle(fontSize: 14, color: Colors.white),
        ),
      ),
    );
  }
}
