import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:horizon/src/controllers/application_controller.dart';
import 'package:horizon/src/elements/CertItemWidget.dart';
import 'package:horizon/src/elements/CertiDownloadItemWidget.dart';
import 'package:horizon/src/elements/CircularLoadingWidget.dart';
import 'package:horizon/src/elements/DocumentItemDownload.dart';
import 'package:horizon/src/elements/DocumentItemView.dart';
import 'package:horizon/src/elements/ProductCertItemWidget.dart';
import 'package:horizon/src/elements/SingleCertItem.dart';
import 'package:horizon/src/helper/Helper.dart';
import 'package:horizon/src/model/ClientApplication.dart';
import 'package:intl/intl.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:url_launcher/url_launcher.dart';

class DownloadApplicationWidget extends StatefulWidget {

  ClientApplication  clientApplication;

  DownloadApplicationWidget({Key key, this.clientApplication}) : super(key: key);

  @override
  _DownloadApplicationWidgetState createState() => _DownloadApplicationWidgetState();
}

class _DownloadApplicationWidgetState extends StateMVC<DownloadApplicationWidget> {

  ApplicationController _con;

  _DownloadApplicationWidgetState() : super(ApplicationController()) {
    _con = controller;
  }

  @override
  void initState() {


    if(widget.clientApplication!=null){
      new Future.delayed(Duration.zero,() {
        _con.listenForApplication(widget.clientApplication.id,context: context,client_next:widget.clientApplication.client_next );
      });
    }

    else{
      _con.listenForApplication(widget.clientApplication.id );

    }


    super.initState();
  }

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




