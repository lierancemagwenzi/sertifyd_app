import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:horizon/src/helper/Helper.dart';
import 'package:horizon/src/model/CountryModel.dart';
import 'package:horizon/src/model/LoginResponse.dart';
import 'package:horizon/src/model/TermModel.dart';
import 'package:horizon/src/model/UserModel.dart';
import 'package:horizon/src/repositories/settings_repository.dart';
import 'package:horizon/src/repositories/user_repository.dart';

import 'package:retry/retry.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


Future<LoginResponseModel> registerUser(UserModel userModel1) async {
  print("#register user");
  final String url = '${GlobalConfiguration().getValue('api_base_url')}signup';
  final client = new http.Client();
  try{
    final response = await client.post(
      url,
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      body: json.encode(userModel1.toMap()),
    ).timeout(Duration(seconds: 6));

    print(response.body);
    if(response.statusCode==201) {
      UserModel userModel=UserModel.fromJson(json.decode(response.body)['data']);
      userModel.statusCode=response.statusCode;
      return LoginResponseModel(userModel: userModel);
    }
    else{
      return  LoginResponseModel(userModel: null,message: "Account using this mobile number already exists");
    }
  }on TimeoutException catch (e) {

    print(e.message);
    return  new LoginResponseModel(message: "Network timout error",userModel: null);
    print(' Timeout Error: $e');
  } on SocketException catch (e) {
    return  new LoginResponseModel(message: "Check your network connection",userModel: null);
    print(' Socket Error: $e');
  } on Error catch (e) {
    print("error");
    print(e.stackTrace);
    return  null;
    print(' General Error: $e');
  }

}



Future<int> logoutuser() async {
  print("#register user");
  final String url = '${GlobalConfiguration().getValue('api_base_url')}logout';
  final client = new http.Client();
  try{
    final response = await client.post(
      url,
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      body: json.encode({
        "user_id":currentuser.value.id,
        "device_id":detailsModel.value.identifier
      }),
    ).timeout(Duration(seconds: 5));

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
    return  null;
    print(' General Error: $e');
  }

}


Future<LoginResponseModel> confirmOtpCode(UserModel userModel1) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  print("#confirm user");
  final String url = '${GlobalConfiguration().getValue('api_base_url')}confirmotp';
  final client = new http.Client();
  try{
    final response = await client.post(
      url,
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      body: json.encode(userModel1.toOtp()),
    ).timeout(Duration(seconds: 5));

    print(response.body);
    if(response.statusCode==201) {
      await prefs.setString('user_details',response.body);
      UserModel userModel=UserModel.fromJson(json.decode(response.body)['data']);
      return LoginResponseModel(userModel: userModel,message: null);
    }
    else{
      return LoginResponseModel(message:"Wrong OTP Code.try again",userModel: null);
    }
  }on TimeoutException catch (e) {

    print(e.message);
    return  new LoginResponseModel(message: "Network timout error",userModel: null);
    print(' Timeout Error: $e');
  } on SocketException catch (e) {
    return  new LoginResponseModel(message: "Check your network connection",userModel: null);
    print(' Socket Error: $e');
  } on Error catch (e) {
    print("error");
    print(e.stackTrace);
    return  null;
    print(' General Error: $e');
  }

}



Future<LoginResponseModel> LoginappUser(UserModel userModel1) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  print("#confirm user");
  final String url = '${GlobalConfiguration().getValue('api_base_url')}login';
  final client = new http.Client();
  try{
    final response = await client.post(
      url,
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      body: json.encode(userModel1.toLogin()),
    ).timeout(Duration(seconds: 5));

    print("login");
    print(response.body);
    if(response.statusCode==201||response.statusCode==401) {




      UserModel userModel=UserModel.fromJson(json.decode(response.body)['data']);

      print(userModel.isverified);

      if(response.statusCode==201&&userModel.isverified==true){
        await prefs.setString('user_details',response.body);
      }

      // print(userModel.toMap());
      // userModel.statusCode=response.statusCode;
      return new LoginResponseModel(userModel: userModel);
    }
    else{
      return new LoginResponseModel(message: "Wrong account details",userModel: null);
    }
  }on TimeoutException catch (e) {

    print(e.message);
    return  new LoginResponseModel(message: "Network timout error",userModel: null);
    print(' Timeout Error: $e');
  } on SocketException catch (e) {
    return  new LoginResponseModel(message: "Check your network connection",userModel: null);
    print(' Socket Error: $e');
  } on Error catch (e) {
    print("error");
    print(e.stackTrace);
    return  null;
    print(' General Error: $e');
  }

}



Future<LoginResponseModel> BioLoginuser(String token) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  print("#confirm user");
  final String url = '${GlobalConfiguration().getValue('api_base_url')}biometriclogin';
  final client = new http.Client();
  try{
    final response = await client.post(
      url,
      headers: {HttpHeaders.contentTypeHeader: 'application/json','x-access-token':token},
    );
    print(response.body);
    if(response.statusCode==201) {
      await prefs.setString('user_details',response.body);

      UserModel userModel=UserModel.fromJson(json.decode(response.body)['data']);
      return new LoginResponseModel(userModel: userModel);
    }
    else{
      return new LoginResponseModel(message: "Token expired.Please use password",userModel: null);
    }
  }on TimeoutException catch (e) {

    print(e.message);
    return  null;
    print(' Timeout Error: $e');
  } on SocketException catch (e) {
    return  null;
    print(' Socket Error: $e');
  } on Error catch (e) {
    print("error");
    print(e.stackTrace);
    return  null;
    print(' General Error: $e');
  }

}

