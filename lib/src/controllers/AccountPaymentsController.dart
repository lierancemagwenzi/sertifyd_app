import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:horizon/src/model/Earning.dart';
import 'package:horizon/src/model/ApplicationModel.dart';
import 'package:horizon/src/model/EarningsStat.dart';
import 'package:horizon/src/model/SertifyerTerm.dart';
import 'package:horizon/src/pages/payfastform.dart';
import 'package:horizon/src/repositories/admin_repository.dart';
import 'package:horizon/src/repositories/application_repository.dart';
import 'package:horizon/src/repositories/payment_repository.dart';
import 'package:horizon/src/repositories/sertifyer_repository.dart';
import 'package:horizon/src/repositories/user_repository.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:horizon/src/repositories/settings_repository.dart' as settingRepo;

import 'application_controller.dart';

class   EarningsController extends ControllerMVC {
  GlobalKey<ScaffoldState> scaffoldKey;

List<EarningModel> earnings=[];

  List<EarningsStat> periods=[];

  List<CertificationApplicationModel> applications=[];
num total=0.0;
bool loading=false;

  EarningsController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();

  }


  void CalculateTotal(){


    for(int i=0;i<applications.length;i++){


      setState(() {
        total=total+applications[i].getnumtotalPrice();

      });


      setState(() {

        total=total;
      });

    }

  }
  void listenForPayments() {
    setState(() {
      loading=true;
    });
    getEarnings({"user_id":currentuser.value.id}).then((value) {
      print(value);
      setState(() {
        loading=false;
        if(value!=null){
          earnings=value;
        }
        else{
          scaffoldKey?.currentState?.showSnackBar(SnackBar(
            content: Text("An error occurred"),
          ));
        }
      });
    });
  }
  Future<void> listenForPeriods() async {
    periods.clear();
    final Stream<EarningsStat> stream = await getmonths();
    stream.listen((EarningsStat bankModel) {
      setState(() => periods.add(bankModel));
    }, onError: (a) {

      print(a);
    }, onDone: () {

    });
  }

  Future<void> listenForapplicationPeriods(int year,int month) async {
    applications.clear();
    final Stream<CertificationApplicationModel> stream = await getapplicationsbygroup(year,month);
    stream.listen((CertificationApplicationModel bankModel) {
      setState(() => applications.add(bankModel));
    }, onError: (a) {

      print(a);
    }, onDone: () {


      CalculateTotal();
    });
  }

}
