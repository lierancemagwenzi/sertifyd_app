import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_uploader/flutter_uploader.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:horizon/src/controllers/sertifyer_controller.dart';
import 'package:horizon/src/elements/CircularLoadingWidget.dart';
import 'package:horizon/src/model/UploadItem.dart';
import 'package:horizon/src/model/UserModel.dart';
import 'package:horizon/src/repositories/global_repository.dart';
import 'package:horizon/src/repositories/user_repository.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

class ApplicationSuccess extends StatefulWidget {


  List<FileItem> fileitems;BuildContext context;
  Map data;

  ApplicationSuccess({Key key, this.title,this.fileitems,this.data}) : super(key: key);

  final String title;
  @override
  _ApplicationSuccessState createState() => _ApplicationSuccessState();
}

class _ApplicationSuccessState extends StateMVC<ApplicationSuccess> {

  SertifyerController _con;

  _ApplicationSuccessState() : super(SertifyerController()) {
    _con = controller;
  }

  bool inprogress=false;
  bool uploading = false;

  bool result=false;

  List<FileItem> fileitems = [];
  BuildContext context1;

  FlutterUploader uploader = FlutterUploader();
  StreamSubscription _progressSubscription;
  StreamSubscription _resultSubscription;

  @override
  void initState() {
    fileitems=widget.fileitems;
    super.initState();
    _progressSubscription = uploader.progress.listen((progress) {
      final task = tasks[progress.tag];
      print("progress: ${progress.progress} , tag: ${progress.tag}");
      if (task == null) return;
      if (task.isCompleted()) return;
      setState(() {
        tasks[progress.tag] =
            task.copyWith(progress: progress.progress, status: progress.status);
      });
    });
    _resultSubscription = uploader.result.listen((result) {
      print(
          "id: ${result.taskId}, status: ${result.status}, response: ${result
              .response}, statusCode: ${result.statusCode}, tag: ${result
              .tag}, headers: ${result.headers}");

      final task = tasks[result.tag];
      if (task == null) return;

      setState(() {
        tasks[result.tag] = task.copyWith(status: result.status);


        tasks[result.tag] = task.copyWith(status: result.status);
        if (result.statusCode == 200) {
          this.result=true;
          UserModel userModel=UserModel.fromJson(json.decode(result.response)['data']);

          print(userModel.residence_proof_decument_id);

          print(userModel.idcard_decument_id);

          print(userModel.firstname);

          currentuser.value=userModel;
        } else {
          this.result=false;
        }
      });
    }, onError: (ex, stacktrace) {
      setState(() {
        uploading = false;
      });
      print("exception: $ex");
      print("stacktrace: $stacktrace" ?? "no stacktrace");
      final exp = ex as UploadException;
      final task = tasks[exp.tag];
      if (task == null) return;

      setState(() {
        tasks[exp.tag] = task.copyWith(status: exp.status);
      });
    });

    UploadFiles();
  }

  @override
  void dispose() {
    super.dispose();
    _progressSubscription?.cancel();
    _resultSubscription?.cancel();
  }


