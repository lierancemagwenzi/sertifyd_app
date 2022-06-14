import 'package:flutter/material.dart';
import 'package:horizon/main.dart';
import 'package:horizon/src/controllers/AdminController.dart';
import 'package:horizon/src/controllers/DocumentController.dart';
import 'package:horizon/src/elements/RejectDocumentDialog.dart';
import 'package:horizon/src/helper/Helper.dart';
import 'package:horizon/src/model/ApplicationModel.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:horizon/src/helper/string_extension.dart';

class DocumentsWidget extends StatefulWidget {

  CertificationApplicationModel applicationModel;

  BuildContext context; AdminController adminController;

  DocumentsWidget({Key key, this.context,this.applicationModel,
    this.adminController}) : super(key: key);


  @override
  _DocumentsWidgetState createState() => _DocumentsWidgetState();
}

class _DocumentsWidgetState extends StateMVC<DocumentsWidget> {


  DocumentController _con;

  _DocumentsWidgetState() : super(DocumentController()) {
    _con = controller;
  }


  @override
  void initState() {

_con.adminController=widget.adminController;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(


      bottomNavigationBar: 1==1?
  BottomAppBar(

        child:   SafeArea(

          child: Container(
            height: 50,
            color: Colors.white,
            child: Row(children: [


              Expanded(


                child:
                InkWell(
                  onTap: (){


                    _markAsCompleted();
                  },
                  child: Container(

                    child: Center(child: Text("Mark as completed",style: TextStyle(color: Theme.of(context).accentColor,fontSize: 12.0,fontWeight: FontWeight.bold),)),

                  ),
                ),
              ),

            ],),
          ),
        ),
      ):BottomAppBar(

        child: SafeArea(

          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal:15.0),
            child: Container(
              width: 130.0,
              height: 43.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                gradient: LinearGradient(
                  // Where the linear gradient begins and ends
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  // Add one stop for each color. Stops should increase from 0 to 1
                  stops: [0.1, 0.9],
                  colors: [
                    // Colors are easy thanks to Flutter's Colors class.
                   Theme.of(context).accentColor,
                Theme.of(context).primaryColorLight,
                  ],
                ),
              ),
              child: FlatButton(
                child: Text(
                  'Mark as completed',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontFamily: 'Righteous',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                textColor: Colors.white,
                color: Colors.transparent,
                shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                onPressed: () {
                  _markAsCompleted();

                },
              ),
            ),
          ),
        ),
      ),
      key: _con.scaffoldKey,
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