          title: Text("Documents Download ",style: TextStyle(color: Colors.black,fontSize: 15.0,fontWeight: FontWeight.bold),),

        ),
        body:    _con.certificationApplicationModel == null
            ? CircularLoadingWidget(height: 500)
            : 1==1?Body():Stack(
          fit: StackFit.expand,
          children: <Widget>[
            CustomScrollView(
              primary: true,
              shrinkWrap: false,
              slivers: <Widget>[
//             SliverAppBar(
//               backgroundColor: Theme.of(context).accentColor.withOpacity(0.9),
//               expandedHeight: 300,
//               elevation: 0,
// //                          iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
//               automaticallyImplyLeading: false,
//               leading: new IconButton(
//                 icon: new Icon(Icons.sort, color: Theme.of(context).primaryColor),
//                 onPressed: () {
//                 },
//               ),
//               flexibleSpace: FlexibleSpaceBar(
//                 collapseMode: CollapseMode.parallax,
//                 background: Hero(
//                   tag: (widget.id.toString()) + "hero",
//                   child: CachedNetworkImage(
//                     fit: BoxFit.cover,
//                     imageUrl: "",
//                     placeholder: (context, url) => Image.asset(
//                       'assets/images/loading.gif',
//                       fit: BoxFit.cover,
//                     ),
//                     errorWidget: (context, url, error) => Icon(Icons.error),
//                   ),
//                 ),
//               ),
//             ),
                SliverToBoxAdapter(
                  child: Wrap(
                    children: [

                      Container(height: 30.0,),
                      // Padding(
                      //   padding: const EdgeInsets.only(right: 20, left: 20, bottom: 10, top: 25),
                      //   child: Row(
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     children: <Widget>[
                      //       Expanded(
                      //         child: Text(
                      //           'Name',
                      //           overflow: TextOverflow.fade,
                      //           softWrap: false,
                      //           maxLines: 2,
                      //           style: Theme.of(context).textTheme.headline3,
                      //         ),
                      //       ),
                      //       SizedBox(
                      //         height: 32,
                      //         child: Chip(
                      //           padding: EdgeInsets.all(0),
                      //           label: Row(
                      //             mainAxisAlignment: MainAxisAlignment.center,
                      //             children: <Widget>[
                      //               Text("40",
                      //                   style: Theme.of(context).textTheme.bodyText1.merge(TextStyle(color: Theme.of(context).primaryColor))),
                      //               Icon(
                      //                 Icons.star_border,
                      //                 color: Theme.of(context).primaryColor,
                      //                 size: 16,
                      //               ),
                      //             ],
                      //           ),
                      //           backgroundColor: Theme.of(context).accentColor.withOpacity(0.9),
                      //           shape: StadiumBorder(),
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      CertiDownloadItemWidget(
                        applicationModel: _con.certificationApplicationModel,
                        expanded: true,
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: ListTile(
                          dense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 0),
                          leading: Icon(
                            Icons.description,
                            color: Theme.of(context).hintColor,
                          ),
                          title: Text(
                            "Description",
                            style: Theme.of(context).textTheme.headline4,
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        child: Text(_con.certificationApplicationModel.description),
                      ),
                      // ImageThumbCarouselWidget(galleriesList: _con.galleries),
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(horizontal: 20),
                      //   child: ListTile(
                      //     dense: true,
                      //     contentPadding: EdgeInsets.symmetric(vertical: 0),
                      //     leading: Icon(
                      //       Icons.video_call_sharp,
                      //       color: Theme.of(context).hintColor,
                      //     ),
                      //     title: Text(
                      //       "Zoom Meeting Information",
                      //       style: Theme.of(context).textTheme.headline4,
                      //     ),
                      //   ),
                      // ),
                      // Container(
                      //   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      //   margin: const EdgeInsets.symmetric(vertical: 5),
                      //   color: Theme.of(context).primaryColor,
                      //   child: Column(
                      //     children: [
                      //       Row(
                      //         crossAxisAlignment: CrossAxisAlignment.center,
                      //         children: <Widget>[
                      //           Expanded(
                      //             child: Text(
                      //               _con.certificationApplicationModel.zoom.join_url,
                      //               overflow: TextOverflow.ellipsis,
                      //               maxLines: 1,
                      //               style: Theme.of(context).textTheme.bodyText1,
                      //             ),
                      //           ),
                      //           SizedBox(width: 10),
                      //           SizedBox(
                      //             width: 42,
                      //             height: 42,
                      //             child: FlatButton(
                      //               padding: EdgeInsets.all(0),
                      //               onPressed: () {
                      //                 _launchURL(_con.certificationApplicationModel.zoom.join_url);
                      //               },
                      //               child: Icon(
                      //                 Icons.arrow_forward,
                      //                 color: Theme.of(context).primaryColor,
                      //                 size: 24,
                      //               ),
                      //               color: Theme.of(context).accentColor.withOpacity(0.9),
                      //               shape: StadiumBorder(),
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //       SizedBox(height: 10),
                      //       Row(
                      //         crossAxisAlignment: CrossAxisAlignment.center,
                      //         children: <Widget>[
                      //           Expanded(
                      //             child: Text(
                      //               _con.certificationApplicationModel.zoom.password,
                      //               overflow: TextOverflow.ellipsis,
                      //               maxLines: 1,
                      //               style: Theme.of(context).textTheme.bodyText1,
                      //             ),
                      //           ),
                      //           SizedBox(width: 10),
                      //           SizedBox(
                      //             width: 42,
                      //             height: 42,
                      //             child: FlatButton(
                      //               padding: EdgeInsets.all(0),
                      //               onPressed: () {
                      //               },
                      //               child: Icon(
                      //                 Icons.lock,
                      //                 color: Theme.of(context).primaryColor,
                      //                 size: 24,
                      //               ),
                      //               color: Theme.of(context).accentColor.withOpacity(0.9),
                      //               shape: StadiumBorder(),
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //       SizedBox(height: 20),
                      //
                      //       Row(
                      //         crossAxisAlignment: CrossAxisAlignment.center,
                      //         children: <Widget>[
                      //           Expanded(
                      //             child: Text(
                      //               getTime(),
                      //               overflow: TextOverflow.ellipsis,
                      //               maxLines: 1,
                      //               style: Theme.of(context).textTheme.bodyText1,
                      //             ),
                      //           ),
                      //           SizedBox(width: 10),
                      //           SizedBox(
                      //             width: 42,
                      //             height: 42,
                      //             child: FlatButton(
                      //               padding: EdgeInsets.all(0),
                      //               onPressed: () {
                      //               },
                      //               child: Icon(
                      //                 Icons.watch_later_rounded,
                      //                 color: Theme.of(context).primaryColor,
                      //                 size: 24,
                      //               ),
                      //               color: Theme.of(context).accentColor.withOpacity(0.9),
                      //               shape: StadiumBorder(),
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //     ],
                      //   ),
                      // ),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: ListTile(
                          dense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 0),
                          leading: Icon(
                            Icons.person,
                            color: Theme.of(context).hintColor,
                          ),
                          title: Text(
                            "Commissioner Of Oaths",
                            style: Theme.of(context).textTheme.headline4,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        color: Theme.of(context).primaryColor,
                        child: Column(
                          children: [

                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    _con.certificationApplicationModel.sertifyer.getFullname(),
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context).textTheme.bodyText1,
                                  ),
                                ),
                                SizedBox(width: 10),
                                SizedBox(
                                  width: 42,
                                  height: 42,
                                  child: FlatButton(
                                    padding: EdgeInsets.all(0),
                                    onPressed: () {
                                      // launch("tel:${_con.market.mobile}");
                                    },
                                    child: Icon(
                                      Icons.account_circle,
                                      color: Theme.of(context).primaryColor,
                                      size: 24,
                                    ),
                                    color: Theme.of(context).accentColor.withOpacity(0.9),
                                    shape: StadiumBorder(),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    _con.certificationApplicationModel.sertifyer.mobile,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context).textTheme.bodyText1,
                                  ),
                                ),
                                SizedBox(width: 10),
                                SizedBox(
                                  width: 42,
                                  height: 42,
                                  child: FlatButton(
                                    padding: EdgeInsets.all(0),
                                    onPressed: () {
                                      // launch("tel:${_con.market.mobile}");
                                    },
                                    child: Icon(
                                      Icons.email_outlined,
                                      color: Theme.of(context).primaryColor,
                                      size: 24,
                                    ),
                                    color: Theme.of(context).accentColor.withOpacity(0.9),
                                    shape: StadiumBorder(),
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 20),
                            _con.certificationApplicationModel.status.can_chat?  Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    "Send In app Message",
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context).textTheme.bodyText1,
                                  ),
                                ),
                                SizedBox(width: 10),
                                SizedBox(
                                  width: 42,
                                  height: 42,
                                  child: FlatButton(
                                    padding: EdgeInsets.all(0),
                                    onPressed: () {
                                      // launch("tel:${_con.market.mobile}");
                                    },
                                    child: Icon(
                                      Icons.chat_bubble,
                                      color: Theme.of(context).primaryColor,
                                      size: 24,
                                    ),
                                    color: Theme.of(context).accentColor.withOpacity(0.9),
                                    shape: StadiumBorder(),
                                  ),
                                ),
                              ],
                            ):SizedBox(height: 0.0,width: 0.0,),
                          ],
                        ),
                      ),
                      _con.certificationApplicationModel.documents.isEmpty
                          ? SizedBox(height: 0)
                          : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: ListTile(
                          dense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 0),
                          leading: Icon(
                            Icons.folder,
                            color: Theme.of(context).hintColor,
                          ),
                          title: Text(
                            "documents",
                            style: Theme.of(context).textTheme.headline4,
                          ),
                        ),
                      ),
                      _con.certificationApplicationModel.documents.isEmpty
                          ? SizedBox(height: 0)
                          : ListView.separated(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        primary: false,
                        itemCount: _con.certificationApplicationModel.documents.length,
                        separatorBuilder: (context, index) {
                          return SizedBox(height: 10);
                        },
                        itemBuilder: (context, index) {
                          return DocumentItemDownload(
                            heroTag: 'details_featured_product',
                            productOrder:_con. certificationApplicationModel.documents[index],
                            applicationModel: _con.certificationApplicationModel,
                          );
                        },
                      ),
                      SizedBox(height: 100),
                      // _con.reviews.isEmpty
                      //     ? SizedBox(height: 5)
                      //     : Padding(
                      //   padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      //   child: ListTile(
                      //     dense: true,
                      //     contentPadding: EdgeInsets.symmetric(vertical: 0),
                      //     leading: Icon(
                      //       Icons.recent_actors,
                      //       color: Theme.of(context).hintColor,
                      //     ),
                      //     title: Text(
                      //       S.of(context).what_they_say,
                      //       style: Theme.of(context).textTheme.headline4,
                      //     ),
                      //   ),
                      // ),
                      // _con.reviews.isEmpty
                      //     ? SizedBox(height: 5)
                      //     : Padding(
                      //   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      //   child: ReviewsListWidget(reviewsList: _con.reviews),
                      // ),
                    ],
                  ),
                ),
              ],
            ),
            // Positioned(
            //   top: 32,
            //   right: 20,
            //   child: ShoppingCartFloatButtonWidget(
            //       iconColor: Theme.of(context).primaryColor,
            //       labelColor: Theme.of(context).hintColor,
            //       routeArgument: RouteArgument(id: '0', param: _con.market.id, heroTag: 'home_slide')),
            // ),
          ],
        )

    );
  }

  void _launchURL(String _url) async =>
      await canLaunch(_url)
          ? await launch(_url)
          : throw 'Could not launch $_url';


  getTime(){
    DateTime parseDate = new DateFormat("yyyy-MM-dd").parse(
        _con.certificationApplicationModel.date);

    var formatter = new DateFormat("yyyy-MM-ddTHH:mm:ssZ");

    DateTime meetingTime = formatter.parse(
        _con. certificationApplicationModel.zoom.start_time);

    var weekday = DateFormat('EEEE').format(parseDate);
    var time = DateFormat('HH:mm').format(meetingTime);

    return time??_con.certificationApplicationModel.zoom.start_time;

  }


  Widget Body(){


    return Padding(
      padding: const EdgeInsets.symmetric(horizontal:15.0),
      child: SingleChildScrollView(

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            SizedBox(height: 30,),
            Row(children: [
              Container(
                height: 60,width: 60,
                decoration: BoxDecoration(
                    color: _con.getColor(),
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.2),
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(10))
                ),
                child: Center(child: Text(_con.certificationApplicationModel.id.toString(),style: TextStyle(color: Colors.white,fontSize: 15.0,fontWeight: FontWeight.bold),)),
              ),  SizedBox(width: 30,),

              Expanded(

                child: Container(

                  height: 60,
                  decoration: BoxDecoration(
                      color: Colors.white,

                      border: Border.all(
                        color: Colors.grey.withOpacity(0.2),

                      ),
                      borderRadius: BorderRadius.all(Radius.circular(10))
                  ),
                  child: ListTile(


                    title: Text("Status",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 12.0),),

                    subtitle: Text(_con.certificationApplicationModel.status.status,style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 10.0),),

                  ),
                ),
              )
            ],),
            SizedBox(height: 15,),
            Container(
              // height: 100,
              decoration: BoxDecoration(
                  color: Colors.white,

                  border: Border.all(
                    color: Colors.grey.withOpacity(0.2),

                  ),
                  borderRadius: BorderRadius.all(Radius.circular(10))
              ),
              child: Column(
                children: [


                  ListTile(

                    title: Text("Description",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 12.0),),

                    subtitle: Text( _con.certificationApplicationModel.status?.client_explanation??''
                      ,style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 10.0),),
                  ),
                  ListTile(

                    title: Text("Posted On",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 12.0),),

                    subtitle: Text(_con.certificationApplicationModel.getPostDate(),style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 10.0),),
                  ),

                  ListTile(

                    title: Text("Amount paid",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 10.0),),

                    subtitle: Text(   Helper.TotalPayPrice(_con.certificationApplicationModel)
                      ,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 12.0),),
                  ),
                ],
              ),
            ),

            SizedBox(height: 15,),
            DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  Container(
                    height: 60,
                    decoration: BoxDecoration(
                        color: Colors.white,

                        border: Border.all(
                          color: Colors.grey.withOpacity(0.2),

                        ),
                        borderRadius: BorderRadius.all(Radius.circular(10))
                    ),

                    child: TabBar(
                      indicatorColor: Theme.of(context).accentColor,
                      indicatorWeight: 3.0,
                      isScrollable: false,
                      labelStyle: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 15.0),
                      tabs: [
                        // Tab(text: "Details",),
                        Tab(text:"Commissioner"),
                        Tab(text: "Documents",),
                      ],

                    ),

                  ),

                  Container(
                    height: MediaQuery.of(context).size.height*0.4,
                    child: TabBarView(
                      children: [
                        Commisioner(),
                        Documents(),
                      ],
                    ),
                  )
                ],
              ),
            )

          ],),
      ),
    );
  }


  Commisioner(){

    return  Padding(
      padding: const EdgeInsets.symmetric(horizontal:15.0),
      child: Column(children: [


        SizedBox(height: 30,),

        Center(child: Text("Commissioner of Oaths Details",style: TextStyle(color: Colors.black,fontSize: 12.0,fontWeight: FontWeight.bold),)),

        SizedBox(height: 30,),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: [

            Text("Name",style: TextStyle(fontSize: 12.0,fontWeight: FontWeight.bold,color: Colors.black),),Text(_con.certificationApplicationModel.sertifyer.getFullname(),style: TextStyle(fontSize: 12.0,fontWeight: FontWeight.bold),),

          ],),
        SizedBox(height: 30,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: [

            Text("Email",style: TextStyle(fontSize: 12.0,fontWeight: FontWeight.bold,color: Colors.black),),Text(_con.certificationApplicationModel.sertifyer.mobile,style: TextStyle(fontSize: 12.0,fontWeight: FontWeight.bold),),

          ],),
        SizedBox(height: 30,),

        _con.certificationApplicationModel.sertifyer.sertifyerApplication!=null?
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: [

            Text("Authorisation Number",style: TextStyle(fontSize: 12.0,fontWeight: FontWeight.bold,color: Colors.black),),Text(_con.certificationApplicationModel.sertifyer.sertifyerApplication?.auth_number??"",style: TextStyle(fontSize: 12.0,fontWeight: FontWeight.bold),),

          ],):      SizedBox(height: 0,width: 0,),
      ],),
    );
  }
  Documents(){

    return  Column(
      children: [
        SizedBox(height: 10,),
        Container(
          height: MediaQuery.of(context).size.height*0.28,
          width: double.infinity,
          decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey.withOpacity(0.1),

              ),
              borderRadius: BorderRadius.all(Radius.circular(15))
          ),

          child:  ListView.builder(
              itemCount: _con.certificationApplicationModel.documents.length,
              itemBuilder: (BuildContext context,int index){
                return 1==1?DocumentItemDownload(
                  heroTag: 'details_featured_product',
                  color: _con.getColor(),
                  productOrder:_con. certificationApplicationModel.documents[index],
                  applicationModel: _con.certificationApplicationModel,
                ):Container(

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
                              color: _con.getColor(),
                              border: Border.all(
                                color: Colors.grey.withOpacity(0.1),

                              ),
                              borderRadius: BorderRadius.all(Radius.circular(5))
                          ),
                          child: Center(child: Text(_con.certificationApplicationModel.documents[index].path.split('.').last.toUpperCase(),style: TextStyle(color: Colors.white,fontSize: 10.0,fontWeight: FontWeight.bold),)),
                        ),
                      ),
                    ),
                    title:Text(_con.certificationApplicationModel.documents[index].documentTypeModel.type,style: TextStyle(color: Colors.black,fontSize: 15.0,fontWeight: FontWeight.bold),),
                    trailing:  Text("Open",style: TextStyle(color: Colors.black,fontSize: 10,fontWeight: FontWeight.bold),),


                    subtitle:  Text(_con.certificationApplicationModel.documents[index].documentTypeModel.country.currency+_con.certificationApplicationModel.documents[index].documentTypeModel.price,style: TextStyle(color: Colors.black,fontSize: 10,fontWeight: FontWeight.bold),),

                  ),
                );
              }
          ),
        ),
      ],
    );
  }
}
