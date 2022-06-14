import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:horizon/src/model/CountryModel.dart';
import 'package:horizon/src/model/TermModel.dart';
import 'package:horizon/src/model/UserModel.dart';
import 'package:horizon/src/pages/Home.dart';

import 'package:horizon/src/pages/Login.dart';
import 'package:horizon/src/pages/NewPassword.dart';
import 'package:horizon/src/pages/OTPScreen.dart';
import 'package:horizon/src/repositories/global_repository.dart';
import 'package:horizon/src/repositories/login_repository.dart';
import 'package:horizon/src/repositories/settings_repository.dart';
import 'package:horizon/src/repositories/user_repository.dart';

import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:shared_preferences/shared_preferences.dart';




class  LoginController extends ControllerMVC {
  GlobalKey<ScaffoldState> scaffoldKey;
  bool  loading=false;
List<TermModel> terms=[];
List<CountryModel> countries=[];
  LoginController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();


  }
  setinstalled() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('installed', true);
  }


  Future<void> listenForCountries() async {
    countries.clear();
    final Stream<CountryModel> stream = await getCountries();
    stream.listen((CountryModel countryModel) {
      setState(() => countries.add(countryModel));
    }, onError: (a) {


      print(a);
    }, onDone: () {

    });
  }


  Future<void> listenForTerms() async {
    terms.clear();
    final Stream<TermModel> stream = await getterms();
    stream.listen((TermModel termModel) {
      setState(() => terms.add(termModel));
    }, onError: (a) {


      print(a);
    }, onDone: () {

    });
  }

  void ResendOtp(String mobile,BuildContext context) {
    setState(() {
      loading=true;
    });
    SendOtp({"mobile":mobile}).then((value) {
      print(value);
      setState(() {
        loading=false;
        if(value!=null){
          scaffoldKey?.currentState?.showSnackBar(SnackBar(
            content: Text('OTP sent to ${mobile} successfully'),
          ));

        }
        else{
          scaffoldKey?.currentState?.showSnackBar(SnackBar(
            content: Text("An error occurred"),
          ));
        }
      });
    });
  }


  void RegisterUser(UserModel userModel,BuildContext context) {
    print(userModel.toMap().toString());
    setState(() {
      loading=true;
    });
    registerUser(userModel).then((value) {
      print(value);
      setState(() {
        loading=false;
        if(value!=null){


          if(value.userModel!=null){
            Map map={"action":"registration","platform":Platform.isIOS?"ios":"android","user_id":currentuser.value.id??0,"device":detailsModel.value.identifier,};
            log_activity(map);
            Navigator.pushReplacement(
                context,
                CupertinoPageRoute(
                    builder: (context) => OTPVerificationScreen(
                      userModel: value.userModel,
                      changepassword: false,
                    )));
          }


          else{
            scaffoldKey?.currentState?.showSnackBar(SnackBar(
              content: Text(value.message??'An error occurred'),
            ));

          }


        }
        else{
          scaffoldKey?.currentState?.showSnackBar(SnackBar(
            content: Text("An error occurred"),
          ));
        }
      });
    });
  }


  void changePassword(UserModel userModel,BuildContext context) {
    print(userModel.toMap().toString());
    setState(() {
      loading=true;
    });
    newpassword(userModel).then((value) {
      print(value);
      setState(() {
        loading=false;
        if(value!=null){

          if(value.userModel!=null){

            Navigator.pushReplacement(
                context,
                CupertinoPageRoute(
                    builder: (context) => LoginScreen(
                      message: "Password changed successfully",
                    )));
          }
       else{

            scaffoldKey?.currentState?.showSnackBar(SnackBar(
              content: Text(value.message??'An error occurred'),
            ));
          }

        }
        else{
          scaffoldKey?.currentState?.showSnackBar(SnackBar(
            content: Text("Failed to change password"),
          ));
        }
      });
    });
  }


  void LoginUser(UserModel userModel,BuildContext context) {
    print(userModel.toMap().toString());
    setState(() {
      loading=true;
    });
    LoginappUser(userModel).then((value) async {
      print(value);
        if(value!=null){

          if(value.userModel!=null){

            Map map={"action":"login","platform":Platform.isIOS?"ios":"android","user_id":currentuser.value.id??0,"device":detailsModel.value.identifier,};

            log_activity(map);

            // SharedPreferences.setMockInitialValues({});
             print("is_verified "+value.userModel.isverified.toString());

            if(value.userModel.isverified==true){
              currentuser.value=value.userModel;

              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.setBool('logged_in', true);

              await prefs.setInt('user_id',value.userModel.id).then((value) {

                // return     Navigator.of(context).pushReplacementNamed('/${currentuser.value.role.home}', arguments: 1);

                return Navigator.of(context).pushReplacementNamed('/Onboarding', arguments: 1);
              });

            }

            else{
              return     Navigator.pushReplacement(
                  context,
                  CupertinoPageRoute(
                      builder: (context) => OTPVerificationScreen(
                        userModel: value.userModel,
                      )));
            }
          }

          else{
            scaffoldKey?.currentState?.showSnackBar(SnackBar(
              content: Text(value.message??'An error occurred'),
            ));
          }

          setState(() {
            loading=false;

          });
        }
        else{
          scaffoldKey?.currentState?.showSnackBar(SnackBar(
            content: Text("An error occurred"),
          ));
          setState(() {
            loading=false;

          });

        }

    });
  }



  void CheckUser(UserModel userModel,BuildContext context) {
    print(userModel.toMap().toString());
    setState(() {
      loading=true;
    });
    checkaccount(userModel).then((value) async {
      print(value);
      if(value!=null){

        if(value.userModel!=null){

          Navigator.pushReplacement(
              context,
              CupertinoPageRoute(
                  builder: (context) => OTPVerificationScreen(
                    userModel: value.userModel,
                    changepassword: true,
                  )));
        }

        else{

          scaffoldKey?.currentState?.showSnackBar(SnackBar(
            content: Text(value.message??"An error occurred"),
          ));
        }

        setState(() {
          loading=false;

        });
      }
      else{
        scaffoldKey?.currentState?.showSnackBar(SnackBar(
          content: Text("An error occurred"),
        ));
        setState(() {
          loading=false;

        });
      }

    });
  }


  void ConfirmOtp(UserModel userModel,BuildContext context,bool changepassword) {
    print(userModel.toOtp().toString());
    setState(() {
      loading=true;
    });
    confirmOtpCode(userModel).then((value) async {
        if(value!=null){
          if(value.userModel!=null){
          if(changepassword){
            Navigator.pushReplacement(
                context,
                CupertinoPageRoute(
                    builder: (context) =>
                        NewPasswordScreen(
                          userModel: value.userModel,
                        )));

          }
else {
            // SharedPreferences.setMockInitialValues({});
            currentuser.value=value.userModel;

            SharedPreferences prefs = await SharedPreferences.getInstance();

            await prefs.setBool('logged_in', true);
            await prefs.setInt('user_id', value.userModel.id).then((value) {

              return Navigator.of(context).pushReplacementNamed('/${currentuser.value.role.home}', arguments: 1);
            });
          }
          setState(() {
            loading=false;

          });
        }
        else{
            scaffoldKey?.currentState?.showSnackBar(SnackBar(
              content: Text(value.message??"An error occurred"),
            ));setState(() {
              loading=false;

            });
          }
        }
        else{
          scaffoldKey?.currentState?.showSnackBar(SnackBar(
            content: Text("Otp is Wrong"),
          ));
          setState(() {
            loading=false;

          });
        }

    });
  }


  Future<void> BioLogin(String token,BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      loading=true;
    });
    BioLoginuser(token).then((value) async {
      print(value);
      loading=false;
      if(value!=null){

        if(value.userModel!=null){
          // SharedPreferences.setMockInitialValues({});
          currentuser.value=value.userModel;
          await prefs.setBool('logged_in', true);
          await prefs.setInt('user_id',value.userModel.id).then((value) {
            return    Navigator.of(context).pushReplacementNamed('/${currentuser.value.role.home}', arguments: 2);
          });

        }
        else{
          scaffoldKey?.currentState?.showSnackBar(SnackBar(
            content: Text(value.message??'An error occurred'),
          ));
        }
        setState(() {
          loading=false;
        });
      }
      else{
        scaffoldKey?.currentState?.showSnackBar(SnackBar(
          content: Text("An error occurred"),
        ));
        setState(() {
          loading=false;
        });
      }

    });
  }


}


