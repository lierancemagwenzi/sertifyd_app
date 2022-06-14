import 'package:flutter/material.dart';
import 'package:horizon/src/controllers/AccountPaymentsController.dart';
import 'package:horizon/src/helper/Helper.dart';
import 'package:horizon/src/model/AdminApplication.dart';
import 'package:horizon/src/model/EarningsStat.dart';
import 'package:horizon/src/repositories/settings_repository.dart';
import 'package:horizon/src/repositories/user_repository.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

class GroupdEarningsWidget extends StatefulWidget {


  EarningsStat earningsStat;

  GroupdEarningsWidget({Key key, this.earningsStat}) : super(key: key);


  @override
  _GroupdEarningsWidgetState createState() => _GroupdEarningsWidgetState();
}

class _GroupdEarningsWidgetState extends StateMVC<GroupdEarningsWidget> {

  EarningsController _con;

  _GroupdEarningsWidgetState() : super(EarningsController()) {
    _con = controller;
  }

double height;

  double width;

  @override
  void initState() {
    _con.listenForapplicationPeriods(widget.earningsStat.year, widget.earningsStat.month);
    super.initState();
  }



  @override
  Widget build(BuildContext context) {

    height=MediaQuery.of(context).size.height;
    return Scaffold(
      bottomNavigationBar: SafeArea(

        child: Container(
color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(

              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              Text("Total: ",style: TextStyle(color: Colors.black,fontSize: 14.0,fontWeight: FontWeight.bold),),
              SizedBox(width: 30,),
              Text(currentuser.value.country.currency+_con.total.toStringAsFixed(2),style: TextStyle(color: Colors.black,fontSize: 14.0,fontWeight: FontWeight.bold))

            ],),
          ),
          height:height*0.1 ,
        ),
      ),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          leading: InkWell(

              onTap: (){

                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back_ios,color: Theme.of(context).accentColor,)),
          title: Text(
            "Completed Jobs for ${widget.earningsStat.monthname}  ${widget.earningsStat.year}",
            style: Theme.of(context).textTheme.headline6.merge(TextStyle(fontSize: 14.0,fontWeight: FontWeight.bold)),
          ),
        ),        body:_con.applications.length<1?Center(child: Text("You do not have any completed jobs for this month",style: TextStyle(fontSize: 12.0,fontWeight: FontWeight.w700,color: Theme.of(context).accentColor),)): Padding(
          padding: const EdgeInsets.symmetric(horizontal:12.0),
          child: ListView.separated(
              separatorBuilder: (context, index) {
                return Divider(color: Colors.grey.withOpacity(0.5),);

              },
              itemCount: _con.applications.length,
              itemBuilder: (BuildContext context,int index){


                return  Column(
                  children: [

                    ListTile(


                      onTap: (){
    Navigator.of(context).pushNamed('/${_con.applications[index].status.admin_next.toLowerCase()}', arguments: AdminApplicationModel(id: _con.applications[index].id,admin_next: _con.applications[index].status.admin_next,message: null));


    },
                      title: Text("Job "+ _con.applications[index].id.toString() ,style: TextStyle(color: Colors.black,fontSize: 12,fontWeight: FontWeight.bold),),

                     trailing: Icon(Icons.arrow_forward_ios,color: Colors.black,size: 25,),


                    ),
                    ListView.builder(
                        shrinkWrap: true,
                        primary: false,
                    itemCount: _con.applications[index].documents.length,
                      itemBuilder: (BuildContext context,int indexx){
                      return  Card(
                        elevation: 0.0,
                        child: Column(
                          children: [
                            ListTile(
                              trailing: Text(_con.applications[index].documents[indexx].documentTypeModel.country.currency+(_con.applications[index].earningSetting.getPercentage()*_con.applications[index].documents[indexx].getPrice()).toStringAsFixed(2),style: TextStyle(color: Colors.black,fontSize: 12,fontWeight: FontWeight.bold),),

                              title: Text(_con.applications[index].documents[indexx].documentTypeModel.type,style: TextStyle(color: Colors.black,fontSize: 12,fontWeight: FontWeight.bold),),

                              subtitle: Text(_con.applications[index].documents[indexx].documentTypeModel.country.currency+ _con.applications[index].documents[indexx].getPrice().toStringAsFixed(2),style: TextStyle(color: Colors.black,fontSize: 12,fontWeight: FontWeight.bold),),

                            ),

                          ],
                        ),

                      );
    }),       ListTile(
                      trailing: Text(currentuser.value.country.currency+_con.applications[index].gettotalPrice(),style: TextStyle(color: Colors.black,fontSize: 12,fontWeight: FontWeight.bold),),

                      title: Text("Total",style: TextStyle(color: Colors.black,fontSize: 12,fontWeight: FontWeight.bold),),


                    ),
                  ],
                );



              }
          ),
        )
    );
  }
}
