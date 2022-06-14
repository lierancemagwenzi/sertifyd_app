
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

class   FaqController extends GeneralController {
  GlobalKey<ScaffoldState> scaffoldKey;
  List<CertificationApplicationModel> applications = [];
  List<CertificationApplicationModel> schedule = [];

  bool loading = false;

  bool success = false;

  int currentindex = 0;


  List<FaqModel> faqs = [];

  ProgressDialog pr;

  String progress_status = '';
  double progress = 0.0;

  CertificationApplicationModel certificationApplicationModel;

  FaqController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }
  
  
  
  Future<void> listenForfaqs(String endpoint) async {
    faqs.clear();
    final Stream<FaqModel> stream = await getFaqs(endpoint);
    stream.listen((FaqModel faqModel) {
      setState(() => faqs.add(faqModel));
    }, onError: (a) {
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text("Cannot get faqs"),
      ));
      print(a);
    }, onDone: () {

    });
  }
  Future<void> refreshFaqs(String endpoint) async {
    faqs.clear();
    listenForfaqs(endpoint);
  }


}