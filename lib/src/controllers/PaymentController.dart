import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:horizon/src/model/ApplicationModel.dart';
import 'package:horizon/src/model/SertifyerTerm.dart';
import 'package:horizon/src/pages/payfastform.dart';
import 'package:horizon/src/repositories/application_repository.dart';
import 'package:horizon/src/repositories/payment_repository.dart';
import 'package:horizon/src/repositories/sertifyer_repository.dart';
import 'package:horizon/src/repositories/user_repository.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:horizon/src/repositories/settings_repository.dart' as settingRepo;

import 'application_controller.dart';

class   PaymentController extends ApplicationController {
  GlobalKey<ScaffoldState> scaffoldKey;



  PaymentController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();

    super.listenForApplications();
  }
    void RequestForm(int id,BuildContext context) {
      setState(() {
        loading=true;
      });
      getForm({"id":id}).then((value) {
        print(value);
        setState(() {
          loading=false;
          if(value!=null){
            Navigator.pushReplacement(
                context,
                CupertinoPageRoute(
                    builder: (context) => PayfastForm(
                   form: value,
                    )));
          }
          else{
            scaffoldKey?.currentState?.showSnackBar(SnackBar(
              content: Text("An error occurred"),
            ));
          }
        });
      });
    }


}
