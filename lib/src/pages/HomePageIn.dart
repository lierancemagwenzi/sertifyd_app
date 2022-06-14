import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:horizon/src/controllers/HomePageController.dart';
import 'package:horizon/src/controllers/application_controller.dart';
import 'package:horizon/src/elements/ApplicationWidget.dart';
import 'package:horizon/src/elements/CertItemWidget.dart';
import 'package:horizon/src/elements/EmptyApplicationsWidget.dart';
import 'package:horizon/src/elements/EmptyDayApplicationsWidget.dart';
import 'package:horizon/src/elements/RescheduleWidget.dart';
import 'package:horizon/src/model/ApplicationModel.dart';
import 'package:horizon/src/model/ClientApplication.dart';
import 'package:horizon/src/repositories/user_repository.dart';
import 'package:intl/intl.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:time_range/time_range.dart';

class HomePageIn extends StatefulWidget {

  @override
  _HomePageInState createState() => _HomePageInState();
}

class _HomePageInState extends StateMVC<HomePageIn> {

  ApplicationController _con;

  _HomePageInState() : super(ApplicationController()) {
    _con = controller;
  }


  CalendarController _calendarController;
  DateTime date1 = DateTime.now();

  double height;
  double width;
  DateTime date;


  String group="pending";

  void _onDaySelected(DateTime day, List events, List holidays) {
    setState(() {
      this.date = day;
    });

    print('CALLBACK: _onDaySelected');
  }


