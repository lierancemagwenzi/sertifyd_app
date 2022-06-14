import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:global_configuration/global_configuration.dart';
import 'package:horizon/src/controllers/sertifyer_controller.dart';
import 'package:horizon/src/helper/Helper.dart';
import 'package:horizon/src/model/Earning.dart';
import 'package:horizon/src/model/SertifyerTerm.dart';
import 'package:horizon/src/model/UserModel.dart';
import 'package:horizon/src/repositories/user_repository.dart';
import 'package:http/http.dart' as http;


Future<String> getForm(var body) async {
  print("#adding new order");
  final String url = '${GlobalConfiguration().getValue('api_base_url')}payment/form';
  final client = new http.Client();
  try{
    final response = await client.post(
      url,
      headers: {HttpHeaders.contentTypeHeader: 'application/json','x-access-token':currentuser.value.access_token},
      body: json.encode(body),
    );
    print(response.body);
    if(response.statusCode==201) {
      return jsonDecode(response.body)['data'];
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


Future<List<EarningModel>> getEarnings(var body) async {
  print("#adding new order");
  final String url = '${GlobalConfiguration().getValue('api_base_url')}account/earnings';
  final client = new http.Client();
  try{
    final response = await client.post(
      url,
      headers: {HttpHeaders.contentTypeHeader: 'application/json','x-access-token':currentuser.value.access_token},
      body: json.encode(body),
    );
    print(response.body);
    if(response.statusCode==201) {
      List<EarningModel> earnings=[];
      List<dynamic> list = json.decode(response.body)['data'];
      for(int i=0;i<list.length;i++){
        EarningModel earningModel=EarningModel.fromJson(list[i]);

        earnings.add(earningModel);

      }

      return earnings;
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