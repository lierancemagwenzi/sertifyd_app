import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_uploader/flutter_uploader.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:horizon/src/model/UploadItem.dart';
import 'package:horizon/src/model/UserModel.dart';
import 'package:horizon/src/repositories/global_repository.dart';
import 'package:horizon/src/repositories/user_repository.dart';

class UploadScreen extends StatefulWidget {

  List<FileItem> fileitems;BuildContext context;

  UploadScreen({Key key, this.title,this.fileitems}) : super(key: key);

  final String title;


  int progress;

  int status_code;

  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  bool inprogress=false;
  bool uploading = false;

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
          UserModel userModel=UserModel.fromJson(json.decode(result.response)['data']);

          print(userModel.residence_proof_decument_id);

          print(userModel.idcard_decument_id);

          print(userModel.firstname);

          currentuser.value=userModel;
        } else {

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


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
title: Text("Upload Progress",style: Theme.of(context).appBarTheme.textTheme.headline5,),
        leading: InkWell(
            onTap: (){
if(currentuser.value.idcard_decument_id!=null&&currentuser.value.residence_proof_decument_id!=null){
  Navigator.of(context).pushReplacementNamed('/Pages', arguments: 2);
}

else{
              Navigator.pop(context);}
            },

            child: Icon(Icons.arrow_back_ios,color: Colors.white,size: 30.0,)),

      ),
      body:  ListView.separated(
        padding: EdgeInsets.all(20.0),
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final item = tasks.values.elementAt(index);
          print("${item.tag} - ${item.status}");
          return UploadItemView(
            item: item,
            onCancel: cancelUpload,
          );
        },
        separatorBuilder: (context, index) {
          return Divider(
            color: Colors.black,
          );
        },
      ),

    );
  }

  Future UploadFiles() async {
    final String url = '${GlobalConfiguration().getValue('api_base_url')}savedocuments';
    final tag = "profile documents upload ${tasks.length + 1}";
    var taskId = await uploader.enqueue(
      url:url,
      data: {
        "user_id":currentuser.value.id.toString(),
      },
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