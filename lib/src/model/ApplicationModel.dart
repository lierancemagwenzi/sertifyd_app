import 'package:horizon/src/model/Application_status.dart';
import 'package:horizon/src/model/CertificationApplicationDocument.dart';
import 'package:horizon/src/model/DocumentType.dart';
import 'package:horizon/src/model/EarningSetting.dart';
import 'package:horizon/src/model/PaymentModel.dart';
import 'package:horizon/src/model/UserModel.dart';
import 'package:horizon/src/repositories/settings_repository.dart';
import 'package:intl/intl.dart';

import 'ZoomMettingModel.dart';

class CertificationApplicationModel{
  int id;
  int applicant_id;
  int status_id;
  int satifyer_id;
  String date;
  ApplicationStatus status;
  String description;
  String comment;
  String start_time;
  String end_time;
  List<CertificationApplicationDocument> documents;
String posted_date;
  UserModel applicant;
  UserModel sertifyer;
  EarningSetting earningSetting;
  PaymentModel paymentModel;
String slot;
  ZoomMeetingModel zoom;
  CertificationApplicationModel({this.id,this.earningSetting,this.slot,this.posted_date,this.paymentModel,this.applicant_id,this.status_id,this.satifyer_id,this.date,this.description,this.start_time,this.end_time,this.documents,this.applicant,this.sertifyer,this.status,this.zoom,this.comment});
  factory CertificationApplicationModel.fromJson(Map<String, dynamic> json) {
    return CertificationApplicationModel(
      id: json["id"],
      applicant_id: json['applicant_id'],
      status_id: json['status_id'],
      slot: json['slot'],
      satifyer_id: json['satifyer_id'],
      posted_date: json['createdAt'],
      date: json['date'],
      description: json['description'],
      comment: json['comment'],
      start_time: json['start_time'],
      end_time: json['end_time'],
      earningSetting:  json['earning_setting'] != null ? EarningSetting.fromJson(json['earning_setting']) : null,
      zoom:  json['zoom'] != null ? ZoomMeetingModel.fromJson(json['zoom']) : null,
      paymentModel:  json['payment'] != null ? PaymentModel.fromJson(json['payment']) : null,
      applicant:  json['applicant'] != null ? UserModel.fromJson(json['applicant']) : null,
      sertifyer:  json['sertifyer'] != null ? UserModel.fromJson(json['sertifyer']) : null,
      status:  json['status'] != null ? ApplicationStatus.fromJson(json['status']) : null,

      documents: json['documents'] != null ? List.from(json['documents']).map((element) {
        CertificationApplicationDocument applicationDocument=CertificationApplicationDocument.fromJson(element);
        print("document");
        print((element['document_type']).toString());
        DocumentTypeModel typeModel=element['document_type']!=null?DocumentTypeModel.fromJson(element['document_type']):null;

        print(typeModel);
        applicationDocument.documentTypeModel=typeModel;
        return applicationDocument;
      }).toList() : [],

    );
  }


  DateTime getEndTime(){

    DateFormat format = DateFormat("yyyy-MM-dd HH:mm:ss");
    DateFormat time_format = DateFormat("HH:mm");
    String date=this.date+" "+start_time;

    DateTime dateTime=format.parse(date);
    DateTime endTime=dateTime.add(Duration(minutes: (setting.value.meeting_time)));

    return endTime;
  }

  DateTime getActualEndtime(){

    DateFormat format = DateFormat("yyyy-MM-dd HH:mm:ss");
    DateFormat time_format = DateFormat("HH:mm");
    String date=this.date+" "+end_time;

    DateTime dateTime=format.parse(date);


    return dateTime;
  }

  DateTime getStarttime(){

    DateFormat format = DateFormat("yyyy-MM-dd HH:mm:ss");
    DateFormat time_format = DateFormat("HH:mm");
    String date=this.date+" "+start_time;

    DateTime dateTime=format.parse(date);


    return dateTime;
  }


  String gettotalPrice(){

    num total=0;

    for(int i=0;i<documents.length;i++){

      total+=documents[i].getPrice()*earningSetting.getPercentage();

    }

    return total.toStringAsFixed(2);
  }
  num getnumtotalPrice(){

    num total=0;

    for(int i=0;i<documents.length;i++){

      total+=documents[i].getPrice()*earningSetting.getPercentage();

    }

    return total;
  }
String getPostDate(){



    if(posted_date==null){
      return '';
    }
  // var formatter = new DateFormat("yyyy-MM-ddTHH:mm:ssZ");

    var formatter = new DateFormat("yyyy-MM-dd HH:mm:ss");


    DateTime notification_date = formatter.parse(posted_date);

  var date = DateFormat.yMEd().add_jms().format(notification_date);

  return  date;

}


  String getslotDate(){



    if(slot==null){
      return '';
    }

    // var formatter = new DateFormat("yyyy-MM-ddTHH:mm:ssZ");

    var formatter = new DateFormat("yyyy-MM-dd HH:mm:ss");

    DateTime notification_date = formatter.parse(slot);

    var date = DateFormat.yMEd().add_jms().format(notification_date);

    return  date;

  }


  String getWanteddate(){


    DateFormat format =
    DateFormat("yyyy-MM-dd");

    var formated =
    format.parse(this.date);

    var date =
    DateFormat.yMMMMEEEEd().format(formated);

    return date;
  }

  DateTime getInitialDate(){


    DateFormat format =
    DateFormat("yyyy-MM-dd");

    var formated =
    format.parse(this.date);



    return formated;
  }

  DateTime getDayEnd(){

    DateFormat format = DateFormat("yyyy-MM-dd HH:mm");
    DateFormat time_format = DateFormat("HH:mm:ss");
    String date=this.date+" "+'23:00:00';
    DateTime dateTime=format.parse(date);

    return dateTime;
  }



}