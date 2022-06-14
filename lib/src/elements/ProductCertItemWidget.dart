import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:horizon/src/helper/Helper.dart';
import 'package:horizon/src/model/ApplicationModel.dart';
import 'package:horizon/src/model/CertificationApplicationDocument.dart';
import 'package:horizon/src/model/DocumentType.dart';


class ProductOrderItemWidget extends StatelessWidget {
  final String heroTag;
  final CertificationApplicationDocument productOrder;
  final CertificationApplicationModel applicationModel;

  const ProductOrderItemWidget({Key key, this.productOrder, this.applicationModel, this.heroTag}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Theme.of(context).accentColor,
      focusColor: Theme.of(context).accentColor,
      highlightColor: Theme.of(context).primaryColor,
      onTap: () {
        // Navigator.of(context).pushNamed('/Product', arguments: RouteArgument(id: this.productOrder.product.id));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 2),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.9),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[

            Flexible(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          productOrder.documentTypeModel.type,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: Theme.of(context).textTheme.subtitle1,
                        ),

                        // Text(
                        //   productOrder.market.name,
                        //   overflow: TextOverflow.ellipsis,
                        //   maxLines: 2,
                        //   style: Theme.of(context).textTheme.caption,
                        // ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                   Text(productOrder.status=='rejected'?'-':Helper.documentPrice(productOrder.documentTypeModel)),

                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
