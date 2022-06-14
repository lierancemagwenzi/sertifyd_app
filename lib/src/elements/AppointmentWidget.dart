import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:horizon/src/helper/Helper.dart';
import 'package:horizon/src/model/AdminApplication.dart';
import 'package:horizon/src/model/ApplicationModel.dart';
import 'package:horizon/src/pages/admin/ApplicationScreen.dart';

AppointmentWidget(CertificationApplicationModel applicationModel,BuildContext context){


  return  applicationModel.applicant==null?Container(height: 0.0,width: 0.0,):Padding(
    padding: const EdgeInsets.symmetric(horizontal:8.0),
    child: InkWell(

      onTap: () async {

        await  Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => ApplicationScreen(
adminApplicationModel: new AdminApplicationModel(id:applicationModel.id),
                )));
      },
      child: Card(
color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),

        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: ListTile(
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
SizedBox(height: 5.0,),
                AutoSizeText(Helper.getDocuments(applicationModel),style: Theme.of(context).textTheme.headline5.copyWith(fontWeight: FontWeight.normal,color: Colors.black87,fontSize: 12.0),maxLines: 1,),
                SizedBox(height: 5.0,),

              applicationModel.start_time!=null?  Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.watch_later,color: Theme.of(context).accentColor,)  ,SizedBox(width: 5.0,),  Text(applicationModel.date+" ,"+   applicationModel.start_time,style:  Theme.of(context).textTheme.headline5.copyWith(fontWeight: FontWeight.normal,color:Color(0xffa4a7a6)
                        ,fontSize: 14.0),),

                  ],
                ):Container(height: 0.0,width: 0.0,),

                OutlinedButton(
                  child: Text("View Job",style: TextStyle(color: Colors.black87),),

                  onPressed: () => print("it's pressed"),
                  style: ElevatedButton.styleFrom(
                    side: BorderSide(width: 2.0, color: Theme.of(context).accentColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                )
            ],),
           title: Text(applicationModel.applicant.getFullname(),style: TextStyle(color: Colors.black87,fontWeight: FontWeight.bold),),
            leading: AspectRatio(
            aspectRatio: 6/6,
            child: Container(
              height: 100,width: 100,
              decoration: BoxDecoration(

                  border: Border.all(
                    color: Theme.of(context).accentColor.withOpacity(0.3),
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(30))
              ),
              child: Icon(Icons.person,color: Theme.of(context).accentColor,),
            ),
          ),
          ),
        ),

      ),
    ),
  );
}