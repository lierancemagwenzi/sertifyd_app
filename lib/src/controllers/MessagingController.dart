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
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'application_controller.dart';


class   MessagingController extends ControllerMVC {
  GlobalKey<ScaffoldState> scaffoldKey;


  bool loading = false;

  MessagingController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }

  @override
  void initState() {
    final String url =
        '${GlobalConfiguration().getValue('chat_url')}';
    socket = IO.io(url, <String, dynamic>{
      'transports': ['websocket'],
      'reconnection':true,
      'reconnectionAttempts':100,
      'extraHeaders': {'setUsname': currentuser.value.getFullname()} // optional
    });

    socket.on('connect', (_) {
      print('chat connected');
      socket.emit('change_username', {
        'username':  currentuser.value.getFullname(),
        'user_id': currentuser.value.id,
      });
    });
    socket.on('disconenct', (_) {
      print('chat disconnected');

    });

    socket.on('error', (_) {
      print('chat error');

    });
   socket.on('new_message', (data) {
      print("new_message");
      var post = jsonDecode(data);
      ChatModel chatModel = ChatModel.fromJson(post);
      setState(() {
        messages.value.add(chatModel);
      });
      // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
      messages.notifyListeners();
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