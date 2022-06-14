import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_uploader/flutter_uploader.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:horizon/src/model/UploadItem.dart';
import 'package:horizon/src/pages/UploadScreen.dart';
import 'package:horizon/src/repositories/global_repository.dart';
import 'package:horizon/src/repositories/user_repository.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:path/path.dart' as thepath;


class UploadDocumentsWidget extends StatefulWidget {

  @override
  _UploadDocumentsWidgetState createState() => _UploadDocumentsWidgetState();
}

class _UploadDocumentsWidgetState extends State<UploadDocumentsWidget> {
  File idcard;
  File proof_card;
  List<FileItem> fileitems = [];



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _submitButton(),
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text("Complete Registration", style: Theme
            .of(context)
            .appBarTheme
            .textTheme
            .headline5,),
      ),
      body:Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(children: [
          SizedBox(height: 20.0,),
        currentuser.value.idcard_decument_id!=null?Container():  Card(child: ListTile(

            onTap: () {
              pickId();
            },
            trailing: Container(
              width: 30.0,
              decoration: BoxDecoration(shape: BoxShape.circle, color: Theme
                  .of(context)
                  .accentColor),
              child: idcard != null
                  ? Center(
                child: Icon(
                  Icons.check,
                  size: 20.0,
                  color: Colors.white,
                ),
              )
                  : Icon(
                  Icons.check_box_outline_blank,
                  size: 20.0,
                  color: Theme
                      .of(context)
                      .accentColor),
            ),
            title: Text("National ID Card"),
            subtitle: Text(idcard == null ? "No file selected" : "Selected"),
          ),),
          SizedBox(height: 20.0,),


          currentuser.value.residence_proof_decument_id!=null?Container():
          Card(child: ListTile(

            onTap: () {
              pickProof();
            },
            trailing: Container(
              width: 30.0,
              decoration: BoxDecoration(shape: BoxShape.circle, color: Theme
                  .of(context)
                  .accentColor),
              child: proof_card != null
                  ? Center(
                child: Icon(
                  Icons.check,
                  size: 20.0,
                  color: Colors.white,
                ),
              )
                  : Icon(
                  Icons.check_box_outline_blank,
                  size: 20.0,
                  color: Theme
                      .of(context)
                      .accentColor),
            ),
            title: Text("Proof Of Residence"),
            subtitle: Text(
                proof_card == null ? "No file selected" : "Selected"),
          )),

          SizedBox(height: 100.0,),

        ],),
      ),

    );
  }


  Widget _submitButton() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: SafeArea(

        child: Container(
          width: MediaQuery
              .of(context)
              .size
              .width * 0.5,
          child: RaisedButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5)),
            onPressed: () {
              bool valid=true;


              if(currentuser.value.residence_proof_decument_id==null&&currentuser.value.idcard_decument_id==null){

                if (idcard != null && proof_card != null) {

                  UploadFiles();
                }

                else{

                  print("one");
                }
              }

              else{
                if(currentuser.value.residence_proof_decument_id==null&& proof_card!=null){
                  UploadFiles();
                }
                 if(currentuser.value.idcard_decument_id==null&&idcard!=null){
                  UploadFiles();
                }
                else{}
              }

            },
            color: Theme
                .of(context)
                .accentColor,
            textColor: Colors.white,
            child: Text("Upload Documents", style: TextStyle(fontSize: 20.0),),
          ),
        ),
      ),
    );
  }

  pickId() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
    );
    if (result != null) {
      File file = File(result.files.single.path);
      setState(() {
        idcard = file;
      });
    } else {

    }
  }


  pickProof() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'pdf', 'png','jpeg'],
    );
    if (result != null) {
      File file = File(result.files.single.path);

      setState(() {
        proof_card = file;
      });
    } else {

    }
  }

  Future UploadFiles() async {

    print("we upload");
    tasks.clear();
    fileitems.clear();

    if(idcard!=null){

      var path = idcard.path;
      final String savedDir = thepath.dirname(path);
      final String filename = thepath.basename(path);
      var fileItem = FileItem(
        filename: filename,
        savedDir: savedDir,
        fieldname: "file",
      );
      fileitems.add(fileItem);
    }

if(proof_card!=null){
  print("proof card inserted");
  var path1 = proof_card.path;
  final String savedDir1 = thepath.dirname(path1);
  final String filename1 = thepath.basename(path1);
  var fileItem1 = FileItem(
    filename: filename1,
    savedDir: savedDir1,
    fieldname: "proof_card",
  );
  fileitems.add(fileItem1);
}

if(fileitems.length>0){
  await  Navigator.push(
      context,
      CupertinoPageRoute(
          builder: (context) => UploadScreen(
            fileitems: fileitems,

          ))).then((value) {

    setState(() {
      idcard=null;
      proof_card=null;
    });
    return null;
  }
  );

}

  }

}