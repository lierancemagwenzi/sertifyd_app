import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:horizon/src/model/ChatModel.dart';
import 'package:horizon/src/model/Earning.dart';
import 'package:horizon/src/model/ApplicationModel.dart';
import 'package:horizon/src/model/EarningsStat.dart';
import 'package:horizon/src/model/SertifyerTerm.dart';
import 'package:horizon/src/pages/payfastform.dart';
import 'package:horizon/src/repositories/admin_repository.dart';
import 'package:horizon/src/repositories/application_repository.dart';
import 'package:horizon/src/repositories/payment_repository.dart';
import 'package:horizon/src/repositories/sertifyer_repository.dart';
import 'package:horizon/src/repositories/user_repository.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:horizon/src/repositories/chat_repository.dart';
import 'package:horizon/src/repositories/settings_repository.dart' as settingRepo;
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'application_controller.dart';



class   ChatHelperController extends ControllerMVC {
  GlobalKey<ScaffoldState> scaffoldKey;
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();
CertificationApplicationModel certificationApplicationModel;
  bool loading = false;
List<ChatModel> conversations=[];
  TextEditingController controller;

  ChatHelperController() {
    controller=new TextEditingController();
    this.scaffoldKey = new GlobalKey<ScaffoldState>();


  }
  Future<void> listenforAllchats() async {
    conversations.clear();
    setState(() {
      loading=true;
    });
    final Stream<ChatModel> stream = await getallchats();
    stream.listen((ChatModel chatModel) {
      setState(() => conversations.add(chatModel));
    }, onError: (a) {

      print(a);
    }, onDone: () {
      setState(() {
        loading=false;
      });

    });
  }

  Future<void> listenForApplication(int id,ScrollController _scrollController) async {
    final Stream<CertificationApplicationModel> stream = await getApplication(
        id);
    stream.listen((
        CertificationApplicationModel certificationApplicationModel) {
setState(() {

  this.certificationApplicationModel=certificationApplicationModel;
});

    }, onError: (a) {
      // scaffoldKey?.currentState?.showSnackBar(SnackBar(
      //   content: Text("Check your connection"),
      // ));
      print(a);
    }, onDone: () {
listenforchats(id, _scrollController);
    });
  }


  Future<void> listenforchats(int id,ScrollController _scrollController) async {
    messages.value.clear();


    setState(() {

      loading=true;
    });
    final Stream<ChatModel> stream = await getchats(id);
    stream.listen((ChatModel chatModel) {
      setState(() => messages.value.add(chatModel));
    }, onError: (a) {

      print(a);
    }, onDone: () {


      // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
      messages.notifyListeners();

      setState(() {

        loading=false;
      });

      Future.delayed(Duration(seconds: 1)).then((value) {
        if(messages.value.length>0){
          itemScrollController.jumpTo(index: messages.value.length-1);

        }      });



    });
  }

  void SendMessage(Map map,ScrollController _scrollController){

    addchat(map).then((value) async {
      print(value);
      if(value!=null){
        setState(() {
         messages.value.add(value);
        });
        value.from=currentuser.value.getFullname();

        socket.emit('new_message', value.toMap());

        setState(() {
          controller.clear();

        });

        Future.delayed(Duration(seconds: 1)).then((value) {
          if(messages.value.length>0){
            itemScrollController.jumpTo(index: messages.value.length-1);

          }      });
      }
      else{
        setState(() {
          loading=false;
        });
        scaffoldKey?.currentState?.showSnackBar(SnackBar(
          content: Text("Failed to send message.Try again"),
        ));
      }

    });

  }


  @override
  void initState() {
    socket.on('new_message', (data) {
      print("new_message");
      var post = jsonDecode(data);
      ChatModel chatModel = ChatModel.fromJson(post);
      setState(() {
        messages.value=messages.value;
      });
      Future.delayed(Duration(seconds: 1)).then((value) {
        if(messages.value.length>0){
          itemScrollController.jumpTo(index: messages.value.length-1);

        }      });
      print("new message received");
      print(chatModel.toMap());
    });
    super.initState();
  }

  @override
  void dispose() {

    // socket.disconnect();
  }
}