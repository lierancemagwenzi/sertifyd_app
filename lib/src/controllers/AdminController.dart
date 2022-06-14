import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:horizon/src/controllers/GeneralController.dart';
import 'package:horizon/src/model/AdminApplication.dart';
import 'package:horizon/src/model/ApplicationModel.dart';
import 'package:horizon/src/model/BankModel.dart';
import 'package:horizon/src/model/DocumentType.dart';
import 'package:horizon/src/model/EarningsStat.dart';
import 'package:horizon/src/model/PaymentDetail.dart';
import 'package:horizon/src/model/PaymentMethod.dart';
import 'package:horizon/src/model/SertificationDocument.dart';
import 'package:horizon/src/model/SertifyerTerm.dart';
import 'package:horizon/src/model/SignatureModel.dart';
import 'package:horizon/src/model/UserModel.dart';
import 'package:horizon/src/model/ZoomMettingModel.dart';
import 'package:horizon/src/pages/AdminHome.dart';
import 'package:horizon/src/pages/admin/ApplicationScreen.dart';
import 'package:horizon/src/repositories/admin_repository.dart';
import 'package:horizon/src/repositories/application_repository.dart';
import 'package:horizon/src/repositories/global_repository.dart';
import 'package:horizon/src/repositories/login_repository.dart';
import 'package:horizon/src/repositories/sertifyer_repository.dart';
import 'package:horizon/src/repositories/settings_repository.dart';
import 'package:horizon/src/repositories/user_repository.dart';
import 'package:intl/intl.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:horizon/src/repositories/settings_repository.dart' as settingRepo;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class   AdminController extends GeneralController {
  GlobalKey<ScaffoldState> scaffoldKey;
  List<CertificationApplicationModel> applications=[];

  List<CertificationApplicationModel> scheduled=[];


  List<CertificationApplicationModel> completed=[];

  List<CertificationApplicationModel> schedule=[];

  List<BankModel> banks=[];

  bool loading=false;

  bool success=false;

  int currentindex=0;

  ZoomMeetingModel zoomMeetingModel;

  List<PaymentMethod> payment_methods=[];

  List<PaymentDetail> payment_details=[];


   ProgressDialog pr ;
  String progress_status='';
  double progress=0.0;

  CertificationApplicationModel certificationApplicationModel;

  AdminController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }

  List<Color> colors=[Color(0xffed7e7f),Color(0xffb0c3de),Color(0xff9bd7e8),Color(0xffa5eeb9),Color(0xffdcc2ec),];





  getColor(){

    final _random = new Random();

    Color color= colors[_random.nextInt(colors.length)];

    return color;
  }

  void LogoutUser(BuildContext context) {
    logoutuser().then((value) async {
      print(value);

      if(value!=null){

        SharedPreferences prefrences= await SharedPreferences.getInstance();
        currentuser.value=new UserModel(id: 0);
        await prefrences.clear();
        Navigator.pushNamed(context, '/Login');
      }
      else{
        scaffoldKey?.currentState?.showSnackBar(SnackBar(
          content: Text('An error occurred'),
        ));

      }


    });
  }





  Future<void> listenForBanks() async {
    banks.clear();
    final Stream<BankModel> stream = await getBanks();
    stream.listen((BankModel bankModel) {
      setState(() => banks.add(bankModel));
    }, onError: (a) {

      print(a);
    }, onDone: () {

    });
  }





  Future<void> GetJobApplication(int id,BuildContext context,{String message}) async {


    final Stream<CertificationApplicationModel> stream = await getApplicationjob(
        id);

    stream.listen((
        CertificationApplicationModel certificationApplicationModel) {

      setState(() {

        loading=false;
      });
      if(certificationApplicationModel.status.admin_next!=null){

        if(certificationApplicationModel.satifyer_id!=null&&certificationApplicationModel.satifyer_id!=currentuser.value.id){

          Navigator.pushNamed(context, '/Taken');
        }

        else{

          Navigator.pushNamed(scaffoldKey.currentContext, "/${certificationApplicationModel.status.admin_next}",arguments:new AdminApplicationModel(id:certificationApplicationModel.id,message: message) );

        }

      }
      else{
        scaffoldKey?.currentState?.showSnackBar(SnackBar(
          content: Text('Cannot get application'),
        ));
      }

    }, onError: (a) {
      print("error ");
setState(() {
  loading=false;
});
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text('Cannot get application'),
      ));
      // scaffoldKey?.currentState?.showSnackBar(SnackBar(
      //   content: Text("Check your connection"),
      // ));
      print(a);
    }, onDone: () {

print("completed");
    });
  }



  Future<void> GetApplication(int id,BuildContext context,{String message}) async {
    final Stream<CertificationApplicationModel> stream = await getApplication(
        id);

    stream.listen((
        CertificationApplicationModel certificationApplicationModel) {
      if(certificationApplicationModel.status.admin_next!=null){

        if(certificationApplicationModel.satifyer_id!=null&&certificationApplicationModel.satifyer_id!=currentuser.value.id){

          Navigator.pushNamed(context, '/Taken');
        }

        else{

          Navigator.pushNamed(context, "/${certificationApplicationModel.status.admin_next}",arguments:new AdminApplicationModel(id:certificationApplicationModel.id,message: message) );

        }


      }

      else{

        scaffoldKey?.currentState?.showSnackBar(SnackBar(
          content: Text('Cannot get application'),
        ));
      }


    }, onError: (a) {
      // scaffoldKey?.currentState?.showSnackBar(SnackBar(
      //   content: Text("Check your connection"),
      // ));
      print(a);
    }, onDone: () {

    });
  }


  Future<void> listenForApplications({String message}) async {
    applications.clear();

    setState(() {

      loading=true;
    });
    final Stream<CertificationApplicationModel> stream = await getPendingApplications();
    stream.listen((CertificationApplicationModel certificationApplicationModel) {
      setState(() => applications.add(certificationApplicationModel));
    }, onError: (a) {

      setState(() {

        loading=false;
      });
      if(message!=null){
        scaffoldKey?.currentState?.showSnackBar(SnackBar(
          content: Text("No data found"),
        ));

      }
      print(a);
    }, onDone: () {
      if(message!=null){
        // scaffoldKey?.currentState?.showSnackBar(SnackBar(
        //   content: Text(message),
        // ));


        setState(() {

          loading=false;
        });

      }
    });
  }

  Future<void> listenForPaymentMethods() async {
    payment_methods.clear();
    final Stream<PaymentMethod> stream = await getPaymentMethods();
    stream.listen((PaymentMethod paymentMethod) {
      setState(() => payment_methods.add(paymentMethod));
    }, onError: (a) {

      // scaffoldKey?.currentState?.showSnackBar(SnackBar(
      //   content: Text("Check your connection"),
      // ));
      print(a);
    }, onDone: () {

    });
  }

  Future<void> listenForPaymentDetail() async {
    payment_details.clear();
    final Stream<PaymentDetail> stream = await getPaymentDetails();
    stream.listen((PaymentDetail paymentDetail) {
      setState(() => payment_details.add(paymentDetail));
    }, onError: (a) {

      // scaffoldKey?.currentState?.showSnackBar(SnackBar(
      //   content: Text("Check your connection"),
      // ));
      print(a);
    }, onDone: () {

    });
  }


  Future<void> listenForScheduledApplications({String message}) async {
    scheduled.clear();


    setState(() {

      loading=true;
    });
    final Stream<CertificationApplicationModel> stream = await getScheduledApplications();
    stream.listen((CertificationApplicationModel certificationApplicationModel) {
      setState(() => scheduled.add(certificationApplicationModel));
    }, onError: (a) {
      if(message!=null){
        scaffoldKey?.currentState?.showSnackBar(SnackBar(
          content: Text("No data found"),
        ));

      }
      print(a);
    }, onDone: () {

      setState(() {

        loading=false;
      });
      if(message!=null){
        // scaffoldKey?.currentState?.showSnackBar(SnackBar(
        //   content: Text(message),
        // ));

        setState(() {

          loading=false;
        });
      }
    });
  }

  Future<void> listenForUpcomingApplications({String message}) async {
    completed.clear();


    setState(() {

      loading=true;
    });
    final Stream<CertificationApplicationModel> stream = await getUpcomingjobs();
    stream.listen((CertificationApplicationModel certificationApplicationModel) {
      setState(() => completed.add(certificationApplicationModel));
    }, onError: (a) {


      setState(() {

        loading=false;
      });
      if(message!=null){
        scaffoldKey?.currentState?.showSnackBar(SnackBar(
          content: Text("No data found"),
        ));

      }
      print(a);
    }, onDone: () {


      setState(() {

        loading=false;
      });
      if(message!=null){
        // scaffoldKey?.currentState?.showSnackBar(SnackBar(
        //   content: Text(message),
        // ));

      }
    });
  }



  Future<void> listenForDaySchedule(String date,String start_time,String end_time) async {
    schedule.clear();
    DateFormat format =
    DateFormat("yyyy-MM-dd");
     Stream<CertificationApplicationModel> stream;
    if(format.format(DateTime.now())==date){
      stream = await getdayschedule(date,DateFormat('HH:mm').format(DateTime.now().add(Duration(minutes: 2))),end_time);
    }
    else{

      stream = await getdayschedule(date,start_time,end_time);
    }


    stream.listen((CertificationApplicationModel certificationApplicationModel) {
      setState(() => schedule.add(certificationApplicationModel));
    }, onError: (a) {
      // scaffoldKey?.currentState?.showSnackBar(SnackBar(
      //   content: Text("Check your connection"),
      // ));
      print(a);
    }, onDone: () {
    });
  }

  Future<void> listenForJobApplication(int id) async {
    final Stream<CertificationApplicationModel> stream = await getApplication(id);
    stream.listen((CertificationApplicationModel certificationApplicationModel) {
      setState(() {
        this.certificationApplicationModel=certificationApplicationModel;
      });

    }, onError: (a) {

      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text("Check your connection"),
      ));
      print(a);
    }, onDone: () {

      listenForDaySchedule(certificationApplicationModel.date,certificationApplicationModel.start_time,certificationApplicationModel.end_time);

    });
  }

  Future<void> listenForApplication(int id,{String admin_next,BuildContext context}) async {
    final Stream<CertificationApplicationModel> stream = await getApplication(id);
    stream.listen((CertificationApplicationModel certificationApplicationModel) {
      if(admin_next==null){

        setState(() {
          this.certificationApplicationModel = certificationApplicationModel;
        });
      }

      else{

        if( admin_next==certificationApplicationModel.status.admin_next){

          setState(() {
            this.certificationApplicationModel = certificationApplicationModel;
          });
        }
        else{
          if(certificationApplicationModel.status.status.toLowerCase()=='pending'){
            Navigator.of(context).pushReplacementNamed('/${certificationApplicationModel.status.admin_next.toLowerCase()}', arguments: AdminApplicationModel(id: certificationApplicationModel.id,message:null,));
          }
          else{
            Navigator.pushReplacementNamed(context, "/${certificationApplicationModel.status.admin_next}",arguments: AdminApplicationModel(id: certificationApplicationModel.id));
          }
        }}

    }, onError: (a) {

      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text("Check your connection"),
      ));
      print(a);
    }, onDone: () {
      Map map={"action":"application","platform":Platform.isIOS?"ios":"android","user_id":currentuser.value.id??0,"device":detailsModel.value.identifier,"detail":"application","action_id":id};

      log_activity(map);
    });
  }


  CreateDialog(){

    pr.style(
        message:"",
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: CircularProgressIndicator(),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progress: 0.0,
        maxProgress: 100.0,
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600)
    );


  }


  UpdateProgress(ProgressDialog pr){
    pr.update(
      progress: 50.0,
      message: "Saving Job...",
      progressWidget: Container(
          padding: EdgeInsets.all(8.0), child: CircularProgressIndicator()),
      maxProgress: 100.0,
      progressTextStyle: TextStyle(
          color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
      messageTextStyle: TextStyle(
          color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600),
    );
  }


  Future<void>  AcceptJob(Map map,BuildContext context) async {
    setState(() {
      loading=true;
    });
    acceptjob(map).then((value) async {
      print(value);
      if(value!=null){
        setState(() {
          success=true;

        });

        Navigator.of(context).pushReplacementNamed('/${value.status.admin_next.toLowerCase()}', arguments: AdminApplicationModel(message: "The job is yours!",id: value.id));

      }
      else{
        setState(() {
          success=false;
          loading=false;
        });
        scaffoldKey?.currentState?.showSnackBar(SnackBar(
          content: Text("Failed to process request.Try again"),
        ));

      }

    });

  }


  Future<void>  CreateMeeting(ZoomMeetingModel zoom,BuildContext context) async {
    pr = ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: false, showLogs: true);
    pr.style(
        message: 'Creating meeting',
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: CircularProgressIndicator(),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progress: 0.0,
        maxProgress: 100.0,
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600)
    );
    await pr.show();
    setState(() {
      loading=true;
      progress_status='Creating meeting';
    });
    createmeeting(zoom.toMap()).then((value) async {
      print(value);
        if(value!=null){
          setState(() {
          zoomMeetingModel=value;
          success=true;
          UpdateApplication({"zoom_meeting_id":value.id,"sertifyer_id":currentuser.value.id},{"id":certificationApplicationModel.id}, certificationApplicationModel.id,"Scheduled",context);

          });
        }
        else{
          setState(() {
            success=false;
            loading=false;
          });
          scaffoldKey?.currentState?.showSnackBar(SnackBar(
            content: Text("Failed to create meeting.Try again"),
          ));

          await pr.hide();
        }

    });
  }





  void  UpdateApplication(Map filter,Map condition,int model_id,String status,BuildContext context) {
    setState(() {
      progress_status='updating job';
      loading=true;
    });
    var  map={
      "model_id":model_id,
      "status":status,
      "case":condition,
      "filter":filter
    };


    updateapplication(map).then((value) async {
      print(value);
        loading=false;
        progress_status='';
        if(value!=null){
          setState(() {
          certificationApplicationModel=value;
          success=true;
          });
          await pr.hide();

          Navigator.of(context).pushReplacementNamed('/${value.status.admin_next.toLowerCase()}', arguments: new AdminApplicationModel(id: value.id,message: "Meeting Created successfully"));
          // scaffoldKey?.currentState?.showSnackBar(SnackBar(
          //   content: Text("Job is yours!"),
          // ));
        }
        else{

          setState(() {
            success=false;

          });

          scaffoldKey?.currentState?.showSnackBar(SnackBar(
            content: Text("Failed to accept Job"),
          ));
        }

    });
  }


  Future<void > refreshJobs(){

    listenForApplications(message:"Refreshed successfully");


  }

  Future<void > refreshScheduledJobs(){

    listenForScheduledApplications(message:"Refreshed successfully");

  }
  Future<void > refreshUpcomingJobs(){

    listenForUpcomingApplications(message:"Refreshed successfully");
    // RefreshProfile();


    setState(() {

      currentuser.value=currentuser.value;

    });


  }


  Future<void>  CertifyDoc(Map data,int index,BuildContext context) async {
    pr = ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: false, showLogs: true);
    pr.style(
        message: 'Certifying Document',
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: CircularProgressIndicator(),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progress: 0.0,
        maxProgress: 100.0,
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600)
    );
    await pr.show();
    setState(() {
      loading=true;
    });

    sertifyDoc(data).then((value) async {
      print(value);
      loading=false;
      if(value!=null){
        setState(() {
         certificationApplicationModel.documents[index]=value;
          success=true;
        });
        await pr.hide();

        scaffoldKey?.currentState?.showSnackBar(SnackBar(
          content: Text("certified successfully"),
        ));
      }
      else{
        await pr.hide();
        setState(() {
          success=false;
        });
        scaffoldKey?.currentState?.showSnackBar(SnackBar(
          content: Text("Failed to process request"),
        ));
      }
    });
  }


  Future<void>  CertifyDocs(List docs,List rejected,int model_id,BuildContext context) async {
    pr = ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: false, showLogs: true);
    pr.style(
        message: 'Certifying Documents',
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: CircularProgressIndicator(),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progress: 0.0,
        maxProgress: 100.0,
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600)
    );
    await pr.show();
    setState(() {
      loading=true;
    });
    var  map={
      "documents":docs,
      "rejected":rejected,
      "model_id":model_id,
    };
    sertifyDocs(map).then((value) async {
      print(value);
      loading=false;
      if(value!=null){
        setState(() {
          certificationApplicationModel=value;
          success=true;
        });
        await pr.hide();
        Navigator.pop(context);
        Navigator.of(context).pushReplacementNamed('/${value.status.admin_next.toLowerCase()}', arguments: value.id);
        // Navigator.pushReplacement(
        //     context,
        //     CupertinoPageRoute(
        //         builder: (context) => AdminHome(
        //           // application_id: value.id,
        //
        //         )));
        scaffoldKey?.currentState?.showSnackBar(SnackBar(
          content: Text("certified successfully"),
        ));
      }
      else{
        await pr.hide();

        setState(() {
          success=false;
        });
        scaffoldKey?.currentState?.showSnackBar(SnackBar(
          content: Text("Failed to submit request"),
        ));
      }
    });
  }


  Future<void>  AddSignature(SignatureModel signatureModel,BuildContext context) async {
    pr = ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: false, showLogs: true);
    pr.style(
        message: 'Uploading Signature',
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: CircularProgressIndicator(),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progress: 0.0,
        maxProgress: 100.0,
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600)
    );
    await pr.show();
    setState(() {
      loading=true;
    });
    var  map={
      "id":currentuser.value.id,
      "path":signatureModel.path,
    };
    UploadSignature(map).then((value) async {
      print(value);
      loading=false;
      if(value!=null){
        setState(() {
          currentuser.value=value;
          success=true;
        });
        await pr.hide();
        Navigator.pop(context);
        Navigator.of(context).pushReplacementNamed('/Settings',arguments: "signature added successfully");
        scaffoldKey?.currentState?.showSnackBar(SnackBar(
          content: Text("signature added successfully"),
        ));
      }
      else{
        await pr.hide();

        setState(() {
          success=false;
        });
        scaffoldKey?.currentState?.showSnackBar(SnackBar(
          content: Text("Failed to submit signature"),
        ));
      }
    });
  }


  void AddPaymentData(PaymentDetail paymentDetail,BuildContext context) {
    setState(() {
      loading=true;
    });
    SavePaymentData(paymentDetail.toMap()).then((value) {
      print(value);
      setState(() {
        loading=false;
        if(value!=null){
         payment_details.add(value);
         scaffoldKey?.currentState?.showSnackBar(SnackBar(
           content: Text("Payment details added"),
         ));
         print(payment_details.length);
        }
        else{
          scaffoldKey?.currentState?.showSnackBar(SnackBar(
            content: Text("An error occurred"),
          ));
        }
      });
    });
  }






  Future<void> RefreshProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String  user=prefs.getString('user_details')??null;
    // print(user);
    print("main");
    if(user!=null){
      UserModel userModel=UserModel.fromJson(jsonDecode(user)['data']);
      RefreshUser(userModel.access_token,{"id":userModel.id});
    }

    // RefreshUser().then((value) {
    //   print(value);
    //   setState(() {
    //     loading=false;
    //     if(value!=null){
    //       payment_details[index]=value;
    //     }
    //     else{
    //       scaffoldKey?.currentState?.showSnackBar(SnackBar(
    //         content: Text("An error occurred"),
    //       ));
    //     }
    //   });
    // });
  }

  void UpdatePaymentData(PaymentDetail paymentDetail,bool make_default,BuildContext context,int index) {
    setState(() {
      loading=true;
    });

    var value={"fields":paymentDetail.toMap(),"id":paymentDetail.id,"is_default":make_default};
    updatePaymentData(value).then((value) {
      print(value);
      setState(() {
        loading=false;
        if(value!=null){
          if(value.is_default){
            for(int i=0;i<payment_details.length;i++){
              payment_details[i].is_default=false;

            }
          }
         payment_details[index]=value;
        }
        else{
          scaffoldKey?.currentState?.showSnackBar(SnackBar(
            content: Text("An error occurred"),
          ));
        }
      });
    });
  }


  void UpdateNotificationData(bool setting) {
    setState(() {
      loading=true;
    });
    var value={"data":setting?1:0,"user_id":currentuser.value.id};
    updatenotificationsettings(value).then((value) {
      print(value);
      setState(() {
        loading=false;
        if(value!=null){
         currentuser.value.receive_job_notifications=setting;

         scaffoldKey?.currentState?.showSnackBar(SnackBar(
           content: Text("updated"),
         ));
        }
        else{
          scaffoldKey?.currentState?.showSnackBar(SnackBar(
            content: Text("An error occurred"),
          ));
        }
      });
    });
  }


}
