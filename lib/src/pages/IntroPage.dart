import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:horizon/src/pages/Login.dart';
import 'package:horizon/src/repositories/user_repository.dart';
import 'package:introduction_screen/introduction_screen.dart';

import 'package:shared_preferences/shared_preferences.dart';

class OnBoardingPage extends StatefulWidget {
  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
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
    return Image.asset(assetName, width: 50,height: 50,);
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 14.0,fontWeight: FontWeight.w500);

    const pageDecoration = const PageDecoration(
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
            title: "Sertifyd Guide",
            body:
            "Press the right bottom arrow to see the certification stages or Skip to home.",
            image: _buildImage('assets/guide/info.png'),
            decoration: pageDecoration,
          ),
          PageViewModel(
            title: "New Certification",
            body:
            "Add a new Certification by pressing '+ Certification' on the homescreen. You will find it under the 'Pending applications tab'. A commissioner of Oaths will pick your application and you will receive a notification. The application is moved to the 'In Progress tab'.",
            image: _buildImage('assets/guide/add.png'),
            decoration: pageDecoration,
          ),
          PageViewModel(
            title: "Payment",
            body:
            "Payment is required once your application has been picked by a Commissioner of oaths. After payment is successful, a Zoom meeting will be scheduled and you will receive a notification.",
            image: _buildImage('assets/guide/payment.png'),
            decoration:  pageDecoration,
          ),
          PageViewModel(
            title: "Meeting,Communication and Completion",
            body:
            "After a Zoom meeting has been scheduled, you can communicate with the Commissioner of Oaths via in app messaging. The commissioner of Oaths will action the documents and after receiving a notification confirming the completion, find the application under the 'Completed tab'. You will be able to download the certified documents from the phone or from your email.",
            image: _buildImage('assets/guide/pass.png'),

            decoration:  PageDecoration(
              titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),

              bodyTextStyle: TextStyle(fontSize: 12.0,fontWeight: FontWeight.w500),
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