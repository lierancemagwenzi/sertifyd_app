import 'package:flutter/material.dart';
import 'package:group_button/group_button.dart';
import 'package:horizon/src/controllers/AdminController.dart';
import 'package:horizon/src/controllers/PaymentController.dart';
import 'package:horizon/src/model/AdminApplication.dart';
import 'package:horizon/src/model/ApplicationModel.dart';
import 'package:horizon/src/model/ZoomMettingModel.dart';
import 'package:horizon/src/repositories/user_repository.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:horizon/src/controllers/application_controller.dart';
import 'package:horizon/src/elements/CertItemWidget.dart';
import 'package:horizon/src/elements/CircularLoadingWidget.dart';
import 'package:horizon/src/elements/DocumentItemView.dart';
import 'package:horizon/src/elements/ProductCertItemWidget.dart';
import 'package:horizon/src/elements/SingleCertItem.dart';
import 'package:horizon/src/helper/Helper.dart';
import 'package:intl/intl.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:url_launcher/url_launcher.dart';

class AcceptWidget extends StatefulWidget {

  AdminApplicationModel adminApplicationModel;
  AcceptWidget({Key key, this.adminApplicationModel}) : super(key: key);

  @override
  _AcceptWidgetState createState() => _AcceptWidgetState();
}

class _AcceptWidgetState extends StateMVC<AcceptWidget> {

  AdminController _con;

  _AcceptWidgetState() : super(AdminController()) {
    _con = controller;
  }
  List<String> buttons=['Now','Later'];
  String time='Now';

  String selected_time;

  @override
  void initState() {


    _con.listenForJobApplication(widget.adminApplicationModel.id);
    _calendarController = CalendarController();


    if(widget.adminApplicationModel.message!=null){

      Future.delayed(const Duration(seconds: 1), () {

        _con.scaffoldKey?.currentState?.showSnackBar(SnackBar(
          content: Text(widget.adminApplicationModel.message??''),
        ));

      });
    }

    super.initState();
  }

  CalendarController _calendarController;


  DateTime date=DateTime.now();
  void _onDaySelected(DateTime day, List events, List holidays) {

    setState(() { this.date=day;});

    print('CALLBACK: _onDaySelected');


  }


