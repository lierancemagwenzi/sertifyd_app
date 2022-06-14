import 'package:flutter/material.dart';
import 'package:horizon/src/model/NotificationModel.dart';
import 'package:intl/intl.dart';

class NotificationScreen extends StatefulWidget {


   NotificationModel notification;


  NotificationScreen({Key key,this.notification}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {

    // var formatter = new DateFormat("yyyy-MM-ddTHH:mm:ssZ");
    var formatter = new DateFormat("yyyy-MM-dd HH:mm:ss");

    DateTime notification_date = formatter.parse(widget.notification.date);

    var date = DateFormat('MMMMEEEEd').format(notification_date);

    return Scaffold(
      appBar: AppBar(
backgroundColor: Colors.transparent,
        leading: InkWell(
            onTap: (){
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios,color: Theme.of(context).accentColor,size: 30.0,)),
        title: Text("Notification",style: TextStyle(color: Theme.of(context).accentColor),),),
      body: Container(
        child: ListTile(
          title: Text(widget.notification.title,           textAlign: TextAlign.justify,
              style: Theme.of(context).textTheme.bodyText1.merge(TextStyle(fontWeight: FontWeight.bold,fontSize: 12.0,color: Colors.black))),
          subtitle:Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.notification.body,style: Theme.of(context).textTheme.bodyText1.merge(TextStyle(fontWeight:  FontWeight.w300,color: Colors.black,fontSize: 10))),
              SizedBox(height: 20.0,),
              Text(date,style: Theme.of(context).textTheme.caption.copyWith(color: Colors.black,fontSize: 12,),),
            ],
          ) ,

        ),
      ),
    );
  }
}
