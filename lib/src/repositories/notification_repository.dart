import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:horizon/src/controllers/sertifyer_controller.dart';
import 'package:horizon/src/helper/Helper.dart';
import 'package:horizon/src/model/ApplicationModel.dart';
import 'package:horizon/src/model/DocumentType.dart';
import 'package:horizon/src/model/NotificationModel.dart';
import 'package:horizon/src/model/SertificationDocument.dart';
import 'package:horizon/src/model/SertifyerTerm.dart';
import 'package:horizon/src/model/UserModel.dart';
import 'package:horizon/src/repositories/user_repository.dart';
import 'package:http/http.dart' as http;


Future<Stream<NotificationModel>> getnotifications() async {
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}notifications/${currentuser.value.id}';
  print(url);
  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

  return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) => Helper.getData(data)).expand((data) => (data as List)).map((data) {
    NotificationModel notificationModel= NotificationModel.fromJson(data);
    return notificationModel;
  });
}

Future<int> notifyrecipient(var body) async {
  print("#adding new payment data");
  final String url = '${GlobalConfiguration().getValue('api_base_url')}messages/notify';
  final client = new http.Client();
  try{
    final response = await client.post(
      url,
      headers: {HttpHeaders.contentTypeHeader: 'application/json','x-access-token':currentuser.value.access_token},
      body: json.encode(body),
    );
    print(response.body);
    if(response.statusCode==201) {
      return 1;
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

Future<int> deletenotification(var body) async {
  print("#adding new meeting");
  final String url = '${GlobalConfiguration().getValue('api_base_url')}notification/delete';
  final client = new http.Client();
  try{
    final response = await client.post(
      url,
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      body: json.encode(body),
    );
    print(response.body);
    if(response.statusCode==201) {
      return 1;
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



Future<NotificationModel> markasread(var condition,var fields) async {
  print("#adding new meeting");
  final String url = '${GlobalConfiguration().getValue('api_base_url')}notification/markasread';
  final client = new http.Client();
  try{
    final response = await client.post(
      url,
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      body: json.encode({"case":condition,"fields":fields}),
    );
    print(response.body);
    if(response.statusCode==201) {
      return   NotificationModel.fromJson(jsonDecode(response.body)['data']);
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