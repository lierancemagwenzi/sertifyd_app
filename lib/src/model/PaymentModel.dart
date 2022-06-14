import 'package:horizon/src/model/Document.dart';

class PaymentModel{
  int id;
  String gross;
  String status;
  int model_id;



  PaymentModel({this.id,this.gross,this.status,this.model_id});
  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json["id"],
      gross: json['gross'],
      status: json['status'],
      model_id: json['model_id'],
    );
  }

}