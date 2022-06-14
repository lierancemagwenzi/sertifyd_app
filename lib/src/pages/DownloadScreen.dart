import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:flutter_full_pdf_viewer/full_pdf_viewer_scaffold.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:horizon/src/elements/CircularLoadingWidget.dart';
import 'package:horizon/src/model/CertificationApplicationDocument.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';


class DownloadScreen extends StatefulWidget {

  CertificationApplicationDocument document;
  DownloadScreen({Key key,this.document}) : super(key: key);




  @override
  _DownloadScreenState createState() => _DownloadScreenState();
}

class _DownloadScreenState extends State<DownloadScreen> {


  bool loading=true;

  String pathPDF = "";

  String filename;

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
    final url = widget.document.getDownloadPath();
    final filename = url.substring(url.lastIndexOf("/") + 1);
    var request = await HttpClient().getUrl(Uri.parse(url));
    var response = await request.close();
    var bytes = await consolidateHttpClientResponseBytes(response);
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = new File('$dir/$filename');

    this.filename='$dir/$filename';
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
      body:pathPDF.length>0? Center(
        child: RaisedButton(
          child: Text("Open Document",style: TextStyle(color: Colors.white),),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PDFScreen(pathPDF,filename)),
          ),
        ),
      ):CircularLoadingWidget(height: 500,),
    );
  }
}
class PDFScreen extends StatelessWidget {
  String pathPDF = "";
  String filename = "";
  PDFScreen(this.pathPDF,this.filename);

  @override
  Widget build(BuildContext context) {
    return PDFViewerScaffold(
        appBar: AppBar(
          leading: InkWell(

              onTap: (){

                Navigator.pop(context);
                Navigator.pop(context);

                deleteFile();
              },

              child: Icon(Icons.arrow_back_ios,color: Colors.white,size: 30.0,)),
          title: Text("Document",style: TextStyle(color: Colors.white),),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.download_outlined,color: Colors.white,),
              onPressed: () {

                share();
              },
            ),

            IconButton(
              icon: Icon(Icons.share,color: Colors.white,),
              onPressed: () {
                Share.shareFiles([filename], text: 'Certified document');
              },
            ),
          ],
        ),
        path: pathPDF);
  }

  share() async {
    final params = SaveFileDialogParams(sourceFilePath: filename);
    final filePath = await FlutterFileDialog.saveFile(params: params);
    print(filePath);
    // Share.shareFiles([this.filename], text: 'Great picture');
  }


  Future<int> deleteFile() async {
    try {
      final file =  File(filename);

      await file.delete();
    } catch (e) {
      return 0;
    }
  }
}