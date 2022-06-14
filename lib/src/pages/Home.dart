

import 'package:badges/badges.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:horizon/src/controllers/home_controller.dart';
import 'package:horizon/src/elements/DraweWidget.dart';
import 'package:horizon/src/pages/CertificationApplication.dart';
import 'package:horizon/src/pages/Completed.dart';
import 'package:horizon/src/pages/HomePageIn.dart';
import 'package:horizon/src/pages/Messages.dart';
import 'package:horizon/src/pages/Notifications.dart';
import 'package:horizon/src/pages/client/Chats.dart';
import 'package:horizon/src/repositories/global_repository.dart';

import 'package:horizon/src/repositories/settings_repository.dart' as settingRepo;

import 'package:mvc_pattern/mvc_pattern.dart';

import 'ChatsScreen.dart';
import 'ProfileScreen.dart';

class Home extends StatefulWidget {
  int  index;

  Home({@required  this.index,});
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends StateMVC<Home> {


  HomeController _con;

  _HomeState() : super(HomeController()) {
    _con = controller;
  }

List<Widget> screens= [

  // CompletedApplications(),
  // NotificationWidget(),
  ChatsScreen(),
  HomePageIn(),

  ProfileScreen(),

];

  @override
  void initState() {
print(widget.index);
    if(widget.index!=null){
      currentIndex=widget.index;
    }
    new Future.delayed(Duration.zero,() {
      _con.getDeviceDetrails(context);
    });

    super.initState();
  }

  int currentIndex=0;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        return false;
      },
      child: Scaffold(
        key: _con.scaffoldKey,

        floatingActionButton: currentIndex==1?FloatingActionButton.extended(
label: Text("Certification"),
          onPressed: () async {

            await  Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (context) => CeertificationApplication(

                    )));
          },

          icon: Icon(Icons.add_circle,color: Colors.white,),
        ):null,
          appBar:currentIndex==1? AppBar(
            // leading: new IconButton(
            //   icon: new Icon(Icons.sort,size: 30.0, color: Theme.of(context).hintColor),
            //   onPressed: () {
            //     Navigator.pushNamed(context, "/Pages",arguments: 3);
            //   },
            // ),
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            elevation: 0,
actions: [          SafeArea(

  child:   InkWell(

    onTap: (){

      setState(() {

        total_client_notifications.value=0;

      });

      Navigator.pushNamed(context, '/Clientnotifications');
    },
    child: Badge(
     position: BadgePosition.topStart(top: 5,start: 3),
        badgeContent: Text(total_client_notifications.value.toString(),style: TextStyle(color: Colors.white,fontSize: 12),),
        child: Icon(Icons.notifications,color: Theme.of(context).accentColor,size: 25,)),
  ),
),SizedBox(width: 10,)
],
            centerTitle: true,
            title: ValueListenableBuilder(
              valueListenable: settingRepo.setting,
              builder: (context, value, child) {
                return InkWell(

                  onTap: (){


                  },
                  child: Text(
                    value.appName.toUpperCase() ?? "home",
                    style: Theme.of(context).textTheme.headline6.merge(TextStyle(letterSpacing: 1.3)),
                  ),
                );
              },
            ),

          ):null,
//         appBar:currentIndex==3?null: AppBar(
//           automaticallyImplyLeading: false,
//           centerTitle: true,
//           backgroundColor: Theme.of(context).accentColor,
//           elevation: 0.0,
//
//           leading:1==2?Icon(Icons.sort,size: 30.0,color: Colors.white,): InkWell(
//
//               onTap: (){
// if(currentIndex==3){}
//
// else{
//   Navigator.pushNamed(context, "/Pages",arguments: 3);
// }
//
//                 // return _con.scaffoldKey.currentState.openDrawer();
//               },
//               child: Padding(
//                 padding: const EdgeInsets.all(3.0),
//                 child: Card(
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(100.0)),
//                     elevation: 5,
//
//                     child: Icon(Icons.person,size: 30.0,color: Theme.of(context).accentColor,)),
//               )),
//
//           title: Text(currentIndex==1?"Notifications":  "Home",          style: Theme.of(context).textTheme.headline6.merge(TextStyle(letterSpacing: 1.3, color: Theme.of(context).primaryColor)),
//               )
//
//           ,),
//         drawer: DrawerWidget(),
// body:  IndexedStack(
//   index: currentIndex,
//   children:screens,
// ),

      body:screens[currentIndex],
          bottomNavigationBar:1==1? BottomNavyBar(
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
          ) :Theme(
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
                //   title: new Text('Ducuments'),
                // ),

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

  void onTabTapped(int index) {

    // if(index==4){
    //
    //   setState(() {  screens.removeAt(4);
    //   screens.insert(4, CompletedApplications());
    //   });
    //
    // }
    // else{}
    setState(() {
      currentIndex = index;
    });
  }

}
