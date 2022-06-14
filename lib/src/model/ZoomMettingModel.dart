import 'package:intl/intl.dart';

class ZoomMeetingModel{
  int id;
  String join_url;
  String password;
  String creation_date;
  String start_time;
  String topic;
  String status;

  ZoomMeetingModel({this.id,this.join_url,this.creation_date,this.start_time,this.topic,this.status,this.password});
  factory ZoomMeetingModel.fromJson(Map<String, dynamic> json) {
    return ZoomMeetingModel(
      id: json["id"],
      join_url: json['join_url'],
      creation_date: json['creation_date'],
      start_time: json['start_time'],
      topic: json['topic'],
      status: json['status'],
      password: json['password'],

    );
  }


  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map['start_time'] = start_time;
    return map;
  }
  String getMeetingDate(){



    if(start_time==null){
      return '';
    }
    var formatter = new DateFormat("yyyy-MM-ddTHH:mm:ssZ");

    DateTime notification_date = formatter.parse(start_time);

    var date = DateFormat.yMEd().add_jms().format(notification_date);

    return  date;

  }
}