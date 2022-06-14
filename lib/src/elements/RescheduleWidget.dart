import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:horizon/src/controllers/application_controller.dart';
import 'package:horizon/src/model/ApplicationModel.dart';
import 'package:intl/intl.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:time_range/time_range.dart';

class RescheduleWidget extends StatefulWidget {
  final ValueChanged<Map> onReschedule;
  final CertificationApplicationModel applicationModel;
  RescheduleWidget({Key key,this.onReschedule,this.applicationModel}) : super(key: key);


  @override
  _RescheduleWidgetState createState() => _RescheduleWidgetState();
}

class _RescheduleWidgetState extends StateMVC<RescheduleWidget> {


  ApplicationController _con;

  _RescheduleWidgetState() : super(ApplicationController()) {
    _con = controller;
  }


  CalendarController _calendarController;

  DateTime date = DateTime.now();



  static const orange = Color(0xFFFE9A75);
  static const dark = Color(0xFF333A47);
  static const double leftPadding = 8;

  List<String> buttons = ['Now', 'Later'];
  String time = 'Now';

  bool is_urgent = false;

  final _defaultTimeRange = TimeRangeResult(
    TimeOfDay(hour: DateTime
        .now()
        .add(Duration(minutes: 10))
        .hour, minute: DateTime
        .now()
        .add(Duration(minutes: 10))
        .minute),
    TimeOfDay(hour: DateTime
        .now()
        .add(Duration(minutes: 30))
        .hour, minute: DateTime
        .now()
        .add(Duration(minutes: 30))
        .minute),
  );
  TimeRangeResult _timeRange;

  @override
  void initState() {
    _calendarController = CalendarController();
    _timeRange = _defaultTimeRange;

    Future.delayed(Duration.zero).then((value) {
      AwesomeDialog(
          context: context,
          headerAnimationLoop: false,
          dialogType: DialogType.NO_HEADER,
          title: 'Application Expired',
          desc:
          ' Your application expired before it could be scheduled.You can  pick another time and reschedule ',
          btnOkOnPress: () {
            debugPrint('OnClcik');
          },
          // btnCancelOnPress: (){
          //   Navigator.pop(context);
          // },
          // btnCancelIcon: Icons.cancel,
          btnOkIcon: Icons.check_circle,
          btnOkColor: Theme.of(context).accentColor
      )..show();
    });
    super.initState();
  }

