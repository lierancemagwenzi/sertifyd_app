import 'package:horizon/src/model/Document.dart';

class SertifyerApplicationModel{
  int id;
  String category;
  String status;
  int document_id;
  DocumentModel document;
  String qualification;
  String auth_number;



  SertifyerApplicationModel({this.id,this.category,this.status,this.qualification,this.document,this.document_id,this.auth_number});
  factory SertifyerApplicationModel.fromJson(Map<String, dynamic> json) {
    return SertifyerApplicationModel(
      id: json["id"],
      category: json['category'],
      status: json['status'],
      qualification: json['qualification'],
      auth_number: json['auth_number'],
      document:  json['document'] != null ? DocumentModel.fromJson(json['document']) : null,
      document_id: json['document_id'],
    );
  }


}