class TermModel{
  int id;
  String title;
  String body;
  TermModel({this.id,this.title,this.body});
  factory TermModel.fromJson(Map<String, dynamic> json) {
    return TermModel(
      id: json["id"],
      title: json['title'],
      body: json['body'],
    );
  }

}