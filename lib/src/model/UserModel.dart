import 'package:global_configuration/global_configuration.dart';
import 'package:horizon/src/model/Application.dart';
import 'package:horizon/src/model/CountryModel.dart';
import 'package:horizon/src/model/Document.dart';
import 'package:horizon/src/model/RoleModel.dart';
import 'package:horizon/src/model/SignatureModel.dart';

class UserModel{
  int id;
  String firstname;
  String lastname;
  String password;
  String mobile;
  String profile_pic;
  CountryModel country;
  String address;
  String sign_in_method;
  String access_token;
  int code;
  int statusCode;
bool isverified;

bool receive_job_notifications;
int signature_id;
SignatureModel signature;
int idcard_decument_id;

int residence_proof_decument_id;
int country_id;


  DocumentModel proof_of_residence;
  DocumentModel national_id;
  RoleModel role;
  int role_id;
  SertifyerApplicationModel sertifyerApplication;
  int application_id;
  String title;
  UserModel({this.id,this.title,this.receive_job_notifications,this.country_id,this.signature,this.signature_id,this.application_id,this.sertifyerApplication,this.password,this.role,this.role_id, this.firstname,this.mobile,this.profile_pic,this.sign_in_method,this.lastname,this.code,this.statusCode,this.access_token,this.isverified,this.country,this.address,this.national_id,this.proof_of_residence,this.residence_proof_decument_id,this.idcard_decument_id});
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["id"],
      mobile: json['mobile'],
      firstname: json['firstname'],
      lastname: json['lastname'],
      statusCode: json['statuscode'],
      isverified: json['is_account_verified'],
      receive_job_notifications: json['receive_job_notifications'],
      code: json['otp'],
      signature_id: json['signature_id'],
      signature:  json['signature'] != null ? SignatureModel.fromJson(json['signature']) : null,
      application_id: json['application_id'],
      sertifyerApplication:  json['application'] != null ? SertifyerApplicationModel.fromJson(json['application']) : null,
      country_id: json['country_id'],
      residence_proof_decument_id: json['residence_proof_document_id'],
      idcard_decument_id: json['idcard_document_id'],
      role_id: json['role_id'],
      role:  json['role'] != null ? RoleModel.fromJson(json['role']) : null,
      proof_of_residence:  json['proof_of_residence'] != null ? DocumentModel.fromJson(json['proof_of_residence']) : null,
      national_id:  json['national_id'] != null ? DocumentModel.fromJson(json['national_id']) : null,
      country: json['country'] != null ? CountryModel.fromJson(json['country']) : null,
      address: json['address'],
      access_token: json['access_token'],

      title: json['title'],

      profile_pic: json['profile_pic'],
      sign_in_method: json['sign_in_method'],
    );
  }

  String getFullname(){
    return firstname+" "+lastname;
  }
  String getProfilePic(){
    return '${GlobalConfiguration().getValue('base_url')}${profile_pic}';
  }


  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map['firstname'] = firstname;
    map['lastname'] = lastname;
    map['mobile'] = mobile;
    map['password'] = password;
    map['country_id'] = country_id;
    map['address'] = address;
    map['title'] = title;
    return map;
  }

  Map<String, dynamic> toOtp() {
    var map = new Map<String, dynamic>();
    map['mobile'] = mobile;
    map['otp'] = code;
    return map;
  }


  Map<String, dynamic> toCheck() {
    var map = new Map<String, dynamic>();
    map['mobile'] = mobile;
    return map;
  }

  Map<String, dynamic> toLogin() {
    var map = new Map<String, dynamic>();
    map['mobile'] = mobile;
    map['password'] = password;
    return map;
  }


  Map<String, dynamic> toNotification() {
    var map = new Map<String, dynamic>();
    map['receive_job_notifications'] = receive_job_notifications;
    return map;
  }

}