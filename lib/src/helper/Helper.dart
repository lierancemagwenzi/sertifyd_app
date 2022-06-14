import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:horizon/src/model/ApplicationModel.dart';
import 'package:horizon/src/model/DocumentType.dart';
import 'package:horizon/src/repositories/settings_repository.dart';
import 'package:horizon/src/repositories/user_repository.dart';
import 'package:html/parser.dart';
import 'package:intl/intl.dart';
import 'string_extension.dart';


class Helper {
  BuildContext context;
  DateTime currentBackPressTime;

  Helper.of(BuildContext _context) {
    this.context = _context;
  }

  // for mapping data retrieved form json array
  static getData(Map<String, dynamic> data) {
    return data['data'] ?? [];
  }
  static String limitString(String text, {int limit = 24, String hiddenText = "..."}) {
    return text.substring(0, min<int>(limit, text.length)) + (text.length > limit ? hiddenText : '');
  }


  static String getfilextention(String path){
    return path.split(".").last;

  }


static  String getFiledName(String myString){

    return myString.replaceFirst(RegExp('_'), ' ');
  }

  static String getRoute(String path){
    String ext=path.split(".").last.toLowerCase();
    if(ext=="pdf"){

      return "/PDF";
    }
    else if(ext=="jpg"||ext=="png"||ext=="jpeg"){


    return "/IMAGE";

    }

    return "/ZIP";

  }
  static String getDocuments(CertificationApplicationModel applicationModel){


    String docs="";


    if(applicationModel.documents.length==0){

      return "Certification documents";
    }

    else{


      for(int i=0;i<applicationModel.documents.length;i++){
        if(i==applicationModel.documents.length-1){

          docs+=applicationModel.documents[i].documentTypeModel.type.capitalize();
        }
        else{

          docs+=applicationModel.documents[i].documentTypeModel.type.capitalize()+" , ";
        }


      }


      return  docs;
    }

  }


  static String TotalPrice(CertificationApplicationModel certificationApplicationModel){
    num price=0;

    if(certificationApplicationModel.documents==null){

      return "-";
    }

    for(int i=0;i<certificationApplicationModel.documents.length;i++){

      price=price+PriceNum(certificationApplicationModel.documents[i].documentTypeModel.price??'0');

    }

    return currentuser.value.country.currency+  price.toString();

  }


  static String TotalPayPrice(CertificationApplicationModel certificationApplicationModel){
    num price=0;

    if(certificationApplicationModel.documents==null){

      return "-";
    }

    for(int i=0;i<certificationApplicationModel.documents.length;i++){

      if(certificationApplicationModel.documents[i].status.toLowerCase()!='rejected'){

        price=price+PriceNum(certificationApplicationModel.documents[i].documentTypeModel.price??'0');

      }else{

        price=price+PriceNum(certificationApplicationModel.documents[i].documentTypeModel.price??'0')/2;

      }

    }

    return currentuser.value.country.currency+  price.toString();

  }
  static num TotalintPayPrice(CertificationApplicationModel certificationApplicationModel){
    num price=0;

    if(certificationApplicationModel.documents==null){

      return 0;
    }

    for(int i=0;i<certificationApplicationModel.documents.length;i++){

      if(certificationApplicationModel.documents[i].status.toLowerCase()!='rejected'){

        price=price+PriceNum(certificationApplicationModel.documents[i].documentTypeModel.price??'0');

      }else{

        price=price+PriceNum(certificationApplicationModel.documents[i].documentTypeModel.price??'0')/2;

      }

    }

    return  price;

  }

 static String documentPrice(DocumentTypeModel documentTypeModel){

    return currentuser.value.country.currency+documentTypeModel.price;

  }


 static  num PriceNum(String price){


    return num.tryParse(price)??0;


  }

 static Iterable<TimeOfDay> getTimes(TimeOfDay startTime, TimeOfDay endTime, Duration step) sync* {
    var hour = startTime.hour;
    var minute = startTime.minute;

    do {
      yield TimeOfDay(hour: hour, minute: minute);
      minute += step.inMinutes;
      while (minute >= 60) {
        minute -= 60;
        hour++;
      }
    } while (hour < endTime.hour ||
        (hour == endTime.hour && minute <= endTime.minute));
  }

