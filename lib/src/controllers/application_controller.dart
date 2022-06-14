import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:horizon/src/controllers/NotificationController.dart';
import 'package:horizon/src/model/ApplicationModel.dart';
import 'package:horizon/src/model/ClientApplication.dart';
import 'package:horizon/src/model/DocumentType.dart';
import 'package:horizon/src/model/SertificationDocument.dart';
import 'package:horizon/src/model/SertifyerTerm.dart';
import 'package:horizon/src/repositories/application_repository.dart';
import 'package:horizon/src/repositories/global_repository.dart';
import 'package:horizon/src/repositories/sertifyer_repository.dart';
import 'package:horizon/src/repositories/settings_repository.dart';
import 'package:horizon/src/repositories/user_repository.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:horizon/src/repositories/settings_repository.dart' as settingRepo;

class   ApplicationController extends ControllerMVC {
  GlobalKey<ScaffoldState> scaffoldKey;

  List<CertificationApplicationModel> applications = [];


  List<DocumentTypeModel> document_types = [];

  bool loading = false;

  bool success = false;
  CertificationApplicationModel certificationApplicationModel;

  ApplicationController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }


  List<Color> colors=[Color(0xffed7e7f),Color(0xffb0c3de),Color(0xff9bd7e8),Color(0xffa5eeb9),Color(0xffdcc2ec),];





  getColor(){

    final _random = new Random();

    Color color= colors[_random.nextInt(colors.length)];

    return color;
  }

  Future<void > refreshHome({String message}){

    listenForApplications(message: "Refreshed successfully");

  }
  Future<void > refreshProfile(){

    listenForApplications(message: "Refreshed successfully");

  }

  Future<void> listenForApplications({String message}) async {
    applications.clear();


    setState(() {

      loading=true;
    });
    final Stream<
        CertificationApplicationModel> stream = await getUserApplications();
    stream.listen((
        CertificationApplicationModel certificationApplicationModel) {
      setState(() => applications.add(certificationApplicationModel));
    }, onError: (a) {

      setState(() {

        loading=false;
      });
      if(message!=null){
        scaffoldKey?.currentState?.showSnackBar(SnackBar(
          content: Text("No new data found"),
        ));

      }
      print(a);
    }, onDone: () {


      setState(() {

        loading=false;
      });
      if(message!=null){
        // scaffoldKey?.currentState?.showSnackBar(SnackBar(
        //   content: Text(message),
        // ));

      }
    });
  }


  Future<void> listenForBanks({String message}) async {
    applications.clear();
    final Stream<
        CertificationApplicationModel> stream = await getUserApplications();
    stream.listen((
        CertificationApplicationModel certificationApplicationModel) {
      setState(() => applications.add(certificationApplicationModel));
    }, onError: (a) {

      if(message!=null){
        scaffoldKey?.currentState?.showSnackBar(SnackBar(
          content: Text("No new data found"),
        ));

      }
      print(a);
    }, onDone: () {
      if(message!=null){
        // scaffoldKey?.currentState?.showSnackBar(SnackBar(
        //   content: Text(message),
        // ));

      }
    });
  }




  Future<void> GetApplication(int id,BuildContext context) async {
    final Stream<CertificationApplicationModel> stream = await getApplication(
        id);
    stream.listen((
        CertificationApplicationModel certificationApplicationModel) {

      if(certificationApplicationModel.status.status.toLowerCase()=='pending'){
        Navigator.of(context).pushNamed('/${certificationApplicationModel.status.client_next.toLowerCase()}', arguments: ClientApplication(id: certificationApplicationModel.id,message:null));

      }

      else{
        Navigator.pushNamed(context, "/${certificationApplicationModel.status.client_next}",arguments: certificationApplicationModel.id);

      }



      setState(() {
        this.certificationApplicationModel = certificationApplicationModel;
      });
    }, onError: (a) {
      // scaffoldKey?.currentState?.showSnackBar(SnackBar(
      //   content: Text("Check your connection"),
      // ));
      print(a);
    }, onDone: () {

    });
  }



  Future<void> listenForApplication(int id,{String client_next,BuildContext context}) async {
    final Stream<CertificationApplicationModel> stream = await getApplication(
        id);
    stream.listen((
        CertificationApplicationModel certificationApplicationModel) {


      if(client_next==null){

        setState(() {
          this.certificationApplicationModel = certificationApplicationModel;
        });
      }

      else{

      if( client_next==certificationApplicationModel.status.client_next){

        setState(() {
          this.certificationApplicationModel = certificationApplicationModel;
        });
      }

      else{
        if(certificationApplicationModel.status.status.toLowerCase()=='pending'){
          Navigator.of(context).pushReplacementNamed('/${certificationApplicationModel.status.client_next.toLowerCase()}', arguments: ClientApplication(id: certificationApplicationModel.id,message:null));

        }

        else{
          Navigator.pushReplacementNamed(context, "/${certificationApplicationModel.status.client_next}",arguments: ClientApplication(id: certificationApplicationModel.id));
        }
    }}

      }, onError: (a) {
      // scaffoldKey?.currentState?.showSnackBar(SnackBar(
      //   content: Text("Check your connection"),
      // ));
      print(a);
    }, onDone: () {
      Map map={"action":"application","platform":Platform.isIOS?"ios":"android","user_id":currentuser.value.id??0,"device":detailsModel.value.identifier,"detail":"application","action_id":id};

      log_activity(map);
    });
  }



  Future<void>  CancelApplication(BuildContext context,Map map,int index) async {

    setState(() {

      loading=true;
    });
    cancelapplication(map).then((value) async {
      print(value);
      if(value!=null){

        for(int i=0;i<applications.length;i++){

          if(applications[i].id==value.id){

setState(() {

  applications[i]=value;
});

          }
        }
        setState(() {

          loading=false;
        });

        scaffoldKey?.currentState?.showSnackBar(SnackBar(
          content: Text("Application Cancelled"),
        ));
      }
      else{
        setState(() {
          success=false;
          loading=false;
        });
        scaffoldKey?.currentState?.showSnackBar(SnackBar(
          content: Text("Failed to cancel application.Try again"),
        ));

      }

    });
  }


  Future<void>  Reschedule(BuildContext context,Map map) async {
    setState(() {
      loading=true;
    });
    rescheduleapplication(map).then((value) async {
      print(value);
      if(value!=null){



        Navigator.pop(context);
        if(value.status.status.toLowerCase()=='pending'){
          Navigator.of(context).pushNamed('/${value.status.client_next.toLowerCase()}', arguments: ClientApplication(id: value.id,message: "Rescheduled Successfully"));

        }

        else{
          Navigator.of(context).pushNamed('/${value.status.client_next.toLowerCase()}', arguments: ClientApplication(id: value.id,message:null));
        }


      }
      else{
        setState(() {
          success=false;
          loading=false;
        });
        scaffoldKey?.currentState?.showSnackBar(SnackBar(
          content: Text("Failed to cancel application.Try again"),
        ));

      }

    });
  }

  Future<void> listenForDocTypes() async {
    document_types.clear();
    final Stream<DocumentTypeModel> stream = await getDocTypes();
    stream.listen((DocumentTypeModel documentTypeModel) {
      setState(() => document_types.add(documentTypeModel));
    }, onError: (a) {
      // scaffoldKey?.currentState?.showSnackBar(SnackBar(
      //   content: Text("Check your connection"),
      // ));
      print(a);
    }, onDone: () {

    });
  }

  AddToList(SertificationDocumentModel sertificationDocumentModel,
      BuildContext context) {
    int count = 1;
    for (int i = 0; i < docs.value.length; i++) {
      if (docs.value[i].documentTypeModel.type ==
          sertificationDocumentModel.documentTypeModel.type) {
        count = count + 1;
        // setState(() {
        //   docs.value.removeAt(i);
        // });
      }
    }
    sertificationDocumentModel.documentTypeModel.short_name =
        sertificationDocumentModel.documentTypeModel.short_name +
            count.toString();
    docs.value.add(sertificationDocumentModel);
    Navigator.pop(context);
  }

  Future<void> refreshApplication() async {

  }
}