Future<int> SendOtp(Map body) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  print("#confirm user");
  final String url = '${GlobalConfiguration().getValue('api_base_url')}resendotp';
  final client = new http.Client();
  try{
    final response = await client.post(
      url,
      headers: {HttpHeaders.contentTypeHeader: 'application/json','x-access-token':''},
      body: json.encode(body)
    );
    print(response.body);
    if(response.statusCode==201) {
     return 1;
    }
    else{
      return null;
    }
  }on TimeoutException catch (e) {

    print(e.message);
    return  null;
    print(' Timeout Error: $e');
  } on SocketException catch (e) {
    return  null;
    print(' Socket Error: $e');
  } on Error catch (e) {
    print("error");
    print(e.stackTrace);
    return  null;
    print(' General Error: $e');
  }

}
Future<LoginResponseModel> RefreshUser(String token,Map condition) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  print("#confirm user");
  final String url = '${GlobalConfiguration().getValue('api_base_url')}biometriclogin';
  final client = new http.Client();
  try{

    final response = await client.post(
      url,
      headers: {HttpHeaders.contentTypeHeader: 'application/json','x-access-token':token},
      body: json.encode(condition),
    );
    print(response.body);
    if(response.statusCode==201) {
      await prefs.setString('user_details',response.body);
      UserModel userModel=UserModel.fromJson(json.decode(response.body)['data']);
      currentuser.value=userModel;

      return new LoginResponseModel(userModel: userModel);
    }
    else{
      return new LoginResponseModel(userModel: null);
    }
  }on TimeoutException catch (e) {

    print(e.message);
    return  null;
    print(' Timeout Error: $e');
  } on SocketException catch (e) {
    return  null;
    print(' Socket Error: $e');
  } on Error catch (e) {
    print("error");
    print(e.stackTrace);
    return  null;
    print(' General Error: $e');
  }

}


Future<LoginResponseModel> checkaccount(UserModel userModel1) async {

  print("#confirm user");
  final String url = '${GlobalConfiguration().getValue('api_base_url')}checkaccount';
  final client = new http.Client();
  try{
    final response = await client.post(
      url,
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      body: json.encode(userModel1.toCheck()),
    ).timeout(Duration(seconds: 5));

    print(response.body);
    if(response.statusCode==201) {


      UserModel userModel=UserModel.fromJson(json.decode(response.body)['data']);
      return LoginResponseModel(userModel:userModel);
    }
    else{
      return LoginResponseModel(message: "Account does not exist",userModel: null);
    }
  }on TimeoutException catch (e) {

    print(e.message);
    return  new LoginResponseModel(message: "Network timout error",userModel: null);
    print(' Timeout Error: $e');
  } on SocketException catch (e) {
    return  new LoginResponseModel(message: "Check your network connection",userModel: null);
    print(' Socket Error: $e');
  } on Error catch (e) {
    print("error");
    print(e.stackTrace);
    return  null;
    print(' General Error: $e');
  }
}



Future<LoginResponseModel> newpassword(UserModel userModel1) async {
  print("#confirm user");
  final String url = '${GlobalConfiguration().getValue('api_base_url')}changepassword';
  final client = new http.Client();
  try{
    final response = await client.post(
      url,
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      body: json.encode(userModel1.toLogin()),
    ).timeout(Duration(seconds: 5));

    print(response.body);
    if(response.statusCode==201) {
      UserModel userModel=UserModel.fromJson(json.decode(response.body)['data']);
      return LoginResponseModel(userModel:userModel);
    }
    else{
      return LoginResponseModel(message: "Failed to change password",userModel: null);
    }
  }on TimeoutException catch (e) {

    print(e.message);
    return  new LoginResponseModel(message: "Network timout error",userModel: null);
    print(' Timeout Error: $e');
  } on SocketException catch (e) {
    return  new LoginResponseModel(message: "Check your network connection",userModel: null);
    print(' Socket Error: $e');
  } on Error catch (e) {
    print("error");
    print(e.stackTrace);
    return  null;
    print(' General Error: $e');
  }

}

Future<int> updatenotificationsettings(Map data) async {

  print("#confirm user");
  final String url = '${GlobalConfiguration().getValue('api_base_url')}updatenotificationsetting';
  final client = new http.Client();
  try{
    final response = await client.post(
      url,
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      body: json.encode(data),
    ).timeout(Duration(seconds: 5));

    print(response.body);
    if(response.statusCode==201) {

      return 1;
    }
    else{
      return null;
    }
  }on TimeoutException catch (e) {

    print(e.message);
    return  null;
    print(' Timeout Error: $e');
  } on SocketException catch (e) {
    return  null;
    print(' Socket Error: $e');
  } on Error catch (e) {
    print("error");
    print(e.stackTrace);
    return  null;
    print(' General Error: $e');
  }
}



Future<Stream<CountryModel>> getCountries() async {
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}countries/all';
  print(url);
  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url,),),);

  return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) => Helper.getData(data)).expand((data) => (data as List)).map((data) {
    CountryModel countryModel= CountryModel.fromJson(data);
    return countryModel;
  });
}
Future<Stream<TermModel>> getterms() async {
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}terms/all';
  print(url);
  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url,),),);

  return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) => Helper.getData(data)).expand((data) => (data as List)).map((data) {
    TermModel termModel= TermModel.fromJson(data);
    return termModel;
  });
}