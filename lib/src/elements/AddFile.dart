import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:horizon/src/controllers/application_controller.dart';
import 'package:horizon/src/elements/CircularLoadingWidget.dart';
import 'package:horizon/src/model/DocumentType.dart';
import 'package:horizon/src/model/SertificationDocument.dart';
import 'package:horizon/src/repositories/settings_repository.dart';
import 'package:horizon/src/repositories/user_repository.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:horizon/src/repositories/application_repository.dart' as appRepo;

class AddFileWidget extends StatefulWidget {
  
  @override
  _AddFileWidgetState createState() => _AddFileWidgetState();
}

class _AddFileWidgetState extends StateMVC<AddFileWidget> {

  ApplicationController _con;

  _AddFileWidgetState() : super(ApplicationController()) {
    _con = controller;
  }
  DocumentTypeModel documentTypeModel;

File file;

  @override
  void initState() {
    _con.listenForDocTypes();
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
title: Text("Add Document",style: Theme.of(context).appBarTheme.textTheme.headline5.copyWith(fontWeight: FontWeight.bold),),
        leading: InkWell(

            onTap: (){

              Navigator.pop(context);
            },
            child: Icon(Icons.close,color: Colors.white,)),
      ),

      body: _con.document_types.length<1?CircularLoadingWidget(height: 500,):Padding(
        padding: const EdgeInsets.symmetric(horizontal:18.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 30.0,
            ),
          Row(
              children: [
                Text("Document Type",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 12.0),),

              ],
            ),
              SizedBox(height: 10,),

            TypeWidget(),
  //             new DecoratedBox(
  //           decoration: ShapeDecoration(
  //           color: Colors.white,
  //           shape: RoundedRectangleBorder(
  //             // side: BorderSide(width: 1.0, style: BorderStyle.solid, color: Colors.grey),
  //             borderRadius: BorderRadius.all(Radius.circular(5.0)),
  //           ),
  //         ),
  //               child: Container(
  //                 width: MediaQuery.of(context).size.width,
  //                 child: Padding(
  //                   padding: const EdgeInsets.symmetric(horizontal:5.0,vertical: 3),
  //                   child: new DropdownButton<DocumentTypeModel>(
  //                     value: documentTypeModel,
  // hint: Text("Document type"),
  //                     onChanged: (DocumentTypeModel newValue) {
  //                       setState(() {
  //                         documentTypeModel = newValue;
  //                       });
  //                     },
  //                     items: _con.document_types.map((DocumentTypeModel d) {
  //                       return new DropdownMenuItem<DocumentTypeModel>(
  //                         value: d,
  //                         child: new Text(
  //                           d.type,
  //                           style: new TextStyle(color: Colors.black),
  //                         ),
  //                       );
  //                     }).toList(),
  //                   ),
  //                 ),
  //               ),
  //             ),


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
              title: Text("Certification document",style: TextStyle(color: Colors.black,fontSize: 12.0,fontWeight: FontWeight.bold),),
              subtitle: Text(file == null ? "No file selected" : "Selected"),
            ),),
            SizedBox(height: 40.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                RaisedButton.icon(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                  onPressed: () {
                    _con.AddToList(new SertificationDocumentModel(file: file,documentTypeModel: documentTypeModel),context);
                  },
                  textColor: Colors.white,
                  color: Theme.of(context).accentColor,
                  label: Text("Add File"),
                  icon: Icon(Icons.add,color: Colors.white,),
                ),
              ],
            )
        ],),
      ),
    );
  }

  TypeWidget(){

    return  Container(
      height: 60.0,
      child: FormField<String>(
        validator: (value)=>documentTypeModel==null?  "  is required":null,
        builder: (FormFieldState<String> state) {
          return InputDecorator(
            decoration: InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.never,
                // labelText: "Town",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0)),

                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 1,color: Colors.black),
                    borderRadius: BorderRadius.all(Radius.circular(5.0))),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 1,color: Colors.black),
                    borderRadius: BorderRadius.all(Radius.circular(5.0))),
                // Icon(Icons.credit_card,)
            ),
            child: DropdownButtonHideUnderline(
              child:           DropdownButton<DocumentTypeModel>(
                value: documentTypeModel,
                style: TextStyle(color: Colors.white38),
                icon: Icon(Icons.keyboard_arrow_down,color: Theme.of(context).primaryColorLight,),
                dropdownColor: Colors.white70,
                hint: Text("Select Document Type",style: TextStyle(color: Colors.black,fontSize: 12.0),),
                onChanged: (DocumentTypeModel newValue) {
                  setState(() {
                    documentTypeModel = newValue;
                  });
                },
                items: _con.document_types.map((DocumentTypeModel p) {
                  return new DropdownMenuItem<DocumentTypeModel>(
                    value: p,
                    child: new Text(
                      p.type+("("+currentuser.value.country.currency+p.price+")"),
                      style: new TextStyle(color: Colors.black,fontSize: 12.0),
                    ),
                  );
                }).toList(),
              ),
            ),
          );
        },
      ),
    );


  }
  picFile() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,

      allowedExtensions: setting.value.enable_images=='1'?['jpg', 'pdf', 'png','jpeg']:['pdf'],
    );
    if (result != null) {
      File file = File(result.files.single.path);
      setState(() {
        this.file = file;
      });
    } else {

    }
  }
}
