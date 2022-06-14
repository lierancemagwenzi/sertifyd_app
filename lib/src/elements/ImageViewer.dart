import 'package:flutter/material.dart';
import 'package:horizon/src/model/CertificationApplicationDocument.dart';

class ImageViewer extends StatefulWidget {

  CertificationApplicationDocument document;

  ImageViewer({Key key,this.document}) : super(key: key);

  @override
  _ImageViewerState createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer> {
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
      body: Container(
        child: Image.network(widget.document.getDocumentPath()),

      ),
    );
  }
}