  @override
  void initState() {
    _calendarController = CalendarController();
    _con.listenForApplications();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    final f = new DateFormat('yyyy-MM-dd');


    List<CertificationApplicationModel> applications = this.date == null ? _con
        .applications : _con.applications.where((i) =>
    i.date == f.format(this.date)).toList();


    return Scaffold(
        backgroundColor: Colors.white,
        key: _con.scaffoldKey,
        body: 1 == 1 ? Body() : Container(
          child: RefreshIndicator(
            onRefresh: () async {
              _con.refreshHome();
            },
            child: ListView(
              children: [
                SingleChildScrollView(

                  child: Column(
                    children: [
                      GreetingWidget(),
                      SizedBox(height: 10.0,),
                      SizedBox(height: 20,),
                      _con.applications.length == 0 ? SizedBox(
                        height: 0, width: 0,) : Card(

                        child: TableCalendar(
                          initialCalendarFormat: CalendarFormat.week,
                          calendarController: _calendarController,
                          // startDay: DateTime.now(),
                          endDay: DateTime.now().add(Duration(days: 7)),
                          initialSelectedDay: DateTime.now(),
                          onDaySelected: (date, events, holidays) {
                            _onDaySelected(date, events, holidays);
                          },
                        ),
                      ),
                      SizedBox(height: 20,),
                      _con.applications.length < 1 ? SizedBox(
                        height: 0, width: 0,) : Divider(color: Colors.grey,),
                      _con.applications.length < 1 ? SizedBox(
                        height: 0, width: 0,) : ListTile(
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        // leading: Icon(
                        //   Icons.folder,
                        //   color: Theme.of(context).hintColor,
                        // ),
                        title: Text(
                          "certifications",
                          style: Theme
                              .of(context)
                              .textTheme
                              .headline4,
                        ),
                        trailing: _con.applications.length == 0
                            ? null
                            : InkWell(

                            onTap: () {
                              if (this.date != null) {
                                setState(() {
                                  date = null;
                                });
                              }
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: this.date != null
                                          ? Colors.grey
                                          : Theme
                                          .of(context)
                                          .primaryColorLight,
                                    ),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(5))
                                ),

                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(this.date == null
                                      ? "Showing All"
                                      : "Show All",
                                      style: this.date == null ? Theme
                                          .of(context)
                                          .textTheme
                                          .headline4
                                          .copyWith(fontSize: 14.0) : TextStyle(
                                          color: Colors.grey)),
                                ))),
                      ),

//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal:8.0),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               InkWell(
//                 onTap: () {
//
//                 },
//                 child: Container(
//                   padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
//                   decoration: BoxDecoration(
//                       borderRadius: BorderRadius.all(Radius.circular(5)),
//                       color:
//                       Theme.of(context).accentColor.withOpacity(1)
//                   ),
//                   child: Text(
//                     "Completed",
//                     style: TextStyle(
//                         color:
//                         Colors.white70 ),
//                   ),
//                 ),
//               ),
// SizedBox(width: 10.0,),
//               InkWell(
//                 onTap: () {
//
//                 },
//                 child: Container(
//                   padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
//                   decoration: BoxDecoration(
//                       borderRadius: BorderRadius.all(Radius.circular(5)),
//                       color:
//                       Colors.white.withOpacity(1)
//                   ),
//                   child: Text(
//                     "Scheduled",
//                     style: TextStyle(
//                         color:
//                         Theme.of(context).accentColor ),
//                   ),
//                 ),
//               ),SizedBox(width: 10.0,),
//             InkWell(
//               onTap: () {
//
//               },
//               child: Container(
//                 padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.all(Radius.circular(5)),
//                   color:
//                        Theme.of(context).accentColor.withOpacity(1)
//                 ),
//                 child: Text(
//                "Pending",
//                   style: TextStyle(
//                       color:
//                       Colors.white70 ),
//                 ),
//               ),
//             ),
//           ],),
//         ),
                      SizedBox(

                        height: 10.0,
                      ),
                      _con.applications.length < 1
                          ? EmptyDocumentsWidget()
                          : applications.length < 1 ? Center(
                          child: EmptyDyCertifications()) : ListView.builder(
                          itemCount: applications.length,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          primary: false,
                          itemBuilder: (BuildContext context, int index) {
                            return CertItemWidget(
                              onSelected: (model) {
                                print("onselected");
                                _con.CancelApplication(
                                    context, {"id": applications[index].id},
                                    index);
                              },


                              onReschedule: (model) {
                                Navigator.of(context)
                                    .pushNamed('/${model.status.client_next
                                    .toLowerCase()}', arguments: model)
                                    .then((value) {
                                  _con.refreshHome();
                                  return null;
                                });
                                // _modalBottomSheetMenu(applications[index]);

                              },

                              onClick: (model) {
                                // _con.GetApplication(model.id,context);


                                if (model.status.status.toLowerCase() ==
                                    'pending') {
                                  Navigator.of(context).pushNamed(
                                      '/${model.status.client_next
                                          .toLowerCase()}',
                                      arguments: ClientApplication(id: model.id,
                                          message: null,
                                          client_next: model.status
                                              .client_next)).then((value) {
                                    _con.refreshHome();
                                    return null;
                                  });
                                }

                                else {
                                  Navigator.of(context).pushNamed(
                                      '/${model.status.client_next
                                          .toLowerCase()}',
                                      arguments: ClientApplication(id: model.id,
                                          message: null,
                                          client_next: model.status
                                              .client_next)).then((value) {
                                    _con.refreshHome();

                                    return null;
                                  });
                                }
                              },

                              applicationModel: applications[index],
                              expanded: index == 0 ? true : false,
                            );
                          }

                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

        )

    );
  }

  void _modalBottomSheetMenu(CertificationApplicationModel applicationModel) {
    CalendarController _calendarController = CalendarController();


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

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        isDismissible: false,
        enableDrag: false,
        builder: (builder) {
          return new Container(
            height: MediaQuery
                .of(context)
                .size
                .height * 0.7,
            color: Colors.transparent, //could change this to Color(0xFF737373),
            //so you don't have to change MaterialApp canvasColor
            child: new Container(
                decoration: new BoxDecoration(
                    color: Colors.white,
                    borderRadius: new BorderRadius.only(
                        topLeft: const Radius.circular(10.0),
                        topRight: const Radius.circular(10.0))),
                child: new Center(
                  child: RescheduleWidget(applicationModel: applicationModel,),
                )),
          );
        }
    );
  }


