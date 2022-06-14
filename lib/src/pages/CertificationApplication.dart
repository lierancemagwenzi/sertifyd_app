import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_uploader/flutter_uploader.dart';
import 'package:group_button/group_button.dart';
import 'package:horizon/src/controllers/application_controller.dart';
import 'package:horizon/src/elements/SearchWidget.dart';
import 'package:horizon/src/model/DocumentType.dart';
import 'package:horizon/src/model/SertificationDocument.dart';
import 'package:horizon/src/pages/ApplicationSuccess.dart';
import 'package:horizon/src/pages/CertificationApplicationProgress.dart';
import 'package:horizon/src/repositories/application_repository.dart';
import 'package:horizon/src/repositories/global_repository.dart';
import 'package:horizon/src/repositories/settings_repository.dart';
import 'package:horizon/src/repositories/user_repository.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:path/path.dart' as thepath;
import 'package:time_range/time_range.dart';


class CeertificationApplication extends StatefulWidget {
  @override
  _CeertificationApplicationState createState() => _CeertificationApplicationState();
}

class _CeertificationApplicationState extends StateMVC<CeertificationApplication> {
double height;
double width;
final _formKey = GlobalKey<FormState>();

  ApplicationController _con;

  _CeertificationApplicationState() : super(ApplicationController()) {
    _con = controller;
  }
List<FileItem> fileitems = [];
  CalendarController _calendarController;

  DateTime date=DateTime.now();

static const orange = Color(0xFFFE9A75);
static const dark = Color(0xFF333A47);
static const double leftPadding = 8;

List<String> buttons=['Now','Later'];
String time='Now';

bool is_urgent=false;

final _defaultTimeRange = TimeRangeResult(
  TimeOfDay(hour:  DateTime.now().add(Duration(minutes: 10)).hour, minute: DateTime.now().add(Duration(minutes: 10)).minute),
  TimeOfDay(hour:  DateTime.now().add(Duration(minutes: 30)).hour, minute: DateTime.now().add(Duration(minutes: 30)).minute),
);
TimeRangeResult _timeRange;

  @override
  void initState() {
    _con.listenForDocTypes();
    _calendarController = CalendarController();
    _timeRange = _defaultTimeRange;
    docs.value.clear();

    Map map={"action":"new_application","platform":Platform.isIOS?"ios":"android","user_id":currentuser.value.id??0,"device":detailsModel.value.identifier,"detail":"v",};

    log_activity(map);
    super.initState();
  }
  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  DocumentTypeModel documentTypeModel;
List<SertificationDocumentModel> documents=[];

  String description;


void _onDaySelected(DateTime day, List events, List holidays) {

  print('CALLBACK: _onDaySelected');
 this.date=day;

}


