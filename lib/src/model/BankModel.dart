class BankModel{
  int id;
  String name;
  int country_id;

  BankModel({this.id,this.country_id,this.name});


  factory BankModel.fromJson(Map<String, dynamic> json) {
    return BankModel(
      id: json["id"],
      name: json['name'],
      country_id: json['country_id'],

    );
  }


}