import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:horizon/src/controllers/HomePageController.dart';
import 'package:horizon/src/helper/Helper.dart';
import 'package:horizon/src/model/ApplicationModel.dart';
import 'package:horizon/src/helper/string_extension.dart';
import 'package:horizon/src/pages/ViewApplication.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;



class AppWidget extends StatefulWidget {


  AppWidget notification;


  BuildContext context;
  CertificationApplicationModel appplicationModel;HomePageController homePageController;int index;

  AppWidget({Key key,this.appplicationModel,this.homePageController,this.context,this.index}) : super(key: key);

  @override
  _AppWidgetState createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
  @override
  Widget build(BuildContext context) {
    now=DateTime.now();
    return AppWidget1(
        widget.context, widget.appplicationModel, widget.homePageController,
        widget.index);
  }

  Timer timer;

  var fifteenAgo;


  DateTime now=DateTime.now();
  @override
  void initState() {
    timer = Timer.periodic(Duration(seconds: 5), (Timer t) => CalulateTime());
    CalulateTime();

    super.initState();
  }

  CalulateTime() {
    setState(() {
      now=DateTime.now();
    });
  }
  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Widget AppWidget1(BuildContext context,
      CertificationApplicationModel appplicationModel,
      HomePageController homePageController, int index) {
    double height = MediaQuery
        .of(context)
        .size
        .height;
    double width = MediaQuery
        .of(context)
        .size
        .width;

    DateFormat format =
    DateFormat("yyyy-MM-dd");

    var formated =
    format.parse(appplicationModel.date);

    var date =
    DateFormat.yMMMMEEEEd().format(formated);

    // final fifteenAgo = new DateTime.now().subtract(new Duration(minutes: 15));
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          InkWell(

            onTap: () async {
              Navigator.pushNamed(
                  context, "/${appplicationModel.status.client_next}",
                  arguments: appplicationModel.id);
            },

            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Theme
                        .of(context)
                        .accentColor
                        .withOpacity(0.1),

                  ),
                  borderRadius: BorderRadius.all(Radius.circular(14))
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(height: 20.0,),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6.0),
                    child: ListTile(
                      leading: AspectRatio(

                        aspectRatio: 6 / 6,
                        child: Container(

                          height: 100, width: 100,
                          // child: Center(
                          //   child: Text((index + 0).toString(), style:
                          //   Theme
                          //       .of(context)
                          //       .textTheme
                          //       .headline5
                          //       .copyWith(color: Colors.black87),),
                          // ),

                          child: Icon(Icons.folder),
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey.withOpacity(0.3),


                              ),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(20))
                          ),
                        ),
                      ),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(child: AutoSizeText(
                            Helper.getDocuments(appplicationModel), style: Theme
                              .of(context)
                              .textTheme
                              .headline5
                              .copyWith(fontWeight: FontWeight.bold,
                              color: Colors.black87,
                              fontSize: 16.0), maxLines: 1,),),

                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                  decoration: BoxDecoration(
                                      color: Theme
                                          .of(context)
                                          .primaryColorLight.withOpacity(0.8),

                                      borderRadius: BorderRadius.all(
                                          Radius.circular(5))
                                  ),

                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4.0),
                                    child: Center(child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 4.0),
                                          child: Text(
                                            appplicationModel.status.status
                                                .capitalize(), style: Theme
                                              .of(context)
                                              .textTheme
                                              .headline5
                                              .copyWith(
                                              fontWeight: FontWeight.normal,
                                              color: Colors.white,
                                              fontSize: 16.0), maxLines: 1,),
                                        ),
                                      ],
                                    )),
                                  )),
                            ],
                          ),
                        ],
                      ),

                      subtitle: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 5.0,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(Icons.calendar_today_outlined, color: Theme
                                  .of(context)
                                  .accentColor.withOpacity(0.5),),

                              SizedBox(width: 5.0,),
                              Text(timeago.format(now.subtract(Duration( minutes:new DateTime.now().difference(formated).inMinutes)))??'', style: Theme
                                  .of(context)
                                  .textTheme
                                  .headline5
                                  .copyWith(fontWeight: FontWeight.normal,
                                  color: Color(0xffa4a7a6)
                                  ,
                                  fontSize: 14.0),),

                            ],
                          ),

                          SizedBox(height: 5.0,),
                          appplicationModel.start_time != null ? Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(Icons.watch_later, color: Theme
                                  .of(context)
                                  .accentColor.withOpacity(0.5),),

                              SizedBox(width: 5.0,),
                              Text(appplicationModel.start_time, style: Theme
                                  .of(context)
                                  .textTheme
                                  .headline5
                                  .copyWith(fontWeight: FontWeight.normal,
                                  color: Color(0xffa4a7a6)
                                  ,
                                  fontSize: 14.0),),

                            ],
                          ) : Text(""),

                          SizedBox(height: 20.0,),

                        ],
                      ),
                    ),
                  ),


                ],
              ),

            ),
          ),

        ],
      ),
    );


    ;
  }

}