  UploadView(){
    final item = tasks.values.elementAt(0);

    final progress = item.progress.toDouble() / 100;


  return Stack(
    fit: StackFit.expand,
    children: <Widget>[
      Container(
        alignment: AlignmentDirectional.center,
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                          begin: Alignment.bottomLeft,
                          end: Alignment.topRight,
                          colors: [
                            Theme.of(context).accentColor.withOpacity(1),
                            Colors.green.withOpacity(0.2),
                          ])),
                  child:  item.status == UploadTaskStatus.running
                      ? Padding(
                    padding: EdgeInsets.all(55),
                    child: CircularProgressIndicator(
                      // value: progress??0,
                      valueColor:
                      new AlwaysStoppedAnimation<Color>(

                          Theme.of(context)
                              .scaffoldBackgroundColor),
                    ),
                  )
                      : Icon(
                    item.status == UploadTaskStatus.complete? Icons.check : Icons.watch_later,
                    color: Theme.of(context)
                        .scaffoldBackgroundColor,
                    size: 90,
                  ),
                ),
                Positioned(
                  right: -30,
                  bottom: -50,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .scaffoldBackgroundColor
                          .withOpacity(0.15),
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
                      color: Theme.of(context)
                          .scaffoldBackgroundColor
                          .withOpacity(0.15),
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
                item.status.description,

                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline3.merge(
                    TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 16.0,
                        color: Colors.black87)),
              ),
            ),

            SizedBox(height: 10),

            item.status == UploadTaskStatus.complete?Text("Application submitted successfully.You will be notified when the admin completes verification",style: TextStyle( fontSize: 12.0,
                color: Colors.black),textAlign: TextAlign.center,):Text("")
          ],
        ),
      ),
    ],
  );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text("Application Upload", style: Theme
            .of(context)
            .appBarTheme
            .textTheme
            .headline5,),
        leading: InkWell(
            onTap: (){
              if(result){

                Navigator.of(context).pushReplacementNamed('/Pages', arguments: 1);
              }
              else{
                Navigator.pop(context);
              }
            },
            child: Icon(Icons.arrow_back_ios,size: 30.0,color: Colors.white,)),
      ),

      body:
        tasks.length>0?UploadView(): CircularLoadingWidget(height: 500,),
    );
  }
  Future UploadFiles() async {
    final String url = '${GlobalConfiguration().getValue('api_base_url')}sertifyer/apply';
    final tag = "profile documents upload ${tasks.length + 1}";
    var taskId = await uploader.enqueue(
      url:url,
      data: widget.data,
      files: fileitems,
      method: UploadMethod.POST,
      tag: tag,
      showNotification: true,
    );

    setState(() {
      uploading = true;
      tasks.putIfAbsent(
          tag,
              () => UploadItem(
            id: taskId,
            tag: tag,
            type: MediaType.Video,
            status: UploadTaskStatus.enqueued,
          ));
    });
    final item =
    tasks.values.elementAt(0);
    // pr =  ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: false, showLogs: false,);
    //
    // pr.style(
    //     message: 'Uploading ...',
    //     borderRadius: 10.0,
    //     backgroundColor: Colors.white,
    //     progressWidget: CircularProgressIndicator(),
    //     elevation: 10.0,
    //     insetAnimCurve: Curves.easeInOut,
    //     progress: 0.0,
    //     maxProgress: 100.0,
    //     progressTextStyle: TextStyle(
    //         color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
    //     messageTextStyle: TextStyle(
    //         color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600)
    // );
    // await pr.show();
  }
  Future cancelUpload(String id) async {
    await uploader.cancel(taskId: id);
  }
}
typedef CancelUploadCallback = Future<void> Function(String id);


class UploadItemView extends StatelessWidget {
  final UploadItem item;
  final CancelUploadCallback onCancel;

  UploadItemView({
    Key key,
    this.item,
    this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final progress = item.progress.toDouble() / 100;
    final widget = item.status == UploadTaskStatus.running
        ? LinearProgressIndicator(value: progress)
        : Container();
    final buttonWidget = item.status == UploadTaskStatus.running
        ? Container(
      height: 50,
      width: 50,
      child: IconButton(
        icon: Icon(Icons.cancel),
        onPressed: () => onCancel(item.id),
      ),
    )
        :item.status == UploadTaskStatus.complete? Container(

      child: RaisedButton(
        color: Theme.of(context).accentColor,
        textColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        onPressed: () {
          Navigator.of(context).pushReplacementNamed('/Pages', arguments: 2);
        },
        child: Text("Go to Profile"),
      ),

    ):Container();
    return Row(
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(item.tag),
              Container(
                height: 5.0,
              ),
              Text(item.status.description),

              Text(item.progress.toString()),

              Container(
                height: 5.0,
              ),
              widget
            ],
          ),
        ),
        buttonWidget
      ],
    );
  }
}