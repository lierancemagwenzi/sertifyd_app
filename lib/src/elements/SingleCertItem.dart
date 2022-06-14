import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:horizon/src/elements/ProductCertItemWidget.dart';
import 'package:horizon/src/helper/Helper.dart';
import 'package:horizon/src/model/ApplicationModel.dart';
import 'package:intl/intl.dart' show DateFormat;



class SingleCertItem extends StatefulWidget {
  final bool expanded;
  final CertificationApplicationModel applicationModel;
  final ValueChanged<void> onCanceled;
  final ValueChanged<void> onClick;
  SingleCertItem({Key key, this.expanded, this.applicationModel, this.onCanceled,this.onClick}) : super(key: key);

  @override
  _SingleCertItemState createState() => _SingleCertItemState();
}

class _SingleCertItemState extends State<SingleCertItem> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).copyWith(dividerColor: Colors.transparent);


    return Stack(
      alignment: AlignmentDirectional.topCenter,

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
                        "Posted on "+  widget.applicationModel.getPostDate(),
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ],
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                    ),
                    trailing: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(Helper.TotalPayPrice(widget.applicationModel)),
                        widget.applicationModel.paymentModel!=null?Text(
                          'payfast',
                          style: Theme.of(context).textTheme.caption,
                        ):Text("")
                      ],
                    ),
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
                                  "Client Availability: "+widget.applicationModel.start_time+'-'+widget.applicationModel.end_time,
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
                                    "Wanted  On :"+ widget.applicationModel.getWanteddate(),
                                    style: Theme.of(context).textTheme.bodyText1.copyWith(color: Theme.of(context).primaryColorLight),
                                  ),
                                ),

                              ],
                            ),
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
