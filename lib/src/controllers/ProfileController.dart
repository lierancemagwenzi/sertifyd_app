
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:horizon/src/controllers/application_controller.dart';
import 'package:horizon/src/model/ApplicationModel.dart';
import 'package:horizon/src/model/ClientApplication.dart';
import 'package:horizon/src/model/UserModel.dart';
import 'package:horizon/src/repositories/application_repository.dart';
import 'package:horizon/src/repositories/login_repository.dart';
import 'package:horizon/src/repositories/user_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'GeneralController.dart';
class   ProfileController extends GeneralController {

  List<CertificationApplicationModel> applications=[];

  ProfileController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }



  Future<void> GetClientApplication(int id,BuildContext context) async {
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

    }, onError: (a) {
      // scaffoldKey?.currentState?.showSnackBar(SnackBar(
      //   content: Text("Check your connection"),
      // ));
      print(a);
    }, onDone: () {

    });
  }

  Future<void>  CancelApplication(BuildContext context,Map map,int index) async {

    setState(() {

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

        });

        scaffoldKey?.currentState?.showSnackBar(SnackBar(
          content: Text("Application Cancelled"),
        ));
      }
      else{
        setState(() {

        });
        scaffoldKey?.currentState?.showSnackBar(SnackBar(
          content: Text("Failed to cancel application.Try again"),
        ));

      }

    });
  }


  Future<void> listenForApplications() async {
    applications.clear();
    final Stream<CertificationApplicationModel> stream = await getRecentUserApplications();
    stream.listen((CertificationApplicationModel certificationApplicationModel) {
      setState(() => applications.add(certificationApplicationModel));
    }, onError: (a) {

      // scaffoldKey?.currentState?.showSnackBar(SnackBar(
      //   content: Text("Check your connection"),
      // ));
      print(a);
    }, onDone: () {

    });
  }

  void LogoutUser(BuildContext context) {
    logoutuser().then((value) async {
      print(value);

        if(value!=null){

            SharedPreferences prefrences= await SharedPreferences.getInstance();
            currentuser.value=new UserModel(id: 0);
            await prefrences.clear();
            Navigator.pushNamed(context, '/Login');
          }
          else{
            scaffoldKey?.currentState?.showSnackBar(SnackBar(
              content: Text('An error occurred'),
            ));

          }


    });
  }

}