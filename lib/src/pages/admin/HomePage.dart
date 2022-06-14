import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:horizon/src/controllers/AdminController.dart';
import 'package:horizon/src/elements/AppointmentWidget.dart';
import 'package:horizon/src/elements/EmptyApplicationsWidget.dart';
import 'package:horizon/src/elements/EmptyDayJobsWidget.dart';
import 'package:horizon/src/elements/EmptyJobsWidget.dart';
import 'package:horizon/src/elements/UpdateSignatureWidget.dart';
import 'package:horizon/src/elements/admin/AdminCertItemWidget.dart';
import 'package:horizon/src/model/AdminApplication.dart';
import 'package:horizon/src/model/ApplicationModel.dart';
import 'package:horizon/src/repositories/user_repository.dart';
import 'package:intl/intl.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:table_calendar/table_calendar.dart';

class AdminHomePage extends StatefulWidget {

  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends StateMVC<AdminHomePage> {


  AdminController _con;

  _AdminHomePageState() : super(AdminController()) {
    _con = controller;
  }

  CalendarController _calendarController;


  DateTime date;
  void _onDaySelected(DateTime day, List events, List holidays) {

    setState(() { this.date=day;});

    print('CALLBACK: _onDaySelected');


  }
  double height;
  double width;


  String group="jobs";

  @override
  void initState() {
    _con.listenForApplications();

    _con.listenForScheduledApplications();
    _con.listenForUpcomingApplications();
    _calendarController = CalendarController();

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final f = new DateFormat('yyyy-MM-dd');

    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    List<CertificationApplicationModel>  applications= this.date==null?_con.applications:_con.applications.where((i) => i.date==f.format(this.date)).toList();


    return Scaffold(
      key: _con.scaffoldKey,
        body:1==1?Body():Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            child:         RefreshIndicator(
             onRefresh: () async {
          _con.refreshJobs();
          },
              child: ListView(
                children: [
                  SingleChildScrollView(

                    child: Column(
                      children: [
                        GreetingWidget(),
                        SizedBox(height: 20,),
                        _con.applications.length<1?SizedBox(height: 0,width: 0,):   Card(

                          child: TableCalendar(
                            initialCalendarFormat: CalendarFormat.week,

                            calendarController: _calendarController,
                            startDay: DateTime.now(),
                            endDay: DateTime.now().add(Duration(days: 7)),

                            onDaySelected: (date, events, holidays) {
                              _onDaySelected(date, events, holidays);
                            },
                          ),
                        ),SizedBox(height: 20,),
                      _con.applications.length<1?SizedBox(height: 0,width: 0,):  Divider(color: Colors.grey,),

                        UpdateSignatureWidget(),

                        _con.applications.length<1?SizedBox(height: 0,width: 0,):     ListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          // leading: Icon(
                          //   Icons.format_align_justify,
                          //   color: Theme.of(context).hintColor,
                          // ),
                          title: Text(
                            "Certification jobs",
                            style: Theme.of(context).textTheme.headline4,
                          ),

                          trailing:_con.applications.length==0?null: InkWell(

                              onTap: (){
                                if(this.date!=null){
                                  // _calendarController.setFocusedDay(null);
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
                                  ))),
                        ),
                      _con.applications.length<1?EmptyJobsWidget():applications.length<1?EmptyDayJobsWidget():  ListView.builder(
                            itemCount: applications.length,
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            primary: false,
                            itemBuilder: (BuildContext context,int index){
                              return AdminCertItemWidget(

                                Onnosignature: (model){

                                  _con.scaffoldKey?.currentState?.showSnackBar(SnackBar(
                                    content: Text(model),
                                  ));


                                  // Navigator.of(context).pushNamed('/${model.status.client_next.toLowerCase()}', arguments: model.id);

                                },
                                onClick: (model){

                                  print(model.status.admin.toLowerCase()=="action");
                                  if(model.status.admin.toLowerCase()=="action"){
                                    print(model.status.admin.toLowerCase()=="action");

                                    _con.GetJobApplication(model.id,context);
                                  }

                                  else{


                                    Navigator.of(context).pushNamed('/${model.status.admin_next.toLowerCase()}', arguments: AdminApplicationModel(id: model.id,admin_next: model.status.admin_next,message: null)).then((value) {

                                      _con.refreshJobs();
                                      return null;
                                    });


                                    // _con.GetApplication(model.id,context);

                                  }
                                  //


                                  // Navigator.of(context).pushNamed('/${model.status.client_next.toLowerCase()}', arguments: model.id);

                                },
scaffoldKey: _con.scaffoldKey,
                                applicationModel: applications[index],
                                expanded: index==0?true:false,
                              );
                            }

                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

          ),
        )

    );
  }

  Widget GreetingWidget() {
    return _con.applications.length < 1
        ? SizedBox(height: 0, width: 0,)
        : Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(

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
            ],



          ),

        ],
      ),
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
    return SafeArea(

      child: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(children: [

            GreetingWidget(),
            SizedBox(height: 16,),

            UpdateSignatureWidget(),

            SizedBox(height: 5,),
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

                                group="jobs";

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

                                  mainAxisAlignment: _con.applications.length>0?MainAxisAlignment.start:  MainAxisAlignment.center,

                                  children: [
                                    Center(child: Text("Jobs",
                                      style: TextStyle(color:group=="jobs"? Colors.black:Colors.grey.withOpacity(0.8),

                                          fontSize: 10,
                                          fontWeight: FontWeight.bold),)),

                                    _con.applications.length>0?   Badge(
                                      badgeColor: Theme.of(context).scaffoldBackgroundColor,
                                      badgeContent: Text(_con.applications.length.toString()),
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

                                  mainAxisAlignment: _con.scheduled.length>0?MainAxisAlignment.start:  MainAxisAlignment.center,

                                  children: [
                                    Center(child: Text("Scheduled",
                                      style: TextStyle(color:group=="scheduled"? Colors.black:Colors.grey.withOpacity(0.8),
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold),)),


                                    _con.scheduled.length>0?   Badge(
                                      badgeColor: Theme.of(context).scaffoldBackgroundColor,
                                      badgeContent: Text(_con.scheduled.length.toString()),
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

                                  mainAxisAlignment: _con.completed.length>0?MainAxisAlignment.start:  MainAxisAlignment.center,

                                  children: [
                                    Center(child: Text("Completed",
                                      style: TextStyle(color:group=="completed"? Colors.black:Colors.grey.withOpacity(0.8),
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold),)),


                                    _con.completed.length>0?   Badge(
                                      badgeColor: Theme.of(context).scaffoldBackgroundColor,
                                      badgeContent: Text(_con.completed.length.toString()),
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

    if(group=="jobs"){

      applications=_con.applications;
    }

    else if(group=="scheduled"){
      applications=_con.scheduled;
    }

    else if(group=="completed"){
      applications=_con.completed;


    }
    return _con.loading?Center(child: CircularProgressIndicator()):   applications.length<1?Container(
      height: height*0.3,

      child: RefreshIndicator(

        onRefresh: () async {
          _con.refreshJobs();
          _con.refreshUpcomingJobs();
          _con.refreshScheduledJobs();
        },
        child: ListView(
          children: [
            Container(

                height: height*0.3,

                child: Center(child: Text("You don't have any ${group} applications",style: TextStyle(color: Colors.black,fontSize: 10.0,fontWeight: FontWeight.w500),))),
          ],
        ),
      ),
    ):Flexible(
      child: RefreshIndicator(

        onRefresh: () async {
          _con.refreshJobs();
          _con.refreshUpcomingJobs();
          _con.refreshScheduledJobs();
        },
        child: ListView.builder(
            itemCount: applications.length,
            itemBuilder: (BuildContext context, int index) {
              return 1==1?AdminCertItemWidget(
color: _con.getColor(),
                Onnosignature: (model){

                  _con.scaffoldKey?.currentState?.showSnackBar(SnackBar(
                    content: Text(model),
                  ));


                  // Navigator.of(context).pushNamed('/${model.status.client_next.toLowerCase()}', arguments: model.id);

                },
                onClick: (model){

                  print(model.status.admin.toLowerCase()=="action");
                  if(model.status.admin.toLowerCase()=="action"){
                    print(model.status.admin.toLowerCase()=="action");

if(_con.loading){


}

else{

  setState(() {

    _con.loading=true;
  });
  _con.GetJobApplication(model.id,context);


}

                  }

                  else{


                    Navigator.of(context).pushNamed('/${model.status.admin_next.toLowerCase()}', arguments: AdminApplicationModel(id: model.id,admin_next: model.status.admin_next,message: null)).then((value) {

                      _con.refreshJobs();
                      _con.refreshScheduledJobs();
                      _con.refreshUpcomingJobs();
                      return null;
                    });


                    // _con.GetApplication(model.id,context);

                  }
                  //


                  // Navigator.of(context).pushNamed('/${model.status.client_next.toLowerCase()}', arguments: model.id);

                },
                scaffoldKey: _con.scaffoldKey,
                applicationModel: applications[index],
                expanded: index==0?true:false,
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
