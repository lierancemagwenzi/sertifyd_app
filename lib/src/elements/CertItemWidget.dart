import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:horizon/src/elements/ProductCertItemWidget.dart';
import 'package:horizon/src/helper/Helper.dart';
import 'package:horizon/src/model/ApplicationModel.dart';
import 'package:intl/intl.dart' show DateFormat;



class CertItemWidget extends StatefulWidget {
  final bool expanded;

  final Color color;
  final CertificationApplicationModel applicationModel;
  final ValueChanged<void> onCanceled;

  final ValueChanged<CertificationApplicationModel> onSelected;
  final ValueChanged<CertificationApplicationModel> onReschedule;


  final ValueChanged<CertificationApplicationModel> onClick;


  CertItemWidget({Key key, this.expanded, this.applicationModel, this.onCanceled,this.onClick,this.onSelected,this.onReschedule,this.color}) : super(key: key);

  @override
  _CertItemWidgetState createState() => _CertItemWidgetState();
}

class _CertItemWidgetState extends State<CertItemWidget> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).copyWith(dividerColor: Colors.transparent);

    DateFormat format =
    DateFormat("yyyy-MM-dd");

    var formated =
    format.parse(widget.applicationModel.date);

    var date =
    DateFormat.yMMMMEEEEd().format(formated);
    return 1==1?Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(

        onTap: (){

if(widget.applicationModel.status.client==null){

  return;
}
          if(widget.applicationModel.status.client.toLowerCase()=="reschedule"){
            widget.onReschedule(widget.applicationModel);
          }
          else{

            widget.onClick(widget.applicationModel);

          }
        },
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Colors.white,
              ),
              borderRadius: BorderRadius.all(Radius.circular(5))
          ),
          child: ListTile(
            title: Text("Order number ${widget.applicationModel.id}", style: TextStyle(
                color: Colors.black,
                fontSize: 10,
                fontWeight: FontWeight.bold),),
            subtitle: Text(widget.applicationModel.getPostDate(), style: TextStyle(
                color: Colors.grey.withOpacity(0.8),
                fontSize: 10,
                fontWeight: FontWeight.w200),),
            leading: Container(
              height: 35, width: 35,
              decoration: BoxDecoration(
                  color: widget.color,
                  border: Border.all(
                    color: Colors.white,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(5))
              ),

              child: Center(child: Icon(
                Icons.folder_open_outlined, color: Colors.white,
                size: 25,)),

            ),

          ),
        ),
      ),
    ): Stack(

      children: <Widget>[
        Opacity(
          opacity:  1 ,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 14),
                padding: EdgeInsets.only(top: 20, bottom: 5),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.9),
                  boxShadow: [
                    BoxShadow(color: Theme.of(context).focusColor.withOpacity(0.1), blurRadius: 5, offset: Offset(0, 2)),
                  ],
                ),
                child: Theme(
                  data: theme,
                  child: ExpansionTile(
                    initiallyExpanded: widget.expanded,
                    title: Column(
                      children: <Widget>[
                        Text('Id: #${widget.applicationModel.id}'),
                        Text(
                      "Posted on "+ widget.applicationModel.getPostDate(),
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ],
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                    ),
                    trailing:widget.applicationModel.paymentModel!=null? Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                      Text(Helper.TotalPayPrice(widget.applicationModel)),
                        widget.applicationModel.paymentModel!=null?Text(
                          'payfast',
                          style: Theme.of(context).textTheme.caption,
                        ):Text("")
                      ],
                    ):null,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
SizedBox(width: 10.0,),
                          Container(

                            height: 60, width: 60,
                            // child: Center(
                            //   child: Text((index + 0).toString(), style:
                            //   Theme
                            //       .of(context)
                            //       .textTheme
                            //       .headline5
                            //       .copyWith(color: Colors.black87),),
                            // ),

                            child: Icon(Icons.folder),
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey.withOpacity(0.3),


                                ),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(8))
                            ),
                          ),
                          Expanded(
                            child: Column(
                                children: List.generate(
                              widget.applicationModel.documents.length,
                              (indexProduct) {
                                return ProductOrderItemWidget(
                                    heroTag: 'mywidget.orders', applicationModel: widget.applicationModel, productOrder: widget.applicationModel.documents.elementAt(indexProduct));
                              },
                            )),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        child: Column(
                          children: <Widget>[
                          widget.applicationModel.sertifyer==null?  Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    "Scheduled   "+widget.applicationModel.getWanteddate()+" "+ widget.applicationModel.start_time+"-"+widget.applicationModel.end_time,
                                    style: Theme.of(context).textTheme.bodyText1,
                                  ),
                                ),
                              ],
                            ):Container(height: 0,width: 0,),
                            // Row(
                            //   children: <Widget>[
                            //     Expanded(
                            //       child: Text(
                            //         '${S.of(context).tax} (${widget.order.tax}%)',
                            //         style: Theme.of(context).textTheme.bodyText1,
                            //       ),
                            //     ),
                            //     Helper.getPrice(Helper.getTaxOrder(widget.order), context, style: Theme.of(context).textTheme.subtitle1)
                            //   ],
                            // ),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    "Total",
                                    style: Theme.of(context).textTheme.bodyText1,
                                  ),
                                ),
                              Text(Helper.TotalPayPrice(widget.applicationModel),style: Theme.of(context).textTheme.headline4)

                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                child: Wrap(
                  alignment: WrapAlignment.end,
                  children: <Widget>[

                    if (widget.applicationModel.status.client!=null)

                      FlatButton(
                      onPressed: () {

                        if(widget.applicationModel.status.client.toLowerCase()=="reschedule"){
                          widget.onReschedule(widget.applicationModel);
                        }
                        else{

                          widget.onClick(widget.applicationModel);

                        }

                      },
                      textColor: Theme.of(context).hintColor,
                      child: Wrap(
                        children: <Widget>[Text(widget.applicationModel.status.client)],
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 0),
                    ),
                    if (widget.applicationModel.status.can_cancel)
                      FlatButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              // return object of type Dialog
                              return AlertDialog(
                                title: Wrap(
                                  spacing: 10,
                                  children: <Widget>[
                                    Icon(Icons.report, color: Theme.of(context).accentColor),
                                    Text(
                                      "confirmation",
                                      style: TextStyle(color:  Theme.of(context).accentColor),
                                    ),
                                  ],
                                ),
                                content: Text("Are you sure you want to cancel"),
                                contentPadding: EdgeInsets.symmetric(horizontal: 30, vertical: 25),
                                actions: <Widget>[
                                  FlatButton(
                                    child: new Text(
                                      "yes",
                                      style: TextStyle(color: Theme.of(context).hintColor),
                                    ),
                                    onPressed: () {
                                      widget.onSelected(widget.applicationModel);
                                      // widget.onCanceled(widget.order);
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  FlatButton(
                                    child: new Text(
                                      "close",
                                      style: TextStyle(color:  Theme.of(context).accentColor),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        textColor: Theme.of(context).hintColor,
                        child: Wrap(
                          children: <Widget>[Text( "Cancel ")],
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 10),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsetsDirectional.only(start: 20),
          padding: EdgeInsets.symmetric(horizontal: 10),
          height: 28,
          width: 140,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)), color: Theme.of(context).accentColor),
          alignment: AlignmentDirectional.center,
          child: Text(
            '${widget.applicationModel.status.status}',
            maxLines: 1,
            overflow: TextOverflow.fade,
            softWrap: false,
            style: Theme.of(context).textTheme.caption.merge(TextStyle(height: 1, color: Theme.of(context).primaryColor)),
          ),
        ),
      ],
    );
  }
}
