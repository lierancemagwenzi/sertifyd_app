import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:horizon/src/controllers/sertifyer_controller.dart';
import 'package:horizon/src/helper/Helper.dart';
import 'package:horizon/src/pages/ApplicationSuccess.dart';
import 'package:horizon/src/pages/AppliocationScreen.dart';
import 'package:horizon/src/repositories/global_repository.dart';
import 'package:horizon/src/repositories/settings_repository.dart';
import 'package:horizon/src/repositories/user_repository.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

class SertifyerApplication extends StatefulWidget {

  @override
  _SertifyerApplicationState createState() => _SertifyerApplicationState();
}

class _SertifyerApplicationState extends StateMVC<SertifyerApplication> {

  SertifyerController _con;

  _SertifyerApplicationState() : super(SertifyerController()) {
    _con = controller;
  }
bool agree=false;
  @override
  void initState() {

    Map map={"action":"notary_application","platform":Platform.isIOS?"ios":"android","user_id":currentuser.value.id??0,"device":detailsModel.value.identifier,"detail":"visited profile",};

    log_activity(map);
    _con.listenForTerms();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key:_con.scaffoldKey,
bottomNavigationBar:          SafeArea(

  child:   Stack(
    fit: StackFit.loose,
    alignment: AlignmentDirectional.center,
    children: <Widget>[
      SizedBox(
        width: MediaQuery.of(context).size.width - 40,
        child: FlatButton(
          onPressed: () {

            if(!agree){
              _con.scaffoldKey?.currentState?.showSnackBar(SnackBar(
                content: Text("Please agree to terms and conditions to proceed"),
              ));

              return;
            }
              Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (context) => ApplicationScreen(

                    )));
          },
          color: Theme.of(context).accentColor,
          disabledColor: Theme.of(context).focusColor.withOpacity(0.5),
          padding: EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(5.0)),
          child: Text(
            "Apply",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyText1.merge(TextStyle(color:!agree?Colors.grey: Colors.white,fontWeight: FontWeight.bold)),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Text(""),
      )
    ],
  ),
),
      appBar: AppBar(

        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: InkWell(

          onTap: (){
            Navigator.pop(context);
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




        title: Text("Commissioner of Oaths Application",style: TextStyle(color: Colors.black,fontSize: 15.0,fontWeight: FontWeight.bold),),

      ),
body: Column(
  children: [
SizedBox(height: 20.0,),
    Center(child: Text("Terms and Conditions",style: Theme.of(context).textTheme.headline5.copyWith(color: Colors.black,fontSize: 15,fontWeight: FontWeight.bold),)),

    SizedBox(height: 20.0,),


    Flexible(
      child: ListView(
        children: [
          ListView.builder(
            shrinkWrap: true,
              primary: false,
              itemCount: _con.terms.length,
              itemBuilder: (BuildContext context,int index){
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical:8.0),
                  child: ExpansionTile(
                    // subtitle: Text(Helper.limitString(_con.terms[index].body,),style: Theme.of(context).textTheme.headline5.copyWith(color: Colors.black87,fontSize: 14.0,fontWeight: FontWeight.normal),textAlign: TextAlign.justify,),
                      leading: AspectRatio(
                        aspectRatio: 6/6,
                        child: Container(
child: Center(child: Text((index+1).toString(),style: TextStyle(color: Colors.black87,fontFamily: "Poppins",fontSize: 22,fontWeight: FontWeight.bold),)),
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey,
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(15))
                          ),
                        ),
                      ),
// trailing: Icon(Icons.arrow_forward_ios,size: 20.0,color: Colors.grey,),
                      title:Text(_con.terms[index].title,style: Theme.of(context).textTheme.headline5.copyWith(color: Colors.black,fontSize: 12.0,fontWeight: FontWeight.bold),),

                    children: [
SizedBox(height: 10.0,),
                     Padding(
                       padding: const EdgeInsets.symmetric(horizontal:15.0),
                       child: Text(_con.terms[index].body??'',style: Theme.of(context).textTheme.headline5.copyWith(color: Colors.black,fontSize: 12.0,fontWeight: FontWeight.normal),textAlign: TextAlign.justify,),
                     ) ,
                      SizedBox(height: 10.0,),
                    ],
                  ),
                );
              }
          ),
          SizedBox(height: 10,),
          CheckboxListTile(
              activeColor: Theme.of(context).accentColor,
              dense: true,
              //font change
              title: new Text(
                "I agree to the terms and conditions",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5),
              ),
              value: agree,
              onChanged: (bool val) {
                setState(() {
                  agree=val;
                });
              }),          SizedBox(height: 10,),

        ],
      ),
    )
  ],
),
    );
  }
}
