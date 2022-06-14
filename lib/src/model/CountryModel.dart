class CountryModel{
  int id;
  String currency;
  bool currency_right;
  String price;
  String name;
  String service_fee;

  CountryModel({this.id,this.price,this.currency,this.currency_right,this.name,this.service_fee});


  factory CountryModel.fromJson(Map<String, dynamic> json) {
    return CountryModel(
      id: json["id"],
      price: json['price'],
      service_fee: json['service_fee'],
      name: json['name'],
      currency: json['currency'],
      currency_right: json['currency_right'],
    );
  }


}