  Widget GreetingWidget() {
    return _con.applications.length < 1
        ? SizedBox(height: 0, width: 0,)
        : Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(

        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10,),
          Row(
            children: [
              Text(greeting(), style: TextStyle(
                  fontSize: 10.0, fontWeight: FontWeight.normal),),
            ],
          ),
          SizedBox(height: 5,),
          Text(currentuser.value.getFullname(), style: TextStyle(
            fontSize: 13.0, fontWeight: FontWeight.w700, color: Colors.black,),)
        ],),
    );
  }


  String greeting() {
    var hour = DateTime
        .now()
        .hour;
    if (hour < 12) {
      return 'Welcome back';
    }
    if (hour < 17) {
      return 'Welcome back';
    }
    return 'Welcome back';
  }


  Widget Body() {

   List<CertificationApplicationModel> pending= _con.applications.where((element) => element.status.status.toLowerCase()=="pending"||element.status.status.toLowerCase()=="expired").toList();

   List<CertificationApplicationModel> completed=  _con.applications.where((element) => element.status.status.toLowerCase()=="completed"||element.status.status.toLowerCase()=='completed').toList();

   List<CertificationApplicationModel> scheduled=  _con.applications.where((element) => element.status.status.toLowerCase()=="scheduled"|| element.status.status.toLowerCase()=="accepted"|| element.status.status.toLowerCase()=="paid").toList();
    return SafeArea(

      child: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(children: [

            GreetingWidget(),
            SizedBox(height: 16,),
            Expanded(

              child: Container(

                width: width,
                color: Color(0xfff4f5f9),

                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(

                    children: [

                      SizedBox(height: 18,),
                      Row(children: [


                        Expanded(

                          child: InkWell(

                            onTap:(){

                              setState((){

                                group="pending";

                });
                },
                            child: Container(
                              height: 40.0,
                              decoration: new BoxDecoration(
                                color: Colors.white,

                                borderRadius: new BorderRadius.only(
                                  topLeft: const Radius.circular(10.0),
                                  bottomLeft: const Radius.circular(10.0),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: pending.length>0?MainAxisAlignment.start:  MainAxisAlignment.center,
                                  children: [
                                    Center(child: Text("Pending",
                                      style: TextStyle(color:group=="pending"? Colors.black:Colors.grey.withOpacity(0.8),

                                          fontSize: 10,
                                          fontWeight: FontWeight.bold),)),

                                 pending.length>0?   Badge(
                                      badgeColor: Theme.of(context).scaffoldBackgroundColor,
                                      badgeContent: Text(pending.length.toString()),
                                      child: Padding(
                                        padding: const EdgeInsets.all(3.0),
                                        child: SizedBox(width: 10,height: 10,),
                                      ),
                                    ):SizedBox(height: 0,width: 0,)
                                  ],
                                ),
                              ),

                            ),
                          ),
                        ),
                        SizedBox(width: 3,),
                        Expanded(
                          child: InkWell(

                            onTap:(){

                              setState((){

                                group="scheduled";

                              });
                            },
                            child: Container(

                              height: 40.0,
                              decoration: new BoxDecoration(
                                color: Colors.white,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(

                                  mainAxisAlignment: scheduled.length>0?MainAxisAlignment.start:  MainAxisAlignment.center,

                                  children: [
                                    Center(child: Text("In Progress",
                                      style: TextStyle(color:group=="scheduled"? Colors.black:Colors.grey.withOpacity(0.8),
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold),)),

                                    scheduled.length>0?   Badge(
                                      badgeColor: Theme.of(context).scaffoldBackgroundColor,
                                      badgeContent: Text(scheduled.length.toString()),
                                      child: Padding(
                                        padding: const EdgeInsets.all(3.0),
                                        child: SizedBox(width: 10,height: 10,),
                                      ),
                                    ):SizedBox(height: 0,width: 0,)
                                  ],
                                ),
                              ),

                            ),
                          ),
                        ),
                        SizedBox(width: 3,),

                        Expanded(

                          child: InkWell(

                            onTap:(){

                              setState((){

                                group="completed";

                              });
                            },
                            child: Container(
                              height: 40.0,
                              decoration: new BoxDecoration(
                                color: Colors.white,

                                borderRadius: new BorderRadius.only(
                                  bottomRight: const Radius.circular(10.0),
                                  topRight: const Radius.circular(10.0),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(

                                  mainAxisAlignment: completed.length>0?MainAxisAlignment.start:  MainAxisAlignment.center,

                                  children: [
                                    Center(child: Text("Completed",
                                      style: TextStyle(color:group=="completed"? Colors.black:Colors.grey.withOpacity(0.8),
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold),)),

                                    completed.length>0?   Badge(
                                      badgeColor: Theme.of(context).scaffoldBackgroundColor,
                                      badgeContent: Text(completed.length.toString()),
                                      child: Padding(
                                        padding: const EdgeInsets.all(3.0),
                                        child: SizedBox(width: 10,height: 10,),
                                      ),
                                    ):SizedBox(height: 0,width: 0,)
                                  ],
                                ),
                              ),

                            ),
                          ),
                        ),

                      ],),

                      SizedBox(height: 10,),

                      Certifications()
                    ],
                  ),
                ),

              ),
            )


          ],),
        ),
      ),
    );
  }


  Widget Certifications() {
    List<CertificationApplicationModel>applications = [];

    if(group=="pending"){

      applications=_con.applications.where((element) => element.status.status.toLowerCase()=="pending"||element.status.status.toLowerCase()=="expired").toList();
    }

    else if(group=="scheduled"){
      applications=_con.applications.where((element) => element.status.status.toLowerCase()=="scheduled"|| element.status.status.toLowerCase()=="accepted"|| element.status.status.toLowerCase()=="paid").toList();
    }

    else if(group=="completed"){
      applications=_con.applications.where((element) => element.status.status.toLowerCase()=="completed"||element.status.status.toLowerCase()=='completed').toList();


    }
    return  _con.loading?Center(child: CircularProgressIndicator()): applications.length<1?Container(
      height: height*0.3,
      child: RefreshIndicator(

        onRefresh: () async {
          _con.refreshHome();
        },
        child: ListView(
          children: [
            Container(

                height: height*0.3,

                child: Center(child: Text("You dont have any ${group} applications",style: TextStyle(color: Colors.black,fontSize: 10.0,fontWeight: FontWeight.w500),))),
          ],
        ),
      ),
    ):Flexible(
      child: RefreshIndicator(
        onRefresh: () async {
          _con.refreshHome();
        },
        child: ListView.builder(
            itemCount: applications.length,
            itemBuilder: (BuildContext context, int index) {
              return 1==1?CertItemWidget(
                onSelected: (model) {
                  print("onselected");
                  _con.CancelApplication(
                      context, {"id": applications[index].id},
                      index);
                },

color: _con.getColor(),
                onReschedule: (model) {
                  Navigator.of(context)
                      .pushNamed('/${model.status.client_next
                      .toLowerCase()}', arguments: model)
                      .then((value) {
                    _con.refreshHome();
                    return null;
                  });
                  // _modalBottomSheetMenu(applications[index]);

                },

                onClick: (model) {
                  // _con.GetApplication(model.id,context);


                  if (model.status.status.toLowerCase() ==
                      'pending') {
                    Navigator.of(context).pushNamed(
                        '/${model.status.client_next
                            .toLowerCase()}',
                        arguments: ClientApplication(id: model.id,
                            message: null,
                            client_next: model.status
                                .client_next)).then((value) {
                      _con.refreshHome();
                      return null;
                    });
                  }

                  else {
                    Navigator.of(context).pushNamed(
                        '/${model.status.client_next
                            .toLowerCase()}',
                        arguments: ClientApplication(id: model.id,
                            message: null,
                            client_next: model.status
                                .client_next)).then((value) {
                      _con.refreshHome();

                      return null;
                    });
                  }
                },

                applicationModel: applications[index],
                expanded: index == 0 ? true : false,
              ): Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(5))
                  ),
                  child: ListTile(
                    title: Text("Order number ${applications[index].id}", style: TextStyle(
                        color: Colors.black,
                        fontSize: 10,
                        fontWeight: FontWeight.bold),),
                    subtitle: Text(applications[index].getPostDate(), style: TextStyle(
                        color: Colors.grey.withOpacity(0.8),
                        fontSize: 10,
                        fontWeight: FontWeight.w200),),
                    leading: Container(
                      height: 35, width: 35,
                      decoration: BoxDecoration(
                          color: _con.getColor(),
                          border: Border.all(
                            color: Colors.white,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(5))
                      ),

                      child: Center(child: Icon(
                        Icons.folder_open_outlined, color: Colors.white,
                        size: 25,)),

                    ),

                  ),
                ),
              );
            }
        ),
      ),
    );
  }

}