import 'package:flutter/material.dart';
import 'package:horizon/src/controllers/AccountPaymentsController.dart';
import 'package:horizon/src/helper/Helper.dart';
import 'package:horizon/src/repositories/settings_repository.dart';
import 'package:horizon/src/repositories/user_repository.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

class PeriodsWidget extends StatefulWidget {

  @override
  _PeriodsWidgetState createState() => _PeriodsWidgetState();
}

class _PeriodsWidgetState extends StateMVC<PeriodsWidget> {

  EarningsController _con;

  _PeriodsWidgetState() : super(EarningsController()) {
    _con = controller;
  }



  @override
  void initState() {
    _con.listenForPeriods();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        body:_con.periods.length<1?Center(child: Text("You do not have any completed jobs",style: TextStyle(fontSize: 12.0,fontWeight: FontWeight.w700,color: Theme.of(context).accentColor),)): Padding(
          padding: const EdgeInsets.symmetric(horizontal:12.0),
          child: ListView.builder(
              itemCount: _con.periods.length,
              itemBuilder: (BuildContext context,int index){
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: ListTile(

                    onTap: (){

                      Navigator.pushNamed(context, '/GroupedEarnings',arguments: _con.periods[index]);
                    },

trailing: Icon(Icons.arrow_forward_ios,color: Colors.black,size: 30,),
                    title: Text(_con.periods[index].monthname+ " "+_con.periods[index].year.toString(),style: TextStyle(color: Colors.black,fontSize: 12,fontWeight: FontWeight.bold),),
                  ),

                );
              }
          ),
        )
    );
  }
}
