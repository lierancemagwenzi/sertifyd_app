import 'package:badges/badges.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:horizon/src/controllers/AdminController.dart';
import 'package:horizon/src/elements/AppointmentWidget.dart';
import 'package:horizon/src/elements/EmptyApplicationsWidget.dart';
import 'package:horizon/src/model/ApplicationModel.dart';
import 'package:horizon/src/pages/Chats.dart';
import 'package:horizon/src/pages/ChatsScreen.dart';
import 'package:horizon/src/pages/admin/AdminNotifications.dart';
import 'package:horizon/src/pages/admin/HomePage.dart';
import 'package:horizon/src/pages/admin/Scheduled.dart';
import 'package:horizon/src/repositories/global_repository.dart';
import 'package:intl/intl.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:horizon/src/repositories/settings_repository.dart' as settingRepo;

import 'admin/Profile.dart';

class AdminHome extends StatefulWidget {

  int  index;

  AdminHome({@required  this.index,});

  @override
  _AdminHomeState createState() => _AdminHomeState();
}

class _AdminHomeState extends StateMVC<AdminHome> {

  AdminController _con;

  _AdminHomeState() : super(AdminController()) {
    _con = controller;
  }
double height;
  double width;

  @override
  void initState() {
    if(widget.index!=null){
      currentIndex=widget.index;
    }
    _con.listenForApplications();
    _con.listenForScheduledApplications();
    _con.listenForUpcomingApplications();

    new Future.delayed(Duration.zero,() {
      _con.getDeviceDetrails(context);
    });
    super.initState();
  }

  int currentIndex=0;

  List<Widget> screens= [
    // ScheduledApplicationsWidget(),
    // AdminNotificationWidget(),

    ChatsScreen(),
    AdminHomePage(),
    AdminProfileWidget(),

  ];

  @override
  Widget build(BuildContext context) {
    height=MediaQuery.of(context).size.height;
    width=MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: ()async{
        return false;
      },
      child: Scaffold(
          appBar:currentIndex==1? AppBar(
            // leading: new IconButton(
            //   icon: new Icon(Icons.sort,size: 30.0, color: Theme.of(context).hintColor),
            //   onPressed: () {
            //     Navigator.pushNamed(context, "/Admin",arguments: 3);
            //   },
            // ),
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            elevation: 0,
            actions: [         SafeArea(
              child: InkWell(


                  onTap: (){

setState(() {

  total_admin_notifications.value=0;

});

                    Navigator.pushNamed(context, '/Adminnotifications');
                  },

                  child: Badge(
                      position: BadgePosition.topStart(top: 4,start: 3),

                      badgeColor: Theme.of(context).accentColor,
                      badgeContent: Text(total_admin_notifications.value.toString(),style: TextStyle(color: Colors.white,),),

                      child: Icon(Icons.notifications,color: Theme.of(context).accentColor,size: 30,))),
            ),SizedBox(width: 10,)
            ],
            centerTitle: true,
            title: ValueListenableBuilder(
              valueListenable: settingRepo.setting,
              builder: (context, value, child) {
                return Text(
                  value.appName.toUpperCase(),
                  style: Theme.of(context).textTheme.headline6.merge(TextStyle(letterSpacing: 1.3)),
                );
              },
            ),

          ):null,

          // body:  IndexedStack(
          //   index: currentIndex,
          //   children:screens,
          // ),


          body: screens[currentIndex],

          bottomNavigationBar:1==1?BottomNavyBar(
            selectedIndex: currentIndex,
            showElevation: true, // use this to remove appBar's elevation
            onItemSelected: (index) => setState(() {
              currentIndex = index;
            }),
            items: [
              BottomNavyBarItem(
                icon: Icon(Icons.chat_bubble_outline),
                title: Text('Messages'),
                activeColor: Theme.of(context).accentColor,
              ),
              BottomNavyBarItem(
                icon: Icon(Icons.home),
                title: Text('Home'),
                activeColor: Theme.of(context).accentColor,
              ),
              BottomNavyBarItem(
                icon: Icon(Icons.person),
                title: Text('Account'),
                activeColor: Theme.of(context).accentColor,
              ),

            ],
          ): Theme(
            data: Theme.of(context).copyWith(
              // sets the background color of the `BottomNavigationBar`
                canvasColor:Theme.of(context).accentColor,
                // sets the active color of the `BottomNavigationBar` if `Brightness` is light
                primaryColor: Colors.red,
                iconTheme: IconThemeData(size: 28.0),
                textTheme: Theme.of(context)
                    .textTheme
                    .copyWith(caption: new TextStyle(color: Colors.yellow))),
            child: BottomNavigationBar(
              currentIndex: currentIndex,
              type: BottomNavigationBarType.fixed,
              selectedIconTheme: IconThemeData(size: 28),
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.grey,

              onTap: onTabTapped,
              // this will be set when a new tab is tapped
              items: [
                // BottomNavigationBarItem(
                //   icon: new Icon(Icons.folder_open),
                //   title: new Text('Tasks'),
                // ),
                //
                // BottomNavigationBarItem(
                //   icon: new Icon(Icons.notifications),
                //   title: new Text('Notifications'),
                // ),

                BottomNavigationBarItem(
                    icon: Icon(Icons.messenger_outline), title: Text('Messages')),
                BottomNavigationBarItem(
                  icon: new Icon(Icons.home_filled),
                  title: new Text('Home'),
                ),

                BottomNavigationBarItem(
                  icon: new Icon(Icons.apps),
                  title: new Text('Account'),
                ),
//            BottomNavigationBarItem(
//                icon: Icon(Icons.work), title: Text('Jobs')),

              ],
            ),
          )
      ),
    );
  }


  body(){

    return _con.applications.length>0? Padding(
      padding: const EdgeInsets.symmetric(horizontal:14.0,vertical: 8.0),
      child: ListView(children: [

      ],),
    ):Text("");
  }

  void onTabTapped(int index) {

    if(index==4){

      screens.removeAt(4);
      screens.insert(4, ChatsWidget());
    }
    setState(() {
      currentIndex = index;
    });
  }

}
