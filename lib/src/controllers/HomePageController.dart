import 'dart:async';

import 'package:flutter/material.dart';
import 'package:horizon/src/model/ApplicationModel.dart';
import 'package:horizon/src/model/SertifyerTerm.dart';
import 'package:horizon/src/repositories/application_repository.dart';
import 'package:horizon/src/repositories/sertifyer_repository.dart';
import 'package:horizon/src/repositories/user_repository.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:horizon/src/repositories/settings_repository.dart' as settingRepo;

import 'application_controller.dart';

class   HomePageController extends ApplicationController {
  GlobalKey<ScaffoldState> scaffoldKey;



  bool loading=false;

  bool success=false;


  HomePageController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();

super.listenForApplications();
  }


}
