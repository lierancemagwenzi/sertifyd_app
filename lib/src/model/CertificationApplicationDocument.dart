import 'package:global_configuration/global_configuration.dart';
import 'package:horizon/src/model/DocumentType.dart';

class CertificationApplicationDocument{
  int id;
  String path;
String download_path;
  bool certified;

  String status;
String price;
  String rejection_reason;

  DocumentTypeModel documentTypeModel;
  CertificationApplicationDocument({this.id,this.path,this.documentTypeModel,this.certified,this.status,this.download_path,this.rejection_reason,this.price});
  factory CertificationApplicationDocument.fromJson(Map<String, dynamic> json) {
    return CertificationApplicationDocument(
      id: json["id"],
      path: json['path'],

      price: json['price'],

      download_path: json['download_path'],
      status: json['status'],
      rejection_reason: json['rejection_reason'],
      certified: false,
      documentTypeModel :  json['document_type'] != null ? DocumentTypeModel.fromJson(json['document_type']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map['path'] = path;
    return map;
  }
  Map<String, dynamic> toCertify() {
    var map = new Map<String, dynamic>();
    map['id'] = id;
    return map;
  }

  String getDocumentPath(){
    return '${GlobalConfiguration().getValue('base_url')}${path}';
  }

num getPrice(){


    if(price==null){

      return 0;
    }

    return num.tryParse(price)??0;
}

  String getDownloadPath(){
    return '${GlobalConfiguration().getValue('base_url')}${download_path}';
  }

}