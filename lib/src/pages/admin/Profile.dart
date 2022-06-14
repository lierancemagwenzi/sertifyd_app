import 'dart:io';

import 'package:flutter/material.dart';
import 'package:horizon/src/controllers/AdminController.dart';
import 'package:horizon/src/controllers/ProfileController.dart';
import 'package:horizon/src/elements/CertItemWidget.dart';
import 'package:horizon/src/elements/EmptyApplicationsWidget.dart';
import 'package:horizon/src/elements/EmptyCompletedApplicationsWidget.dart';
import 'package:horizon/src/elements/EmptyUpcomingJobs.dart';
import 'package:horizon/src/elements/ProfileAvatarWidget.dart';
import 'package:horizon/src/elements/admin/AdminCertItemWidget.dart';
import 'package:horizon/src/elements/admin/ProfileAvatarWidget.dart';
import 'package:horizon/src/icons/logout.dart';
import 'package:horizon/src/model/AdminApplication.dart';
import 'package:horizon/src/repositories/global_repository.dart';
import 'package:horizon/src/repositories/settings_repository.dart';
import 'package:horizon/src/repositories/user_repository.dart';
import 'package:mvc_pattern/mvc_pattern.dart';


class AdminProfileWidget extends StatefulWidget {
  final GlobalKey<ScaffoldState> parentScaffoldKey;

  AdminProfileWidget({Key key, this.parentScaffoldKey}) : super(key: key);
  @override
  _AdminProfileWidgetState createState() => _AdminProfileWidgetState();
}

class _AdminProfileWidgetState extends StateMVC<AdminProfileWidget> {
  AdminController _con;

  _AdminProfileWidgetState() : super(AdminController()) {
    _con = controller;
  }


  @override
  void initState() {


    _con.listenForUpcomingApplications();

    _con.RefreshProfile();
    Map map={"action":"profile","platform":Platform.isIOS?"ios":"android","user_id":currentuser.value.id??0,"device":detailsModel.value.identifier,"detail":"visited profile",};

    log_activity(map);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con.scaffoldKey,
      backgroundColor: Colors.white,
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
      body:1==1?Body(): RefreshIndicator(
        onRefresh: () async {
          _con.refreshUpcomingJobs();
        },
        child: ListView(
          children: [
            SingleChildScrollView(
//              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
              child: Column(
                children: <Widget>[
                  AdminProfileAvatarWidget(user: currentuser.value,adminController:_con),

                  ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    leading: Icon(
                      Icons.folder,
                      color: Theme.of(context).hintColor,
                    ),
                    title: Text(
                      "Completed Jobs",
                      style: Theme.of(context).textTheme.headline4,
                    ),
                  ),
                  _con.applications.isEmpty
                      ? EmptyUpcomingJobs()
                      : ListView.separated(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    primary: false,
                    itemCount: _con.applications.length,
                    itemBuilder: (context, index) {
                      var _order = _con.applications.elementAt(index);
                      return AdminCertItemWidget(

                          onClick: (model){


                            Navigator.of(context).pushNamed('/${model.status.admin_next.toLowerCase()}', arguments: AdminApplicationModel(id: model.id,admin_next: model.status.admin_next,message: null)).then((value) {

                              _con.refreshUpcomingJobs();
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
// image: DecorationImage(
//   image: AssetImage("assets/images/userr.png"),fit: BoxFit.contain
// ),
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

          currentuser.value.role!=null&& currentuser.value.role.name=='sertifyer'? ListTile(

               subtitle: Text("Commisssioner Of Oaths",style: TextStyle(color: Colors.grey.withOpacity(0.9),fontSize: 10.0,),),
              title: Text("Role",style: TextStyle(color: Colors.black,fontSize: 10,fontWeight: FontWeight.bold),),
              leading: Container(
                height: 40,width: 40,
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.3),

                    shape: BoxShape.circle
                ),child: Center(child: Icon(Icons.person,color: Colors.white,)),
              )
          ):SizedBox(height: 0,width: 0,),

          ListTile(

              onTap: (){

                Navigator.pushNamed(context, '/Settings');

              },
              trailing: Icon(Icons.settings,color: Theme.of(context).accentColor.withOpacity(0.3),),

              title: Text("Settings",style: TextStyle(color: Colors.black,fontSize: 10,fontWeight: FontWeight.bold),),
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

                Navigator.pushNamed(context, '/Earnings');

              },
              trailing: Icon(Icons.money,color: Theme.of(context).accentColor.withOpacity(0.3),),

              title: Text("Earnings",style: TextStyle(color: Colors.black,fontSize: 10,fontWeight: FontWeight.bold),),
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

                Navigator.pushNamed(context, '/Faq',arguments: 'admin');

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
