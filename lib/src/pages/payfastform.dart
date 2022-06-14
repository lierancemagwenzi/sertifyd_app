import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:horizon/src/pages/Home.dart';

import 'package:webview_flutter/webview_flutter.dart';

class PayfastForm extends StatefulWidget {


  String form ;

  PayfastForm({Key key, this.form}) : super(key: key);


  @override
  _PayfastFormState createState() => _PayfastFormState();
}

class _PayfastFormState extends State<PayfastForm> {


  final Completer<WebViewController> _controller =
  Completer<WebViewController>();

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();


  }



 Future<String> localLoader(){

    Future.delayed(const Duration(seconds: 3), () {


      return widget.form;

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(


      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0.0,
        centerTitle: true,
        title: Text(" payment",),
        leading: InkWell(
            onTap: (){
              Navigator.pushReplacement(context,
                  CupertinoPageRoute(builder: (context) => Home(index: 1,)));
            },
            child: Icon(Icons.arrow_back_ios,color: Theme.of(context).accentColor,)),
      ),

      body:  Padding(
        padding: const EdgeInsets.all(8.0),
        child: WebView(

    initialUrl:
    new Uri.dataFromString(widget.form, mimeType: 'text/html')
          .toString(),

    javascriptMode: JavascriptMode.unrestricted,
    ),
      )
    );
  }
}
