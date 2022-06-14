import 'package:flutter/material.dart';
import 'package:group_button/group_button.dart';
import 'package:horizon/src/controllers/AdminController.dart';
import 'package:horizon/src/elements/ApplicationElement.dart';
import 'package:horizon/src/elements/CircularLoadingWidget.dart';
import 'package:horizon/src/helper/Helper.dart';
import 'package:horizon/src/model/AdminApplication.dart';
import 'package:horizon/src/model/ZoomMettingModel.dart';
import 'package:intl/intl.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:progress_dialog/progress_dialog.dart';

class ApplicationScreen extends StatefulWidget {
  AdminApplicationModel adminApplicationModel;


  ApplicationScreen({Key key, this.adminApplicationModel}) : super(key: key);

  @override
  _ApplicationScreenState createState() => _ApplicationScreenState();
}

class _ApplicationScreenState extends StateMVC<ApplicationScreen> {


  AdminController _con;

  _ApplicationScreenState() : super(AdminController()) {
    _con = controller;
  }

  List<String> buttons=['Now','Later'];
  String time='Now';

  @override
  void initState() {

    if(widget.adminApplicationModel!=null){
      new Future.delayed(Duration.zero,() {
        _con.listenForApplication(widget.adminApplicationModel.id,context: context,admin_next:widget.adminApplicationModel.admin_next );
      });
    }

    else{
      _con.listenForApplication(widget.adminApplicationModel.id );

    }

    if(widget.adminApplicationModel.message!=null){

      Future.delayed(const Duration(seconds: 1), () {

        _con.scaffoldKey?.currentState?.showSnackBar(SnackBar(
          content: Text(widget.adminApplicationModel.message??''),
        ));

      });
    }


    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    _con.pr  = ProgressDialog(context);
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




        title: Text("Application Details",style: TextStyle(color: Colors.black,fontSize: 15.0,fontWeight: FontWeight.bold),),

      ),

      body: _con.certificationApplicationModel==null?CircularLoadingWidget(height: 500,):Container(

        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal:18.0),
          child: _con.certificationApplicationModel.sertifyer!=null?ApplicationElement(applicationModel: _con.certificationApplicationModel,context: context,adminController: _con,): ListView(children: [
            SizedBox(height: 10.0,),
           _con.certificationApplicationModel.satifyer_id==null? Container(
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
            ):Container(height: 0.0,width: 0.0,),

            SizedBox(height:   _con.certificationApplicationModel.satifyer_id==null? 10.0:0.0,),
            Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),

                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                   title: Text("Applicant",style: TextStyle(color: Theme.of(context).primaryColorLight,fontSize: 20.0,fontWeight: FontWeight.bold),),
                    leading: CircleAvatar(backgroundColor: Theme.of(context).primaryColorLight,child: Icon(Icons.person,color: Colors.white.withOpacity(0.7),),),

                    subtitle: Text(_con.certificationApplicationModel.applicant.getFullname(),style: TextStyle(color: Theme.of(context).accentColor.withOpacity(0.5)),),),

                )),

            Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text("Documents",style: TextStyle(color: Theme.of(context).primaryColorLight,fontSize: 20.0,fontWeight: FontWeight.bold),),
                    leading: CircleAvatar(backgroundColor: Theme.of(context).primaryColorLight,child: Icon(Icons.folder_open_outlined,color: Colors.white.withOpacity(0.7),),),

                    subtitle: Text(Helper.getDocuments(_con.certificationApplicationModel),style: TextStyle(color: Theme.of(context).accentColor.withOpacity(0.5)),),),


                )),


            Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text("Message",style: TextStyle(color: Theme.of(context).primaryColorLight,fontSize: 20.0,fontWeight: FontWeight.bold),),
                    leading: CircleAvatar(backgroundColor: Theme.of(context).primaryColorLight,child: Icon(Icons.chat_bubble_outline,color: Colors.white.withOpacity(0.7),),),

                    subtitle: Text(_con.certificationApplicationModel.description,style: TextStyle(color: Theme.of(context).accentColor.withOpacity(0.5)),),),


                )),
            ListTile(
              title: Text("Requested Time",style: TextStyle(color: Theme.of(context).primaryColorLight,fontSize: 20.0,fontWeight: FontWeight.bold),),
             ),
            ListTile(
              leading: Icon(Icons.calendar_today),
              title: Text(_con.certificationApplicationModel.date   ,style: TextStyle(color: Theme.of(context).accentColor.withOpacity(0.5),fontSize: 17.0,fontWeight: FontWeight.bold),),

            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal:10.0),
              child: GroupButton(
                spacing: 15,
                isRadio: true,
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                unselectedColor:Theme.of(context).primaryColor,
                unselectedTextStyle: TextStyle(color: Theme.of(context).accentColor,fontWeight: FontWeight.bold),
                selectedTextStyle: TextStyle(color:Colors.white70,fontWeight: FontWeight.bold),
                selectedColor: Theme.of(context).primaryColorLight,
                direction: Axis.horizontal,
                onSelected: (index, isSelected) {
                  setState(() {
                    // time=buttons[index];
                  });
                  if(isSelected){

                  }
                  else{

                  }
                  print(
                      '$index button is ${isSelected ? 'selected' : 'unselected'}');
                },
                buttons: [         _con.certificationApplicationModel.start_time],
                selectedButtons: [
                  _con.certificationApplicationModel.start_time
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height*0.2,),

            _submitButton()

          ],),
        ),
      ),
    );
  }

  Widget _submitButton() {
    return InkWell(
      onTap: (){
        if(_con.loading){}

        else{
          _submit();
        }
      },
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
                colors: [Theme.of(context).accentColor,Theme.of(context).accentColor])),
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
    );
  }




  _submit(){
    ZoomMeetingModel zoomMeetingModel;

    if(_con.certificationApplicationModel.start_time.toLowerCase()=="immediately"){

      var formatter = new DateFormat("yyyy-MM-ddTHH:mm:ss");

      var start_time=  formatter.format(new DateTime.now().add(Duration(minutes: 5)));

      zoomMeetingModel=new ZoomMeetingModel(start_time: start_time+"Z");

    }
    else{
      String  date=_con.certificationApplicationModel.date+" "+Helper.SplitTime(_con.certificationApplicationModel.start_time);
      DateTime parseDate = new DateFormat("yyyy-MM-dd HH:mm").parse(date);
      var formatter = new DateFormat("yyyy-MM-ddTHH:mm:ss");
      DateTime newdate=DateTime(parseDate.year,parseDate.month,parseDate.hour,parseDate.minute);
      var start_time=  formatter.format(newdate)+"Z";
      zoomMeetingModel=new ZoomMeetingModel(start_time: start_time);
      print(start_time);
    }
    _con.CreateMeeting(zoomMeetingModel,context);
  }



}
