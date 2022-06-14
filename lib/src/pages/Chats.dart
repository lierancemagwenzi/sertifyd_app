import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_1.dart';
import 'package:horizon/src/controllers/ChatController.dart';
import 'package:horizon/src/elements/EmptyMessagesWidget.dart';
import 'package:horizon/src/elements/customWidgets.dart';
import 'package:horizon/src/elements/rippleButton.dart';
import 'package:horizon/src/elements/title_text.dart';
import 'package:horizon/src/helper/Helper.dart';
import 'package:horizon/src/helper/light_color.dart';
import 'package:horizon/src/helper/text_styles.dart';
import 'package:horizon/src/model/MessageModel.dart';
import 'package:horizon/src/repositories/global_repository.dart';
import 'package:horizon/src/repositories/settings_repository.dart';
import 'package:horizon/src/repositories/user_repository.dart';
import 'package:intl/intl.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:rxdart/streams.dart';
import 'package:rxdart/rxdart.dart';

class ChatsWidget extends StatefulWidget {

  @override
  _ChatsWidgetState createState() => _ChatsWidgetState();
}

class _ChatsWidgetState extends StateMVC<ChatsWidget> {

  ChatController _con;

  _ChatsWidgetState() : super(ChatController()) {
    _con = controller;
  }

Stream <QuerySnapshot>  chats = FirebaseFirestore.instance.collection('messages').doc("52").collection('chats').orderBy('id',descending: true).snapshots();
  @override
  void initState() {

  _con.listenForChats();
  _con.getchats();
timer = Timer.periodic(Duration(seconds: 15), (Timer t) => _con.getchats());
  Map map={"action":"messages","platform":Platform.isIOS?"ios":"android","user_id":currentuser.value.id??0,"device":detailsModel.value.identifier,"detail":"visited chats",};

  log_activity(map);
print("initstatecalled");

// _timer = Timer.periodic(Duration(minutes: 1), (Timer t) => _con.listenForChats());

    super.initState();
  }

  List<String> data=[];


  Timer timer;


  Timer _timer;

  @override
  void dispose() {
    timer?.cancel();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
key: _con.scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: InkWell(

          onTap: (){

            _con.getchats();

            // _con.listenForChats();
          },
          child: Text(
            "Messages",
            style: Theme.of(context).textTheme.headline6.merge(TextStyle(letterSpacing: 1.3)),
          ),
        ),

      ),
body:_con.conversations.length<1?RefreshIndicator(

  onRefresh: ()async{
    _con.refreshChats();
  },
  child: ListView(
    children: [
      EmptyMessagesWidget(),
    ],
  ),
):RefreshIndicator(


  onRefresh: ()async{
    _con.refreshChats();
  },

  child:  1==1?_body(): ListView.builder(
      itemCount: _con.conversations.length,
      shrinkWrap: true,
      primary: false,
      itemBuilder: (BuildContext context,int index){

        DateTime date = new DateTime.fromMillisecondsSinceEpoch(_con.conversations[index].date);
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(

            onTap: (){

              _con.findAdminApplication(_con.conversations[index].application_id, context);
              },
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              elevation: 0.0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  trailing:  _con.conversations[index].sender_id==currentuser.value.id? Icon(  _con.conversations[index].read?Icons.done_all_outlined:Icons.done,color: Theme.of(context).accentColor,):null,
                    leading: CircleAvatar(child: Icon(Icons.person,color: Colors.white,),),
  subtitle: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
            Text(_con.conversations[index].message,maxLines: 1,overflow: TextOverflow.ellipsis,),

      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
            Text(getDate(date)),
        ],
      )
    ],
  ), title:Text(_con.conversations[index].receiver_id==currentuser.value.id?_con.conversations[index].sender:_con.conversations[index].receiver,maxLines: 1,)
                ),
              ),
            ),
          ),
        );
      }
  ),
)


    );
  }


  String  getDate(DateTime dateTime){

    final time_f = new DateFormat('hh:mm');
    final f = new DateFormat('yyyy-MM-dd');
    final date_f = new DateFormat('yyyy-MM-dd');

    return f.format(dateTime)==f.format(DateTime.now())?time_f.format(dateTime):DateFormat.yMEd().add_jms().format(dateTime);
  }



  Widget _body() {

    _con.conversations..sort((a, b) => b.date.compareTo(a.date));
    return ListView.separated(
      physics: BouncingScrollPhysics(),
      itemCount: _con.conversations.length,
      itemBuilder: (context, index) => _userCard(
          _con.conversations[index]
      ),
      separatorBuilder: (context, index) {
        return Divider(
          height: 0,
          color:  AppColor.darkGrey.withOpacity(0.6),

        );
      },
    );
  }


  Widget _userCard( MessageModel lastMessage) {
    DateTime date = new DateTime.fromMillisecondsSinceEpoch(lastMessage.date);

    return Container(
      color: lastMessage.receiver_id==currentuser.value.id&&!lastMessage.read?Theme.of(context).scaffoldBackgroundColor:Colors.white,
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 10),
        onTap: () {
          _con.findAdminApplication(lastMessage.application_id, context);

        },
        leading: RippleButton(
          onPressed: () {
            // Navigator.push(
            //     context, ProfilePage.getRoute(profileId: model.userId));
          },
          borderRadius: BorderRadius.circular(28),
          child: Container(
            height: 56,
            width: 56,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 2),
              borderRadius: BorderRadius.circular(28),
              // image: DecorationImage(
              //     image: customAdvanceNetworkImage(
              //       model.profilePic ?? Constants.dummyProfilePic,
              //     ),
              //     fit: BoxFit.cover),
            ),

            child:  CircleAvatar(child: Icon(Icons.person,color: Colors.white,),backgroundColor: Theme.of(context).dividerColor),
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: TitleText(
                lastMessage.receiver_id==currentuser.value.id?lastMessage.sender:lastMessage.receiver,
                fontSize: 16,
                fontWeight: FontWeight.w800,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            lastMessage.sender_id==currentuser.value.id?Container(

              decoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle
              ),
                child: Center(child: (Icon(lastMessage.read?Icons.done_all:Icons.done,size: 13.0,color:Colors.white,)))):SizedBox(height: 0,width: 0,)

          ],
        ),
        subtitle: customText(
          getLastMessage(lastMessage.message) ?? '@${lastMessage.sender}',
          style:
          TextStyles.onPrimarySubTitleText.copyWith(color: Colors.black54),
        ),
        trailing: lastMessage == null
            ? SizedBox.shrink()
            : Text(
          Helper.getChatTime(date))


      ),
    );
  }

  String getLastMessage(String message) {
    if (message != null && message.isNotEmpty) {
      if (message.length > 100) {
        message = message.substring(0, 80) + '...';
        return message;
      } else {
        return message;
      }
    }
    return null;
  }
}
