import 'package:flutter/material.dart';

class ScheduledApplication extends StatefulWidget {

  int  id;
  ScheduledApplication({Key key, this.id}) : super(key: key);

  @override
  _ScheduledApplicationState createState() => _ScheduledApplicationState();
}

class _ScheduledApplicationState extends State<ScheduledApplication> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(


      appBar: AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.sort, color: Theme.of(context).hintColor),
          onPressed: () {
          },
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Certification Application",
          style: Theme.of(context).textTheme.headline6.merge(TextStyle(letterSpacing: 1.3)),
        ),

      ),


    );
  }
}