  @override
  Widget build(BuildContext context) {
    height=MediaQuery.of(context).size.height;
    width=MediaQuery.of(context).size.width;
    return Scaffold(
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




        title: Text("New Application ",style: TextStyle(color: Colors.black,fontSize: 15.0,fontWeight: FontWeight.bold),),

      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal:15.0),
        child: ListView(children: [
          SizedBox(height: 20,),
          // Text(
          //   'Select Date',
          //   style: Theme.of(context)
          //       .textTheme
          //       .headline6
          //       .copyWith(fontWeight: FontWeight.bold, color:Theme.of(context).accentColor),
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
          // ),SizedBox(height: 20,),
          Text(
            'Select a time slot',
            style: TextStyle(fontWeight: FontWeight.bold, color:Colors.black,fontSize: 12),
          ),

          SizedBox(height: 5),

          // GroupButton(
          //   spacing: 15,
          //   isRadio: true,
          //   borderRadius: BorderRadius.all(Radius.circular(5.0)),
          //   unselectedColor:Theme.of(context).primaryColor,
          //   unselectedTextStyle: TextStyle(color: Theme.of(context).accentColor,fontWeight: FontWeight.bold),
          //   selectedTextStyle: TextStyle(color:Colors.white70,fontWeight: FontWeight.bold),
          //   selectedColor: Theme.of(context).primaryColorLight,
          //   direction: Axis.horizontal,
          //   onSelected: (index, isSelected) {
          //     setState(() {
          //       time=buttons[index];
          //       if(time=="now"){
          //
          //         this.date=DateTime.now();
          //       }
          //     });
          //
          //
          //     if(isSelected){
          //
          //     }
          //     else{
          //
          //     }
          //     print(
          //         '$index button is ${isSelected ? 'selected' : 'unselected'}');
          //   },
          //   buttons: buttons,
          //   selectedButtons: [
          // 'Now'
          //   ],
          // ),
          // SizedBox(height: 20,),
          TimeWidget(),
          Text(
            'Documents Description',
            style: Theme.of(context)
                .textTheme
                .headline6
                .copyWith(fontWeight: FontWeight.bold, color:Colors.black,fontSize: 12.0),
          ),
Form(
  key: _formKey,
  child:    _entryField("Description",(input) => description = input,(input) => input==null||input.trim().length<1? " Enter a valid description" : null,),
),
          // Divider(color: Colors.grey,),

          SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Documents',
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    .copyWith(fontWeight: FontWeight.bold, color:Colors.black,fontSize: 12.0),
              ),             docs.value.length>0? InkWell(
                  onTap: (){
                    Navigator.of(context).push(SearchModal()).whenComplete(() {

                      setState(() {
                        docs.value=docs.value;
                      });
                      return null;
                    });

                  },
                  child: Icon(Icons.add_circle,color: Theme.of(context).accentColor,)):Text("")
            ],


          ),

