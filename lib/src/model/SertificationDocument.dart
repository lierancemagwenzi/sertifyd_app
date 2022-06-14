import 'dart:io';

import 'package:horizon/src/model/DocumentType.dart';

class SertificationDocumentModel{
  int id;
  File file;


  DocumentTypeModel documentTypeModel;


  SertificationDocumentModel({this.id,this.file,this.documentTypeModel});

}