import 'package:flutter/material.dart';
import 'package:horizon/src/helper/Helper.dart';
import 'package:horizon/src/model/PaymentDetail.dart';


// ignore: must_be_immutable
class EditPaymentDetailWidget extends StatefulWidget {
  PaymentDetail paymentDetail;
  VoidCallback onChanged;

  bool make_default;

  EditPaymentDetailWidget({Key key, this.paymentDetail, this.onChanged,this.make_default}) : super(key: key);

  @override
  _EditPaymentDetailWidgetState createState() => _EditPaymentDetailWidgetState();
}

class _EditPaymentDetailWidgetState extends State<EditPaymentDetailWidget> {
  GlobalKey<FormState> _paymentSettingsFormKey = new GlobalKey<FormState>();

  bool is_default=false;
  @override
  void initState() {

if(widget.paymentDetail.is_default){

  widget.make_default=true;
}

    super.initState();
  }
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
                return  SimpleDialog(
                  contentPadding: EdgeInsets.symmetric(horizontal: 20),
                  titlePadding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                  title: Row(
                    children: <Widget>[
                      Icon(Icons.person),
                      SizedBox(width: 10),
                      Text(
                        "Payment settings",
                        style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 12),
                      )
                    ],
                  ),
                  children: <Widget>[
                    Form(
                      key: _paymentSettingsFormKey,
                      child: Column(
                        children: <Widget>[
                          Text(widget.paymentDetail.paymentMethod.name),
                          SizedBox(height: 10,),
                          Column(
                              children: List<Widget>.generate( widget.paymentDetail.fields.keys.length, (indexx) {
                                String key = widget.paymentDetail.fields.keys.elementAt(indexx);
                                String value = widget.paymentDetail.fields.values.elementAt(indexx);
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [


                                      new TextFormField(
                                        style: TextStyle(color: Theme.of(context).hintColor,fontSize: 12),
                                        keyboardType: TextInputType.number,
                                        decoration: getInputDecoration(hintText: key, labelText: Helper.getFiledName(key)),

                                        initialValue: value,
                                        validator: (input) => input.trim().length <1 ? "enter a valid input" : null,
                                        onSaved: (input) {
                                          return widget.paymentDetail.fields[key]= input;
                                        },
                                      ),

                                    ],
                                  ),
                                );
                              })

                          )
                          ,
                          CheckboxListTile(
                              activeColor: Theme.of(context).accentColor,
                              dense: true,
                              //font change
                              title: new Text(
                                "Make default",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.5),
                              ),
                              value: widget.paymentDetail.make_default,

                              onChanged: (bool val) {

                                setState(() {
                                  widget.paymentDetail.make_default=val;
                                });



                              })

                          // new TextFormField(
                          //   style: TextStyle(color: Theme.of(context).hintColor),
                          //   keyboardType: TextInputType.number,
                          //   decoration: getInputDecoration(hintText: '4242 4242 4242 4242', labelText: S.of(context).number),
                          //   initialValue: widget.creditCard.number.isNotEmpty ? widget.creditCard.number : null,
                          //   validator: (input) => input.trim().length != 16 ? S.of(context).not_a_valid_number : null,
                          //   onSaved: (input) => widget.creditCard.number = input,
                          // ),
                          // new TextFormField(
                          //     style: TextStyle(color: Theme.of(context).hintColor),
                          //     keyboardType: TextInputType.text,
                          //     decoration: getInputDecoration(hintText: 'mm/yy', labelText: S.of(context).exp_date),
                          //     initialValue: widget.creditCard.expMonth.isNotEmpty ? widget.creditCard.expMonth + '/' + widget.creditCard.expYear : null,
                          //     // TODO validate date
                          //     validator: (input) => !input.contains('/') || input.length != 5 ? S.of(context).not_a_valid_date : null,
                          //     onSaved: (input) {
                          //       widget.creditCard.expMonth = input.split('/').elementAt(0);
                          //       widget.creditCard.expYear = input.split('/').elementAt(1);
                          //     }),
                          // new TextFormField(
                          //   style: TextStyle(color: Theme.of(context).hintColor),
                          //   keyboardType: TextInputType.number,
                          //   decoration: getInputDecoration(hintText: '253', labelText: S.of(context).cvc),
                          //   initialValue: widget.creditCard.cvc.isNotEmpty ? widget.creditCard.cvc : null,
                          //   validator: (input) => input.trim().length != 3 ? S.of(context).not_a_valid_cvc : null,
                          //   onSaved: (input) => widget.creditCard.cvc = input,
                          // ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: <Widget>[
                        MaterialButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("Cancel"),
                        ),
                        MaterialButton(
                          onPressed: _submit,
                          child: Text(
                            "Save",
                            style: TextStyle(color: Theme.of(context).accentColor),
                          ),
                        ),
                      ],
                      mainAxisAlignment: MainAxisAlignment.end,
                    ),
                    SizedBox(height: 10),
                  ],
                );
              },
            );
          },
        );

      },
      child: Text(
        "Edit",
        style: Theme.of(context).textTheme.bodyText2,
      ),
    );
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
      print(widget.make_default);
      widget.onChanged();
      Navigator.pop(context);
    }
  }
}
