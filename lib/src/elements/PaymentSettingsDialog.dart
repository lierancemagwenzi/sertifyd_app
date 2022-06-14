import 'package:flutter/material.dart';
import 'package:horizon/src/controllers/AdminController.dart';
import 'package:horizon/src/helper/Helper.dart';
import 'package:horizon/src/model/BankModel.dart';
import 'package:horizon/src/model/PaymentDetail.dart';
import 'package:horizon/src/model/PaymentMethod.dart';
import 'package:horizon/src/repositories/user_repository.dart';
import 'package:mvc_pattern/mvc_pattern.dart';



// ignore: must_be_immutable
class PaymentSettingsDialog extends StatefulWidget {
  // CreditCard creditCard;
  VoidCallback onChanged;



  PaymentSettingsDialog({Key key, this.onChanged}) : super(key: key);

  @override
  _PaymentSettingsDialogState createState() => _PaymentSettingsDialogState();
}

class _PaymentSettingsDialogState extends StateMVC<PaymentSettingsDialog> {


  AdminController _con;

  _PaymentSettingsDialogState() : super(AdminController()) {
    _con = controller;
  }

PaymentMethod paymentMethod;

BankModel bankModel;
List<Widget> children=[];
  @override
  void initState() {
    _con.listenForPaymentMethods();
    _con.listenForBanks();
    super.initState();
  }

