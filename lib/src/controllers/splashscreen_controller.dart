import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:horizon/src/model/UserModel.dart';
import 'package:horizon/src/repositories/user_repository.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:horizon/src/repositories/settings_repository.dart' as settingRepo;
import 'package:shared_preferences/shared_preferences.dart';

class   SplashSceenController extends ControllerMVC {
  GlobalKey<ScaffoldState> scaffoldKey;

  ValueNotifier<Map<String, double>> progress = new ValueNotifier(new Map());

  SplashSceenController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    progress.value = {"Setting": 0, "User": 0};

  }



  load() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    settingRepo.setting.addListener(() {
      if (settingRepo.setting.value.appName != null && settingRepo.setting.value.appName != '' && settingRepo.setting.value.mainColor != null) {
        progress.value["Setting"] = 41;
        progress?.notifyListeners();
      }
    });
    bool logged_in=prefs.getBool('logged_in')??false;
    if(!logged_in){
      progress.value["User"] = 59;
    }
    else{
      currentuser.addListener(() {
        if (currentuser.value.id != null && currentuser.value.access_token != null&& currentuser.value.firstname != null) {
          progress.value["User"] = 59;
          progress?.notifyListeners();
        }
      });
    }

  }
  @override
  void initState() {

    load();

    Timer(Duration(seconds: 15), () {
      // scaffoldKey?.currentState?.showSnackBar(SnackBar(
      //   content: Text("Verify your internet connection"),
      // ));
setState(() {
  progress.value["User"] = 59;
});

    });
    super.initState();
  }

  // Future<void> listenForSettings() async {
  //   final Stream<Setting> stream = await getFaqs();
  //   stream.listen((Setting setting) {
  //     setState(() {
  //     });
  //   }, onError: (a) {
  //     scaffoldKey?.currentState?.showSnackBar(SnackBar(
  //       content: Text("Check your network connection"),
  //     ));
  //     print(a);
  //   }, onDone: () {
  //
  //   });
  // }
  //
}
