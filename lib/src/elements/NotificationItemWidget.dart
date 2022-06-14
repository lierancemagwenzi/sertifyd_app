import 'package:flutter/material.dart';
import 'package:horizon/src/helper/Helper.dart';
import 'package:horizon/src/helper/swipe_widget.dart';
import 'package:horizon/src/model/NotificationModel.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:horizon/src/helper/string_extension.dart';



class NotificationItemWidget extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onMarkAsRead;
  final VoidCallback onMarkAsUnRead;
  final VoidCallback onRemoved;

  final VoidCallback onClick;

  NotificationItemWidget({Key key, this.notification, this.onMarkAsRead, this.onMarkAsUnRead, this.onRemoved,this.onClick}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    // var formatter = new DateFormat("yyyy-MM-ddTHH:mm:ssZ");
    var formatter = new DateFormat("yyyy-MM-dd HH:mm:ss");


    DateTime notification_date = formatter.parse(notification.date);

    var date = DateFormat('MMMMEEEEd').add_jms().format(notification_date);

    return OnSlide(
      backgroundColor: notification.read ? Theme.of(context).scaffoldBackgroundColor : Theme.of(context).primaryColor,
      items: <ActionItems>[
        ActionItems(
            icon: notification.read
                ? new Icon(
                    Icons.panorama_fish_eye,
                    color: Theme.of(context).accentColor,
                  )
                : new Icon(
                    Icons.brightness_1,
                    color: Theme.of(context).accentColor,
                  ),
            onPress: () {
              if (notification.read) {
                onMarkAsUnRead();
              } else {
                onMarkAsRead();
              }
            },
            backgroudColor: Theme.of(context).scaffoldBackgroundColor),
        new ActionItems(
            icon: Padding(
              padding: const EdgeInsets.only(right: 10),
              child: new Icon(Icons.delete, color: Theme.of(context).accentColor),
            ),
            onPress: () {
              onRemoved();
            },
            backgroudColor: Theme.of(context).scaffoldBackgroundColor),
      ],
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(begin: Alignment.bottomLeft, end: Alignment.topRight, colors: [
                        Theme.of(context).focusColor.withOpacity(0.7),
                        Theme.of(context).focusColor.withOpacity(0.05),
                      ])),
                  // child: Icon(
                  //   Icons.notifications,
                  //   color: Theme.of(context).scaffoldBackgroundColor,
                  //   size: 40,
                  // ),
                ),
                Positioned(
                  right: -30,
                  bottom: -50,
                  child: Container(
                    width: 100,
                    height: 100,
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
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(150),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(width: 15),
            Flexible(
              child: InkWell(

                onTap: (){

                  onClick();
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Text(
                     notification.title.capitalize(),
                      // Helper.of(context).trans(notification.type),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,

                      textAlign: TextAlign.justify,
                      style: Theme.of(context).textTheme.bodyText1.merge(TextStyle(fontWeight: notification.read ? FontWeight.bold : FontWeight.bold,color: Colors.black,fontSize: 12)),
                    ),
                    Text(
                     Helper.skipHtml(notification.body.capitalize()) ,
                      // Helper.of(context).trans(notification.type),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      textAlign: TextAlign.justify,
                      style: Theme.of(context).textTheme.bodyText1.merge(TextStyle(fontWeight: notification.read ? FontWeight.w300 : FontWeight.w600,color: Colors.black,fontSize: 10)),
                    ),
                    Text(
                      date,
                      // DateFormat('yyyy-MM-dd | HH:mm').format(notification.createdAt),
                      style: Theme.of(context).textTheme.caption.copyWith(color: Colors.black,fontSize: 10),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
