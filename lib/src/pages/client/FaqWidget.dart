import 'dart:io';

import 'package:flutter/material.dart';
import 'package:horizon/src/controllers/FaqController.dart';
import 'package:horizon/src/elements/CircularLoadingWidget.dart';
import 'package:horizon/src/elements/FaqItem.dart';
import 'package:horizon/src/repositories/global_repository.dart';
import 'package:horizon/src/repositories/settings_repository.dart';
import 'package:horizon/src/repositories/user_repository.dart';

import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:url_launcher/url_launcher.dart';

class FaqWidget extends StatefulWidget {

  final String endpoint;
  FaqWidget({Key key, this.endpoint}) : super(key: key);

  @override
  _FaqWidgetState createState() => _FaqWidgetState();
}

class _FaqWidgetState extends StateMVC<FaqWidget> {


  FaqController _con;

  _FaqWidgetState() : super(FaqController()) {

    _con = controller;
  }

  @override
  void initState() {
    _con.listenForfaqs(widget.endpoint);

    Map map={"action":"faq","platform":Platform.isIOS?"ios":"android","user_id":currentuser.value.id??0,"device":detailsModel.value.identifier,"detail":"faq"};

    log_activity(map);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
bottomNavigationBar: setting.value.helpline!=null?BottomAppBar(

  child:   SafeArea(

    child: InkWell(

      onTap: (){

        String phone=setting.value.helpline;
        _makePhoneCall('tel:$phone');
      },
      child: Container(
        height: MediaQuery.of(context).size.height*0.1,
        color: Colors.white,
        child: Row(

          mainAxisAlignment: MainAxisAlignment.center,

          children: [


          Container(

            child: Center(child: Text("Helpline",style: TextStyle(color: Theme.of(context).accentColor,fontSize: 12.0,fontWeight: FontWeight.bold),)),

          ),
SizedBox(width: 30,),
          Icon(Icons.phone,color: Theme.of(context).accentColor,size: 20,)

        ],),
      ),
    ),
  ),
):null,
        key: _con.scaffoldKey,
        appBar: AppBar(
          elevation: 0.0,
          centerTitle: true,
// actions:setting.value.helpline!=null? [
// Center(child: Text("Helpline")),
//   InkWell(
//
//
//       onTap: (){
//       String phone=setting.value.helpline;
//       _makePhoneCall('tel:$phone');
//
//       },
//       child: Icon(Icons.phone)),SizedBox(width: 10,)
// ]:null,
          title: Text("Frequently Asked Questions",style: TextStyle(color: Theme.of(context).accentColor,letterSpacing: 1.3,fontSize: 12),),
          backgroundColor: Colors.white,
          leading: InkWell(
              onTap: (){
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back_ios,)),
        ),
        body: _con.faqs.length<1?CircularLoadingWidget(height: 500,): Padding(
          padding: const EdgeInsets.symmetric(horizontal:8.0),
          child: RefreshIndicator(
            onRefresh: ()async{
              _con.refreshFaqs(widget.endpoint);
            },
            child:    ListView.separated(
              padding: EdgeInsets.symmetric(vertical: 5),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              primary: false,
              itemCount: _con.faqs.length,
              separatorBuilder: (context, index) {
                return SizedBox(height: 15);
              },
              itemBuilder: (context, indexFaq) {
                return FaqItemWidget(faq: _con.faqs.elementAt(indexFaq));
              },
            ),
          ),
        )

    );
  }

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
