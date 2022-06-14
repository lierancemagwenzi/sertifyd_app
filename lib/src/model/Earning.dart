import 'package:global_configuration/global_configuration.dart';
import 'package:horizon/src/model/Document.dart';
import 'package:horizon/src/model/PaymentDetail.dart';
import 'package:intl/intl.dart';

class EarningModel{
  int id;
  String amount;
  String status;
  int user_id;
  String reference;
  PaymentDetail paymentDetail;
  int payment_detail_id;
  String date;
  String description;
  String proof_of_payment;

  EarningModel({this.id,this.amount,this.status,this.user_id,this.paymentDetail,this.reference,this.payment_detail_id,this.date,this.description,this.proof_of_payment});
  factory EarningModel.fromJson(Map<String, dynamic> json) {
    return EarningModel(
      id: json["id"],
      amount: json['amount'],
      description: json['description'],
      proof_of_payment: json['proof_of_payment'],
      date: json['createdAt'],
      status: json['status'],
      reference: json['reference'],
      paymentDetail: json['payment_detail']!=null?PaymentDetail.fromJson(json['payment_detail']):null,
      user_id: json['user_id'],
      payment_detail_id: json['payment_detail_id'],
    );
  }

  String getdate(){

    var formatter = new DateFormat("yyyy-MM-ddTHH:mm:ssZ");
    DateTime notification_date = formatter.parse(this.date);
    var date = DateFormat('yMMMMEEEEd').format(notification_date);

    return date;
  }
  String getDocumentPath(){
    return '${GlobalConfiguration().getValue('base_url')}${proof_of_payment}';
  }

}