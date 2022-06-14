import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:horizon/src/controllers/NotificationController.dart';
import 'package:horizon/src/elements/EmptyNotificationsWidget.dart';
import 'package:horizon/src/elements/NotificationItemWidget.dart';
import 'package:horizon/src/pages/SingleNotificationScreen.dart';
import 'package:horizon/src/repositories/global_repository.dart';
import 'package:horizon/src/repositories/settings_repository.dart';
import 'package:horizon/src/repositories/user_repository.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

class NotificationWidget extends StatefulWidget {
  bool fromlauncher;

  NotificationWidget({Key key, this.fromlauncher}) : super(key: key);
  @override
  _NotificationWidgetState createState() => _NotificationWidgetState();
}

class _NotificationWidgetState extends StateMVC<NotificationWidget> {


  NotificationController _con;

  _NotificationWidgetState() : super(NotificationController()) {
    _con = controller;
  }
  double height;
  double width;

  @override
  void initState() {


    _con.listenForNotifications();
    Map map={"action":"notifications","platform":Platform.isIOS?"ios":"android","user_id":currentuser.value.id??0,"device":detailsModel.value.identifier,"detail":"visited profile",};

    log_activity(map);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con.scaffoldKey,
      appBar: AppBar(
        leading:widget.fromlauncher==true? new IconButton(
          icon: new Icon(Icons.arrow_back_ios, color: Theme.of(context).hintColor),
          onPressed: () {

            Navigator.pushNamed(context, '/Pages',arguments: 1);

          },
        ):null,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
      "Notifications",
          style: Theme.of(context).textTheme.headline6.merge(TextStyle(letterSpacing: 1.3)),
        ),

      ),
      body:  _con.loading?Center(child: CircularProgressIndicator()): _con.notifications.length<1?RefreshIndicator(



        onRefresh: ()async{

          _con.refreshNotifications();
        },
        child: ListView(

          children: [
            EmptyNotificationsWidget(),
          ],
        ),
      ):  RefreshIndicator(

        onRefresh: ()async{

          _con.refreshNotifications();
        },

        child: ListView(
          children: [
            ListView.separated(
              padding: EdgeInsets.symmetric(vertical: 15),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              primary: false,
              itemCount: _con.notifications.length,
              separatorBuilder: (context, index) {
                return SizedBox(height: 15);
              },
              itemBuilder: (context, index) {
                return NotificationItemWidget(
                  notification: _con.notifications.elementAt(index),
                  onMarkAsRead: () {
                    _con.MarkAsRead(_con.notifications.elementAt(index).id,index,1);
                  },
                  onMarkAsUnRead: () {
                    _con.MarkAsRead(_con.notifications.elementAt(index).id,index,0);
                  },
                  onRemoved: () {
                    _con.DeleteNotification(_con.notifications.elementAt(index).id);
                  },
                  onClick: () {
                    if(_con.notifications[index].action=="application"){
                      _con.findApplication(_con.notifications.elementAt(index).action_id,context);
                    }
                    else{

                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => NotificationScreen(
                                notification: _con.notifications[index],
                              )));
                    }
                    // _con.DeleteNotification(_con.notifications.elementAt(index).id);
                  },

                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
