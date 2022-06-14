
import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:horizon/src/controllers/GeneralController.dart';
import 'package:horizon/src/model/AdminApplication.dart';
import 'package:horizon/src/model/ApplicationModel.dart';
import 'package:horizon/src/model/DocumentType.dart';
import 'package:horizon/src/model/FaqModel.dart';
import 'package:horizon/src/model/PaymentDetail.dart';
import 'package:horizon/src/model/PaymentMethod.dart';
import 'package:horizon/src/model/SertificationDocument.dart';
import 'package:horizon/src/model/SertifyerTerm.dart';
import 'package:horizon/src/model/SignatureModel.dart';
import 'package:horizon/src/model/UserModel.dart';
import 'package:horizon/src/model/ZoomMettingModel.dart';
import 'package:horizon/src/pages/AdminHome.dart';
import 'package:horizon/src/pages/ResultScreen.dart';
import 'package:horizon/src/pages/admin/ApplicationScreen.dart';
import 'package:horizon/src/repositories/admin_repository.dart';
import 'package:horizon/src/repositories/application_repository.dart';
import 'package:horizon/src/repositories/login_repository.dart';
import 'package:horizon/src/repositories/sertifyer_repository.dart';
import 'package:horizon/src/repositories/user_repository.dart';
import 'package:intl/intl.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:horizon/src/repositories/settings_repository.dart' as settingRepo;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class   VerifyController extends GeneralController {
  GlobalKey<ScaffoldState> scaffoldKey;

bool loading=false;
  VerifyController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }


  void  VeridyDoc(String data,BuildContext context) {

    if(data==null){

      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text('Invalid data recorded.Cannot verify.try again'),
      ));
      return ;
    }

    var d=data.split("^")  ;
    if(data.split('^').length==2){
      setState(() {
        loading=true;
      });

      verifydocument({"document_id":int.tryParse(d[0]),"code":d[1]}).then((value) {
        print(value);
        setState(() {
          if(value!=null){
            loading=false;
            // scaffoldKey?.currentState?.showSnackBar(SnackBar(
            //   content: Text(value??''),
            // ));
            Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (context) => ValidateResultScreen(
                      applicationModel: value,
                    )));
          }
          else{
            loading=false;
            scaffoldKey?.currentState?.showSnackBar(SnackBar(
              content: Text('Check your connection'),
            ));
          }
        });
      });
    }
    else{
      loading=false;
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text('Invalid data.Data is invalid'),
      ));
    }

  }


}