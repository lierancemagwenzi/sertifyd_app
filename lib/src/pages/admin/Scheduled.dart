import 'package:flutter/material.dart';
import 'package:horizon/src/controllers/AdminController.dart';
import 'package:horizon/src/controllers/DownloadController.dart';
import 'package:horizon/src/elements/CertItemWidget.dart';
import 'package:horizon/src/elements/EmptyCompletedApplicationsWidget.dart';
import 'package:horizon/src/elements/EmptyScheduledJobs.dart';
import 'package:horizon/src/elements/admin/AdminCertItemWidget.dart';
import 'package:horizon/src/model/AdminApplication.dart';
import 'package:horizon/src/model/ApplicationModel.dart';
import 'package:intl/intl.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:table_calendar/table_calendar.dart';

class ScheduledApplicationsWidget extends StatefulWidget {

  @override
  _ScheduledApplicationsWidgetState createState() => _ScheduledApplicationsWidgetState();
}

class _ScheduledApplicationsWidgetState extends StateMVC<ScheduledApplicationsWidget> {


  AdminController _con;

  _ScheduledApplicationsWidgetState() : super(AdminController()) {
    _con = controller;
  }
  CalendarController _calendarController;


  DateTime date;
  void _onDaySelected(DateTime day, List events, List holidays) {

    setState(() { this.date=day;});

    print('CALLBACK: _onDaySelected');


  }

  @override
  void initState() {
    _con.listenForScheduledApplications();
        _calendarController = CalendarController();

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final f = new DateFormat('yyyy-MM-dd');
    List<CertificationApplicationModel>  applications=this.date==null?_con.applications: _con.applications.where((i) => i.date==f.format(this.date)).toList();
    return Scaffold(
      key: _con.scaffoldKey,
      appBar: AppBar(
        // leading: new IconButton(
        //   icon: new Icon(Icons.sort, color: Theme.of(context).hintColor),
        //   onPressed: () {
        //     Navigator.pushNamed(context, '/Admin',arguments: 2);
        //   },
        // ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Scheduled Certifications",
          style: Theme.of(context).textTheme.headline6.merge(TextStyle(letterSpacing: 1.3)),
        ),

      ),
      body: RefreshIndicator(

        onRefresh: () async {
          _con.refreshScheduledJobs();
        },
        child: ListView(
          children: [
            SingleChildScrollView(
//              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
              child: Column(
                children: <Widget>[

                  SizedBox(height: 20,),
                _con.applications.length<1?SizedBox(height: 0,width: 0,):  Card(

                    child: TableCalendar(
                      initialCalendarFormat: CalendarFormat.week,
                      calendarController: _calendarController,
                      startDay: DateTime.now().subtract(Duration(days: 7)),

                      endDay: DateTime.now().add(Duration(days: 7)),

                      onDaySelected: (date, events, holidays) {
                        _onDaySelected(date, events, holidays);
                      },
                    ),
                  ),SizedBox(height: 20,),
                  _con.applications.length<1?SizedBox(height: 0,width: 0,):    Divider(color: Colors.grey,),


                  _con.applications.length==0?Text(""):Padding(
                    padding: const EdgeInsets.symmetric(horizontal:8.0),
                    child:   Row(

                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [

                        InkWell(

                            onTap: (){
                              if(this.date!=null){
                                setState(() { date=null; });

                              }

                            },

                            child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color:this.date!=null?Colors.grey: Theme.of(context).primaryColorLight,
                                    ),
                                    borderRadius: BorderRadius.all(Radius.circular(5))
                                ),

                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(this.date==null?"Showing All":"Show All",   style: this.date==null?Theme.of(context).textTheme.headline4.copyWith(fontSize: 14.0):TextStyle(color: Colors.grey)),
                                )))
                      ],
                    ),
                  ),

                  applications.isEmpty
                      ? EmptyScheduledJobs()
                      : ListView.separated(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    primary: false,
                    itemCount: applications.length,
                    itemBuilder: (context, index) {
                      var _order = applications.elementAt(index);
                      return AdminCertItemWidget(

                          onClick: (model){


                            Navigator.of(context).pushNamed('/${model.status.admin_next.toLowerCase()}', arguments: AdminApplicationModel(id: model.id,admin_next: model.status.admin_next,message: null)).then((value) {

                              _con.refreshJobs();
                              return null;
                            });

                            // _con.GetApplication(model.id,context);

                            // Navigator.of(context).pushNamed('/${model.status.client_next.toLowerCase()}', arguments: model.id);

                          },

                          expanded: index == 0 ? true : false, applicationModel: _order);
                    },
                    separatorBuilder: (context, index) {
                      return SizedBox(height: 20);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
