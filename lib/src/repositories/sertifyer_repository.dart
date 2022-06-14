import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:global_configuration/global_configuration.dart';
import 'package:horizon/src/controllers/sertifyer_controller.dart';
import 'package:horizon/src/helper/Helper.dart';
import 'package:horizon/src/model/SertifyerTerm.dart';
import 'package:horizon/src/model/UserModel.dart';
import 'package:horizon/src/repositories/user_repository.dart';
import 'package:http/http.dart' as http;



Future<Stream<SetifyerTermModel>> getTerms() async {
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}sertifyer/terms';
  print(url);
  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

  return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) => Helper.getData(data)).expand((data) => (data as List)).map((data) {
    SetifyerTermModel setifyerTermModel= SetifyerTermModel.fromJson(data);
    return setifyerTermModel;
  });
}



Future<UserModel> apply(var body) async {
  print("#adding new order");
  final String url = '${GlobalConfiguration().getValue('api_base_url')}sertifyer/apply';
  final client = new http.Client();
  try{
    final response = await client.post(
      url,
      headers: {HttpHeaders.contentTypeHeader: 'application/json','x-access-token':currentuser.value.access_token},
      body: json.encode(body),
    );
    print(response.body);
    if(response.statusCode==201) {
      return UserModel.fromJson(jsonDecode(response.body)['data']);
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