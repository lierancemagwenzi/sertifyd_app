import 'package:global_configuration/global_configuration.dart';

class SignatureModel{
  int id;
  String path;


  SignatureModel({this.id,this.path});
  factory SignatureModel.fromJson(Map<String, dynamic> json) {
    return SignatureModel(
      id: json["id"],
      path: json['path'],
    );
  }
  String getPath(){
    return '${GlobalConfiguration().getValue('base_url')}${path}';
  }


}