  void _onDaySelected(DateTime day, List events, List holidays) {
    print('CALLBACK: _onDaySelected');
    this.date = day;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(

        child:   SafeArea(

          child: Container(
            height: 50,
            color: Colors.white,
            child: Row(children: [


              Expanded(


                child:
                InkWell(
                  onTap: (){
                    _submit();



                  },
                  child: Container(

                    child: Center(child: Text("Reschedule Application",style: TextStyle(color: Theme.of(context).accentColor,fontSize: 18.0,fontWeight: FontWeight.bold),)),

                  ),
                ),
              ),

            ],),
          ),
        ),
      ),
key: _con.scaffoldKey,

      appBar: AppBar(

        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: InkWell(

          onTap: (){
            Navigator.pop(context);
          },
          child: Container(
            height: 50,width: 50,
            child: Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100.0),
                ),

                child: Center(child: new Icon(Icons.arrow_back_ios, color: Theme.of(context).hintColor))),
          ),
        ),




        title: Text("Application Reschedule",style: TextStyle(color: Colors.black,fontSize: 15.0,fontWeight: FontWeight.bold),),

      ),
      body: SafeArea(

        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                SizedBox(height: 10),

                // Text(
                //   'Select Date',
                //   style: Theme
                //       .of(context)
                //       .textTheme
                //       .headline6
                //       .copyWith(fontWeight: FontWeight.bold, color: Theme
                //       .of(context)
                //       .accentColor),
                // ),
                // SizedBox(height: 20,),
                // Card(
                //
                //   child: TableCalendar(
                //     calendarController: _calendarController,
                //     startDay: DateTime.now(),
                //     endDay: DateTime.now().add(Duration(days: 7)),
                //     onDaySelected: (date, events, holidays) {
                //       _onDaySelected(date, events, holidays);
                //     },
                //   ),
                // ), SizedBox(height: 20,),
                // Divider(color: Colors.grey,),
                Row(
                  children: [
                    Text(
                      'Select Time',
                      style: Theme
                          .of(context)
                          .textTheme
                          .headline6
                          .copyWith(fontWeight: FontWeight.bold, color: Colors.black,fontSize: 12.0),
                    ),
                  ],
                ),

                TimeWidget(),
                SizedBox(height: 20,),

              ],
            ),
          ),
        ),
      ),


    );
  }


  TimeWidget() {
    final _defaultTimeRange = TimeRangeResult(
      TimeOfDay(hour: DateTime
          .now()
          .add(Duration(minutes: 10))
          .hour, minute: DateTime
          .now()
          .add(Duration(minutes: 10))
          .minute),
      TimeOfDay(hour: DateTime
          .now()
          .add(Duration(minutes: 30))
          .hour, minute: DateTime
          .now()
          .add(Duration(minutes: 30))
          .minute),
    );
    TimeRangeResult _timeRange = _defaultTimeRange;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final aDate = DateTime(this.date.year, this.date.month, this.date.day);


    final date2 = DateTime.now();
    final difference = date2
        .difference(DateTime(
        now.year,
        now.month,
        now.day,
        23,
        59,
        59,
        0))
        .inSeconds;


    return aDate == today ? difference > 0 ? Center(
        child: Text("No time available", style: TextStyle(color: Theme
            .of(context)
            .accentColor),)) : Column(children: [
      // Text(
      //   'Available Times',
      //   style: Theme.of(context)
      //       .textTheme
      //       .headline6
      //       .copyWith(fontWeight: FontWeight.bold, color:Theme.of(context).accentColor),
      // ),
      SizedBox(height: 20),
      TimeRange(
        fromTitle: Text(
          'From',
          style: TextStyle(
            fontSize: 12,
            color: Colors.black,
            fontWeight: FontWeight.normal,
          ),
        ),
        toTitle: Text(
          'To',
          style: TextStyle(
            fontSize: 14,
            color: Colors.black,
            fontWeight: FontWeight.normal,
          ),
        ),
        titlePadding: 8,
        textStyle: TextStyle(
          fontWeight: FontWeight.normal,
          color: Theme
              .of(context)
              .accentColor,
        ),
        activeTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        borderColor: Theme
            .of(context)
            .accentColor,
        activeBorderColor: Theme
            .of(context)
            .accentColor,
        backgroundColor: Colors.transparent,
        activeBackgroundColor: Theme
            .of(context)
            .accentColor,
        firstTime: TimeOfDay(hour: DateTime
            .now()
            .hour, minute: DateTime
            .now()
            .minute),
        lastTime: TimeOfDay(hour: 23, minute: 59),
        initialRange: _timeRange,
        timeStep: 30,
        timeBlock: 30,
        onRangeCompleted: (range) =>
            setState(() {
              return _timeRange = range;
            }),
      ),
      SizedBox(height: 30),
      if (_timeRange != null)
        Padding(
          padding: const EdgeInsets.only(top: 8.0, left: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Text(
              //   'Selected Range: ${_timeRange.start.format(context)} - ${_timeRange.end.format(context)}',
              //   style: TextStyle(fontSize: 20, color: dark),
              // ),
              Text(""),
              SizedBox(height: 20),
              // MaterialButton(
              //   child: Text('Default'),
              //   onPressed: () =>
              //       setState(() => _timeRange = _defaultTimeRange),
              //   color: Colors.white,
              // )
            ],
          ),
        ),
    ],) : TimeWidget2();
  }

  TimeWidget2() {
    double leftPadding = 8;

    final _defaultTimeRange = TimeRangeResult(
      TimeOfDay(hour: DateTime
          .now()
          .add(Duration(minutes: 10))
          .hour, minute: DateTime
          .now()
          .add(Duration(minutes: 10))
          .minute),
      TimeOfDay(hour: DateTime
          .now()
          .add(Duration(minutes: 30))
          .hour, minute: DateTime
          .now()
          .add(Duration(minutes: 30))
          .minute),
    );
    TimeRangeResult _timeRange = _defaultTimeRange;
    return Column(children: [

      SizedBox(height: 5),
      TimeRange(
        fromTitle: Text(
          'FROM',
          style: TextStyle(
            fontSize: 14,
            color: Theme
                .of(context)
                .accentColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        toTitle: Text(
          'TO',
          style: TextStyle(
            fontSize: 14,
            color: Theme
                .of(context)
                .accentColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        titlePadding: leftPadding,
        textStyle: TextStyle(
          fontWeight: FontWeight.normal,
          color: Theme
              .of(context)
              .accentColor,
        ),
        activeTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        borderColor: Theme
            .of(context)
            .accentColor,
        activeBorderColor: Theme
            .of(context)
            .accentColor,
        backgroundColor: Colors.transparent,
        activeBackgroundColor: Theme
            .of(context)
            .accentColor,
        firstTime: TimeOfDay(hour: 00, minute: 00),
        lastTime: TimeOfDay(hour: 23, minute: 59,),
        initialRange: _timeRange,
        timeStep: 30,
        timeBlock: 30,
        onRangeCompleted: (range) =>
            setState(() {
              return _timeRange = range;
            }),
      ),
      SizedBox(height: 30),
      if (_timeRange != null)
        Padding(
          padding: const EdgeInsets.only(top: 8.0, left: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Text(
              //   'Selected Range: ${_timeRange.start.format(context)} - ${_timeRange.end.format(context)}',
              //   style: TextStyle(fontSize: 20, color: dark),
              // ),
              Text(""),
              SizedBox(height: 20),
              // MaterialButton(
              //   child: Text('Default'),
              //   onPressed: () =>
              //       setState(() => _timeRange = _defaultTimeRange),
              //   color: Colors.white,
              // )
            ],
          ),
        ),
    ],);
  }

  _submit() {
    if (
    date != null && _timeRange != null) {

      String time=_timeRange.start.format(context);

      DateFormat format = DateFormat("hh:mm a");
      if(time.toLowerCase().contains("am")||time.toLowerCase().contains('pm')){
        format = DateFormat("hh:mm a");
      }
      else{
        format = DateFormat("HH:mm");
      }
      DateTime formated = format.parse(time);

      print("start::"+time);
      print(formated);


      DateTime formated2 = format.parse(_timeRange.end.format(context));



      final f = new DateFormat('yyyy-MM-dd');

      _con.Reschedule(context, {
        "id": widget.applicationModel.id,
        "start_time": DateFormat("HH:mm").format(formated),
        "end_time": DateFormat("HH:mm").format(formated2),
        "date": f.format(date),

      });
    }
  }

}
