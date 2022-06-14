import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:horizon/src/helper/Helper.dart';
import 'package:horizon/src/model/ChatModel.dart';
import 'package:horizon/src/repositories/user_repository.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:http/http.dart' as http;

IO.Socket socket;

ValueNotifier<List<ChatModel>> messages = ValueNotifier([]);


sockets() {
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}';
  socket = IO.io(url, <String, dynamic>{
    'transports': ['websocket'],
    'extraHeaders': {'setUsname': currentuser.value.getFullname()} // optional
  });

  socket.on('connect', (_) {
    print('connect');
   socket.emit('change_username', {
      'username':  currentuser.value.getFullname(),
      'user_id': currentuser.value.id,
    });
  });
}


Future<ChatModel> addchat(var body) async {
  print("#adding new chat");
  final String url = '${GlobalConfiguration().getValue('api_base_url')}chat/add';
  final client = new http.Client();
  try{
    final response = await client.post(
      url,
      headers: {HttpHeaders.contentTypeHeader: 'application/json','x-access-token':currentuser.value.access_token},
      body: json.encode(body),
    );
    print(response.body);
    if(response.statusCode==201) {
      return ChatModel.fromJson(jsonDecode(response.body)['data']);
    }
    else{
      return null;
    }
  }on TimeoutException catch (e) {
    return  null;
    print(' Timeout Error: $e');
  } on SocketException catch (e) {
    return  null;
    print(' Socket Error: $e');
  } on Error catch (e) {
    print(' General Error: $e');
    return  null;
  }
}
Future<Stream<ChatModel>> getchats(int id) async {
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}chats/${id}';
  print(url);
  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url,),),);

  return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) => Helper.getData(data)).expand((data) => (data as List)).map((data) {
    ChatModel chatModel= ChatModel.fromJson(data);
    return chatModel;
  });
}


Future<Stream<ChatModel>> getallchats() async {
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}allchats/${currentuser.value.id}';
  print(url);
  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url,),),);

  return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) => Helper.getData(data)).expand((data) => (data as List)).map((data) {
    ChatModel chatModel= ChatModel.fromMap(data);
    return chatModel;
  });
}
