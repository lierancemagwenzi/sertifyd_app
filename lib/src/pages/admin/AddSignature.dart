import 'dart:convert';

import 'package:flutter/material.dart';

import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:horizon/src/controllers/AdminController.dart';
import 'package:horizon/src/model/ImageUpload.dart';
import 'package:horizon/src/model/SignatureModel.dart';
import 'package:horizon/src/repositories/user_repository.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import 'package:http/http.dart' as http;

class AddSignature extends StatefulWidget {

  @override
  _AddSignatureState createState() => _AddSignatureState();
}

class _AddSignatureState extends StateMVC<AddSignature> {

  AdminController _con;

  _AddSignatureState() : super(AdminController()) {
    _con = controller;
  }

  final GlobalKey<SfSignaturePadState> signatureGlobalKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  void _handleClearButtonPressed() {
    signatureGlobalKey.currentState.clear();
  }

  void _handleSaveButtonPressed() async {
    final data =
    // await signatureGlobalKey.currentState.toImage(pixelRatio: 0.2);
    await signatureGlobalKey.currentState.toImage(pixelRatio: 3.0);

    final bytes = await data.toByteData(format: ui.ImageByteFormat.png);
    _upload(bytes.buffer.asUint8List());
    // await Navigator.of(context).push(
    //   MaterialPageRoute(
    //     builder: (BuildContext context) {
    //       return Scaffold(
    //         appBar: AppBar(),
    //         body: Center(
    //           child: Container(
    //             color: Colors.grey[300],
    //             child: Image.memory(bytes.buffer.asUint8List()),
    //           ),
    //         ),
    //       );
    //     },
    //   ),
    // );
  }


  void _upload(var bytes) {
    final String url =
        '${GlobalConfiguration().getValue('base_url')}signatures/api.php';
      String base64Image = base64Encode(bytes);
      String fileName = "signature.png";
      String ext = fileName.split(".").last;
      var newname = new DateTime.now().millisecondsSinceEpoch.toString() +
      currentuser.value.id.toString()+
          "." +
          ext;
      http.post(url, body: {
        "image": base64Image,
        "name": newname,
//      "email": globals.useremail,
      }).then((res) async {
        print("responsefromuploads:" + res.body);

        if (res.statusCode == 200) {
          ImageUpload imageUpload = ImageUpload.fromJson(json.decode(res.body));
          if (imageUpload.urls.contains("failed")) {
            Future.delayed(const Duration(seconds: 2), () {
              _con. scaffoldKey?.currentState?.showSnackBar(SnackBar(
                content: Text("Failed to submit signature"),
              ));
            });
          } else {
            String a = imageUpload.urls;
            imageUpload.urls = imageUpload.urls;
print(imageUpload.urls);
            _con.AddSignature(new SignatureModel(path: a), context);

          }
//        setImage();
        } else {
          Future.delayed(const Duration(seconds: 3), () {
           _con. scaffoldKey?.currentState?.showSnackBar(SnackBar(
              content: Text("Failed to submit signature"),
            ));
          });
        }
      }).catchError((err) {
        print(err);
      });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con.scaffoldKey,
        appBar: AppBar(
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back_ios, color: Theme.of(context).hintColor),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text(
            "Signature",
            style: Theme.of(context).textTheme.headline6.merge(TextStyle(letterSpacing: 1.3)),
          ),

        ),
        body: Column(
            children: [
              Text("Draw your signature below",style: TextStyle(color: Colors.black87,fontSize: 16.0,fontWeight: FontWeight.bold),),
              SizedBox(height: 10.0,),
              Padding(
                  padding: EdgeInsets.all(10),
                  child: Container(
                      child: SfSignaturePad(
                          key: signatureGlobalKey,
                          backgroundColor: Colors.white,
                          strokeColor: Colors.black,
                          minimumStrokeWidth: 10.0,

                          maximumStrokeWidth: 15.0),
                      decoration:
                      BoxDecoration(border: Border.all(color: Colors.grey)))),
              SizedBox(height: 10),
              Row(children: <Widget>[
                TextButton(
                  child: Text('Save'),
                  onPressed: _handleSaveButtonPressed,
                ),
                TextButton(
                  child: Text('Clear'),
                  onPressed: _handleClearButtonPressed,
                )
              ], mainAxisAlignment: MainAxisAlignment.spaceEvenly)
            ],
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center));
  }
}