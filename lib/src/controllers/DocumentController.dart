import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:horizon/src/controllers/AdminController.dart';
import 'package:horizon/src/controllers/GeneralController.dart';
import 'package:horizon/src/model/AdminApplication.dart';
import 'package:horizon/src/model/ApplicationModel.dart';
import 'package:horizon/src/model/DocumentType.dart';
import 'package:horizon/src/model/PaymentDetail.dart';
import 'package:horizon/src/model/PaymentMethod.dart';
import 'package:horizon/src/model/SertificationDocument.dart';
import 'package:horizon/src/model/SertifyerTerm.dart';
import 'package:horizon/src/model/SignatureModel.dart';
import 'package:horizon/src/model/UserModel.dart';
import 'package:horizon/src/model/ZoomMettingModel.dart';
import 'package:horizon/src/pages/AdminHome.dart';
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

class   DocumentController extends GeneralController {
  GlobalKey<ScaffoldState> scaffoldKey;


  bool loading = false;

  bool success = false;

  int currentindex = 0;


  ProgressDialog pr;

  String progress_status = '';
  double progress = 0.0;

  CertificationApplicationModel certificationApplicationModel;
  AdminController adminController;

  DocumentController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }

  Future<void>  CertifyDoc(Map data,int index,BuildContext context) async {
    pr = ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: false, showLogs: true);
    pr.style(
        message: 'Certifying Document',
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: CircularProgressIndicator(),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progress: 0.0,
        maxProgress: 100.0,
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600)
    );
    await pr.show();
    setState(() {
      loading=true;
    });

    sertifyDoc(data).then((value) async {
      print(value);
      loading=false;
      if(value!=null){
        setState(() {
         adminController. certificationApplicationModel.documents[index]=value;
          success=true;
        });
        await pr.hide();

        scaffoldKey?.currentState?.showSnackBar(SnackBar(
          content: Text("certified successfully"),
        ));
      }
      else{
        await pr.hide();
        setState(() {
          success=false;
        });
        scaffoldKey?.currentState?.showSnackBar(SnackBar(
          content: Text("Failed to process request"),
        ));
      }
    });
  }


  Future<void>  RejectDoc(Map data,int index,BuildContext context) async {
    pr = ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: false, showLogs: true);
    pr.style(
        message: 'Rejecting Document',
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: CircularProgressIndicator(),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progress: 0.0,
        maxProgress: 100.0,
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600)
    );
    await pr.show();
    setState(() {
      loading=true;
    });

    rejectDoc(data).then((value) async {
      print(value);
      loading=false;
      if(value!=null){
        setState(() {
          adminController. certificationApplicationModel.documents[index]=value;
          success=true;
        });
        await pr.hide();

        scaffoldKey?.currentState?.showSnackBar(SnackBar(
          content: Text("rejected successfully"),
        ));
      }
      else{
        await pr.hide();
        setState(() {
          success=false;
        });
        scaffoldKey?.currentState?.showSnackBar(SnackBar(
          content: Text("Failed to process request"),
        ));
      }
    });
  }

  Future<void>  MarkAsComplete(map,BuildContext context) async {
    pr = ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: false, showLogs: true);
    pr.style(
        message: 'Completing Application',
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: CircularProgressIndicator(),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progress: 0.0,
        maxProgress: 100.0,
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600)
    );
    await pr.show();
    setState(() {
      loading=true;
    });
    markascomplete(map).then((value) async {
      print(value);
      loading=false;
      if(value!=null){
        setState(() {
          certificationApplicationModel=value;
          success=true;
        });
        await pr.hide();
        Navigator.pop(context);
        Navigator.of(context).pushReplacementNamed('/${value.status.admin_next.toLowerCase()}', arguments: new AdminApplicationModel(id: value.id,message: "Documents updated successfully"));
        scaffoldKey?.currentState?.showSnackBar(SnackBar(
          content: Text("completed successfully"),
        ));
      }
      else{
        await pr.hide();

        setState(() {
          success=false;
        });
        scaffoldKey?.currentState?.showSnackBar(SnackBar(
          content: Text("Failed to submit request"),
        ));
      }
    });
  }


}