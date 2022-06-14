import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:horizon/src/controllers/sertifyer_controller.dart';
import 'package:horizon/src/helper/Helper.dart';
import 'package:horizon/src/model/ApplicationModel.dart';
import 'package:horizon/src/model/DocumentType.dart';
import 'package:horizon/src/model/SertificationDocument.dart';
import 'package:horizon/src/model/SertifyerTerm.dart';
import 'package:horizon/src/model/UserModel.dart';
import 'package:horizon/src/repositories/user_repository.dart';
import 'package:http/http.dart' as http;

ValueNotifier<List<SertificationDocumentModel>> docs =ValueNotifier([]);

Future<Stream<DocumentTypeModel>> getDocTypes() async {
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}application/doc_types';
  print(url);
  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

  return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) => Helper.getData(data)).expand((data) => (data as List)).map((data) {
    DocumentTypeModel documentTypeModel= DocumentTypeModel.fromJson(data);
    return documentTypeModel;
  });
}





Future<Stream<String>> getAllchats() async {
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}client/chat/${currentuser.value.id}';
  print(url);
  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url,),),);

  return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) => Helper.getData(data)).expand((data) => (data as List)).map((data) {
    String  id= data;
    return id;
  });
}



Future<Stream<CertificationApplicationModel>> getUserApplications() async {
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}application/applications/${currentuser.value.id}';
  print(url);
  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url,),),);

  return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) => Helper.getData(data)).expand((data) => (data as List)).map((data) {
    CertificationApplicationModel applicationModel= CertificationApplicationModel.fromJson(data);
    return applicationModel;
  });
}


Future<Stream<CertificationApplicationModel>> getRecentUserApplications() async {
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}application/recentapplications/${currentuser.value.id}';
  print(url);
  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url,),),);

  return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) => Helper.getData(data)).expand((data) => (data as List)).map((data) {
    CertificationApplicationModel applicationModel= CertificationApplicationModel.fromJson(data);
    return applicationModel;
  });
}



Future<Stream<CertificationApplicationModel>> getCompletedUserApplications() async {
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}application/completedapplications/${currentuser.value.id}';
  print(url);
  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url,),),);

  return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) => Helper.getData(data)).expand((data) => (data as List)).map((data) {
    CertificationApplicationModel applicationModel= CertificationApplicationModel.fromJson(data);
    print(applicationModel.toString());
    print("completed");
    return applicationModel;
  });
}



Future<Stream<CertificationApplicationModel>> getApplication(int id) async {
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}application/application/${id}';
  print(url);
  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));
  return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) => Helper.getData(data)).map((data) {

    CertificationApplicationModel applicationModel = CertificationApplicationModel.fromJson(data);

    return applicationModel;
  });
}


Future<Stream<CertificationApplicationModel>> getApplicationjob(int id) async {
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}application/applicationjob/${id}/${currentuser.value.id}';
  print(url);
  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));
  return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) => Helper.getData(data)).map((data) {

    CertificationApplicationModel applicationModel = CertificationApplicationModel.fromJson(data);

    return applicationModel;
  });
}



Future<CertificationApplicationModel> cancelapplication(var body) async {
  print("#adding new meeting");
  final String url = '${GlobalConfiguration().getValue('api_base_url')}application/cancel';
  final client = new http.Client();
  try{
    final response = await client.post(
      url,
      headers: {HttpHeaders.contentTypeHeader: 'application/json','x-access-token':currentuser.value.access_token},
      body: json.encode(body),
    );
    print(response.body);
    if(response.statusCode==201) {
      return CertificationApplicationModel.fromJson(jsonDecode(response.body)['data']);
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



Future<CertificationApplicationModel> rescheduleapplication(var body) async {
  print("#adding new meeting");
  final String url = '${GlobalConfiguration().getValue('api_base_url')}application/reschedule';
  final client = new http.Client();
  try{
    final response = await client.post(
      url,
      headers: {HttpHeaders.contentTypeHeader: 'application/json','x-access-token':currentuser.value.access_token},
      body: json.encode(body),
    );
    print(response.body);
    if(response.statusCode==201) {
      return CertificationApplicationModel.fromJson(jsonDecode(response.body)['data']);
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