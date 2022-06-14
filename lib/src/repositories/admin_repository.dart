import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:horizon/src/controllers/sertifyer_controller.dart';
import 'package:horizon/src/helper/Helper.dart';
import 'package:horizon/src/model/ApplicationModel.dart';
import 'package:horizon/src/model/BankModel.dart';
import 'package:horizon/src/model/CertificationApplicationDocument.dart';
import 'package:horizon/src/model/DocumentType.dart';
import 'package:horizon/src/model/EarningsStat.dart';
import 'package:horizon/src/model/PaymentDetail.dart';
import 'package:horizon/src/model/PaymentMethod.dart';
import 'package:horizon/src/model/PaymentModel.dart';
import 'package:horizon/src/model/SertificationDocument.dart';
import 'package:horizon/src/model/SertifyerTerm.dart';
import 'package:horizon/src/model/UserModel.dart';
import 'package:horizon/src/model/ZoomMettingModel.dart';
import 'package:horizon/src/repositories/user_repository.dart';
import 'package:http/http.dart' as http;

ValueNotifier<List<SertificationDocumentModel>> docs =ValueNotifier([]);



Future<Stream<BankModel>> getBanks() async {
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}banks/all/${currentuser.value.country_id}';
  print(url);
  var client = new http.Client();
  var streamedRest = await client.send(http.Request('get', Uri.parse(url,),),);

  return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) => Helper.getData(data)).expand((data) => (data as List)).map((data) {
    BankModel bankModel= BankModel.fromJson(data);
    return bankModel;
  });
}


Future<Stream<CertificationApplicationModel>> getPendingApplications() async {
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}applications/pending/${currentuser.value.id}';
  print(url);
  var client = new http.Client();
  var streamedRest = await client.send(http.Request('get', Uri.parse(url,),),);

  return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) => Helper.getData(data)).expand((data) => (data as List)).map((data) {
    CertificationApplicationModel applicationModel= CertificationApplicationModel.fromJson(data);
    return applicationModel;
  });
}

Future<Stream<CertificationApplicationModel>> getScheduledApplications() async {
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}admin/applications/scheduled/${currentuser.value.id}';
  print(url);
  final client = new http.Client();

  final streamedRest = await client.send(http.Request('get', Uri.parse(url,),),);
  streamedRest.headers.clear();
  streamedRest.headers.addAll({HttpHeaders.contentTypeHeader: 'application/json','x-access-token':currentuser.value.access_token});


  return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) => Helper.getData(data)).expand((data) => (data as List)).map((data) {
    CertificationApplicationModel applicationModel= CertificationApplicationModel.fromJson(data);
    return applicationModel;
  });
}


Future<Stream<String>> getAllchats() async {
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}admin/chat/${currentuser.value.id}';
  print(url);
  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url,),),);

  return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) => Helper.getData(data)).expand((data) => (data as List)).map((data) {
    String  id= data;
    return id;
  });
}


Future<Stream<CertificationApplicationModel>> getUpcomingjobs() async {
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}admin/applications/upcoming/${currentuser.value.id}';
  print(url);
  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url,),),);

  return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) => Helper.getData(data)).expand((data) => (data as List)).map((data) {
    CertificationApplicationModel applicationModel= CertificationApplicationModel.fromJson(data);
    return applicationModel;
  });
}



Future<Stream<CertificationApplicationModel>> getdayschedule(String date,String start_time,String end_time) async {
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}admin/applications/dayschedule/${currentuser.value.id}/${date}/${start_time}/${end_time}';
  print(url);
  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url,),),);

  return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) => Helper.getData(data)).expand((data) => (data as List)).map((data) {
    CertificationApplicationModel applicationModel= CertificationApplicationModel.fromJson(data);
    return applicationModel;
  });
}



Future<Stream<PaymentDetail>> getPaymentDetails() async {
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}admin/payments/details/${currentuser.value.id}';
  print(url);
  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url,),),);

  return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) => Helper.getData(data)).expand((data) => (data as List)).map((data) {
    PaymentDetail paymentDetail= PaymentDetail.fromJson(data);
    return paymentDetail;
  });
}



