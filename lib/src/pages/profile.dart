import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:horizon/src/controllers/ProfileController.dart';
import 'package:horizon/src/elements/CertItemWidget.dart';
import 'package:horizon/src/elements/EmptyApplicationsWidget.dart';
import 'package:horizon/src/elements/EmptyCompletedApplicationsWidget.dart';
import 'package:horizon/src/elements/ProfileAvatarWidget.dart';
import 'package:horizon/src/elements/RescheduleWidget.dart';
import 'package:horizon/src/icons/logout.dart';
import 'package:horizon/src/model/ApplicationModel.dart';
import 'package:horizon/src/model/ClientApplication.dart';
import 'package:horizon/src/repositories/global_repository.dart';
import 'package:horizon/src/repositories/settings_repository.dart';
import 'package:horizon/src/repositories/user_repository.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:time_range/time_range.dart';

import 'SertifyerApplication.dart';


class ProfileWidget extends StatefulWidget {
  final GlobalKey<ScaffoldState> parentScaffoldKey;

  ProfileWidget({Key key, this.parentScaffoldKey}) : super(key: key);
  @override
  _ProfileWidgetState createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends StateMVC<ProfileWidget> {
  ProfileController _con;

  _ProfileWidgetState() : super(ProfileController()) {
    _con = controller;
  }


  @override
  void initState() {
    Map map={"action":"profile","platform":Platform.isIOS?"ios":"android","user_id":currentuser.value.id??0,"device":detailsModel.value.identifier,"detail":"visited profile",};

    log_activity(map);

    _con.listenForApplications();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _con.scaffoldKey,
      appBar: AppBar(
        // leading: new IconButton(
        //   icon: new Icon(Icons.sort, color: Theme.of(context).primaryColor),
        //   onPressed: () {
        //     Navigator.pushNamed(context, '/Admin',arguments: 2);
        //   },
        // ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Profile",
          style: Theme.of(context).textTheme.headline6.merge(TextStyle(letterSpacing: 1.3, color: Theme.of(context).accentColor)),
        ),

      ),
      body: 1==1?Body():SingleChildScrollView(
//              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
        child: Column(
          children: <Widget>[
            ProfileAvatarWidget(user: currentuser.value,profileController:_con),

            ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              leading: Icon(
                Icons.folder,
                color: Theme.of(context).hintColor,
              ),
              title: Text(
                "Recent Applications",
                style: Theme.of(context).textTheme.headline4,
              ),
            ),
            _con.applications.isEmpty
                ? EmptyDocumentsWidget()
                : ListView.separated(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              primary: false,
              itemCount: _con.applications.length,
              itemBuilder: (context, index) {
                var _order = _con.applications.elementAt(index);
                return CertItemWidget(

                    onSelected: (model) {

                      print("onselected");
                      _con.CancelApplication(context, {"id":_con.applications[index].id}, index);

                    },

                    onReschedule: (model) {


                      Navigator.of(context).pushNamed('/${model.status.client_next.toLowerCase()}', arguments: model).then((value) {

                        _con.refresh();
                        return null;    });
                      // _modalBottomSheetMenu(_con.applications[index]);

                    },
                    onClick: (model){

                      // _con.GetApplication(model.id,context);


                      if(model.status.status.toLowerCase()=='pending'){

                        Navigator.of(context).pushNamed('/${model.status.client_next.toLowerCase()}', arguments: ClientApplication(id: model.id,message:null,client_next: model.status.client_next)).then((value) {

                          _con.refresh();

                          return null;
                        });




                      }

                      else{
                        Navigator.of(context).pushNamed('/${model.status.client_next.toLowerCase()}', arguments:  ClientApplication(id: model.id,message:null,client_next: model.status.client_next)).then((value) {

                          _con.refresh();
                          return null;
                        });
                      }



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
    );
  }

  void _modalBottomSheetMenu(CertificationApplicationModel applicationModel){

    CalendarController _calendarController=CalendarController();

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        isDismissible: false,
        enableDrag: false,
        builder: (builder){
          return new Container(
            height: MediaQuery.of(context).size.height*0.7,
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

  Widget Body(){

    return SingleChildScrollView(

      child: Column(

        crossAxisAlignment: CrossAxisAlignment.center,
        children: [


SizedBox(height: 15,),
        Container(


child:  Center(
  child:   Container(
    height: 100,width: 100,
        decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.2),
image: DecorationImage(
  image: AssetImage("assets/images/user-icon.png"),fit: BoxFit.contain
),
            shape: BoxShape.circle
        ),
      ),
)


        ),
        SizedBox(height: 8),
        Text(currentuser.value.getFullname(),style: TextStyle(fontSize: 14.0,fontWeight: FontWeight.bold,color: Colors.black),),
          SizedBox(height: 8),
          Text(currentuser.value.mobile,style: TextStyle(fontSize: 10.0,fontWeight: FontWeight.normal,color: Colors.grey.withOpacity(0.8)),),
          SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal:20.0),
            child: Divider(height: 5,color: Colors.grey.withOpacity(0.9),),
          ),
          SizedBox(height: 15,),



          ListTile(

            onTap: (){

              Navigator.pushNamed(context, '/TestDocument');

            },
              trailing: Icon(Icons.arrow_forward_ios,color: Theme.of(context).accentColor.withOpacity(0.3),),

              title: Text("Verify a document",style: TextStyle(color: Colors.black,fontSize: 10,fontWeight: FontWeight.bold),),
              leading: Container(
                height: 40,width: 40,
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.3),

                    shape: BoxShape.circle
                ),child: Center(child: Icon(Icons.verified,color: Colors.white,)),
              )
          ),
ListTile(

  onTap: (){

    Navigator.pushNamed(context, '/Faq',arguments: 'client');

  },
  trailing: Icon(Icons.arrow_forward_ios,color: Theme.of(context).accentColor.withOpacity(0.3),),

title: Text("Help and support",style: TextStyle(color: Colors.black,fontSize: 10,fontWeight: FontWeight.bold),),
  leading: Container(
    height: 40,width: 40,
    decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.3),

        shape: BoxShape.circle
    ),child: Center(child: Icon(Icons.help,color: Colors.white,)),
  )
),

          currentuser.value.role!=null&& currentuser.value.role.name=='client'?   ListTile(

              onTap: () async {

                await  Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => SertifyerApplication(

                        )));
              },
              trailing: Icon(Icons.arrow_forward_ios,color: Theme.of(context).accentColor.withOpacity(0.3),),

              title: Text("Become A Commissioner of Oaths",style: TextStyle(color: Colors.black,fontSize: 10,fontWeight: FontWeight.bold),),
              leading: Container(
                height: 40,width: 40,
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.3),

                    shape: BoxShape.circle
                ),child: Center(child: Icon(Icons.person,color: Colors.white,)),
              )
          ):  currentuser.value.role!=null&& currentuser.value.role.name=='Pending Sertifyer'? ListTile(


              subtitle: Text("Pending Approval",style: TextStyle(color: Colors.grey.withOpacity(0.8),fontSize: 10,fontWeight: FontWeight.normal),),
              title: Text("Commissioner of Oaths Application",style: TextStyle(color: Colors.black,fontSize: 10,fontWeight: FontWeight.bold),),
              leading: Container(
                height: 40,width: 40,
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.3),

                    shape: BoxShape.circle
                ),child: Center(child: Icon(Icons.person,color: Colors.white,)),
              )
          ):SizedBox(height: 0,width: 0,),
SizedBox(height: 10,),
          ListTile(

            onTap: (){

              _con.LogoutUser(context);

            },
              trailing: Icon(Icons.arrow_forward_ios,color: Theme.of(context).accentColor.withOpacity(0.3),),

              title: Text("Logout",style: TextStyle(color: Colors.black,fontSize: 10,fontWeight: FontWeight.bold),),
              leading: Container(
                height: 40,width: 40,
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.3),


                    shape: BoxShape.circle
                ),child: Center(child: Icon(LogoutIcon.logout,color: Colors.white)),
              )
          ),

      ],),
    );
  }
}
