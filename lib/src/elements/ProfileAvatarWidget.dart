import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:horizon/src/controllers/ProfileController.dart';
import 'package:horizon/src/model/UserModel.dart';
import 'package:horizon/src/pages/SertifyerApplication.dart';
import 'package:horizon/src/repositories/global_repository.dart';
import 'package:horizon/src/repositories/settings_repository.dart';
import 'package:horizon/src/repositories/user_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';



class ProfileAvatarWidget extends StatefulWidget {
  final UserModel user;
  ProfileController profileController;

  ProfileAvatarWidget({
    Key key,
    this.user,this.profileController
  }) : super(key: key);


  @override
  _ProfileAvatarWidgetState createState() => _ProfileAvatarWidgetState();
}

class _ProfileAvatarWidgetState extends State<ProfileAvatarWidget> {

@override
  void initState() {


  Map map={"action":"profile","platform":Platform.isIOS?"ios":"android","user_id":currentuser.value.id??0,"device":detailsModel.value.identifier,"detail":"visited profile",};

  log_activity(map);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 30),
      decoration: BoxDecoration(
        color: Theme.of(context).accentColor,
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
      ),
      child: Column(
        children: <Widget>[
          Container(
            height: 160,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
//              SizedBox(
//                width: 50,
//                height: 50,
//                child: FlatButton(
//                  padding: EdgeInsets.all(0),
//                  onPressed: () {},
//                  child: Icon(Icons.add, color: Theme.of(context).primaryColor),
//                  color: Theme.of(context).accentColor,
//                  shape: StadiumBorder(),
//                ),
//              ),
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(300)),
                  child: CachedNetworkImage(
                    height: 135,
                    width: 135,
                    fit: BoxFit.cover,
                    imageUrl: widget.user.getProfilePic(),
                    placeholder: (context, url) => Image.asset(
                      'assets/images/loading.gif',
                      fit: BoxFit.cover,
                      height: 135,
                      width: 135,
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
//              SizedBox(
//                width: 50,
//                height: 50,
//                child: FlatButton(
//                  padding: EdgeInsets.all(0),
//                  onPressed: () {},
//                  child: Icon(Icons.chat, color: Theme.of(context).primaryColor),
//                  color: Theme.of(context).accentColor,
//                  shape: StadiumBorder(),
//                ),
//              ),
              ],
            ),
          ),
          Text(
            widget.user.getFullname(),
            style: Theme.of(context).textTheme.headline5.merge(TextStyle(color: Theme.of(context).primaryColor)),
          ),
          Text(
            widget.user.mobile,
            style: Theme.of(context).textTheme.caption.merge(TextStyle(color: Theme.of(context).primaryColor)),
          ),
          SizedBox(height: 15.0,),

          currentuser.value.role!=null&& currentuser.value.role.name=='client'? Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: InkWell(
                onTap: () async {
                  await  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => SertifyerApplication(

                          )));
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Become A Commissioner Of Oaths'.toUpperCase(),   style: Theme.of(context).textTheme.headline5.merge(TextStyle(color: Theme.of(context).primaryColor,fontSize: 14))),
                    SizedBox(height: 5.0,),
                    Text("Click to fill application",   style: Theme.of(context).textTheme.caption.merge(TextStyle(color: Theme.of(context).primaryColor)))
                  ],
                ),
              ),
            ),
          ):currentuser.value.role!=null&& currentuser.value.role.name=='Pending Sertifyer'?
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              // decoration: BoxDecoration(
              //     border: Border.all(
              //       color: Colors.grey,
              //     ),
              //     borderRadius: BorderRadius.all(Radius.circular(5))
              // ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Pending Commissioner Of Oaths",style: Theme.of(context).textTheme.headline5.merge(TextStyle(color: Theme.of(context).primaryColor,fontSize: 14)))
                ],
              ),
            ),
          ):



          SizedBox(height: 15.0,),
          InkWell(
            onTap: () async {

              Navigator.pushNamed(context, '/Faq',arguments: 'client');
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: Text(
                  "Help and Support",
                  style: Theme.of(context).textTheme.caption.merge(TextStyle(color: Theme.of(context).primaryColor,fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ),
          SizedBox(height: 8.0,),
          SizedBox(height: 20.0,),
          InkWell(
            onTap: () async {

              widget.profileController.LogoutUser(context);
            },

            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: Text(
                  "Logout",
                  style: Theme.of(context).textTheme.caption.merge(TextStyle(color: Theme.of(context).primaryColor,fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ),
          SizedBox(height: 20.0,),
          InkWell(
            onTap: () async {

              Navigator.pushNamed(context, '/TestDocument');
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: Text(
                  "Verify Document",
                  style: Theme.of(context).textTheme.caption.merge(TextStyle(color: Colors.white,fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }
}
