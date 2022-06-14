class DocumentModel{
  int id;
  String path;
  DocumentModel({this.id,this.path});
  factory DocumentModel.fromJson(Map<String, dynamic> json) {
    return DocumentModel(
      id: json["id"],
      path: json['path'],
    );
  }


  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map['path'] = path;
    return map;
  }

}