  @override
  Widget build(BuildContext context) {

    DateTime parseDate = _con.certificationApplicationModel==null?DateTime.now():new DateFormat("yyyy-MM-dd").parse(
        _con.certificationApplicationModel.date);
    return Scaffold(
key: _con.scaffoldKey,
        bottomNavigationBar:_con.certificationApplicationModel==null?null:  BottomAppBar(

          child:   SafeArea(

            child: Container(
              height: MediaQuery.of(context).size.height*0.2,
              color: Colors.white,
              child: Column(
                children: [

                  SlotWidget(),
Divider(color: Colors.grey,),
                  SizedBox(height: 15,),

                  Row(children: [


                    Expanded(


                      child:                       Helper.findFreeSlots(_con.schedule, _con.certificationApplicationModel, context).length<1?Center(child: Text("No free slots available for this job",style: TextStyle(color: Colors.black,fontSize: 10.0),)):
                      InkWell(
                        onTap: (){

                          if(_con.loading||Helper.findFreeSlots(_con.schedule, _con.certificationApplicationModel, context).length<1){


                          }

                          else{
                            _submit();
                          }

                        },
                        child: Container(

                          child: Center(child: Text("Take Job",style: TextStyle(color: Theme.of(context).accentColor,fontSize: 12.0,fontWeight: FontWeight.bold),)),

                        ),
                      ),
                    ),

                  ],),
                ],
              ),
            ),
          ),
        ),
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




          title: Text("Application Details",style: TextStyle(color: Colors.black,fontSize: 15.0,fontWeight: FontWeight.bold),),

        ),
        body:    _con.certificationApplicationModel == null
            ? CircularLoadingWidget(height: 500)
            :1==1?Body(): SafeArea(

              child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
              CustomScrollView(
                primary: true,
                shrinkWrap: false,
                slivers: <Widget>[
//             SliverAppBar(
//               backgroundColor: Theme.of(context).accentColor.withOpacity(0.9),
//               expandedHeight: 300,
//               elevation: 0,
// //                          iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
//               automaticallyImplyLeading: false,
//               leading:1==1?null: new IconButton(
//                 icon: new Icon(Icons.sort, color: Theme.of(context).primaryColor),
//                 onPressed: () {
//                 },
//               ),
//               flexibleSpace: FlexibleSpaceBar(
//                 collapseMode: CollapseMode.parallax,
//                 background:       Container(
//
//
//                   child: SfCalendar(view: CalendarView.schedule,
//                     dataSource: MeetingDataSource(
//                         _getDataSource(_con.certificationApplicationModel, parseDate, context)),
//                     initialDisplayDate: parseDate,),
//                 ),
//               ),
//             ),
                  SliverToBoxAdapter(
                    child: Wrap(
                      children: [

                        Container(height: 30.0,),
                        // Padding(
                        //   padding: const EdgeInsets.only(right: 20, left: 20, bottom: 10, top: 25),
                        //   child: Row(
                        //     crossAxisAlignment: CrossAxisAlignment.start,
                        //     children: <Widget>[
                        //       Expanded(
                        //         child: Text(
                        //           'Name',
                        //           overflow: TextOverflow.fade,
                        //           softWrap: false,
                        //           maxLines: 2,
                        //           style: Theme.of(context).textTheme.headline3,
                        //         ),
                        //       ),
                        //       SizedBox(
                        //         height: 32,
                        //         child: Chip(
                        //           padding: EdgeInsets.all(0),
                        //           label: Row(
                        //             mainAxisAlignment: MainAxisAlignment.center,
                        //             children: <Widget>[
                        //               Text("40",
                        //                   style: Theme.of(context).textTheme.bodyText1.merge(TextStyle(color: Theme.of(context).primaryColor))),
                        //               Icon(
                        //                 Icons.star_border,
                        //                 color: Theme.of(context).primaryColor,
                        //                 size: 16,
                        //               ),
                        //             ],
                        //           ),
                        //           backgroundColor: Theme.of(context).accentColor.withOpacity(0.9),
                        //           shape: StadiumBorder(),
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),

                        _con.certificationApplicationModel.satifyer_id==null&& Helper.findFreeSlots(_con.schedule, _con.certificationApplicationModel, context).length>0? Padding(
                          padding: const EdgeInsets.symmetric(horizontal:8.0),
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: Theme.of(context).primaryColorLight,
                                ),
                                borderRadius: BorderRadius.all(Radius.circular(5))
                            ),

                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Job is available"),Container(
                                      decoration: BoxDecoration(
                                          color: Colors.transparent,
                                          border: Border.all(
                                            color: Theme.of(context).primaryColorLight,
                                          ),
                                          shape: BoxShape.circle
                                      ),
                                      child: Icon(Icons.done,size: 20.0,))
                                ],),
                            ),
                          ),
                        ):Container(height: 0.0,width: 0.0,),
                        Container(height: 15.0,),
                        SingleCertItem(
                          applicationModel: _con.certificationApplicationModel,
                          expanded: true,
                        ),


                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: ListTile(
                            dense: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 0),
                            leading: Icon(
                              Icons.description,
                              color: Theme.of(context).hintColor,
                            ),
                            title: Text(
                              "Description",
                              style: Theme.of(context).textTheme.headline4.copyWith(fontSize: 15.0),
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          child: Text(_con.certificationApplicationModel.description),
                        ),


                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: ListTile(
                            dense: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 0),
                            leading: Icon(
                              Icons.schedule,
                              color: Theme.of(context).hintColor,
                            ),
                            title: Text(
                              "Your Schedule",
                              style: Theme.of(context).textTheme.headline4.copyWith(fontSize: 15.0),
                            ),
                          ),
                        ),
                        SizedBox(height: 20,),
                        Divider(color: Colors.grey,),

                        Card(
                          child: TableCalendar(
                            initialCalendarFormat: CalendarFormat.week,
                            calendarController: _calendarController,
                            startDay: _con.certificationApplicationModel.getInitialDate(),
                            initialSelectedDay: _con.certificationApplicationModel.getInitialDate(),
                            endDay: _con.certificationApplicationModel.getInitialDate().add(Duration(days: 0)),


                            onDaySelected: (date, events, holidays) {
                              _onDaySelected(date, events, holidays);
                            },
                          ),
                        ),SizedBox(height: 20,),


                       _con.schedule.isEmpty?CircularLoadingWidget(height: 60,): ListView.builder(
                            itemCount: _con.schedule.length,
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            primary: false,
                            itemBuilder: (BuildContext context,int index){
                              return ListTile(

                                onTap: (){

                                  Helper.findFreeSlots(_con.schedule, _con.certificationApplicationModel, context);
                                },
                                  leading: Icon(Icons.list),
                                  title:Text(Helper.getSlotTime(_con.schedule[index]))
                              );
                            }
                        ),

                        Divider(color: Colors.grey,),
                        // Padding(
                        //   padding: const EdgeInsets.symmetric(horizontal: 20),
                        //   child: ListTile(
                        //     dense: true,
                        //     contentPadding: EdgeInsets.symmetric(vertical: 0),
                        //     leading: Icon(
                        //       Icons.watch_later,
                        //       color: Theme.of(context).hintColor,
                        //     ),
                        //     title: Text(
                        //       "Requested Time",
                        //       style: Theme.of(context).textTheme.headline4,
                        //     ),
                        //   ),
                        // ),
                        //
                        // Padding(
                        //   padding: const EdgeInsets.symmetric(horizontal:10.0),
                        //   child: GroupButton(
                        //     spacing: 15,
                        //     isRadio: true,
                        //     borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        //     unselectedColor:Theme.of(context).primaryColor,
                        //     unselectedTextStyle: TextStyle(color: Theme.of(context).accentColor,fontWeight: FontWeight.bold),
                        //     selectedTextStyle: TextStyle(color:Colors.white70,fontWeight: FontWeight.bold),
                        //     selectedColor: Theme.of(context).primaryColorLight,
                        //     direction: Axis.horizontal,
                        //     onSelected: (index, isSelected) {
                        //       setState(() {
                        //         // time=buttons[index];
                        //       });
                        //       if(isSelected){
                        //
                        //       }
                        //       else{
                        //
                        //       }
                        //       print(
                        //           '$index button is ${isSelected ? 'selected' : 'unselected'}');
                        //     },
                        //     buttons: [         _con.certificationApplicationModel.slot],
                        //     selectedButtons: [
                        //       _con.certificationApplicationModel.slot
                        //     ],
                        //   ),
                        // ),
                        // ImageThumbCarouselWidget(galleriesList: _con.galleries),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: ListTile(
                            dense: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 0),
                            leading: Icon(
                              Icons.person,
                              color: Theme.of(context).hintColor,
                            ),
                            title: Text(
                              "Client",
                              style: Theme.of(context).textTheme.headline4.copyWith(fontSize: 15.0),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          color: Theme.of(context).primaryColor,
                          child: Column(
                            children: [

                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      _con.certificationApplicationModel.applicant.getFullname(),
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context).textTheme.bodyText1,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  SizedBox(
                                    width: 42,
                                    height: 42,
                                    child: FlatButton(
                                      padding: EdgeInsets.all(0),
                                      onPressed: () {
                                        // launch("tel:${_con.market.mobile}");
                                      },
                                      child: Icon(
                                        Icons.account_circle,
                                        color: Theme.of(context).primaryColor,
                                        size: 24,
                                      ),
                                      color: Theme.of(context).accentColor.withOpacity(0.9),
                                      shape: StadiumBorder(),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      _con.certificationApplicationModel.applicant.mobile,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context).textTheme.bodyText1,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  SizedBox(
                                    width: 42,
                                    height: 42,
                                    child: FlatButton(
                                      padding: EdgeInsets.all(0),
                                      onPressed: () {
                                        // launch("tel:${_con.market.mobile}");
                                      },
                                      child: Icon(
                                        Icons.email_outlined,
                                        color: Theme.of(context).primaryColor,
                                        size: 24,
                                      ),
                                      color: Theme.of(context).accentColor.withOpacity(0.9),
                                      shape: StadiumBorder(),
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: 20),
                              _con.certificationApplicationModel.status.can_chat?  Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      "Send In app Message",
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context).textTheme.bodyText1,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  SizedBox(
                                    width: 42,
                                    height: 42,
                                    child: FlatButton(
                                      padding: EdgeInsets.all(0),
                                      onPressed: () {
                                        // launch("tel:${_con.market.mobile}");
                                      },
                                      child: Icon(
                                        Icons.chat_bubble,
                                        color: Theme.of(context).primaryColor,
                                        size: 24,
                                      ),
                                      color: Theme.of(context).accentColor.withOpacity(0.9),
                                      shape: StadiumBorder(),
                                    ),
                                  ),
                                ],
                              ):SizedBox(height: 0.0,width: 0.0,),
                            ],
                          ),
                        ),
                        _con.certificationApplicationModel.documents.isEmpty
                            ? SizedBox(height: 0)
                            : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: ListTile(
                            dense: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 0),
                            leading: Icon(
                              Icons.folder,
                              color: Theme.of(context).hintColor,
                            ),
                            title: Text(
                              "documents",
                              style: Theme.of(context).textTheme.headline4.copyWith(fontSize: 15.0),
                            ),
                          ),
                        ),
                        _con.certificationApplicationModel.documents.isEmpty
                            ? SizedBox(height: 0)
                            : ListView.separated(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          primary: false,
                          itemCount: _con.certificationApplicationModel.documents.length,
                          separatorBuilder: (context, index) {
                            return SizedBox(height: 10);
                          },
                          itemBuilder: (context, index) {
                            return DocumentItemView(
                              heroTag: 'details_featured_product',
                              productOrder:_con. certificationApplicationModel.documents[index],
                              applicationModel: _con.certificationApplicationModel,
                            );
                          },
                        ),

             SlotWidget(),
                        SizedBox(height: 100),
                        _submitButton()
                        // Padding(
                        //   padding: const EdgeInsets.symmetric(horizontal:15.0),
                        //   child:  _submitButton(),
                        // )
                        // _con.reviews.isEmpty
                        //     ? SizedBox(height: 5)
                        //     : Padding(
                        //   padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        //   child: ListTile(
                        //     dense: true,
                        //     contentPadding: EdgeInsets.symmetric(vertical: 0),
                        //     leading: Icon(
                        //       Icons.recent_actors,
                        //       color: Theme.of(context).hintColor,
                        //     ),
                        //     title: Text(
                        //       S.of(context).what_they_say,
                        //       style: Theme.of(context).textTheme.headline4,
                        //     ),
                        //   ),
                        // ),
                        // _con.reviews.isEmpty
                        //     ? SizedBox(height: 5)
                        //     : Padding(
                        //   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        //   child: ReviewsListWidget(reviewsList: _con.reviews),
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
              // Positioned(
              //   top: 32,
              //   right: 20,
              //   child: ShoppingCartFloatButtonWidget(
              //       iconColor: Theme.of(context).primaryColor,
              //       labelColor: Theme.of(context).hintColor,
              //       routeArgument: RouteArgument(id: '0', param: _con.market.id, heroTag: 'home_slide')),
              // ),


            _con.loading?Center(child: CircularProgressIndicator()):SizedBox(height: 0,width: 0,)
          ],
        ),
            )

    );
  }

  SlotWidget(){

    return  Helper.findFreeSlots(_con.schedule, _con.certificationApplicationModel, context).length<1?SizedBox(height: 0,width: 0,) :Padding(
      padding: const EdgeInsets.symmetric(horizontal:15.0),
      child: Column(children: [

        SizedBox(height: 5,),

        Row(
          children: [
            Text("Select a time slot",style: Theme.of(context).textTheme.headline4.copyWith(fontSize: 12.0,color: Colors.black)),
          ],
        ),

        SizedBox(height: 10,),
       Row(
         children: [
           GroupButton(
             isRadio: true,
             direction: Axis.horizontal,
             borderRadius: BorderRadius.all(Radius.circular(5)),
             spacing: 10,
             selectedColor: Theme.of(context).primaryColorLight,
             onSelected: (index, isSelected) {
               setState(() {              selected_time=Helper.findFreeSlots(_con.schedule, _con.certificationApplicationModel, context)[index]; });

               print('$index button is selected');
             },
             selectedButtons: [],
             buttons:   Helper.findFreeSlots(_con.schedule, _con.certificationApplicationModel, context),
           ),
         ],
       ),
      ],),
    );
  }
  Widget _submitButton() {
    return InkWell(
      onTap: (){
        if(_con.loading||Helper.findFreeSlots(_con.schedule, _con.certificationApplicationModel, context).length<1){}

        else{
          _submit();
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal:15.0),
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(vertical: 15),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.grey.shade200,
                    offset: Offset(2, 4),
                    blurRadius: 5,
                    spreadRadius: 2)
              ],
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors:Helper.findFreeSlots(_con.schedule, _con.certificationApplicationModel, context).length<1?[Theme.of(context).accentColor.withOpacity(0.3),Theme.of(context).accentColor.withOpacity(0.3)]: [Theme.of(context).accentColor,Theme.of(context).accentColor])),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Take  Job',
                style: TextStyle(fontSize: 20, color: Colors.white.withOpacity(0.7)),

              ),
              SizedBox(width: 20.0,),
              Icon(Icons.done,color: Colors.white,)
            ],
          ),
        ),
      ),
    );
  }




  _submit(){

    if(Helper.findFreeSlots(_con.schedule, _con.certificationApplicationModel, context).length==1){

      selected_time=Helper.findFreeSlots(_con.schedule, _con.certificationApplicationModel, context)[0];
    }

    if(selected_time==null){
      _con.scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text('Pick a  time slot '),
      ));
    }
    else{
    ZoomMeetingModel zoomMeetingModel;

    if(_con.certificationApplicationModel.start_time.toLowerCase()=="immediately"){

      var formatter = new DateFormat("yyyy-MM-ddTHH:mm:ss");

      var start_time=  formatter.format(new DateTime.now().add(Duration(minutes: 5)));

      zoomMeetingModel=new ZoomMeetingModel(start_time: start_time+"Z");

    }
    else{
      String  date=_con.certificationApplicationModel.date+" "+selected_time.split("-")[0];
      DateTime parseDate = new DateFormat("yyyy-MM-dd HH:mm").parse(date);
      var formatter = new DateFormat("yyyy-MM-ddTHH:mm:ss");
      DateTime newdate=DateTime(parseDate.year,parseDate.month,parseDate.day,parseDate.hour,parseDate.minute);
      var start_time=  formatter.format(newdate)+"Z";

      print(parseDate.day.toString());
      // print(parseDate.day.toString())
      zoomMeetingModel=new ZoomMeetingModel(start_time: start_time);
      print(start_time);

      _con.AcceptJob({"application_id":_con.certificationApplicationModel.id,"sertifyer_id":currentuser.value.id,"slot":start_time,"status":_con.certificationApplicationModel.paymentModel!=null?"paid":"accepted"},context);

    }



    // _con.CreateMeeting(zoomMeetingModel,context);
  }}

  void _launchURL(String _url) async =>
      await canLaunch(_url)
          ? await launch(_url)
          : throw 'Could not launch $_url';


  getTime(){
    DateTime parseDate = new DateFormat("yyyy-MM-dd").parse(
        _con.certificationApplicationModel.date);

    var formatter = new DateFormat("yyyy-MM-ddTHH:mm:ssZ");

    DateTime meetingTime = formatter.parse(
        _con. certificationApplicationModel.zoom.start_time);

    var weekday = DateFormat('EEEE').format(parseDate);
    var time = DateFormat('HH:mm').format(meetingTime);

    return time??_con.certificationApplicationModel.zoom.start_time;

  }
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
  void _modalBottomSheetMenu(){
    showModalBottomSheet(
        context: context,
        builder: (builder){
          return new Container(
            height: 350.0,
            color: Colors.transparent, //could change this to Color(0xFF737373),
            //so you don't have to change MaterialApp canvasColor
            child: new Container(
                decoration: new BoxDecoration(
                    color: Colors.white,
                    borderRadius: new BorderRadius.only(
                        topLeft: const Radius.circular(10.0),
                        topRight: const Radius.circular(10.0))),
                child: new Center(
                  child: new Text("This is a modal sheet"),
                )),
          );
        }
    );
  }


  Widget Body(){


    return Padding(
      padding: const EdgeInsets.symmetric(horizontal:15.0),
      child: Stack(
        children: [
          SingleChildScrollView(

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                SizedBox(height: 30,),
                Row(children: [
                  Container(
                    height: 60,width: 60,
                    decoration: BoxDecoration(
                        color: _con.getColor(),
                        border: Border.all(
                          color: Colors.grey.withOpacity(0.2),
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(10))
                    ),
                    child: Center(child: Text(_con.certificationApplicationModel.id.toString(),style: TextStyle(color: Colors.white,fontSize: 15.0,fontWeight: FontWeight.bold),)),
                  ),  SizedBox(width: 30,),

                  Expanded(

                    child: Container(

                      height: 60,
                      decoration: BoxDecoration(
                          color: Colors.white,

                          border: Border.all(
                            color: Colors.grey.withOpacity(0.2),

                          ),
                          borderRadius: BorderRadius.all(Radius.circular(10))
                      ),
                      child: Center(
                        child: ListTile(


                          title: Text("Status",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 12.0),),

                          subtitle: Padding(
                            padding: const EdgeInsets.only(bottom:8.0),
                            child: Text(_con.certificationApplicationModel.status.status,style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 10.0),),
                          ),

                        ),
                      ),
                    ),
                  )
                ],),
                SizedBox(height: 15,),
                Container(
                  // height: 100,
                  decoration: BoxDecoration(
                      color: Colors.white,

                      border: Border.all(
                        color: Colors.grey.withOpacity(0.2),

                      ),
                      borderRadius: BorderRadius.all(Radius.circular(10))
                  ),
                  child: Column(
                    children: [

                      _con.certificationApplicationModel.status.admin_explanation!=null?   ListTile(

                        title: Text("Description",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 12.0),),

                        subtitle: Text( _con.certificationApplicationModel.status?.admin_explanation??''
                          ,style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 10.0),),
                      ):SizedBox(height: 0,width: 0,),
                      ListTile(

                        title: Text("Posted On",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 12.0),),

                        subtitle: Text(_con.certificationApplicationModel.getPostDate(),style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 10.0),),
                      ),
                      ListTile(

                        title: Text("Scheduled For",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 12.0),),

                        subtitle: Text(_con.certificationApplicationModel.getWanteddate(),style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 10.0),),
                      ),
                      ListTile(

                        title: Text("About application",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 12.0),),

                        subtitle: Text( _con.certificationApplicationModel.description
                          ,style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 10.0),),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 15,),
                DefaultTabController(
                  length: 2,
                  child: Column(
                    children: [
                      Container(
                        height: 60,
                        decoration: BoxDecoration(
                            color: Colors.white,

                            border: Border.all(
                              color: Colors.grey.withOpacity(0.2),

                            ),
                            borderRadius: BorderRadius.all(Radius.circular(10))
                        ),

                        child: TabBar(
                          indicatorColor: Theme.of(context).accentColor,
                          indicatorWeight: 3.0,
                          isScrollable: false,
                          labelStyle: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 15.0),
                          tabs: [
                            // Tab(text: "Details",),
                            Tab(text:"Client"),
                            Tab(text: "Documents",),
                          ],

                        ),

                      ),

                      Container(
                        height: MediaQuery.of(context).size.height*0.4,
                        child: TabBarView(
                          children: [
                            Client(),
                            Documents(),
                          ],
                        ),
                      )
                    ],
                  ),
                )

              ],),
          ),

          _con.loading?Center(child: CircularProgressIndicator()):SizedBox(height: 0,width: 0,)

        ],
      ),
    );
  }


  Client(){

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal:15.0),
      child: Column(children: [


        SizedBox(height: 30,),

        Center(child: Text("Client Details",style: TextStyle(color: Colors.black,fontSize: 12.0,fontWeight: FontWeight.bold),)),

        SizedBox(height: 30,),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: [

            Text("Name",style: TextStyle(fontSize: 12.0,fontWeight: FontWeight.bold,color: Colors.black),),Text(_con.certificationApplicationModel.applicant.getFullname(),style: TextStyle(fontSize: 12.0,fontWeight: FontWeight.bold),),

          ],),
        SizedBox(height: 30,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: [

            Text("Email",style: TextStyle(fontSize: 12.0,fontWeight: FontWeight.bold,color: Colors.black),),Text(_con.certificationApplicationModel.applicant.mobile,style: TextStyle(fontSize: 12.0,fontWeight: FontWeight.bold),),

          ],),
        SizedBox(height: 30,),


      ],),
    );
  }
  Documents(){

    return  Column(
      children: [
        SizedBox(height: 10,),
        Container(
          height: MediaQuery.of(context).size.height*0.28,
          width: double.infinity,
          decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey.withOpacity(0.1),

              ),
              borderRadius: BorderRadius.all(Radius.circular(15))
          ),

          child:  ListView.builder(
              itemCount: _con.certificationApplicationModel.documents.length,
              itemBuilder: (BuildContext context,int index){
                return 1==1?DocumentItemView(
                  heroTag: 'details_featured_product',
                  color: _con.getColor(),
                  productOrder:_con. certificationApplicationModel.documents[index],
                  applicationModel: _con.certificationApplicationModel,
                ):Container(

                  decoration: new BoxDecoration(
                    border: Border(
                      bottom: BorderSide( //                   <--- left side
                        color: Colors.grey.withOpacity(0.1),

                        width: 1.0,
                      ),

                    ),
                  ),
                  child: ListTile(
                    leading: Container(
                      height: 50,width: 50,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.grey.withOpacity(0.1),

                          ),
                          borderRadius: BorderRadius.all(Radius.circular(5))
                      ),
                      child: Center(
                        child: Container(

                          height: 40,width: 40,
                          decoration: BoxDecoration(
                              color: _con.getColor(),
                              border: Border.all(
                                color: Colors.grey.withOpacity(0.1),

                              ),
                              borderRadius: BorderRadius.all(Radius.circular(5))
                          ),
                          child: Center(child: Text(_con.certificationApplicationModel.documents[index].path.split('.').last.toUpperCase(),style: TextStyle(color: Colors.white,fontSize: 10.0,fontWeight: FontWeight.bold),)),
                        ),
                      ),
                    ),
                    title:Text(_con.certificationApplicationModel.documents[index].documentTypeModel.type,style: TextStyle(color: Colors.black,fontSize: 15.0,fontWeight: FontWeight.bold),),
                    trailing:  Text("Open",style: TextStyle(color: Colors.black,fontSize: 10,fontWeight: FontWeight.bold),),


                    subtitle:  Text(_con.certificationApplicationModel.documents[index].documentTypeModel.country.currency+_con.certificationApplicationModel.documents[index].documentTypeModel.price,style: TextStyle(color: Colors.black,fontSize: 10,fontWeight: FontWeight.bold),),

                  ),
                );
              }
          ),
        ),
      ],
    );
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
