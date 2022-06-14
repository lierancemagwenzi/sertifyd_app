import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:horizon/src/controllers/NotificationController.dart';
import 'package:horizon/src/model/ApplicationModel.dart';
import 'package:horizon/src/model/DocumentType.dart';
import 'package:horizon/src/model/MessageModel.dart';
import 'package:horizon/src/model/SertificationDocument.dart';
import 'package:horizon/src/model/SertifyerTerm.dart';
import 'package:horizon/src/pages/MessagingWidget.dart';
import 'package:horizon/src/repositories/admin_repository.dart';
import 'package:horizon/src/repositories/application_repository.dart';
import 'package:horizon/src/repositories/notification_repository.dart';
import 'package:horizon/src/repositories/sertifyer_repository.dart';
import 'package:horizon/src/repositories/user_repository.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:horizon/src/repositories/settings_repository.dart' as settingRepo;
import 'package:horizon/src/repositories/admin_repository.dart' as adminRepo;

class   ChatController extends ControllerMVC {
  GlobalKey<ScaffoldState> scaffoldKey;

  FirebaseFirestore firestore = FirebaseFirestore.instance;


  List<String> chat_ids=[];

  CertificationApplicationModel certificationApplicationModel;


  List<MessageModel> chats=[];

  List<MessageModel> conversations=[];

  ChatController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }

          Future<void> UpdateMessage(String id,var data){

    return FirebaseFirestore.instance.collection('messages').doc(certificationApplicationModel.id.toString()).collection("chats").doc(id).update(data).then((value) {
          print("message updated");
          return null;
        }).catchError((error) => print("Failed to add user: $error"));

  }


  Future<void > refreshChats(){
    listenForChats();

  }

  getchats(){
    conversations.clear();
    List ids=chat_ids;
    for(int i=0;i<ids.length;i++){
      FirebaseFirestore.instance
          .collection('messages').doc(ids[i]).collection("chats").orderBy("date",descending: true).limit(1)

          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          MessageModel messageModel=MessageModel(message: doc["message"],date: doc["date"],sender: doc["sender"],receiver: doc["receiver"],sender_id: doc["sender_id"],receiver_id: doc["receiver_id"],application_id: doc["application_id"],read: doc["read"]);

          setState(() {conversations.add(messageModel); });

          print(doc["message"]);
        });
      });
    }

    }

  Future<void>  findAdminApplication(int id,BuildContext context) async {
    final Stream<CertificationApplicationModel> stream = await getApplication(id);
    stream.listen((CertificationApplicationModel certificationApplicationModel) {

      Navigator.push(
          context,
          CupertinoPageRoute(
              builder: (context) => MessagingWidget(
                applicationModel: certificationApplicationModel,
                isadmin: true,
              ))).then((value) {

                getchats();
                return null;
              });



    }, onError: (a) {

      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text("Check your network!"),
      ));
      print(a);
    }, onDone: () {

    });
  }


  Future<void> addMessage(MessageModel messageModel,ScrollController _scrollController) {
    CollectionReference messages = FirebaseFirestore.instance.collection('messages').doc(certificationApplicationModel.id.toString()).collection("chats");

    return messages
        .add(messageModel.toMap())
        .then((value) {

      NotifyRecipient(messageModel);

      _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 500),
          curve: Curves.ease);
          print("message Added");
        })
        .catchError((error) => print("Failed to add user: $error"));
  }


  void NotifyRecipient(MessageModel messageModel) {
    notifyrecipient({"title":"You have a new message","body":"${currentuser.value.getFullname()} messaged you.","action":"new_message","action_id":"0","user_id":messageModel.receiver_id}).then((value) {
      print(value);
      setState(() {
        if(value!=null){
        }
        else{

        }
      });
    });
  }



  Future<void> listenForChats() async {
    chat_ids.clear();
    final Stream<String> stream = await adminRepo.getAllchats();
    stream.listen((String chat_id) {
      setState(() => chat_ids.add(chat_id));
    }, onError: (a) {

      print(a);
      // scaffoldKey?.currentState?.showSnackBar(SnackBar(
      //   content: Text("Check your connection"),
      // ));
      print(a);
    }, onDone: () {

      getchats();
      print(chat_ids.length);
    });
  }

}