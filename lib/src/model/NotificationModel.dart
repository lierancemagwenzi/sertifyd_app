class NotificationModel {
  int id;
  String body;
  String title;
  int seen;
  int user_id;
  String date;
  String action;
  int action_id;

  bool read;

  NotificationModel(
      {this.id,
      this.body,
      this.title,
      this.date,
      this.seen,
      this.action_id,this.read,
      this.action,
      this.user_id});

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
        id: json["id"],
        body: json['body'],
        action: json['action'],
        action_id: json['action_id'],
        date: json['createdAt'],
        read: json['read'],
        user_id: json['user_id'],
        title: json['title']);
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map['body'] = body;
    map['title'] = title;
    map['action'] = action;
    map['action_id'] = action_id;


    return map;
  }

}
