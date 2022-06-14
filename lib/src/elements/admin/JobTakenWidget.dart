import 'package:flutter/material.dart';

class JobTakenWidget extends StatefulWidget {

  @override
  _JobTakenWidgetState createState() => _JobTakenWidgetState();
}

class _JobTakenWidgetState extends State<JobTakenWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar:  AppBar(

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

      ),
      body:Center(

        child: Opacity(
          opacity: 0.4,
          child: Text(
            "Sorry, job taken" ,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline3.merge(TextStyle(fontWeight: FontWeight.bold,fontSize: 16.0,color:Theme.of(context).accentColor)),
          ),
        ),
      ),

    );
  }
}