          SizedBox(height: 20,),
          emptyDocuments(),
          SizedBox(height: 40.0,),
          _submitButton(),
          //
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.end,
          //   children: [
          //     RaisedButton.icon(
          //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          //       onPressed: () {
          //
          //         if(_formKey.currentState.validate()){
          //           _formKey.currentState.save();
          //           UploadFiles();
          //         }else{
          //
          //           _con.scaffoldKey?.currentState?.showSnackBar(SnackBar(
          //             content: Text("error with form"),
          //           ));
          //         }
          //       },
          //       textColor: Colors.white,
          //       color: Theme.of(context).accentColor,
          //       label: Text("Upload"),
          //       icon: Icon(Icons.file_upload,color: Colors.white,),
          //     ),
          //   ],
          // )
        ],),
      ),
    );
  }


  Widget _entryField(String title,onsaved,validator, {bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            style: TextStyle(color: Colors.black,fontSize: 12.0),
              onSaved: onsaved,
              validator:validator,
              obscureText: isPassword,
              decoration:getInputDecoration(title))
        ],
      ),
    );
  }


  getInputDecoration(String title){
    var Platform;
    return InputDecoration(
        border: InputBorder.none,
        fillColor: Color(0xfff3f3f4),
        filled: true);
  }


  TimeWidget(){

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final aDate = DateTime(this.date.year, this.date.month, this.date.day);


    final date2 = DateTime.now();
    final difference = date2.difference(DateTime(now.year, now.month, now.day,23,59,59,0)).inSeconds;


    return aDate == today? difference>0?Center(child: Text("No time available",style: TextStyle(color: Theme.of(context).accentColor),)): Column(children: [
    // Text(
    //   'Available Times',
    //   style: Theme.of(context)
    //       .textTheme
    //       .headline6
    //       .copyWith(fontWeight: FontWeight.bold, color:Theme.of(context).accentColor),
    // ),
    SizedBox(height: 5),
    TimeRange(
      fromTitle: Text(
        'FROM',
        style: TextStyle(
          fontSize: 10,
          color: Colors.black,
          fontWeight: FontWeight.w600,
        ),
      ),
      toTitle: Text(
        'TO',
        style: TextStyle(
          fontSize: 10,
          color: Colors.black,
          fontWeight: FontWeight.w600,
        ),
      ),
      titlePadding: leftPadding,
      textStyle: TextStyle(
        fontWeight: FontWeight.normal,
        fontSize: 10,
        color: Colors.black,
      ),
      activeTextStyle: TextStyle(
        fontWeight: FontWeight.normal,
        fontSize: 10,
        color: Colors.white,
      ),
      borderColor: Colors.black,

      activeBorderColor: Theme.of(context).accentColor,
      backgroundColor: Colors.transparent,
      activeBackgroundColor: Theme.of(context).accentColor,
      firstTime: TimeOfDay(hour: DateTime.now().add(Duration(minutes: 10)).hour, minute:DateTime.now().add(Duration(minutes: 10)).minute),
      lastTime: TimeOfDay(hour: 23, minute: 59),
      initialRange: _timeRange,
      timeStep: 30,
      timeBlock: 30,
      onRangeCompleted: (range) => setState(() {
        return _timeRange = range;
      }),
    ),
    SizedBox(height: 30),
    if (_timeRange != null)
      Padding(
        padding: const EdgeInsets.only(top: 8.0, left: leftPadding),
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
  ],):TimeWidget2();
  }

TimeWidget2(){
  return   Column(children: [
    Text(
      'Available Times',
      style: Theme.of(context)
          .textTheme
          .headline6
          .copyWith(fontWeight: FontWeight.bold, color:Theme.of(context).accentColor),
    ),
    SizedBox(height: 20),
    TimeRange(
      fromTitle: Text(
        'FROM',
        style: TextStyle(
          fontSize: 10,
          color: Theme.of(context).accentColor,
          fontWeight: FontWeight.w600,
        ),
      ),
      toTitle: Text(
        'TO',
        style: TextStyle(
          fontSize: 10,
          color: Theme.of(context).accentColor,
          fontWeight: FontWeight.w600,
        ),
      ),
      titlePadding: leftPadding,
      textStyle: TextStyle(
        fontWeight: FontWeight.normal,
        color: Theme.of(context).accentColor,
      ),
      activeTextStyle: TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      borderColor: Theme.of(context).accentColor,
      activeBorderColor: Theme.of(context).accentColor,
      backgroundColor: Colors.transparent,
      activeBackgroundColor: Theme.of(context).accentColor,
      firstTime: TimeOfDay(hour: 00, minute: 00),
      lastTime: TimeOfDay(hour: 23, minute: 59,),
      initialRange: _timeRange,
      timeStep: 30,
      timeBlock: 30,
      onRangeCompleted: (range) => setState(() {
        return _timeRange = range;
      }),
    ),
    SizedBox(height: 30),
    if (_timeRange != null)
      Padding(
        padding: const EdgeInsets.only(top: 8.0, left: leftPadding),
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

  Widget emptyDocuments(){
    return docs.value.length<1?  Center(
      child: Container(
        color: Colors.white,
        height: height*0.25,
        width: width,
        child:      Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                onTap: (){
                  Navigator.of(context).push(SearchModal()).whenComplete(() {

                    setState(() {
                      docs.value=docs.value;
                    });
                    return null;
                  });
                },
                child: Stack(
                  children: <Widget>[
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(begin: Alignment.bottomLeft, end: Alignment.topRight, colors: [
                            Theme.of(context).focusColor.withOpacity(0.7),
                            Theme.of(context).focusColor.withOpacity(0.05),
                          ])),
                      child: Icon(
                        Icons.add,
                        color: Theme.of(context).scaffoldBackgroundColor,
                        size: 70,
                      ),
                    ),
                    Positioned(
                      right: -30,
                      bottom: -50,
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(150),
                        ),
                      ),
                    ),
                    Positioned(
                      left: -20,
                      top: -50,
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(150),
                        ),
                      ),
                    )
                  ],
                ),
              ),
SizedBox(height: 20.0,),
              Opacity(
                opacity: 0.4,
                child: Text(
                  "Add documents",

                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline3.merge(TextStyle(fontWeight: FontWeight.bold,fontSize: 12.0,color:Colors.black87)),
                ),
              ),
            ],
          ),
        ),
      ),
    ): ListView.builder(
        itemCount: docs.value.length,
        shrinkWrap: true,
        primary: false,
        itemBuilder: (BuildContext context,int index){
      return Card(

        child: ListTile(
          trailing: InkWell(
              onTap: (){

                setState(() {

                  docs.value.removeAt(index);
                });
              },

              child: Icon(Icons.close,color: Theme.of(context).accentColor,)),
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
                  color:_con.getColor()??Theme.of(context).accentColor,
                  border: Border.all(
                    color: Colors.grey.withOpacity(0.1),

                  ),
                  borderRadius: BorderRadius.all(Radius.circular(5))
              ),
              child: Center(child: Text(docs.value[index].file.path.split('.').last.toUpperCase(),style: TextStyle(color: Colors.white,fontSize: 10.0,fontWeight: FontWeight.bold),)),
            ),
          ),
        ),


            title:Text(docs.value[index].documentTypeModel.type,style: TextStyle(color: Colors.black,fontSize: 12.0,fontWeight: FontWeight.bold),)

            ,            subtitle:Text(docs.value[index].documentTypeModel.country.currency+docs.value[index].documentTypeModel.price,style: TextStyle(color: Colors.grey.withOpacity(0.8),fontSize: 12.0,fontWeight: FontWeight.bold),)

        ),
      );
    }
    );
  }
