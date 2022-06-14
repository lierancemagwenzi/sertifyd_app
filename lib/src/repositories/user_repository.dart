import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:horizon/src/helper/Helper.dart';
import 'package:horizon/src/model/ApplicationModel.dart';
import 'package:horizon/src/model/FaqModel.dart';
import 'package:horizon/src/model/UserModel.dart';

import 'package:http/http.dart' as http;
import 'package:retry/retry.dart';
import 'package:shared_preferences/shared_preferences.dart';


ValueNotifier<UserModel> currentuser = new ValueNotifier(new UserModel(id: 0,firstname: "",lastname: "",profile_pic: "",mobile: "",));



Future<void> RegisterToken({String token,int id,String identifier,String deviceName,String deviceVersion }) async {
  final String url = '${GlobalConfiguration().getValue('api_base_url')}register_token';

  try {
    final r = RetryOptions(maxAttempts: 8);
    final response = await r.retry(
      // Make a GET request
          () => http.post(url,
          body: jsonEncode({
            "token": token,
            "user_id": currentuser.value.id,
            "device_id": identifier,
            "is_logged_in": 1,
          }),
          headers: {
            'Content-type': 'application/json'
          }).timeout(Duration(seconds: 5)),
      retryIf: (e) => e is SocketException || e is TimeoutException,
    );
    if (response.statusCode == 201) {
    } else {}
  } on TimeoutException catch (e) {
    print(' Timeout Error: $e');
  } on SocketException catch (e) {
    print(' Socket Error: $e');
  } on Error catch (e) {
    print(' General Error: $e');
  }

}


Future<Stream<FaqModel>> getFaqs(String endpoint) async {
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}faqs/${endpoint}';
  print(url);
  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

  return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) => Helper.getData(data)).expand((data) => (data as List)).map((data) {
    FaqModel faqModel= FaqModel.fromJson(data);
    return faqModel;
  });
}


Future<CertificationApplicationModel> verifydocument(var body) async {
  print("#testing document");
  final String url = '${GlobalConfiguration().getValue('api_base_url')}document/validate';
  final client = new http.Client();
  try{
    final response = await client.post(
      url,
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      body: json.encode(body),
    );
    print(response.body);

    if(jsonDecode(response.body)['data']!=null&&response.statusCode==201){
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


