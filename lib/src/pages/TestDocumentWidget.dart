import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:horizon/src/controllers/VerifyController.dart';
import 'package:horizon/src/repositories/global_repository.dart';
import 'package:horizon/src/repositories/settings_repository.dart';
import 'package:horizon/src/repositories/user_repository.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';



class TestDocumentWidget extends StatefulWidget {

  @override
  _TestDocumentWidgetState createState() => _TestDocumentWidgetState();
}

class _TestDocumentWidgetState extends StateMVC<TestDocumentWidget> {

  VerifyController _con;

  _TestDocumentWidgetState() : super(VerifyController()) {
    _con = controller;
  }


  int result_found=0;

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode result;
  QRViewController controller1;

  @override
  void initState() {
    Map map={"action":"verify_document","platform":Platform.isIOS?"ios":"android","user_id":currentuser.value.id??0,"device":detailsModel.value.identifier,"detail":"verify"};

    log_activity(map);
    super.initState();
  }
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller1.pauseCamera();
    } else if (Platform.isIOS) {
      controller1.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con.scaffoldKey,
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




        title: Text("Verify Document Signature",style: TextStyle(color: Colors.black,fontSize: 15.0,fontWeight: FontWeight.bold),),

      ),
      body: Stack(
        children: [
          Column(
            children: <Widget>[
              Expanded(
                flex: 5,
                child: QRView(
                  key: qrKey,
                  onQRViewCreated: _onQRViewCreated,
                ),
              ),
              Expanded(
                flex: 1,
                child: Center(
                  child: (result != null)
                      ? Text(
                      'Result found.Exit to try again')
                      :result_found>0?InkWell(
                      onTap: (){

                        setState(() {

                          result_found=0;
                        });
                      },
                      child: Text('Try again')): Text('Focus camera to scan qr code'),
                ),
              )
            ],
          ),

          _con.loading?Center(child: CircularProgressIndicator()):Text("")
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller1 = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
        result_found=result_found+1;
      });

      if(result_found==1){
        _con.VeridyDoc(result.code,context);
      }


    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}