_addDocuments(){

    return showCupertinoModalBottomSheet(
      context: context,
      builder: (context) => Container(),
    );
}

Future UploadFiles() async {

  // _con.scaffoldKey?.currentState?.showSnackBar(SnackBar(
  //   content: Text("upload pressed"),
  // ));
  print("we upload");
  tasks.clear();
  fileitems.clear();
  List files = [];

  if (docs.value.length > 0 && description != null && description.length > 0 &&
      date != null && _timeRange != null) {



    try {


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

    for (int i = 0; i < docs.value.length; i++) {
      var path = docs.value[i].file.path;
      final String savedDir = thepath.dirname(path);
      final String filename = thepath.basename(path);

      files.add(docs.value[i].documentTypeModel.toMap());
      var fileItem = FileItem(
        filename: filename,
        savedDir: savedDir,
        fieldname: docs.value[i].documentTypeModel.short_name,
      );
      fileitems.add(fileItem);
    }

    if (fileitems.length > 0) {
      final f = new DateFormat('yyyy-MM-dd');
      await Navigator.push(
          context,
          CupertinoPageRoute(
              builder: (context) =>
                  ApplicationProgress(
                      fileitems: fileitems,
                      description: description,
                      date: f.format(date),
                      files: files,
                      start_time:DateFormat("HH:mm").format(formated),
                      end_time:DateFormat("HH:mm").format(formated2)

                  ))).then((value) {
        setState(() {
          docs.value = [];
        });
        return null;
      }
      );
    }
    else{

      _con.scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text("No files selected for upload"),
      ));
    }}

    on Exception catch (e) {
      _con.scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));

      print(e); // Only catches an exception of type `Exception`.
    } catch (e) {

      _con.scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));
      print(e); // Catches all types of `Exception` and `Error`.
    }

  }
  else{
String error="";
    if(docs.value.isEmpty){

      error+="No documents selected";
    }

    if(description==null||description.length<1){

      error+=",description is empty";
    }


    if(date==null){
      error+=",No date selected";

    }
if(date==null){
  error+=",No date selected";

}

if(_timeRange==null){
  error+=",No time range selected";

}

    _con.scaffoldKey?.currentState?.showSnackBar(SnackBar(
      content: Text(error),
    ));
  }
}




Widget _submitButton() {
  return InkWell(
    onTap: (){

      if(_formKey.currentState.validate()){
        _formKey.currentState.save();
        UploadFiles();
      }else{

        _con.scaffoldKey?.currentState?.showSnackBar(SnackBar(
          content: Text("error with form"),
        ));
      }

    },
    child: Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(vertical: 25),
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
              colors: [Theme.of(context).accentColor,Theme.of(context).accentColor])),
      child: Text(
        'Submit Application',
        style: TextStyle(fontSize: 14, color: Colors.white,fontWeight: FontWeight.bold,letterSpacing: 1.3),
      ),
    ),
  );
}


}