  static String getSlotTime(CertificationApplicationModel applicationModel){
    DateFormat format = DateFormat("yyyy-MM-dd HH:mm:ss");
    DateFormat time_format = DateFormat("HH:mm:ss");
    String date=applicationModel.date+" "+getStartTime(applicationModel.start_time);

    DateTime dateTime=format.parse(date);

    DateTime endTime=dateTime.add(Duration(minutes: (setting.value.meeting_time)));


  return time_format.format(dateTime)+"-"+time_format.format(endTime);


  }



  static  List<String>findFreeSlots(List<CertificationApplicationModel> applications,CertificationApplicationModel certificationApplicationModel,BuildContext context){
    List<String> slots=[];
    DateFormat time_format = DateFormat("HH:mm:ss");
    if(applications.length>0){
      print("greater than 0");
      print(applications[0].start_time+"-"+certificationApplicationModel.start_time);
      if(applications[0].getStarttime().difference(certificationApplicationModel.getStarttime()).inMinutes>(setting.value.meeting_time)){
        slots.add(certificationApplicationModel.start_time+"-"+applications[0].start_time);
      }else{}
        for (int i = 0; i < applications.length; i++) {
          if((i+1)<applications.length){
            int diff=applications[i+1].getStarttime().difference(applications[i].getEndTime()).inMinutes;
            print(diff);
            if(diff>(setting.value.meeting_time)){
              slots.add(time_format.format(applications[i].getEndTime())+"-"+time_format.format(applications[i+1].getStarttime()));
            }
            else{
            }
          }
        }
      print(certificationApplicationModel.end_time+"-"+applications[applications.length-1].end_time);
     print(certificationApplicationModel.getActualEndtime().difference(applications[applications.length-1].getEndTime()).inMinutes);
      if(certificationApplicationModel.getActualEndtime().difference(applications[applications.length-1].getEndTime()).inMinutes>(setting.value.meeting_time??(setting.value.meeting_time))){
        slots.add(time_format.format(applications[applications.length-1].getEndTime())+"-"+time_format.format(certificationApplicationModel.getActualEndtime()));
      }
    }

    else{
      slots.add(certificationApplicationModel.start_time+"-"+ time_format.format(certificationApplicationModel.getStarttime().add(Duration(minutes: (setting.value.meeting_time)))));
    }
    print("slots");
    print(slots);

    return slots;
  }



  static String  getStartTime(String slot){
    var slots=slot.split('-');
    print(slots);
    if(slots.length>0){
      return slots[0];
    }
    else{

      return '00:00';
    }

  }


  static String skipHtml(String htmlString) {
    try {
      var document = parse(htmlString);
      String parsedString = parse(document.body.text).documentElement.text;
      return parsedString;
    } catch (e) {
      return '';
    }
  }

  static String SplitTime(String time){
    var parts = time.split('-');

    if(parts.length>1){

      return parts[0];
    }
    else{
      return "00:00";
    }

  }


  static String getChatTime(DateTime date) {
    if (date == null) {
      return '';
    }
    String msg = '';
    var dt = date.toLocal();

    if (DateTime.now().toLocal().isBefore(dt)) {
      return DateFormat.jm().format(date.toLocal()).toString();
    }

    var dur = DateTime.now().toLocal().difference(dt);
    if (dur.inDays > 0) {
      msg = '${dur.inDays} d';
      return dur.inDays == 1 ? '1d' : DateFormat("dd MMM").format(dt);
    } else if (dur.inHours > 0) {
      msg = '${dur.inHours} h';
    } else if (dur.inMinutes > 0) {
      msg = '${dur.inMinutes} m';
    } else if (dur.inSeconds > 0) {
      msg = '${dur.inSeconds} s';
    } else {
      msg = 'now';
    }
    return msg;
  }


}
