import 'package:horizon/src/model/PaymentField.dart';

class PaymentMethod{
  int id;
  String name;

  List<PaymentField> fields;
  PaymentMethod({this.id,this.name,this.fields});
  factory PaymentMethod.fromJson(Map<String, dynamic> json) {
    return PaymentMethod(
      id: json["id"],
      name: json['name'],
      fields: json['fields'] != null ? List.from(json['fields']).map((element) {
        PaymentField paymentField=PaymentField.fromJson(element);
        return paymentField;
      }).toList() : [],

    );
  }

}