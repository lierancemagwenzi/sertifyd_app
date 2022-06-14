import 'package:flutter/material.dart';
import 'package:horizon/src/helper/Helper.dart';
import 'package:horizon/src/model/CertificationApplicationDocument.dart';
import 'package:horizon/src/model/PaymentDetail.dart';


// ignore: must_be_immutable
class RejectDocumentWidget extends StatefulWidget {
  CertificationApplicationDocument document;
  VoidCallback onChanged;

  RejectDocumentWidget({Key key, this.document, this.onChanged}) : super(key: key);

  @override
  _RejectDocumentWidgetState createState() => _RejectDocumentWidgetState();
}

class _RejectDocumentWidgetState extends State<RejectDocumentWidget> {
  GlobalKey<FormState> _paymentSettingsFormKey = new GlobalKey<FormState>();
  BuildContext buildContext;

  @override
  Widget build(BuildContext context) {
    this.buildContext=context;
    return FlatButton(
      onPressed: () {
        showDialog(
            context: context,
            builder: (context) {
              return SimpleDialog(
                contentPadding: EdgeInsets.symmetric(horizontal: 20),
                titlePadding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                title: Row(
                  children: <Widget>[
                    Icon(Icons.folder),
                    SizedBox(width: 10),
                    Text(
                      "Document rejection",
                      style: Theme.of(context).textTheme.bodyText1,
                    )
                  ],
                ),
                children: <Widget>[
                  Form(
                    key: _paymentSettingsFormKey,
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 10,),
                        new TextFormField(
                          style: TextStyle(color: Theme.of(context).hintColor),
                          // keyboardType: TextInputType.number,
                          decoration: getInputDecoration(hintText: "Rejection reason", labelText: "Rejection reason"),

                          // initialValue: "",
                          validator: (input) => input.trim().length <1 ? "enter a valid input" : null,
                          onSaved: (input) {
                            return widget.document.rejection_reason= input;
                          },
                        )


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
            });
      },
      child: Text(
        "Reject",
        style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 12.0),
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
      widget.onChanged();
      // Navigator.pop(this.buildContext);
    }
  }
}
