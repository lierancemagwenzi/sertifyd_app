class MessageModel{
  int id;
  String message;
  int sender_id;
  int receiver_id;
  int date;
  int application_id;

  bool read;

  String sender;
  String receiver;

  MessageModel({this.id,this.message,this.sender_id,this.receiver_id,this.date,this.application_id,this.read,this.sender,this.receiver});
  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      application_id: json["application_id"],
      message: json['message'],
      sender_id: json['sender_id'],
      receiver_id: json['receiver_id'],
      date: json['date'],
      sender: json['sender'],
      receiver: json['receiver'],
      read: json['read'],
    );
  }


  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map['message'] = message;
    map['sender_id'] = sender_id;
    map['receiver_id'] = receiver_id;
    map['date'] = date;
    map['sender'] = sender;
    map['receiver'] = receiver;
    map['read'] = false;
    map['application_id'] = application_id;
    return map;
  }

}