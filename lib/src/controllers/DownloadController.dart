
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:horizon/src/model/ApplicationModel.dart';
import 'package:horizon/src/repositories/application_repository.dart';

import 'GeneralController.dart';
class   DownloadController extends GeneralController {

  List<CertificationApplicationModel> applications=[];

  DownloadController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }


  Future<void> GetApplication(int id,BuildContext context) async {
    final Stream<CertificationApplicationModel> stream = await getApplication(
        id);
    stream.listen((
        CertificationApplicationModel certificationApplicationModel) {
      Navigator.pushNamed(context, "/${certificationApplicationModel.status.client_next}",arguments: certificationApplicationModel.id);
      setState(() {
      });
    }, onError: (a) {
      // scaffoldKey?.currentState?.showSnackBar(SnackBar(
      //   content: Text("Check your connection"),
      // ));
      print(a);
    }, onDone: () {

    });
  }

  Future<void> listenForApplications({String message}) async {
    applications.clear();
    final Stream<CertificationApplicationModel> stream = await getCompletedUserApplications();
    stream.listen((CertificationApplicationModel certificationApplicationModel) {

      print("complted");
      setState(() => applications.add(certificationApplicationModel));
    }, onError: (a) {

      if(message!=null){
        scaffoldKey?.currentState?.showSnackBar(SnackBar(
          content: Text("No data found"),
        ));

      }
      print(a);
    }, onDone: () {
      if(message!=null){
        scaffoldKey?.currentState?.showSnackBar(SnackBar(
          content: Text(message),
        ));

      }
    });
  }
  Future<void > refreshCompleted(){

    listenForApplications(message: "Refreshed successfully");

  }

}