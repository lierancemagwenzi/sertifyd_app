import 'package:flutter/material.dart';

class JobCancelledWidget extends StatefulWidget {

  @override
  _JobCancelledWidgetState createState() => _JobCancelledWidgetState();
}

class _JobCancelledWidgetState extends State<JobCancelledWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:1==1?      AppBar(

        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: InkWell(

          onTap: (){
            Navigator.pushNamed(context, '/Admin',arguments: 1);
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

      ): AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back_ios, color: Theme.of(context).hintColor),
          onPressed: () {
            Navigator.pushNamed(context, '/Admin',arguments: 2);
          },
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Error",
          style: Theme.of(context).textTheme.headline6.merge(TextStyle(letterSpacing: 1.3)),
        ),
      ),
      body:Center(
        child: Opacity(
          opacity: 0.4,
          child: Text(
            "Sorry, job cancelled" ,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline3.merge(TextStyle(fontWeight: FontWeight.bold,fontSize: 16.0,color:Theme.of(context).accentColor)),
          ),
        ),
      ),

    );
  }
}
