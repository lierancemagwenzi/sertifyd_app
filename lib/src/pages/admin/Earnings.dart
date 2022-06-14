import 'package:flutter/material.dart';
import 'package:horizon/src/controllers/AccountPaymentsController.dart';
import 'package:horizon/src/helper/Helper.dart';
import 'package:horizon/src/repositories/settings_repository.dart';
import 'package:horizon/src/repositories/user_repository.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

class EarningsWidget extends StatefulWidget {

  @override
  _EarningsWidgetState createState() => _EarningsWidgetState();
}

class _EarningsWidgetState extends StateMVC<EarningsWidget> {

  EarningsController _con;

  _EarningsWidgetState() : super(EarningsController()) {
    _con = controller;
  }



  @override
  void initState() {
   _con.listenForPayments();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(



        body:_con.earnings.length<1?Center(child: Text("You do not have any earnings",style: TextStyle(fontSize: 12.0,fontWeight: FontWeight.w700,color: Theme.of(context).accentColor),)): ListView.builder(
            itemCount: _con.earnings.length,
            itemBuilder: (BuildContext context,int index){
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal:15.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ExpansionTile(
                          title:Text(_con.earnings[index].getdate(),style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12.0)),
                          initiallyExpanded: index==0,
                          subtitle:Text("Reference: "+_con.earnings[index].reference,style: TextStyle(color: Colors.black,fontSize: 12),),
                        children: [
                          ListTile(
                            title:Text("Description",style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.0),),
                            subtitle:                      Text(_con.earnings[index].description,style: TextStyle(color: Colors.black,fontSize: 12),)
                            ,
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal:8.0),
                            child: Row(
                              children: [
                                Text("Payment Details",style: TextStyle(fontWeight: FontWeight.w700),),
                              ],
                            ),
                          ),
                          SizedBox(height: 10,),
                          _con.earnings[index].paymentDetail!=null?   Column(
                              children: List<Widget>.generate( _con.earnings[index].paymentDetail.fields.keys.length, (indexx) {

                                String key = _con.earnings[index].paymentDetail.fields.keys.elementAt(indexx);
                                String value = _con.earnings[index].paymentDetail.fields.values.elementAt(indexx);


                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(Helper.getFiledName(key)),

                                          Text(value),


                                        ],
                                      )
                                  ),
                                );
                              })

                          ):SizedBox(height: 0,width: 0,),

                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Text("Status:  ",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 12),),
                                Text(_con.earnings[index].status,style: TextStyle(color: Colors.black,fontSize: 12),),
                              ],
                            ),
                          ),

                         Padding(
                           padding: const EdgeInsets.all(8.0),
                           child: Row(
                             children: [
                               Text("Amount:  ",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 12),),

                               Text(currentuser.value.country.currency+   _con.earnings[index].amount,style: TextStyle(fontWeight: FontWeight.normal,fontSize: 12,color: Colors.black)),
                             ],
                           ),
                         ),
                         _con.earnings[index].proof_of_payment!=null? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(

                              onTap: (){
                                Navigator.pushNamed(context, '/Proof',arguments: _con.earnings[index].getDocumentPath());
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Proof of payment:  ",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 12),),

                                  Icon(Icons.arrow_forward_ios)
                                ],
                              ),
                            ),
                          ):SizedBox(height: 0,width: 0,),

                        ],
                      ),

                    ],
                  ),
                ),
              );
            }
        )
    );
  }
}
