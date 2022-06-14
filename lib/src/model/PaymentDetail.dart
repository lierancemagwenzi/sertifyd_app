import 'package:horizon/src/model/PaymentMethod.dart';

class PaymentDetail{
  int id;
  int user_id;
  int payment_method_id;
  String value;

  Map fields;

  bool is_default;

  bool make_default;

  PaymentMethod paymentMethod;



  PaymentDetail({this.id,this.fields,this.payment_method_id,this.value,this.user_id,this.paymentMethod,this.is_default,this.make_default});

  factory PaymentDetail.fromJson(Map<String, dynamic> json) {
    return PaymentDetail(
      id: json["id"],
      user_id: json['user_id'],
      fields: json['values'] ,
      value: json['value'],
      is_default: json['is_default'],
      make_default: json['is_default'],
      paymentMethod: json['payment_method']!=null?PaymentMethod.fromJson(json['payment_method']):null,
      payment_method_id: json['payment_method_id'],

    );
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map['values'] = fields;
    map['user_id'] = user_id;
    map['payment_method_id'] = payment_method_id;
    map['is_default'] = make_default;

    return map;
  }



}