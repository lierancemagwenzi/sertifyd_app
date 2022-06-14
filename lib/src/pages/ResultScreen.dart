import 'package:flutter/material.dart';
import 'package:horizon/src/model/ApplicationModel.dart';

class ValidateResultScreen extends StatefulWidget {



  CertificationApplicationModel  applicationModel;
  ValidateResultScreen({Key key, this.applicationModel}) : super(key: key);


  @override
  _ValidateResultScreenState createState() => _ValidateResultScreenState();
}

class _ValidateResultScreenState extends State<ValidateResultScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(


      appBar: AppBar(

        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: InkWell(

          onTap: (){
            Navigator.pop(context);
          },
          child: Container(
            height: 50,width: 50,
            child: Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100.0),
                ),

                child: Center(child: new Icon(Icons.arrow_back_ios, color: Theme.of(context).hintColor))),
          ),
        ),




        title: Text("Document Validation Results",style: TextStyle(color: Colors.black,fontSize: 15.0,fontWeight: FontWeight.bold),),

      ),

      body: SingleChildScrollView(

        child: Column(children: [

          Card(


            child: ListTile(title:Text("Status",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w700,fontSize: 12.0),),

                subtitle:Text("Valid",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w200,fontSize: 12.0),)


            ),
          ),
  Card(


    child: ListTile(title:Text("Certified By",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w700,fontSize: 12.0),),

        subtitle:Text(widget.applicationModel.sertifyer.getFullname(),style: TextStyle(color: Colors.black,fontWeight: FontWeight.w200,fontSize: 12.0),)


    ),
  ),

          // Card(
          //
          //
          //   child: ListTile(title:Text("Auth Number",style: TextStyle(color: Theme.of(context).accentColor,fontWeight: FontWeight.w700,fontSize: 16.0),),
          //
          //       subtitle:Text(widget.applicationModel.sertifyer.sertifyerApplication.auth_number??'',style: TextStyle(color: Theme.of(context).accentColor,fontWeight: FontWeight.w200,fontSize: 14.0),)
          //
          //
          //   ),
          // ),
  Card(

            child: ListTile(title:Text("Certified On",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w700,fontSize: 12.0),),

                subtitle:Text(widget.applicationModel.date,style: TextStyle(color: Colors.black,fontWeight: FontWeight.w200,fontSize: 12.0),)

            ),
          ),


          widget.applicationModel.documents.length>0?  Card(
            child: ListTile(
                onTap: (){
                  if(widget.applicationModel.documents[0].download_path!=null){
                    Navigator.pushNamed(context, "/Download",arguments: widget.applicationModel.documents[0]);
                  }


                },

                trailing: Icon(Icons.arrow_forward_ios,color: Theme.of(context).accentColor.withOpacity(0.3),size: 30,),

                title:Text("Preview Document",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w700,fontSize: 12.0),),

                subtitle:Text("View original document",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w200,fontSize: 12.0),)

            ),
          ):SizedBox(height: 0,width: 0,)

        ],),
      ),
    );
  }
}
