import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:horizon/src/elements/ImageViewer.dart';
import 'package:horizon/src/elements/PDFViewer.dart';
import 'package:horizon/src/elements/RescheduleWidget.dart';
import 'package:horizon/src/elements/admin/JobCancelledWidget.dart';
import 'package:horizon/src/elements/admin/JobTakenWidget.dart';
import 'package:horizon/src/pages/AdminHome.dart';
import 'package:horizon/src/pages/DownloadScreen.dart';
import 'package:horizon/src/pages/Home.dart';
import 'package:horizon/src/pages/IntroPage.dart';
import 'package:horizon/src/pages/Login.dart';

import 'package:horizon/src/pages/Login.dart';
import 'package:horizon/src/pages/Notifications.dart';
import 'package:horizon/src/pages/TestDocumentWidget.dart';
import 'package:horizon/src/pages/UploadDocuments.dart';
import 'package:horizon/src/pages/admin/AcceptWidget.dart';
import 'package:horizon/src/pages/admin/AccountEarnings.dart';
import 'package:horizon/src/pages/admin/ActionWidget.dart';
import 'package:horizon/src/pages/admin/AddSignature.dart';
import 'package:horizon/src/pages/admin/AdminIntroPage.dart';
import 'package:horizon/src/pages/admin/AdminNotifications.dart';
import 'package:horizon/src/pages/admin/GroupedEarnings.dart';
import 'package:horizon/src/pages/admin/ImageViewer.dart';
import 'package:horizon/src/pages/admin/MeeetingWidget.dart';
import 'package:horizon/src/pages/admin/PaidWidget.dart';
import 'package:horizon/src/pages/admin/Earnings.dart';
import 'package:horizon/src/pages/admin/Settings.dart';
import 'package:horizon/src/pages/chat/ChatScreen.dart';
import 'package:horizon/src/pages/client/ApplicationWidget.dart';
import 'package:horizon/src/pages/client/DownloadWidget.dart';
import 'package:horizon/src/pages/client/FaqWidget.dart';
import 'package:horizon/src/pages/client/PaidWidget.dart';
import 'package:horizon/src/pages/client/PaymentWidget.dart';
import 'package:horizon/src/pages/client/PendingWidget.dart';
import 'package:horizon/src/pages/splashscreen.dart';
import 'package:horizon/src/repositories/user_repository.dart';



class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case '/Splash':
        return CupertinoPageRoute(builder: (_) => SplashScreen());

      case '/Onboarding':
        return CupertinoPageRoute(builder: (_) =>currentuser.value.role.name=="client"? OnBoardingPage():AdminIntroPage());
      // case '/Onboarding1':
      //   return CupertinoPageRoute(builder: (_) => OnBoardingPage());
      case '/Login':
        return CupertinoPageRoute(builder: (_) => LoginScreen());
      // case '/Pages':
      //   return CupertinoPageRoute(builder: (_) => currentuser.value.idcard_decument_id==null||currentuser.value.residence_proof_decument_id==null?UploadDocumentsWidget():Home(index: args,));
      //
      // case '/Admin':
      //   return CupertinoPageRoute(builder: (_) => currentuser.value.idcard_decument_id==null||currentuser.value.residence_proof_decument_id==null?UploadDocumentsWidget():AdminHome(index: args,));


      case '/Pages':
        return CupertinoPageRoute(builder: (_) => currentuser.value.idcard_decument_id==null||currentuser.value.residence_proof_decument_id==null?Home(index: args,):Home(index: args,));

      case '/Admin':
        return CupertinoPageRoute(builder: (_) => currentuser.value.idcard_decument_id==null||currentuser.value.residence_proof_decument_id==null?AdminHome(index: args,):AdminHome(index: args,));

      case '/Testt':
        return CupertinoPageRoute(builder: (_) => LoginScreen());

      case '/Registration':
        return CupertinoPageRoute(builder: (_) => LoginScreen());
      case '/PDF':
        return CupertinoPageRoute(builder: (_) => PDFViewerWidget(document: args,));
      case '/Download':
        return CupertinoPageRoute(builder: (_) => DownloadScreen(document: args,));
      case '/IMAGE':
        return CupertinoPageRoute(builder: (_) => ImageViewer(document: args,));

      case '/Proof':
        return CupertinoPageRoute(builder: (_) => ProofOfPayment(path: args,));
      case '/pay':
        return CupertinoPageRoute(builder: (_) => PaymentWidget(clientApplication: args,));
      case '/viewpaid':
        return CupertinoPageRoute(builder: (_) => ClientPaidWidget(clientApplication: args,));


      case '/view':
        return CupertinoPageRoute(builder: (_) => ApplicationViewWidget(clientApplication: args,));

      case '/pending':
        return CupertinoPageRoute(builder: (_) => PendingApplicationWidget(clientApplication: args,));

      case '/download':
        return CupertinoPageRoute(builder: (_) => DownloadApplicationWidget(clientApplication: args,));
      case '/Clientnotifications':
        return CupertinoPageRoute(builder: (_) => NotificationWidget(fromlauncher: true,));

        //admin
      case '/action':
        return CupertinoPageRoute(builder: (_) => AcceptWidget(adminApplicationModel: args,));

      case '/meeting':
        return CupertinoPageRoute(builder: (_) => ApplicationMeetingWidget(adminApplicationModel: args,));

      case '/adminview':
        return CupertinoPageRoute(builder: (_) => AdminPaidWidget(adminApplicationModel: args,));
      case '/Adminnotifications':
        return CupertinoPageRoute(builder: (_) => AdminNotificationWidget(fromlauncher: true,));
      case '/Settings':
        return CupertinoPageRoute(builder: (_) => SettingsWidget(message: args,));

      case '/Earnings':
        return CupertinoPageRoute(builder: (_) => AccountEarnings());

      case '/AddSignature':
        return CupertinoPageRoute(builder: (_) => AddSignature());

      case '/Faq':
        return CupertinoPageRoute(builder: (_) => FaqWidget(endpoint: args,));

      case '/job_cancelled':
        return CupertinoPageRoute(builder: (_) => JobCancelledWidget());


      case '/schedule':
        return CupertinoPageRoute(builder: (_) => ActionApplicationWidget(adminApplicationModel: args,));

      case '/reschedule':
        return CupertinoPageRoute(builder: (_) => RescheduleWidget(applicationModel: args,));

      case '/Taken':
        return CupertinoPageRoute(builder: (_) => JobTakenWidget());
      case '/Messaging':
        return CupertinoPageRoute(builder: (_) => ChatScreen(id: args,));
      case '/GroupedEarnings':
        return CupertinoPageRoute(builder: (_) => GroupdEarningsWidget(earningsStat: args,));
      case '/TestDocument':
        return CupertinoPageRoute(builder: (_) => TestDocumentWidget());
      default:
      // If there is no such named route in the switch statement, e.g. /third
        return CupertinoPageRoute(builder: (_) => Scaffold(

            body: SafeArea(child: Center(child: Text('The item you want to access has changed status and is no longer available. Swipe to return')))));
    }
  }
}


