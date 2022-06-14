import 'package:flutter/material.dart';
import 'package:horizon/src/controllers/AdminController.dart';
import 'package:horizon/src/elements/CircularLoadingWidget.dart';
import 'package:horizon/src/elements/EditPaymentDetailDialog.dart';
import 'package:horizon/src/elements/PaymentSettingsDialog.dart';
import 'package:horizon/src/helper/Helper.dart';
import 'package:horizon/src/icons/zoom_signature.dart';
import 'package:horizon/src/repositories/user_repository.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

class SettingsWidget extends StatefulWidget {

  SettingsWidget({Key key,this.message}) : super(key: key);


  String message;

  @override
  _SettingsWidgetState createState() => _SettingsWidgetState();
}

class _SettingsWidgetState extends StateMVC<SettingsWidget> {
  AdminController _con;

  _SettingsWidgetState() : super(AdminController()) {
    _con = controller;
  }

  @override
  void initState() {
    if(widget.message!=null){

      Future.delayed(const Duration(seconds: 1), () {

        _con.scaffoldKey?.currentState?.showSnackBar(SnackBar(
          content: Text(widget.message??''),
        ));

      });
    }

    _con.listenForPaymentDetail();

    // _con.listenForBanks();


    super.initState();
  }


  bool make_default=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _con.scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          leading: InkWell(

              onTap: (){

                Navigator.pushNamed(context, '/Admin',arguments: 2);
              },

              child: Icon(Icons.arrow_back_ios,color: Theme.of(context).accentColor,)),
          title: Text(
            "Settings",
            style: Theme.of(context).textTheme.headline6.merge(TextStyle(letterSpacing: 1.3)),
          ),
        ),
        body: currentuser.value.id == null
            ? CircularLoadingWidget(height: 500)
            : SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 7),
          child: Column(
            children: <Widget>[

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Row(
                  children: <Widget>[
                    // Expanded(
                    //   child: Column(
                    //     children: <Widget>[
                    //       Text(
                    //         currentuser.value.getFullname(),
                    //         textAlign: TextAlign.left,
                    //         style: Theme.of(context).textTheme.headline3.copyWith(fontSize: 12),
                    //       ),
                    //       Text(
                    //         currentuser.value.mobile,
                    //         style: Theme.of(context).textTheme.caption.copyWith(fontSize: 12),
                    //       )
                    //     ],
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //   ),
                    // ),
                    // SizedBox(
                    //     width: 55,
                    //     height: 55,
                    //     child: InkWell(
                    //       borderRadius: BorderRadius.circular(300),
                    //       onTap: () {
                    //         // Navigator.of(context).pushNamed('/Profile');
                    //       },
                    //       child: CircleAvatar(
                    //         backgroundImage: NetworkImage(currentuser.value.getProfilePic()),
                    //       ),
                    //     )),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [BoxShadow(color: Theme.of(context).hintColor.withOpacity(0.15), offset: Offset(0, 3), blurRadius: 10)],
                ),
                child: ListView(
                  shrinkWrap: true,
                  primary: false,
                  children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.person,color: Theme.of(context).accentColor,),
                      title: Text(
                       "Profile Settings",
                        style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 12),
                      ),
                      // trailing: ButtonTheme(
                      //   padding: EdgeInsets.all(0),
                      //   minWidth: 50.0,
                      //   height: 25.0,
                      //   child: ProfileSettingsDialog(
                      //     user: currentUser.value,
                      //     onChanged: () {
                      //       _con.update(currentUser.value);
                      //       //setState(() {});
                      //     },
                      //   ),
                      // ),
                    ),
                    ListTile(
                      onTap: () {},
                      dense: true,
                      title: Text(
                        "Full name",
                        style: Theme.of(context).textTheme.bodyText2.copyWith(fontSize: 12),
                      ),
                      trailing: Text(
                        currentuser.value.getFullname(),
                        style: TextStyle(color: Theme.of(context).focusColor,fontSize: 12),
                      ),
                    ),
                    ListTile(
                      onTap: () {},
                      dense: true,
                      title: Text(
                        currentuser.value.mobile.contains('@')?  "Email":"Phone",
                        style: Theme.of(context).textTheme.bodyText2.copyWith(fontSize: 12),
                      ),
                      trailing: Text(
                        currentuser.value.mobile,

                        style: TextStyle(color: Theme.of(context).focusColor,fontSize: 12),
                      ),
                    ),
                    // ListTile(
                    //   onTap: () {},
                    //   dense: true,
                    //   title: Text(
                    //    "Phone",
                    //     style: Theme.of(context).textTheme.bodyText2.copyWith(fontSize: 12),
                    //   ),
                    //   trailing: Text(
                    //     currentuser.value.mobile,
                    //     style: TextStyle(color: Theme.of(context).focusColor,fontSize: 12),
                    //   ),
                    // ),
                    ListTile(
                      onTap: () {},
                      dense: true,
                      title: Text(
                        "Address",
                        style: Theme.of(context).textTheme.bodyText2.copyWith(fontSize: 12),
                      ),
                      trailing: Text(
                        Helper.limitString(currentuser.value.address ?? "unknown"),
                        overflow: TextOverflow.fade,
                        softWrap: false,
                        style: TextStyle(color: Theme.of(context).focusColor,fontSize: 12),
                      ),
                    ),

                  ],
                ),
              ),

              Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [BoxShadow(color: Theme.of(context).hintColor.withOpacity(0.15), offset: Offset(0, 3), blurRadius: 10)],
                ),
                child: ListView(
                  shrinkWrap: true,
                  primary: false,
                  children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.notifications,color: Theme.of(context).accentColor,),
                      title: Text(
                        "Job Notifications",
                        style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 12),
                      ),

                      trailing: currentuser.value.signature==null?InkWell(

                          onTap: (){

                            Navigator.pushNamed(context, "/AddSignature");
                          },
                          child: Icon(Icons.add_circle,color: Theme.of(context).accentColor,)):null,

                    ),

                    CheckboxListTile(
                        activeColor: Theme.of(context).accentColor,
                        dense: true,
                        //font change
                        title: new Text(
                         "Receive Job  Notifications?",
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                              letterSpacing: 0.5),
                        ),
                        value: currentuser.value.receive_job_notifications??false,

                        onChanged: (bool val) {

_con.UpdateNotificationData(val);
                        })

                  ],
                ),
              ),
             Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [BoxShadow(color: Theme.of(context).hintColor.withOpacity(0.15), offset: Offset(0, 3), blurRadius: 10)],
                ),
                child: ListView(
                  shrinkWrap: true,
                  primary: false,
                  children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.credit_card,color: Theme.of(context).accentColor,),
                      title: Text(
                      "Payment settings",
                        style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 12),
                      ),
                      trailing: ButtonTheme(
                        padding: EdgeInsets.all(0),
                        minWidth: 50.0,
                        height: 25.0,
                        child: PaymentSettingsDialog(
                          // creditCard: _con.creditCard,
                          onChanged: () {
                            Navigator.pop(context);
                            Future.delayed(const Duration(seconds: 2), () {
                              setState(() {
                                 _con.listenForPaymentDetail();
                              });
                            });

                          },
                        ),
                      ),
                    ),

                    ListView.builder(
                        itemCount: _con.payment_details.length,
                        shrinkWrap: true,
                        primary: false,
                        itemBuilder: (BuildContext context,int position){
                          return ListTile(
                              leading: Icon(Icons.credit_card,color: Theme.of(context).accentColor,),
trailing:       ButtonTheme(
  padding: EdgeInsets.all(0),
  minWidth: 50.0,
  height: 25.0,
  child: EditPaymentDetailWidget(
    paymentDetail: _con.payment_details[position],
    make_default: make_default,
    // creditCard: _con.creditCard,
    onChanged: () {
    print(make_default);
      _con.UpdatePaymentData(_con.payment_details[position],make_default, context, position);

    },
  ),
),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _con.payment_details[position].is_default?Text("default",style: TextStyle(fontSize: 12),):Container(height: 0,width: 0,),
                                  ListView.builder(
                                      itemCount: _con.payment_details[position].fields.keys.length,
                                      shrinkWrap:true,
                                      primary:false,

                                      itemBuilder: (BuildContext context,int indexx){
                                        String key = _con.payment_details[position].fields.keys.elementAt(indexx);
                                        String value = _con.payment_details[position].fields.values.elementAt(indexx);
                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(Helper.getFiledName(key)+": ",style: TextStyle(fontSize: 12),),
                                                  Expanded(child: Text(value,overflow: TextOverflow.ellipsis,maxLines: 1,style: TextStyle(fontSize: 12),)),

                                                ],
                                              )
                                          ),
                                        );
                                      }
                                  ),
                                  // Column(
                                  //     children: List<Widget>.generate( _con.payment_details[index].fields.keys.length, (indexx) {
                                  //
                                  //       String key = _con.payment_details[index].fields.keys.elementAt(indexx);
                                  //       String value = _con.payment_details[index].fields.values.elementAt(indexx);
                                  //
                                  //
                                  //       return Padding(
                                  //         padding: const EdgeInsets.all(8.0),
                                  //         child: Container(
                                  //             child: Row(
                                  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  //               children: [
                                  //                 Text(Helper.getFiledName(key)+": "),
                                  //                 Expanded(child: Text(value,overflow: TextOverflow.ellipsis,maxLines: 1,)),
                                  //
                                  //               ],
                                  //             )
                                  //         ),
                                  //       );
                                  //     })
                                  //
                                  // ),
                                ],
                              ),
                              title: Text(_con.payment_details[position].paymentMethod.name,style: TextStyle(fontSize: 12),

                               ),
                          );
                        }
                    )
                    // ListTile(
                    //   dense: true,
                    //   title: Text(
                    //     S.of(context).default_credit_card,
                    //     style: Theme.of(context).textTheme.bodyText2,
                    //   ),
                    //   trailing: Text(
                    //     _con.creditCard.number.isNotEmpty ? _con.creditCard.number.replaceRange(0, _con.creditCard.number.length - 4, '...') : '',
                    //     style: TextStyle(color: Theme.of(context).focusColor),
                    //   ),
                    // ),
                  ],
                ),
              ),

              Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [BoxShadow(color: Theme.of(context).hintColor.withOpacity(0.15), offset: Offset(0, 3), blurRadius: 10)],
                ),
                child: ListView(
                  shrinkWrap: true,
                  primary: false,
                  children: <Widget>[
                    ListTile(
                      leading: Icon(CustomIcons.signature,color: Theme.of(context).accentColor,),
                      title: Text(
                        "Signature settings",
                        style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 12),
                      ),

                      trailing: currentuser.value.signature==null?InkWell(

                        onTap: (){

                          Navigator.pushNamed(context, "/AddSignature");
                        },
                          child: Icon(Icons.add_circle,color: Theme.of(context).accentColor,)):null,

                    ),

                    currentuser.value.signature!=null?Image.network(currentuser.value.signature.getPath()):SizedBox(height: 0,)
                  ],
                ),
              ),
              // Container(
              //   margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              //   decoration: BoxDecoration(
              //     color: Theme.of(context).primaryColor,
              //     borderRadius: BorderRadius.circular(6),
              //     boxShadow: [BoxShadow(color: Theme.of(context).hintColor.withOpacity(0.15), offset: Offset(0, 3), blurRadius: 10)],
              //   ),
              //   child: ListView(
              //     shrinkWrap: true,
              //     primary: false,
              //     children: <Widget>[
              //       ListTile(
              //         leading: Icon(Icons.settings),
              //         title: Text(
              //          "App Settings",
              //           style: Theme.of(context).textTheme.bodyText1,
              //         ),
              //       ),
              //       ListTile(
              //         onTap: () {
              //           Navigator.of(context).pushNamed('/Languages');
              //         },
              //         dense: true,
              //         title: Row(
              //           children: <Widget>[
              //             Icon(
              //               Icons.translate,
              //               size: 22,
              //               color: Theme.of(context).focusColor,
              //             ),
              //             SizedBox(width: 10),
              //             Text(
              //               "Languages",
              //               style: Theme.of(context).textTheme.bodyText2,
              //             ),
              //           ],
              //         ),
              //         trailing: Text(
              //          "English",
              //           style: TextStyle(color: Theme.of(context).focusColor),
              //         ),
              //       ),
              //       ListTile(
              //         onTap: () {
              //           Navigator.of(context).pushNamed('/DeliveryAddresses');
              //         },
              //         dense: true,
              //         title: Row(
              //           children: <Widget>[
              //             Icon(
              //               Icons.place,
              //               size: 22,
              //               color: Theme.of(context).focusColor,
              //             ),
              //             SizedBox(width: 10),
              //             Text(
              //               "Delivery Addresses",
              //               style: Theme.of(context).textTheme.bodyText2,
              //             ),
              //           ],
              //         ),
              //       ),
              //       ListTile(
              //         onTap: () {
              //           Navigator.of(context).pushNamed('/Help');
              //         },
              //         dense: true,
              //         title: Row(
              //           children: <Widget>[
              //             Icon(
              //               Icons.help,
              //               size: 22,
              //               color: Theme.of(context).focusColor,
              //             ),
              //             SizedBox(width: 10),
              //             Text(
              //               "Help and support",
              //               style: Theme.of(context).textTheme.bodyText2,
              //             ),
              //           ],
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
        ));
  }
}