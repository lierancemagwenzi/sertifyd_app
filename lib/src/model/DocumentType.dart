import 'package:horizon/src/model/CountryModel.dart';

class DocumentTypeModel{
  int id;
  String type;
  String short_name;

  String price;

  CountryModel country;

  int country_id;

  DocumentTypeModel({this.id,this.type,this.short_name,this.country_id,this.price,this.country});
  factory DocumentTypeModel.fromJson(Map<String, dynamic> json) {
    return DocumentTypeModel(
      id: json["id"],
      type: json['type'],
      short_name: json['short_name'],
      country_id: json['country_id'],
      price: json['price'],
      country: json['country'] != null ? CountryModel.fromJson(json['country']) : null,

    );
  }
  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    // map["type"] = type;
    map["id"] = id;
    map["file_name"] = short_name;
    map["price"] = price;

    return map;
  }
}