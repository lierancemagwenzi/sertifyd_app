import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:horizon/src/pages/Home.dart';




class EmptyMessagesWidget extends StatefulWidget {
  EmptyMessagesWidget({
    Key key,
  }) : super(key: key);

  @override
  _EmptyMessagesWidgetState createState() => _EmptyMessagesWidgetState();
}

class _EmptyMessagesWidgetState extends State<EmptyMessagesWidget> {
  bool loading = true;

  @override
  void initState() {
    Timer(Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        loading
            ? SizedBox(
          height: 1,
          child: LinearProgressIndicator(
            backgroundColor: Theme.of(context).accentColor.withOpacity(0.2),
          ),
        )
            : SizedBox(),
        Container(
          alignment: AlignmentDirectional.center,
          padding: EdgeInsets.symmetric(horizontal: 30),
          height: MediaQuery.of(context).size.height*0.5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    width: 150,
                    height: 150,
                    // decoration: BoxDecoration(
                    //     shape: BoxShape.circle,
                    //     gradient: LinearGradient(begin: Alignment.bottomLeft, end: Alignment.topRight, colors: [
                    //       Theme.of(context).focusColor.withOpacity(0.7),
                    //       Theme.of(context).focusColor.withOpacity(0.05),
                    //     ])),
                    child: Icon(
                      Icons.chat_bubble,
                      color: Theme.of(context).primaryColorLight,
                      size: 70,
                    ),
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
              SizedBox(height: 15),
              Opacity(
                opacity: 0.4,
                child: Text(
                  "You do not have any messages"    ,

                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline3.merge(TextStyle(fontWeight: FontWeight.bold,fontSize: 10.0,color:Colors.black)),
                ),
              ),
              SizedBox(height: 50),
              // !loading
              //     ? FlatButton(
              //   onPressed: () {
              //     Navigator.push(context,
              //         CupertinoPageRoute(builder: (context) => Home(index: 2,)));
              //   },
              //   padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
              //   color:Theme.of(context).accentColor,
              //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
              //   child: Text(
              //     "Start Exploring ",
              //     style: Theme.of(context).textTheme.headline6.merge(TextStyle(color: Theme.of(context).scaffoldBackgroundColor)),
              //   ),
              // )
              //     : SizedBox(),
            ],
          ),
        ),
      ],
    );
  }
}
