import 'dart:io';

import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_uploader/flutter_uploader.dart';
import 'package:horizon/src/controllers/sertifyer_controller.dart';
import 'package:horizon/src/repositories/global_repository.dart';
import 'package:horizon/src/repositories/user_repository.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:path/path.dart' as thepath;

import 'ApplicationSuccess.dart';


class ApplicationScreen extends StatefulWidget {

  @override
  _ApplicationScreenState createState() => _ApplicationScreenState();
}

class _ApplicationScreenState extends StateMVC<ApplicationScreen> {
  SertifyerController _con;

  _ApplicationScreenState() : super(SertifyerController()) {
    _con = controller;
  }
  List<FileItem> fileitems = [];

  final _formKey = GlobalKey<FormState>();
  double height;
  double width;

  String highest_qualification;

  String issuing_authority;
String category;
  File file;

  String auth_number;

  @override
  Widget build(BuildContext context) {
    width=MediaQuery.of(context).size.width;
    height=MediaQuery.of(context).size.height;
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
          color: Colors.white,
          image: DecorationImage(image: AssetImage("assets/bg/backbg.png"),fit: BoxFit.cover)),
      child: Scaffold(
        key: _con.scaffoldKey,
        backgroundColor: Colors.transparent,
        appBar: AppBar(

          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          leading: InkWell(

            onTap: (){
              Navigator.pop(context);
            },
            child: Container(
              height: 50,width: 50,
              child: Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100.0),
                  ),

                  child: Center(child: new Icon(Icons.arrow_back_ios, color: Theme.of(context).hintColor))),
            ),
          ),




          title: Text("Qualifications",style: TextStyle(color: Colors.black,fontSize: 15.0,fontWeight: FontWeight.bold),),

        ),

        body:  Padding(
          padding: const EdgeInsets.symmetric(horizontal:8.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20,),
                Container(
                  color: Colors.white,
                  padding: EdgeInsets.all(16),
                  child: Theme(
                    data: ThemeData(

                      accentColor: Colors.black,
                      focusColor: Colors.black
                    ),
                    child: DropDownFormField(

                      required: true,

                      validator: (input)=>input==null?"Category is required":null,
                      titleText: 'What category are you',
                      hintText: 'Please choose one',

                      filled: false,


                      value: category,
                      onSaved: (value) {
                        setState(() {
                          category = value;
                        });
                      },
                      onChanged: (value) {
                        setState(() {
                          category = value;
                        });
                      },

                      dataSource: [
                        {
                          "display": "Lawyers",
                          "value": "lawyers",
                        },
                        {
                          "display": "Actuaries or accountants",
                          "value": "actuaries or accountants",
                        },
                        {
                          "display": "Members of the Judiciary",
                          "value": "judiciary member",
                        },

                      ],
                      textField: 'display',
                      valueField: 'value',
                    ),
                  ),
                ),

                Container(
                  color: Colors.white,
                  padding: EdgeInsets.all(16),
                  child: Theme(
                    data: ThemeData(

                        accentColor: Colors.black,
                        focusColor: Colors.black
                    ),
                    child: DropDownFormField(

                      required: true,

                      validator: (input)=>input==null?"Highest qualification is required":null,
                      titleText: 'What is your highest qualification',
                      hintText: 'Please choose one',

                      filled: false,


                      value: highest_qualification,
                      onSaved: (value) {
                        setState(() {
                          highest_qualification = value;
                        });
                      },
                      onChanged: (value) {
                        setState(() {
                          highest_qualification = value;
                        });
                      },

                      dataSource: [
                        {
                          "display": "High School Certificate",
                          "value": "high_school_certificate",
                        },
                        {
                          "display": "Bachelors Degree",
                          "value": "bachelors_degree",
                        },
                        {
                          "display": "Masters Degree",
                          "value": "masters_degree",
                        },
                        {
                          "display": "PHD",
                          "value": "phd",
                        },
                      ],
                      textField: 'display',
                      valueField: 'value',
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                _entryField("Issuing Authority",(input) => issuing_authority = input,(input) => input==null||input.trim().length<1? " Enter a valid issuing authority" : null,),

                SizedBox(
                  height: 20.0,
                ),
                _entryField("Authorisation  Number",(input) => auth_number = input,(input) => input==null||input.trim().length<1? " Enter a valid auth number" : null,),

                SizedBox(
                  height: 30.0,
                ),
                Card(child: ListTile(
                  onTap: () {
                    picFile();
                  },
                  trailing: Container(
                    width: 30.0,
                    decoration: BoxDecoration(shape: BoxShape.circle, color: Theme
                        .of(context)
                        .accentColor),
                    child: file != null
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
                  title: Text("Qualification document",style: TextStyle(color: Colors.black,fontSize: 12),),
                  subtitle: Text(file == null ? "No file selected" : "Selected"),
                ),),
                SizedBox(
                  height: 30.0,
                ),
                _submitButton(),
              ],),
          ),
        ),
      ),
    );
  }

  picFile() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'pdf', 'png','jpeg'],
    );
    if (result != null) {
      File file = File(result.files.single.path);
      setState(() {
        this.file = file;
      });
    } else {

    }
  }


  Widget _entryField(String title,onsaved,validator, {bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            style: TextStyle(color: Colors.black,fontSize: 12),
              onSaved: onsaved,
              validator:validator,
              obscureText: isPassword,
              decoration:getInputDecoration(title))
        ],
      ),
    );
  }


  getInputDecoration(String title){
    var Platform;
    return  InputDecoration(
        border: InputBorder.none,
        hintText: title,
        hintStyle: TextStyle(color: Colors.black,fontSize: 12),
        fillColor:  Colors.white,
        filled: true);
  }

  void _submit() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      print("validated");
if(file!=null){

  UploadFiles();
}
    }

    else{print("incorrect form");}
  }
  Widget _submitButton() {
    return InkWell(
      onTap: (){
        _submit();
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey.shade200,
                  offset: Offset(2, 4),
                  blurRadius: 5,
                  spreadRadius: 2)
            ],
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Theme.of(context).accentColor,Theme.of(context).accentColor])),
        child: Text(
          'Apply',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  Future UploadFiles() async {

    print("we upload");
    tasks.clear();
    fileitems.clear();

    if(file!=null){

      var path = file.path;
      final String savedDir = thepath.dirname(path);
      final String filename = thepath.basename(path);
      var fileItem = FileItem(
        filename: filename,
        savedDir: savedDir,
        fieldname: "file",
      );
      fileitems.add(fileItem);
    }
    Map<String, String> someMap = {
      "user_id":currentuser.value.id.toString(),"category":category,"qualification":highest_qualification,"auth_number":auth_number,"issuing_authority":issuing_authority
    };


    if(fileitems.length>0){
      await  Navigator.push(
          context,
          CupertinoPageRoute(
              builder: (context) => ApplicationSuccess(
                fileitems: fileitems,
                data:   someMap,
              ))).then((value) {

        setState(() {
          file=null;
        });
        return null;
      }
      );

    }

  }


}
