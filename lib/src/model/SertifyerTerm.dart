class SetifyerTermModel{
  int id;
  String title;
  String body;
  SetifyerTermModel({this.id,this.title,this.body});
  factory SetifyerTermModel.fromJson(Map<String, dynamic> json) {
    return SetifyerTermModel(
      id: json["id"],
      title: json['title'],
      body: json['body'],
    );
  }

}