Future<Stream<CertificationApplicationModel>> getUserApplication(int id) async {
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



Future<ZoomMeetingModel> createmeeting(var body) async {
  print("#adding new meeting");
  final String url = '${GlobalConfiguration().getValue('api_base_url')}meeting/create';
  final client = new http.Client();
  try{
    final response = await client.post(
      url,
      headers: {HttpHeaders.contentTypeHeader: 'application/json','x-access-token':currentuser.value.access_token},
      body: json.encode(body),
    );
    print(response.body);
    if(response.statusCode==201) {
      return ZoomMeetingModel.fromJson(jsonDecode(response.body)['data']);
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



Future<CertificationApplicationModel> updateapplication(var body) async {
  print("#adding new meeting");
  final String url = '${GlobalConfiguration().getValue('api_base_url')}application/update';
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

Future<CertificationApplicationModel> sertifyDocs(var body) async {
  print("#adding new meeting");
  final String url = '${GlobalConfiguration().getValue('api_base_url')}application/certify';
  final client = new http.Client();
  try{
    final response = await client.post(
      url,
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
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


Future<CertificationApplicationModel> markascomplete(var body) async {
  print("#adding new meeting");
  final String url = '${GlobalConfiguration().getValue('api_base_url')}application/markascomplete';
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





Future<CertificationApplicationModel> acceptjob(var body) async {
  print("#adding new meeting");
  final String url = '${GlobalConfiguration().getValue('api_base_url')}job/accept';
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




Future<CertificationApplicationDocument> sertifyDoc(var body) async {
  print("#adding new meeting");
  final String url = '${GlobalConfiguration().getValue('api_base_url')}application/certifydoc';
  final client = new http.Client();
  try{
    final response = await client.post(
      url,
      headers: {HttpHeaders.contentTypeHeader: 'application/json','x-access-token':currentuser.value.access_token},
      body: json.encode(body),
    );
    print(response.body);
    if(response.statusCode==201) {
      return CertificationApplicationDocument.fromJson(jsonDecode(response.body)['data']);
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


Future<CertificationApplicationDocument> rejectDoc(var body) async {
  print("#adding new meeting");
  final String url = '${GlobalConfiguration().getValue('api_base_url')}application/rejectdoc';
  final client = new http.Client();
  try{
    final response = await client.post(
      url,
      headers: {HttpHeaders.contentTypeHeader: 'application/json','x-access-token':currentuser.value.access_token},
      body: json.encode(body),
    );
    print(response.body);
    if(response.statusCode==201) {
      return CertificationApplicationDocument.fromJson(jsonDecode(response.body)['data']);
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


Future<UserModel> UploadSignature(var body) async {
  print("#adding new meeting");
  final String url = '${GlobalConfiguration().getValue('api_base_url')}signature/add';
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



Future<PaymentDetail> SavePaymentData(var body) async {
  print("#adding new payment data");
  final String url = '${GlobalConfiguration().getValue('api_base_url')}paymentdata/store';
  final client = new http.Client();
  try{
    final response = await client.post(
      url,
      headers: {HttpHeaders.contentTypeHeader: 'application/json','x-access-token':currentuser.value.access_token},
      body: json.encode(body),
    );
    print(response.body);
    if(response.statusCode==201) {
      PaymentDetail paymentDetail= PaymentDetail.fromJson(jsonDecode(response.body)['data']);
      print(paymentDetail.toMap());

      return PaymentDetail.fromJson(jsonDecode(response.body)['data']);
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


Future<PaymentDetail> updatePaymentData(var body) async {
  print("#adding new payment data");
  final String url = '${GlobalConfiguration().getValue('api_base_url')}paymentdata/update';
  final client = new http.Client();
  try{
    final response = await client.post(
      url,
      headers: {HttpHeaders.contentTypeHeader: 'application/json','x-access-token':currentuser.value.access_token},
      body: json.encode(body),
    );
    print(response.body);
    if(response.statusCode==201) {
      return PaymentDetail.fromJson(jsonDecode(response.body)['data']);
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




Future<Stream<PaymentMethod>> getPaymentMethods() async {
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}payment/methods';
  print(url);
  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url,),),);

  return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) => Helper.getData(data)).expand((data) => (data as List)).map((data) {
    PaymentMethod paymentMethod= PaymentMethod.fromJson(data);
    return paymentMethod;
  });
}



Future<Stream<EarningsStat>> getmonths() async {
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}admin/earnings/months/${currentuser.value.id}';
  print(url);
  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url,),),);

  return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) => Helper.getData(data)).expand((data) => (data as List)).map((data) {
    EarningsStat earningsStat= EarningsStat.fromJson(data);
    return earningsStat;
  });
}



Future<Stream<CertificationApplicationModel>> getapplicationsbygroup(int year,int month) async {
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}admin/earnings/group/${currentuser.value.id}/${year}/${month}';
  print(url);
  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url,),),);

  return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) => Helper.getData(data)).expand((data) => (data as List)).map((data) {
    CertificationApplicationModel applicationModel= CertificationApplicationModel.fromJson(data);
    return applicationModel;
  });
}