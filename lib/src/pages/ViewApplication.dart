import 'package:flutter/material.dart';
import 'package:horizon/src/controllers/application_controller.dart';
import 'package:horizon/src/elements/CircularLoadingWidget.dart';
import 'package:intl/intl.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:table_calendar/table_calendar.dart';

class ViewApplicationWidget extends StatefulWidget {

 int application_id;

  ViewApplicationWidget({Key key, this.application_id}) : super(key: key);

  @override
  _ViewApplicationWidgetState createState() => _ViewApplicationWidgetState();
}

class _ViewApplicationWidgetState extends StateMVC<ViewApplicationWidget> {



  ApplicationController _con;

  _ViewApplicationWidgetState() : super(ApplicationController()) {
    _con = controller;
  }
DateTime date;
  CalendarController _calendarController;

  @override
  void initState() {
    // TODO: implement initState
    _calendarController = CalendarController();

_con.listenForApplication(widget.application_id);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

appBar: AppBar(
  title: Text("Application",style: Theme.of(context).appBarTheme.textTheme.headline5.copyWith(fontWeight: FontWeight.bold,)),
  leading: InkWell(
      onTap: (){

        Navigator.pop(context);
      },

      child: Icon(Icons.arrow_back_ios,color: Colors.white,)),

),
body: _con.certificationApplicationModel==null?CircularLoadingWidget(height: 500,):Container(


child:Padding(
  padding: const EdgeInsets.all(8.0),
  child:   Column(children: [
    Card(

      child: TableCalendar(

        calendarStyle: CalendarStyle(markersColor: Theme.of(context).primaryColorLight),
        calendarController: _calendarController,
        initialSelectedDay: new DateFormat("yyyy-MM-dd").parse(_con.certificationApplicationModel.date),
        // onDaySelected: (date, events, holidays) {
        //   // _onDaySelected(date, events, holidays);
        // },
      ),
    ),SizedBox(height: 20,)

  ],),
)

),
    );
  }
}
