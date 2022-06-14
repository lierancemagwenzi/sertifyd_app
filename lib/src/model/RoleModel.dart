class RoleModel{
  int id;
  String name;
  String home;
  RoleModel({this.id,this.name,this.home});
  factory RoleModel.fromJson(Map<String, dynamic> json) {
    return RoleModel(
      id: json["id"],
      name: json['name'],
      home: json['home'],
    );
  }

}