        title: Text("Application Documents",style: TextStyle(color: Colors.black,fontSize: 15.0,fontWeight: FontWeight.bold),),

      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child:1==1? ListView.separated(
            padding: EdgeInsets.symmetric(vertical: 15),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            primary: false,
            itemCount: _con.adminController.certificationApplicationModel.documents.length,
            separatorBuilder: (context, index) {
              return SizedBox(height: 15);
            },
            itemBuilder: (context, index) {
              return Container(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal:10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical:15.0,horizontal: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(_con.adminController.certificationApplicationModel.documents[index].documentTypeModel.type.capitalize(),style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 12.0),),
                                  SizedBox(height: 10,),
                                  Text(_con.adminController.certificationApplicationModel.documents[index].status.capitalize(),style: TextStyle(color: Colors.black,fontWeight: FontWeight.normal,fontSize: 12.0),),

                                ],
                              ),
                            _con.adminController.certificationApplicationModel.documents[index].status!="pending"?Container(
                                decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColorLight,
                                    shape: BoxShape.circle
                                ),
                                child: Center(child: Icon(_con.adminController.certificationApplicationModel.documents[index].status=="complete"?Icons.done:Icons.close,color: Colors.white,size: 20,))):Text(""),

                          ],),
                        ),
                      ),
                      Container(
                        child: Wrap(
                          alignment: WrapAlignment.end,
                          children: <Widget>[

                            if(_con.adminController.certificationApplicationModel.documents[index].status=="pending")
                            FlatButton(
                              onPressed: () {
                                _certify(index);
                              },
                              textColor: Theme.of(context).hintColor,
                              child: Wrap(
                                children: <Widget>[Text("Certify",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 12.0),)],
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 0),
                            ),

                            if(_con.adminController.certificationApplicationModel.documents[index].status=="pending")
                              RejectDocumentWidget(

                                document:_con.adminController.certificationApplicationModel.documents[index] ,
                                onChanged: (){
Navigator.pop(context);
                                  _con.RejectDoc({"document_id":_con.adminController.certificationApplicationModel.documents[index].id,"reason":_con.adminController.certificationApplicationModel.documents[index].rejection_reason}, index, context);

                                },
                              ),
                            FlatButton(
                              onPressed: () {
                                Navigator.pushNamed(context, Helper.getRoute(_con.adminController.certificationApplicationModel.documents[index].path,),arguments: _con.adminController.certificationApplicationModel.documents[index]);

                              },
                              textColor: Theme.of(context).hintColor,
                              child: Wrap(
                                children: <Widget>[Text( "View",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 12.0))],
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 10),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),

              );
            }): Stack(
          children: [
            new GridView.builder(
                itemCount: widget.applicationModel.documents.length,
                gridDelegate:
                new SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 2/3,
                    crossAxisSpacing: 5.0,
                    mainAxisSpacing: 5.0,
                    crossAxisCount: 2),
                itemBuilder: (BuildContext context, int index) {

                  return Card(
     child: Column(
       mainAxisAlignment: MainAxisAlignment.center,
  children: [
  Card(
    elevation:10.0,
      shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(Icons.file_present,color: Theme.of(context).accentColor,size: 60.0,)),
    SizedBox(height: 10.0,),
    Text(  widget.applicationModel.documents[index].documentTypeModel.type),
    RaisedButton(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5),side: BorderSide(color:Theme.of(context).primaryColorLight)),
      onPressed: () {
        print(widget.applicationModel.documents[index].path);
        print(Helper.getfilextention(widget.applicationModel.documents[index].path));
        print(Helper.getRoute(widget.applicationModel.documents[index].path));
            Navigator.pushNamed(context, Helper.getRoute(widget.applicationModel.documents[index].path,),arguments: widget.applicationModel.documents[index]);

      },
      child: Text("View File"),
    ),
    Container(
      width: MediaQuery.of(context).size.width * 0.3,
      child: OutlinedButton(
        child: Text(
          "Certify Doc",
          style: TextStyle(
              fontSize: 14,
              fontFamily: "Poppins",
              color: Theme.of(context).accentColor),
        ),
        onPressed: () {
          _certify(index);
        },
        style: ElevatedButton.styleFrom(
          // textStyle: TextStyle(fontSize: 14,fontFamily: "Poppins"),
          side: BorderSide(width: 2.0, color: Theme.of(context).accentColor),
          shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(32.0),
          ),
        ),
      ),
    ),
    CheckboxListTile(
      title:  Text('Certify?',style: TextStyle(color: Theme.of(context).accentColor,fontSize: 17.0,fontWeight: FontWeight.w200)),
      autofocus: false,
      activeColor: Theme.of(context).accentColor,
      checkColor: Colors.white,
      selected: true,
      value: widget.applicationModel.documents[index].certified ,
      onChanged: (bool value) {
            setState(() {
              widget.applicationModel.documents[index].certified=value;
            });
      },
    )

],),
                  );
                }),
Positioned(

    bottom: 20.0,left: 10.0,right: 10.0,
    child: SafeArea(child: _submitButton()))

          ],
        ),
      ),
    );
  }




  _certify(int index){

    Map map={"application_id":widget.applicationModel.id,"document_id":widget.applicationModel.documents[index].id};
    _con.CertifyDoc(map,index,widget.context);

  }


  _submit(){
    var docs=[];
    var rejected=[];
    for(int i=0;i<widget.applicationModel.documents.length;i++){
      if(widget.applicationModel.documents[i].certified==true){

        docs.add(widget.applicationModel.documents[i].id);
      }
      else{
        rejected.add(widget.applicationModel.documents[i].id);
      }
    }
    if(docs.length>0){
      _con.adminController.CertifyDocs(docs,rejected, widget.applicationModel.id,widget.context);
    }
    else{
      _con.scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text("Select at least one document"),
      ));
    }

  }

  _markAsCompleted(){
print("tapped");
    int count=0;
    for(int i=0;i<_con.adminController.certificationApplicationModel.documents.length;i++) {


      if(_con.adminController.certificationApplicationModel.documents[i].status=="pending"){

        count=count+1;
      }
    }

    if(count>0){
      _con.scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text("Some documents need actioning"),
      ));
    }
    else{
      _con.MarkAsComplete({"application_id":_con.adminController.certificationApplicationModel.id}, context);
    }

    }


  Widget _submitButton() {
    return InkWell(
      onTap: (){

        _submit();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal:15.0),
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(vertical: 15),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.grey.shade200,
                    offset: Offset(2, 4),
                    blurRadius: 5,
                    spreadRadius: 2)
              ],
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [Theme.of(context).accentColor,Theme.of(context).accentColor])),
          child: Text(
            'Certify Documents',
            style: TextStyle(fontSize: 20, color: Colors.white70),
          ),
        ),
      ),
    );
  }
}
