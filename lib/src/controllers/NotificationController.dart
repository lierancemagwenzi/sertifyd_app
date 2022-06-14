import 'dart:async';

import 'package:flutter/material.dart';
import 'package:horizon/src/model/AdminApplication.dart';
import 'package:horizon/src/model/ApplicationModel.dart';
import 'package:horizon/src/model/ClientApplication.dart';
import 'package:horizon/src/model/NotificationModel.dart';
import 'package:horizon/src/model/SertifyerTerm.dart';
import 'package:horizon/src/repositories/application_repository.dart';
import 'package:horizon/src/repositories/notification_repository.dart';
import 'package:horizon/src/repositories/sertifyer_repository.dart';
import 'package:horizon/src/repositories/user_repository.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:horizon/src/repositories/settings_repository.dart' as settingRepo;

import 'application_controller.dart';

class   NotificationController extends ControllerMVC {
  GlobalKey<ScaffoldState> scaffoldKey;

List<NotificationModel> notifications=[];
  NotificationModel notificationModel;
  bool loading=false;

  bool success=false;


  NotificationController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();

  }

  Future<void> listenForNotifications() async {

    setState(() {

      loading=true;
    });
    notifications.clear();
    final Stream<NotificationModel> stream = await getnotifications();
    stream.listen((NotificationModel notificationModel) {
      setState(() => notifications.add(notificationModel));
    }, onError: (a) {
      setState(() {
        loading=false;
      });
      print(a);
    }, onDone: () {
      setState(() {
        loading=false;
      });
    });
  }

  Future<void > refreshNotifications(){
    notifications.clear();
    listenForNotifications();

  }

  void  DeleteNotification(int id) {
    deletenotification({"id":id}).then((value) async {
      print(value);
      loading=false;
      if(value!=null){
        setState(() {
         notifications.removeWhere((element) => element.id==id);
          success=true;
        });
        scaffoldKey?.currentState?.showSnackBar(SnackBar(
          content: Text("deleted"),
        ));
      }
      else{
        scaffoldKey?.currentState?.showSnackBar(SnackBar(
          content: Text("Failed to remove comment"),
        ));
      }

    });
  }


  Future<void>  findApplication(int id,BuildContext context) async {
    final Stream<CertificationApplicationModel> stream = await getApplication(id);
    stream.listen((CertificationApplicationModel certificationApplicationModel) {

      print(certificationApplicationModel.status.client_next);
    Navigator.pushNamed(context, "/${certificationApplicationModel.status.client_next}",arguments:  ClientApplication(id: id,message:null,client_next:null));

    }, onError: (a) {
      print(a);
    }, onDone: () {

    });
  }

  Future<void>  findAdminApplication(int id,BuildContext context) async {
    final Stream<CertificationApplicationModel> stream = await getApplication(id);
    stream.listen((CertificationApplicationModel certificationApplicationModel) {

      print(certificationApplicationModel.status.admin_next);
      Navigator.pushNamed(context, "/${certificationApplicationModel.status.admin_next}",arguments: AdminApplicationModel(id: id,message: null));


    }, onError: (a) {
      print(a);
    }, onDone: () {

    });
  }


  void  MarkAsRead(int id,int index,int read) {
    markasread({"id":id},{"read":read}).then((value) async {
      print(value);
      loading=false;
      if(value!=null){
        setState(() {
          notifications[index]=value;
          success=true;
        });

      }
      else{

      }

    });
  }


}
