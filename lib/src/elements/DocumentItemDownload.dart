import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:horizon/src/helper/Helper.dart';
import 'package:horizon/src/model/ApplicationModel.dart';
import 'package:horizon/src/model/CertificationApplicationDocument.dart';
import 'package:horizon/src/model/DocumentType.dart';


class DocumentItemDownload extends StatelessWidget {
  final String heroTag;
  final CertificationApplicationDocument productOrder;
  final CertificationApplicationModel applicationModel;
  final Color color;

  const DocumentItemDownload({Key key, this.productOrder, this.applicationModel, this.heroTag,this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Theme.of(context).accentColor,
      focusColor: Theme.of(context).accentColor,
      highlightColor: Theme.of(context).primaryColor,
      onTap: () {
        if(productOrder.download_path!=null){

          Navigator.pushNamed(context, "/Download",arguments: productOrder);

        }

        // print(productOrder.getDocumentPath());
        // print(Helper.getfilextention(productOrder.path));
        // print(Helper.getRoute(productOrder.path));
        // Navigator.pushNamed(context, Helper.getRoute(productOrder.path,),arguments: productOrder);
        // Navigator.of(context).pushNamed('/Product', arguments: RouteArgument(id: this.productOrder.product.id));
      },
      child: 1==1?Container(

        decoration: new BoxDecoration(
          border: Border(
            bottom: BorderSide( //                   <--- left side
              color: Colors.grey.withOpacity(0.1),

              width: 1.0,
            ),

          ),
        ),
        child: ListTile(
          leading: Container(
            height: 50,width: 50,
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Colors.grey.withOpacity(0.1),

                ),
                borderRadius: BorderRadius.all(Radius.circular(5))
            ),
            child: Center(
              child: Container(

                height: 40,width: 40,
                decoration: BoxDecoration(
                    color:color??Theme.of(context).accentColor,
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.1),

                    ),
                    borderRadius: BorderRadius.all(Radius.circular(5))
                ),
                child: Center(child: Text(productOrder.path.split('.').last.toUpperCase(),style: TextStyle(color: Colors.white,fontSize: 10.0,fontWeight: FontWeight.bold),)),
              ),
            ),
          ),
          title:Text(productOrder.documentTypeModel.type,style: TextStyle(color: Colors.black,fontSize: 15.0,fontWeight: FontWeight.bold),),
          trailing:                    productOrder.status=="complete"?Text("Download",style: TextStyle(color: Colors.black,fontSize: 12),):Text(productOrder.status??'pending',style: TextStyle(color: Colors.red,fontSize: 12.0),)
          ,


          subtitle:  Text(productOrder.documentTypeModel.country.currency+productOrder.documentTypeModel.price,style: TextStyle(color: Colors.grey.withOpacity(0.6),fontSize: 10,fontWeight: FontWeight.bold),),

        ),
      ):Container(
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
                   productOrder.status=="complete"?Text("Download"):Text(productOrder.status??'pending',style: TextStyle(color: Colors.red),)
                      
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
