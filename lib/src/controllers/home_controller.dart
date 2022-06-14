import 'dart:async';

import 'package:flutter/material.dart';
import 'package:horizon/src/controllers/GeneralController.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:horizon/src/repositories/settings_repository.dart' as settingRepo;

class   HomeController extends GeneralController {
  GlobalKey<ScaffoldState> scaffoldKey;


  HomeController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();

  }

}
