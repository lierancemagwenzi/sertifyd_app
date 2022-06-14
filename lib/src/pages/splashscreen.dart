import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' as s;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:horizon/src/controllers/splashscreen_controller.dart';
import 'package:horizon/src/model/UserModel.dart';
import 'package:horizon/src/pages/Notifications.dart';
import 'package:horizon/src/repositories/global_repository.dart';
import 'package:horizon/src/repositories/settings_repository.dart';
import 'package:horizon/src/repositories/user_repository.dart';

import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class SplashScreen extends StatefulWidget {

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends StateMVC<SplashScreen> {
  SplashSceenController _con;

  _SplashScreenState() : super(SplashSceenController()) {
    _con = controller;
  }

  Future<void> loadData() async {
    // SharedPreferences.setMockInitialValues({});
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _con.progress.addListener(()  {
      double progress = 0;
      _con.progress.value.values.forEach((_progress) {
        progress += _progress;


      });
      if (progress == 100) {

        Map map={"action":"open_app","platform":Platform.isIOS?"ios":"android","user_id":currentuser.value.id??0,"device":detailsModel.value.identifier,"detail":"opened app",};

        log_activity(map);

        bool installed=prefs.getBool('installed')??false;
         print(installed.toString());
        if(!installed){

          Future.delayed(const Duration(seconds: 5), () {

            Navigator.of(context).pushReplacementNamed('/Registration');

          });

        }
        else{

          Future.delayed(const Duration(seconds: 5), () {

            if(currentuser.value.access_token!=null){
              // Navigator.of(context).pushReplacementNamed('/${currentuser.value.role.home}', arguments: 1);

              Navigator.of(context).pushReplacementNamed('/Onboarding', arguments: 1);
            }
            else{
              Navigator.of(context).pushReplacementNamed('/Registration', arguments: 1);
            }

          });


        }}
    });
  }



  @override
  void initState() {
    init();
    super.initState();
    s.SchedulerBinding.instance.addPostFrameCallback((_) {
      loadData();
    });

  }


  Widget _title() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal:8.0),
      child: Container(
        height: 200,
        width: MediaQuery.of(context).size.width*0.7,
        decoration: BoxDecoration(
            color: Colors.white,
            image: DecorationImage(image: AssetImage("assets/logo/logoo.png"),fit: BoxFit.contain)
        ),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _con.scaffoldKey,
      body: Center(child:_title()),
    );
  }


  init() async {
 flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    var initializationSettingsAndroid =
    AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    await flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onSelectNotification: selectNotification);

    requestpermission(flutterLocalNotificationsPlugin);
  }
  requestpermission(flutterLocalNotificationsPlugin) async {
    var result = await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }
  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    // display a dialog with the notification details, tap ok to go to another page
  }

  show(String body, String title) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max, priority: Priority.High, ticker: 'ticker');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin
        .show(0, title, body, platformChannelSpecifics, payload: "app");
  }

  Future selectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => NotificationWidget(
            // payload: payload,
          )),
    );
  }
}
