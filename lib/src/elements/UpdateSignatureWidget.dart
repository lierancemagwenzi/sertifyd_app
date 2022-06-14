import 'package:flutter/material.dart';
import 'package:horizon/src/repositories/user_repository.dart';

class UpdateSignatureWidget extends StatefulWidget {

  @override
  _UpdateSignatureWidgetState createState() => _UpdateSignatureWidgetState();
}

class _UpdateSignatureWidgetState extends State<UpdateSignatureWidget> {

  double width;double height;
  @override
  Widget build(BuildContext context) {

    width=MediaQuery.of(context).size.width;

    height=MediaQuery.of(context).size.height;

    return currentuser.value.signature==null?Container(
      width: width,
        // height: height*0.13,
        decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).primaryColorLight,
            ),
            borderRadius: BorderRadius.all(Radius.circular(5))
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
SizedBox(height: 10.0,),
Text("You are yet to set your signature.Update your signature to take jobs",style: TextStyle(color: Theme.of(context).accentColor,fontSize: 12.0,fontWeight: FontWeight.w700),textAlign: TextAlign.center,),
            SizedBox(height: 10.0,),

          OutlinedButton(
            child: Text("Update Signature",style: TextStyle(color: Theme.of(context).accentColor,fontSize: 12.0,fontWeight: FontWeight.w700)),
            onPressed: () {

              Navigator.pushNamed(context, '/AddSignature');

            },
            style: ElevatedButton.styleFrom(
              side: BorderSide(width: 2.0, color: Theme.of(context).primaryColorLight),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
          )

        ],)
    ):Container();
  }
}
