class ChatModel{
  int id;
  String message;
  int user_id;
  int receiver_id;
  String created_at;
  int order_id;
  String time;
  String from;
String to;
  String date_result;

  ChatModel({this.id,this.message,this.user_id,this.receiver_id,this.created_at,this.order_id,this.time,this.from,this.date_result,this.to});
  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      order_id: json["order_id"],
      message: json['message'],
      user_id: json['user_id'],
      receiver_id: json['receiver_id'],
      created_at: json['created_at'],
      from: json['from'],
      to: json['to'],
      date_result: json['date_result'],
      time: json['time'],
    );
  }
  factory ChatModel.fromMap(Map<String, dynamic> json) {
    return ChatModel(
      order_id: json["order_id"],
      message: json['message'],
      user_id: json['user_id'],
      receiver_id: json['receiver_id'],
      created_at: json['created_at'],
      from: json['fromm'],
      to: json['too'],
      date_result: json['date_result'],
      time: json['time'],
    );
  }


  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map['message'] = message;
    map['user_id'] = user_id;
    map['receiver_id'] = receiver_id;
    map['created_at'] = created_at;
    map['from'] = from;
    map['date_result'] = date_result;
    map['time'] = time;
    map['order_id'] = order_id;
    return map;
  }

}