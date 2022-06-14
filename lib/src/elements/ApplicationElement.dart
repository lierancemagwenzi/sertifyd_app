import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:horizon/src/controllers/AdminController.dart';
import 'package:horizon/src/helper/Helper.dart';
import 'package:horizon/src/icons/zoom.dart';
import 'package:horizon/src/model/ApplicationModel.dart';
import 'package:horizon/src/pages/admin/DocumentsWidget.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';


class ApplicationElement extends StatefulWidget {

  CertificationApplicationModel applicationModel;
      BuildContext context; AdminController adminController;

  ApplicationElement({Key key, this.context,this.applicationModel,this.adminController}) : super(key: key);

  @override
  _ApplicationElementState createState() => _ApplicationElementState();
}

class _ApplicationElementState extends State<ApplicationElement> {



  String  time_remaining="-";


  Timer timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) => subtractTime());
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }


  subtractTime(){
    final birthday = DateTime(2021, 10, 12);
      DateTime parseDate = new DateFormat("yyyy-MM-ddTHH:mm:ssZ").parse(widget.applicationModel.zoom.start_time);

      final now = DateTime.now();

      int minutes=parseDate.difference(now).inMinutes;


      if(minutes>0){

        setState(() {
          time_remaining = _printDuration(Duration(minutes:minutes));
        });
      }

      else{

        setState(() {
          time_remaining='--';
        });
      }




  }

  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));

    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }


  @override
  Widget build(BuildContext context) {
    return ApplicationElement1(widget.applicationModel,widget.context,widget.adminController);
  }


  Widget ApplicationElement1(CertificationApplicationModel applicationModel,
      BuildContext context, AdminController adminController) {
    double height = MediaQuery
        .of(context)
        .size
        .height;

    double width = MediaQuery
        .of(context)
        .size
        .width;

    DateTime parseDate = new DateFormat("yyyy-MM-dd").parse(
        applicationModel.date);

    return SafeArea(
      child: Container(


        child: ListView(children: [
          Container(


            child: SfCalendar(view: CalendarView.schedule,
              dataSource: MeetingDataSource(
                  _getDataSource(applicationModel, parseDate, context)),
              initialDisplayDate: parseDate,),
          )
          , AppointMentDetails(applicationModel, parseDate, context)
        ],),

      ),
    );
  }

  AppointMentDetails(
      CertificationApplicationModel certificationApplicationModel,
      DateTime date, BuildContext context) {
    var formatter = new DateFormat("yyyy-MM-ddTHH:mm:ssZ");

    DateTime meetingTime = formatter.parse(
        certificationApplicationModel.zoom.start_time);

    var weekday = DateFormat('EEEE').format(date);
    var time = DateFormat('HH:mm').format(meetingTime);


    return Container(
      color: Theme
          .of(context)
          .accentColor
          .withOpacity(0.6),


      child: Padding(
        padding: const EdgeInsets.symmetric(vertical:8.0),
        child: Column(
          children: [
            Center(child: Text(getDay(date.day.toString()),
              style: TextStyle(color: Colors.white, fontSize: 60.0),)),

            Center(child: Text(
              weekday, style: TextStyle(color: Colors.white, fontSize: 20.0),)),
            SizedBox(height: 10.0,),

            ListTile(
              leading: Icon(Icons.info_outline_sharp, color: Colors.white70,),
              title: Text(certificationApplicationModel.applicant.getFullname(),
                style: TextStyle(color: Colors.white70, fontSize: 16.0),),
            ),

            ListTile(
              leading: Icon(Icons.alternate_email, color: Colors.white70,),
              title: Text(certificationApplicationModel.applicant.mobile,
                style: TextStyle(color: Colors.white70, fontSize: 16.0),),
            ),
            ListTile(
              onTap: (){

                Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => DocumentsWidget(
                          applicationModel: widget.applicationModel,
                          adminController: widget.adminController,
                          context: widget.context,

                        )));
              },

              leading: Icon(Icons.folder, color: Colors.white70,),
              trailing: Text("View Docs",style: TextStyle(fontSize: 18.0,color: Colors.white70),),
              title: Text(Helper.getDocuments(widget.applicationModel),

                style: TextStyle(color: Colors.white70, fontSize: 16.0),),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Divider(color: Colors.black87.withOpacity(0.5),),
            ),
            ListTile(
              // leading: Icon(Icons.alternate_email,color: Colors.white70,),
              title: Text("Zoom Meeting ", style: TextStyle(color: Colors.white70,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold),),
            ),

            ListTile(

              onTap: () {
                _launchURL(certificationApplicationModel.zoom.join_url);
              },
              trailing: InkWell(
                  onTap: () {
                    Clipboard.setData(ClipboardData(
                        text: certificationApplicationModel.zoom.join_url));

                    Toast.show("Copied!", context, duration: Toast.LENGTH_SHORT,
                        gravity: Toast.CENTER);
                  },
                  child: Icon(Icons.copy, color: Colors.white70,)),
              leading: Icon(Icons.video_call_sharp, color: Colors.white70,),
              title: Text(certificationApplicationModel.zoom.join_url,
                style: TextStyle(color: Colors.white70, fontSize: 16.0),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,),
            ),
            ListTile(
              leading: Icon(Icons.lock, color: Colors.white70,),
              title: Text(widget.applicationModel.zoom.password,
                style: TextStyle(color: Colors.white70, fontSize: 16.0),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,),
            ),
            ListTile(
              leading: Icon(Icons.watch_later_rounded, color: Colors.white70,),
              title: Text(time,
                style: TextStyle(color: Colors.white70, fontSize: 16.0),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,),
            ),

            ListTile(
              leading: Icon(Icons.timer, color: Colors.white70,),
              trailing:       Text(time_remaining.toString(),style: TextStyle(fontSize: 20.0,color: Colors.white70),),
              title:       Text("Time remaining",style: TextStyle(fontSize: 16.0,color: Colors.white70),),
            ),


          ],),
      ),)
    ;
  }


  String getDay(String day) {
    if (day.length == 1) {
      return day.toString().padLeft(2, '0');
    }
    else {
      return day;
    }
  }

  void _launchURL(String _url) async =>
      await canLaunch(_url)
          ? await launch(_url)
          : throw 'Could not launch $_url';

  List<Meeting> _getDataSource(CertificationApplicationModel applicationModel,
      DateTime dateTime, BuildContext context) {
    final List<Meeting> meetings = <Meeting>[];
    final DateTime today = DateTime.now();
    final DateTime startTime =
    DateTime(dateTime.year, dateTime.month, dateTime.day, 9, 0, 0);
    final DateTime endTime = startTime.add(const Duration(hours: 1));
    meetings.add(Meeting(
        applicationModel.zoom != null
            ? applicationModel.zoom.topic
            : "Certification", startTime, endTime,

     Theme.of(context).accentColor
        .withOpacity(1.0), false));

    return meetings;
  }

}
class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments[index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments[index].to;
  }

  @override
  String getSubject(int index) {
    return appointments[index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments[index].background;
  }

  @override
  bool isAllDay(int index) {
    return appointments[index].isAllDay;
  }
}

class Meeting {
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);

  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
}


class Countdown extends AnimatedWidget {
  Countdown({Key key, this.animation}) : super(key: key, listenable: animation);
  Animation<int> animation;

  @override
  build(BuildContext context) {
    Duration clockTimer = Duration(seconds: animation.value);

    String timerText =
        '${clockTimer.inMinutes.remainder(60).toString()}:${clockTimer.inSeconds.remainder(60).toString().padLeft(2, '0')}';

    print('animation.value  ${animation.value} ');
    print('inMinutes ${clockTimer.inMinutes.toString()}');
    print('inSeconds ${clockTimer.inSeconds.toString()}');
    print('inSeconds.remainder ${clockTimer.inSeconds.remainder(60).toString()}');

    return Text(
      "$timerText",
      style: TextStyle(
        fontSize: 110,
        color: Theme.of(context).primaryColor,
      ),
    );
  }
}