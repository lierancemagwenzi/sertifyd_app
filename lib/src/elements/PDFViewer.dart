import 'dart:io';

// import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer/full_pdf_viewer_scaffold.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:horizon/src/elements/CircularLoadingWidget.dart';
import 'package:horizon/src/model/CertificationApplicationDocument.dart';
import 'package:horizon/src/repositories/user_repository.dart';
import 'package:path_provider/path_provider.dart';

class PDFViewerWidget extends StatefulWidget {

  CertificationApplicationDocument document;
  PDFViewerWidget({Key key,this.document}) : super(key: key);




  @override
  _PDFViewerWidgetState createState() => _PDFViewerWidgetState();
}

class _PDFViewerWidgetState extends State<PDFViewerWidget> {


  bool loading=true;

  String pathPDF = "";

  @override
  void initState() {
    super.initState();
    createFileOfPdfUrl().then((f) {
      setState(() {
        pathPDF = f.path;
        print(pathPDF);
      });
    });
  }

  Future<File> createFileOfPdfUrl() async {
    String  url;
    if(currentuser.value.role.name=='sertifyer'){
      url =  widget.document.download_path!=null?widget.document.getDownloadPath():widget.document.getDocumentPath();
    }
    else{
   url = widget.document.getDocumentPath();
    }

    final filename = url.substring(url.lastIndexOf("/") + 1);
    var request = await HttpClient().getUrl(Uri.parse(url));
    var response = await request.close();
    var bytes = await consolidateHttpClientResponseBytes(response);
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = new File('$dir/$filename');
    await file.writeAsBytes(bytes);
    return file;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(


appBar: AppBar(

  leading: InkWell(

      onTap: (){

        Navigator.pop(context);
      },

      child: Icon(Icons.arrow_back_ios,color: Colors.white,size: 30.0,)),

title: Text(widget.document.documentTypeModel.type,   style: Theme.of(context).textTheme.headline6.merge(TextStyle(letterSpacing: 1.3,color: Colors.white))),

),
      body:pathPDF.length>0? Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 5,),
          widget.document .rejection_reason!=null?Text("Rejection reason:"+    widget.document.rejection_reason,maxLines: 1,overflow: TextOverflow.ellipsis,):Text(""),     SizedBox(height: 25,),

          Center(
            child: RaisedButton(
              child: Text("Open Document",style: TextStyle(color: Colors.white),),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PDFScreen(pathPDF)),
              ),
            ),
          ),
        ],
      ):CircularLoadingWidget(height: 500,),
    );
  }
}
class PDFScreen extends StatelessWidget {
  String pathPDF = "";
  PDFScreen(this.pathPDF);

  @override
  Widget build(BuildContext context) {
    return PDFViewerScaffold(
        appBar: AppBar(
          leading: InkWell(

              onTap: (){

                Navigator.pop(context);
                Navigator.pop(context);
              },

              child: Icon(Icons.arrow_back_ios,color: Colors.white,size: 30.0,)),
          title: Text("Document",style: TextStyle(color: Colors.white),),
          // actions: <Widget>[
          //   IconButton(
          //     icon: Icon(Icons.share,color: Colors.white,),
          //     onPressed: () {},
          //   ),
          // ],
        ),
        path: pathPDF);
  }
}