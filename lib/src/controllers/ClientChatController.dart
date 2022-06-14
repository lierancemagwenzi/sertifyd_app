import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:horizon/src/model/ApplicationModel.dart';
import 'package:horizon/src/model/MessageModel.dart';
import 'package:horizon/src/pages/MessagingWidget.dart';
import 'package:horizon/src/repositories/application_repository.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

class   ClientChatController extends ControllerMVC {
  GlobalKey<ScaffoldState> scaffoldKey;


  List<String> chat_ids = [];

  List<MessageModel> chats = [];

  List<MessageModel> conversations = [];

  ClientChatController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
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
                isadmin: false,
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


  Future<void> listenForChats() async {
    chat_ids.clear();
    final Stream<String> stream = await getAllchats();
    stream.listen((String chat_id) {
      setState(() => chat_ids.add(chat_id));
    }, onError: (a) {

      print(a);
      // scaffoldKey?.currentState?.showSnackBar(SnackBar(
      //   content: Text("Check your connection"),
      // ));
      print(a);
    }, onDone: () {
      print(chat_ids.length);
      getchats();
    });
  }

}