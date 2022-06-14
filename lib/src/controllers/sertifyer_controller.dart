import 'dart:async';

import 'package:flutter/material.dart';
import 'package:horizon/src/model/SertifyerTerm.dart';
import 'package:horizon/src/repositories/sertifyer_repository.dart';
import 'package:horizon/src/repositories/user_repository.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:horizon/src/repositories/settings_repository.dart' as settingRepo;

class   SertifyerController extends ControllerMVC {
  GlobalKey<ScaffoldState> scaffoldKey;
List<SetifyerTermModel> terms=[];


bool loading=false;

bool success=false;


  SertifyerController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }

  Future<void> listenForTerms() async {
    terms.clear();
    final Stream<SetifyerTermModel> stream = await getTerms();
    stream.listen((SetifyerTermModel setifyerTermModel) {
      setState(() => terms.add(setifyerTermModel));
    }, onError: (a) {

      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text("Check your connection"),
      ));
      print(a);
    }, onDone: () {

    });
  }

  void  Apply() {
    setState(() {
      loading=true;
    });
    var user={
      "user_id":currentuser.value.id,

    };
    apply(user).then((value) {
      print(value);
      setState(() {
        loading=false;
        if(value!=null){
          currentuser.value=value;
        success=true;
        }
        else{
         success=false;
        }
      });
    });
  }


}