  GlobalKey<FormState> _paymentSettingsFormKey = new GlobalKey<FormState>();



  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () {

        showDialog(
          context: context,
          builder: (context) {
            String contentText = "Content of Dialog";
            return StatefulBuilder(
              builder: (context, setState) {
                return AlertDialog(
                  title: Row(
                            children: <Widget>[
                              Icon(Icons.credit_card),
                              SizedBox(width: 10),
                              Text(
                                "Payment settings",
                                style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 12),
                              )
                            ],
                          ),
                  content: Form(
                    key: _paymentSettingsFormKey,
                    child: Column(

                      mainAxisSize: MainAxisSize.min,
                      children: [
Center(child: Text("Add payment method",style: TextStyle(fontSize: 12),)),

                      new DecoratedBox(
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            // side: BorderSide(width: 1.0, style: BorderStyle.solid, color: Colors.grey),
                            borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          ),
                        ),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal:5.0,vertical: 3),
                            child: new DropdownButton<PaymentMethod>(
                              value: paymentMethod,
                              hint: Text("Payment Method",style: TextStyle(fontSize: 12),),
                              onChanged: (PaymentMethod newValue) {
                                setState(() {
                                  paymentMethod = newValue;
                                  children.clear();

                                  for(int i=0;i<paymentMethod.fields.length;i++){

                                    if(paymentMethod.fields[i].name=="bank_name"){
                                      children.add(BankWidget(i));
                                    }
                                    else {
                                      children.add(
                                          TextFormField(
                                            style: TextStyle(color: Theme
                                                .of(context)
                                                .hintColor),
                                            keyboardType: TextInputType.number,
                                            decoration: getInputDecoration(
                                                hintText: Helper.getFiledName(
                                                    paymentMethod.fields[i]
                                                        .name),
                                                labelText: Helper.getFiledName(
                                                    paymentMethod.fields[i]
                                                        .name)),
                                            validator: (input) =>
                                            input
                                                .trim()
                                                .length < 1
                                                ? "Not a valid field"
                                                : null,
                                            onSaved: (input) =>
                                            paymentMethod.fields[i].value =
                                                input,
                                          ));
                                    }
                                  }
                                });
                              },
                              items: _con.payment_methods.map((PaymentMethod d) {
                                return new DropdownMenuItem<PaymentMethod>(
                                  value: d,
                                  child: new Text(
                                    d.name,

                                    style: new TextStyle(color: Colors.black,fontSize: 12),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),

    Column(children: children,)
                    ],),
                  ),
                  actions: <Widget>[
                    FlatButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("Cancel"),
                    ),
                    FlatButton(
                      onPressed: () {
                        _submit();
                      },
                      child: Text("Save"),
                    ),
                  ],
                );
              },
            );
          },
        );

        //
        // showDialog(
        //     context: context,
        //
        //     builder: (context) {
        //       return SimpleDialog(
        //         contentPadding: EdgeInsets.symmetric(horizontal: 20),
        //         titlePadding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        //
        //         title: Row(
        //           children: <Widget>[
        //             Icon(Icons.credit_card),
        //             SizedBox(width: 10),
        //             Text(
        //               "Payment settings",
        //               style: Theme.of(context).textTheme.bodyText1,
        //             )
        //           ],
        //         ),
        //
        //         children: <Widget>[
        //
        //          paymentMethod!=null? Form(
        //             key: _paymentSettingsFormKey,
        //             child: Container(
        //               child: Column(children: children,),
        //               // child: Column(
        //               //     children: List<Widget>.generate(paymentMethod.fields.length, (index) {
        //               //       return Container(
        //               //           child: TextFormField(
        //               //                     style: TextStyle(color: Theme.of(context).hintColor),
        //               //                     keyboardType: TextInputType.number,
        //               //                     decoration: getInputDecoration(hintText: paymentMethod.fields[index].name, labelText: paymentMethod.fields[index].name),
        //               //                     validator: (input) => input.trim().length <1 ? "Not a valid field" : null,
        //               //                     // onSaved: (input) => widget.creditCard.number = input,
        //               //                   ),
        //               //       );
        //               //     })
        //               // ),
        //               // child: ListView.builder(
        //               //     itemCount: 5,
        //               //     shrinkWrap: true,
        //               //     // primary: false,
        //               //     itemBuilder: (BuildContext context,int index){
        //               //       return Container(
        //               //         height: 70.0,
        //               //         child: TextFormField(
        //               //           style: TextStyle(color: Theme.of(context).hintColor),
        //               //           keyboardType: TextInputType.number,
        //               //           decoration: getInputDecoration(hintText: '4242 4242 4242 4242', labelText: "Field value"),
        //               //           validator: (input) => input.trim().length != 16 ? "Not a valid field" : null,
        //               //           // onSaved: (input) => widget.creditCard.number = input,
        //               //         ),
        //               //       );
        //               //     }
        //               // ),
        //             ),
        //           ):SizedBox(height: 0,width: 0,),
        //           SizedBox(height: 20),
        //           Row(
        //             children: <Widget>[
        //               MaterialButton(
        //                 onPressed: () {
        //                   Navigator.pop(context);
        //                 },
        //                 child: Text("Cancel"),
        //               ),
        //               MaterialButton(
        //                 onPressed: _submit,
        //                 child: Text(
        //                   "Save",
        //                   style: TextStyle(color: Theme.of(context).accentColor),
        //                 ),
        //               ),
        //             ],
        //             mainAxisAlignment: MainAxisAlignment.end,
        //           ),
        //           SizedBox(height: 10),
        //         ],
        //       );
        //     });
      },
      child: Text(
        "Add",
        style: Theme.of(context).textTheme.bodyText2,
      ),
    );
  }
  BankWidget(int i){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FormField<String>(
          builder: (FormFieldState<String> state) {
            return InputDecorator(
              decoration: InputDecoration(
                  border: InputBorder.none,
                  fillColor: Colors.white,
                  filled: true),
              isEmpty: bankModel == null,
              child:      DropdownButtonHideUnderline(

                child: new DropdownButton<BankModel>(
                  value: bankModel,
                  isDense: true,
                  style: TextStyle(color: Colors.white),
                  dropdownColor: Colors.white,
                  hint: Text("Bank",style: TextStyle(color: Colors.black,fontSize: 16.0),),
                  onChanged: (BankModel newValue) {
                    setState(() {
                      bankModel = newValue;

                      paymentMethod.fields[i].value=bankModel.name;
                    });
                  },
                  items: _con.banks.map((BankModel p) {
                    return new DropdownMenuItem<BankModel>(
                      value: p,
                      child: new Text(
                        p.name,
                        style: new TextStyle(color: Colors.black,fontSize: 16.0),
                      ),
                    );
                  }).toList(),
                ),
              ),
            );
          },
        ),

      ],
    );
  }


  _submit1(){
    Map values={};
    for(int i =0;i<paymentMethod.fields.length;i++){
    values[paymentMethod.fields[i].name]=paymentMethod.fields[i].value;
    }

    print(values.toString());

    _con.AddPaymentData(new PaymentDetail(user_id: currentuser.value.id,fields: values, payment_method_id: paymentMethod.id),context);
  }


  InputDecoration getInputDecoration({String hintText, String labelText}) {
    return new InputDecoration(
      hintText: hintText,
      labelText: labelText,
      hintStyle: Theme.of(context).textTheme.bodyText2.merge(
            TextStyle(color: Theme.of(context).focusColor),
          ),
      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).hintColor.withOpacity(0.2))),
      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).hintColor)),
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      labelStyle: Theme.of(context).textTheme.bodyText2.merge(
            TextStyle(color: Theme.of(context).hintColor),
          ),
    );
  }

  void _submit() {
    if (_paymentSettingsFormKey.currentState.validate()) {
      _paymentSettingsFormKey.currentState.save();
      _submit1();
      widget.onChanged();
   }
  }
}
