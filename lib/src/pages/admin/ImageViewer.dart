import 'package:flutter/material.dart';
import 'package:horizon/src/model/CertificationApplicationDocument.dart';

class ProofOfPayment extends StatefulWidget {

  String  path;

  ProofOfPayment({Key key,this.path}) : super(key: key);

  @override
  _ProofOfPaymentState createState() => _ProofOfPaymentState();
}

class _ProofOfPaymentState extends State<ProofOfPayment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(

        leading: InkWell(

            onTap: (){

              Navigator.pop(context);
            },

            child: Icon(Icons.arrow_back_ios,color: Colors.white,size: 30.0,)),

        title: Text("Proof Of Payment",   style: Theme.of(context).textTheme.headline6.merge(TextStyle(letterSpacing: 1.3,color: Colors.white))),

      ),
      body: Container(
        child: Image.network(widget.path),

      ),
    );
  }
}
