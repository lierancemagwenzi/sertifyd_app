

import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:horizon/Route_generator.dart';
import 'package:horizon/src/model/UserModel.dart';
import 'package:horizon/src/repositories/login_repository.dart';
import 'package:horizon/src/repositories/settings_repository.dart' as settingRepo;
import 'package:horizon/src/helper/app_config.dart' as config;
import 'package:horizon/testing/pages/SplashScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'src/model/Setting.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();


LoadUser() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String  user=prefs.getString('user_details')??null;
  // print(user);
  print("main");
  if(user!=null){
    UserModel userModel=UserModel.fromJson(jsonDecode(user)['data']);
    RefreshUser(userModel.access_token,{"id":userModel.id});
  }

}

init(){
  FlutterLocalNotificationsPlugin flp = FlutterLocalNotificationsPlugin();
  var android = AndroidInitializationSettings(
    '@mipmap/ic_launcher',
  );
  var iOS = IOSInitializationSettings();
  var initSetttings = InitializationSettings(android, iOS);
  flp.initialize(initSetttings);
}

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await GlobalConfiguration().loadFromAsset("app_settings");
  await Firebase.initializeApp();

  settingRepo.initSettings();
  LoadUser();
  init();
  initializeDateFormatting().then((_) => runApp(App()));

  // runApp(App());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lifesol Health Wallet',
      theme: ThemeData(
backgroundColor:  Color(0xFFEFEFEF),
        brightness: Brightness.light,
        primaryColor: Colors.green,
        accentColor: Colors.brown,
        // Define the default font family.
        fontFamily: 'sans',
        // Define the default TextTheme. Use this to specify the default
        // text styling for headlines, titles, bodies of text, and more.
        textTheme: TextTheme(
          headline1: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          headline2: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          headline3: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          headline4: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w100),
          headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),

          bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'sans'),
        ),
          buttonTheme: ButtonThemeData(
            buttonColor: Colors.green,     //  <-- dark color
            textTheme: ButtonTextTheme.primary, //  <-- this auto selects the right color
          ),


        scaffoldBackgroundColor: const Color(0xFFEFEFEF),

        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.green,

        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SplashScreen(),
    );
  }
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    precacheImage(AssetImage("assets/bg/backbg.png"), context);

    return ValueListenableBuilder(
        valueListenable: settingRepo.setting,
        builder: (context, Setting _setting, _) {
          return MaterialApp(
              navigatorKey: settingRepo.navigatorKey,
              title: _setting.appName,
              initialRoute: '/Splash',
              //       initialRoute: '/Intro',
              onGenerateRoute: RouteGenerator.generateRoute,
              debugShowCheckedModeBanner: false,
              locale: _setting.mobileLanguage.value,
              theme: _setting.brightness.value == Brightness.light
                  ?ThemeData(
                fontFamily: 'Poppins',
                primaryColor: Colors.white,
                floatingActionButtonTheme: FloatingActionButtonThemeData(elevation: 0, foregroundColor: Colors.white),
                brightness: Brightness.light,
                accentColor: config.Colors().mainColor(1),
                cursorColor:config.Colors().mainColor(1) ,
                primaryColorLight:config.Colors().accentColor(1),
                dividerColor: config.Colors().accentColor(0.1),
                focusColor: config.Colors().accentColor(1),
                hintColor: config.Colors().secondColor(1),
                  appBarTheme: AppBarTheme(centerTitle: true,   color:config.Colors().mainColor(1),elevation: 0.0,textTheme:TextTheme(headline5: TextStyle(fontSize: 18.0, color:Colors.white,fontWeight: FontWeight.bold, height: 1.3))  ),
                  buttonTheme: ButtonThemeData(
                    buttonColor: config.Colors().accentColor(1),     //  <-- dark color
                     //  <-- this auto selects the right color
                  ),
                textTheme: TextTheme(
                  headline5: TextStyle(fontSize: 22.0, color: config.Colors().accentColor(1), height: 1.3),
                  headline4: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w700, color: config.Colors().accentColor(1), height: 1.3),
                  headline3: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w700, color: config.Colors().secondColor(1), height: 1.3),
                  headline2: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w700, color: config.Colors().mainColor(1), height: 1.4),
                  headline1: TextStyle(fontSize: 26.0, fontWeight: FontWeight.w300, color: config.Colors().secondColor(1), height: 1.4),
                  subtitle1: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500, color: config.Colors().secondColor(1), height: 1.3),
                  headline6: TextStyle(fontSize: 17.0, fontWeight: FontWeight.w700, color: config.Colors().mainColor(1), height: 1.3),
                  bodyText2: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400, color: config.Colors().secondColor(1), height: 1.2),
                  bodyText1: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w400, color: config.Colors().secondColor(1), height: 1.3),
                  caption: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w300, color: config.Colors().accentColor(1), height: 1.2),
                ),
              ):ThemeData(
                fontFamily: 'sans',
                primaryColor: Color(0xFF252525),
                brightness: Brightness.dark,
                scaffoldBackgroundColor: Color(0xFF2C2C2C),
                accentColor: config.Colors().mainDarkColor(1),
                dividerColor: config.Colors().accentColor(0.1),
                hintColor: config.Colors().secondDarkColor(1),
                focusColor: config.Colors().accentDarkColor(1),
                textTheme: TextTheme(
                  headline5: TextStyle(fontSize: 22.0, color: config.Colors().secondDarkColor(1), height: 1.3),
                  headline4: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w700, color: config.Colors().secondDarkColor(1), height: 1.3),
                  headline3: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w700, color: config.Colors().secondDarkColor(1), height: 1.3),
                  headline2: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w700, color: config.Colors().mainDarkColor(1), height: 1.4),
                  headline1: TextStyle(fontSize: 26.0, fontWeight: FontWeight.w300, color: config.Colors().secondDarkColor(1), height: 1.4),
                  subtitle1: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500, color: config.Colors().secondDarkColor(1), height: 1.3),
                  headline6: TextStyle(fontSize: 17.0, fontWeight: FontWeight.w700, color: config.Colors().mainDarkColor(1), height: 1.3),
                  bodyText2: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400, color: config.Colors().secondDarkColor(1), height: 1.2),
                  bodyText1: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w400, color: config.Colors().secondDarkColor(1), height: 1.3),
                  caption: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w300, color: config.Colors().secondDarkColor(0.6), height: 1.2),
                ),
              ));
        });
  }
}

