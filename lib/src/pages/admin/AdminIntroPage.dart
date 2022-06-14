import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:horizon/src/pages/Login.dart';
import 'package:horizon/src/repositories/user_repository.dart';
import 'package:introduction_screen/introduction_screen.dart';

import 'package:shared_preferences/shared_preferences.dart';

class AdminIntroPage extends StatefulWidget {
  @override
  _AdminIntroPageState createState() => _AdminIntroPageState();
}

class _AdminIntroPageState extends State<AdminIntroPage> {
  final introKey = GlobalKey<IntroductionScreenState>();

  Future<void> _onIntroEnd(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('installed', true);
     Navigator.of(context).pushReplacementNamed('/${currentuser.value.role.home}', arguments: 1);

  }

  Widget _buildFullscrenImage() {
    return Image.asset(
      'assets/1.png',
      fit: BoxFit.cover,
      height: double.infinity,
      width: double.infinity,
      alignment: Alignment.center,
    );
  }

  Widget _buildImage(String assetName, [double width = 350]) {
    return Image.asset(assetName, width: 50,height: 50,      alignment: Alignment.center,
    );
  }

  @override
  Widget build(BuildContext context) {
    var bodyStyle = TextStyle(fontSize: 15.0,fontWeight: FontWeight.w500);
    var pageDecoration =  PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.all(100),

    );

    return WillPopScope(

      onWillPop: () async{
        return false;
      },
      child: IntroductionScreen(
        key: introKey,
        globalBackgroundColor: Colors.white,


        pages: [
          PageViewModel(

            body: "Press the right bottom arrow to see the certification stages or Skip to home.",
            // bodyWidget: Column(children: [
            //
            //
            //   Text(  "Press right bottom arrow to see the certification stages or Skip to home."),
            //   SizedBox(height: 40,),
            //   _buildImage('assets/guide/info.png')
            //
            // ],),
            title: "Sertifyd Guide",
            // body:
            // "Press right bottom arrow to see the certification stages or Skip to home.",
            image: _buildImage('assets/guide/info.png'),
            decoration: pageDecoration,
          ),
          PageViewModel(
            title: "New Job",
            body:
            "After receiving a job notification, you will find it under the pending applications tab. You then have to open and accept it then it will be moved to the 'Scheduled tab'.",
            image: _buildImage('assets/guide/add.png'),
            decoration: pageDecoration,
          ),
          PageViewModel(
            title: "Payment",
            body:
            "The client will receive a notification after you pick the application but they will have to pay first before proceeding with the process.",
            image: _buildImage('assets/guide/payment.png'),
            decoration:  pageDecoration,
          ),
          PageViewModel(
            title: "Meeting,Communication and Completion",
            body:
            "After a Zoom meeting has been scheduled, you can communicate with the client via in app messaging. You can action the documents(reject or certify) at this stage and mark them as completed. The client will receive a notification to download the certified documents.",
            image: _buildImage('assets/guide/pass.png'),
            decoration:  const PageDecoration(
              titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
              bodyTextStyle: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w500),
              descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
              pageColor: Colors.white,
              imagePadding: EdgeInsets.all(100),

            ),
          ),

        ],

        onSkip: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setBool('installed', true);
          return  Navigator.of(context).pushReplacementNamed('/${currentuser.value.role.home}', arguments: 1);
        },
        onDone: () => _onIntroEnd(context),
        //onSkip: () => _onIntroEnd(context), // You can override onSkip callback
        showSkipButton: true,
        skipFlex: 0,
        nextFlex: 0,
        //rtl: true, // Display as right-to-left
        skip:  Text('skip',style: Theme.of(context).textTheme.headline5.copyWith(fontSize: 14.0),),
        next:  Icon(Icons.arrow_forward,color: Theme.of(context).textTheme.headline5.color,),
        done:  Text('done', style:Theme.of(context).textTheme.headline5.copyWith(fontSize: 14.0)),
        curve: Curves.fastLinearToSlowEaseIn,

        dotsDecorator:  DotsDecorator(
          size: Size(10.0, 10.0),
          activeColor: Theme.of(context).textTheme.headline5.color,
          color:Theme.of(context).accentColor,
          activeSize: Size(22.0, 10.0),
          activeShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(25.0)),
          ),
        ),

      ),
    );
  }
}