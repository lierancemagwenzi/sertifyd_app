class PaymentField{
  int id;
  String name;
int payment_method_id;
String value;

  PaymentField({this.id,this.name,this.payment_method_id,this.value});
  factory PaymentField.fromJson(Map<String, dynamic> json) {
    return PaymentField(
      id: json["id"],
      name: json['name'],
      payment_method_id: json['payment_method_id'],
    );
  }

  Map<String, dynamic> toOtp() {
    var map = new Map<String, dynamic>();
    map['name'] = name;
    map['value'] = value;
    return map;
  }



}