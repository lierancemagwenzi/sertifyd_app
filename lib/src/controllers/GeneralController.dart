import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flash/flash.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:horizon/src/controllers/MessagingController.dart';
import 'package:horizon/src/model/ApplicationModel.dart';
import 'package:horizon/src/model/DocumentType.dart';
import 'package:horizon/src/model/NotificationModel.dart';
import 'package:horizon/src/model/SertificationDocument.dart';
import 'package:horizon/src/model/SertifyerTerm.dart';
import 'package:horizon/src/pages/Notifications.dart';
import 'package:horizon/src/pages/admin/AdminNotifications.dart';
import 'package:horizon/src/repositories/admin_repository.dart';
import 'package:horizon/src/repositories/application_repository.dart';
import 'package:horizon/src/repositories/global_repository.dart';
import 'package:horizon/src/repositories/sertifyer_repository.dart';
import 'package:horizon/src/repositories/settings_repository.dart';
import 'package:horizon/src/repositories/user_repository.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:horizon/src/repositories/settings_repository.dart' as settingRepo;
import 'package:horizon/src/repositories/global_repository.dart' as globalRepo;

class   GeneralController extends MessagingController {
  GlobalKey<ScaffoldState> scaffoldKey;

  int notification_count=0;

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  GlobalKey<NavigatorState> navigatorKey;

  GeneralController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }


  void getDeviceDetrails(BuildContext context) {
    settingRepo.getDeviceDetails().then((value) {
      print(value);
      setState(() {
        settingRepo.detailsModel.value=value;
      });

      if(value.identifier!=null){

        init(context);
      }
    });
  }


  Future<void> init(BuildContext context) async {
    _firebaseMessaging.requestNotificationPermissions();
    if (!globalRepo.initialized) {
      // For iOS request permission first.

      Future.delayed(Duration(seconds: 1), () {
        _firebaseMessaging.configure(
          onMessage: (Map<String, dynamic> message) async {
            print("onMessage: $message");
          // var notification=  new NotificationModel(
          //       action_id: int.parse(message['data']['action_id']),
          //       title: message['notification']['title'],
          //       body: message['notification']['body'],
          //       seen: 0,
          //       user_id: 0);

          // print(notification);

          if(Platform.isIOS){
print("soildier");
            setState(() {
             notifications.add(new NotificationModel(
                // id: int.parse(message['data']['action_id']),
                // title: message['notification']['title'],
                // body: message['notification']['body'],
                  action_id: int.parse(message['action_id']),
                  title: message['notification']['title'],
                  body: message['notification']['body'],
                  seen: 0,
                  user_id: 0));
             if(currentuser.value.role.name=="client"){



               total_client_notifications.value+=1;

               // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
               total_client_notifications.notifyListeners();
             }

             else{
               total_client_notifications.value+=1;

               // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
               total_client_notifications.notifyListeners();

             }

            });
showFlash(
    context: context,
    duration: Duration(seconds: 5),
    builder: (_, controller) {
      return Flash(
        controller: controller,
        position: FlashPosition.top,
        style: FlashStyle.grounded,
        backgroundColor: Theme.of(context).accentColor,
        insetAnimationDuration: Duration(seconds: 3),
        child: FlashBar(
          // icon: Icon(
          //   Icons.notifications,
          //   size: 36.0,
          //   color: Colors.white,
          // ),
          message: ListTile(title:
          Text(message['notification']['title'],style: TextStyle(color: Colors.white),),
              subtitle:  Text(message['notification']['body'],style: TextStyle(color: Colors.white),)),
        ),



      );
    });

          }
            // setState(() {
            //   notification_count += 1;
            //   notifications.add(new NotificationModel(
            //       action_id: int.parse(message['data']['action_id']),
            //       title: message['notification']['title'],
            //       body: message['notification']['body'],
            //       seen: 0,
            //       user_id: 0));
            // });



          else{
            print("about to show");
            globalRepo.showNotification(message['notification']['body'], message['notification']['title'],NotificationModel(
                     action_id: int.parse(message['data']['action_id']),
                     title: message['notification']['title'],
                     body: message['notification']['body'],
                     seen: 0,
                     user_id: 0).toMap().toString());}


//            AudioCache player = AudioCache(prefix: 'assets/sounds/');
//            player.play('sound.mp3', volume: 1.0);
//             AudioCache _audioCache = AudioCache(
//                 prefix: "sounds/",
//                 fixedPlayer: AudioPlayer()..setReleaseMode(ReleaseMode.STOP));
//
//             _audioCache.play('sound.mp3');

//             Flushbar(
//               flushbarPosition: FlushbarPosition.TOP,
//               reverseAnimationCurve: Curves.decelerate,
//               forwardAnimationCurve: Curves.elasticOut,
//               flushbarStyle: FlushbarStyle.FLOATING,
//               backgroundColor: Colors.blue,
// //            message:
// //                "Lorem Ipsum is simply dummy text of the printing and typesetting industry",
//
//               titleText: Text(
//                 "hey",
//                 style: TextStyle(color: Colors.white),
//               ),
//               dismissDirection: FlushbarDismissDirection.HORIZONTAL,
//               isDismissible: true,
//               messageText: Text(
//                "hello",
//                 style: TextStyle(color: Colors.white),
//               ),
//
//               icon: Icon(
//                 Icons.notifications,
//                 size: 28.0,
//                 color: Colors.white,
//               ),
//               duration: Duration(seconds: 6),
//               leftBarIndicatorColor: Colors.blue[300],
//             )..show(context);

//          showAlertDialog(context);

//          _showItemDialog(message);
          },
          onBackgroundMessage:Platform.isAndroid? myBackgroundMessageHandler:null,
          onLaunch: (Map<String, dynamic> message) async {
            print("onLaunch: $message");
            // navigatorKey.currentState.push(MaterialPageRoute(
            //     builder: (_) => FcmNotifications(
            //       map: message,
            //     )));
//
//            Navigator.push(§§
//                context, SlideRightRoute(page: NotificationScreen()));

//          showAlertDialog(context);
            Navigator.pushReplacement(context,
                CupertinoPageRoute(builder: (context) => currentuser.value.role.name=='sertifyer'?AdminNotificationWidget(fromlauncher: true,):NotificationWidget(fromlauncher: true,)));
          },
          onResume: (Map<String, dynamic> message) async {
            // navigatorKey.currentState.push(MaterialPageRoute(
            //     builder: (_) => FcmNotifications(
            //       map: message,
            //     )));
            print("onResume: $message");

            Navigator.pushReplacement(context,
                CupertinoPageRoute(builder: (context) =>currentuser.value.role.name=='sertifyer'?AdminNotificationWidget(fromlauncher: true,): NotificationWidget(fromlauncher: true,)));
//            Navigator.push(
//                context, SlideRightRoute(page: NotificationScreen()));

//          showAlertDialog(context);

//          Navigator.push(context, SlideRightRoute(page: NotificationScreen()));
//          _navigateToItemDetail(message);
          },
        );

        // For testing purposes print the Firebase Messaging token

        globalRepo. initialized = true;
      });
    }
    String token = await _firebaseMessaging.getToken();
    if(currentuser.value.id!=0){
      RegisterToken(token: token,id: currentuser.value.id,  identifier: settingRepo.detailsModel.value.identifier,deviceName: settingRepo.detailsModel.value.deviceName,deviceVersion: settingRepo.detailsModel.value.deviceVersion);

    }

    _firebaseMessaging.subscribeToTopic("generalnotifications");

    print("FirebaseMessaging token: $token");

    print(
        "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ token: $token");
  }




}