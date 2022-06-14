import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_1.dart';
import 'package:horizon/src/controllers/ChatController.dart';
import 'package:horizon/src/helper/Helper.dart';
import 'package:horizon/src/helper/light_color.dart';
import 'package:horizon/src/model/ApplicationModel.dart';
import 'package:horizon/src/model/MessageModel.dart';
import 'package:horizon/src/repositories/global_repository.dart';
import 'package:horizon/src/repositories/settings_repository.dart';
import 'package:horizon/src/repositories/user_repository.dart';
import 'package:intl/intl.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class MessagingWidget extends StatefulWidget {

  CertificationApplicationModel applicationModel;

  bool isadmin;

  MessagingWidget({Key key, this.applicationModel,this.isadmin}) : super(key: key);

  @override
  _MessagingWidgetState createState() => _MessagingWidgetState();
}

class _MessagingWidgetState extends StateMVC<MessagingWidget> {

  ChatController _con;

  _MessagingWidgetState() : super(ChatController()) {
    _con = controller;
  }

  @override
  void initState() {

    _con.certificationApplicationModel=widget.applicationModel;

    Map map={"action":"chat","platform":Platform.isIOS?"ios":"android","user_id":currentuser.value.id??0,"device":detailsModel.value.identifier,"detail":"chat","action_id":widget.applicationModel.id};

    log_activity(map);
    super.initState();
  }
  ScrollController _scrollController=ScrollController();

int length=0;
  TextEditingController _controller=new TextEditingController();

  @override
  Widget build1(BuildContext context) {
    return Scaffold(
resizeToAvoidBottomInset: true,
        bottomNavigationBar: BottomAppBar(child: SafeArea(child:Container(
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            boxShadow: [BoxShadow(color: Theme.of(context).hintColor.withOpacity(0.10), offset: Offset(0, -4), blurRadius: 10)],
          ),
          child: TextField(
            controller: _controller,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(20),
              hintText:"Type to start Chat",
              hintStyle: TextStyle(color: Theme.of(context).focusColor.withOpacity(0.8)),
              suffixIcon: IconButton(
                padding: EdgeInsets.only(right: 30),
                onPressed: () {
                  _con.addMessage(new MessageModel(id: _con.certificationApplicationModel.id,sender: currentuser.value.id==widget.applicationModel.sertifyer.id?widget.applicationModel.sertifyer.getFullname():widget.applicationModel.applicant.getFullname(),receiver: currentuser.value.id==widget.applicationModel.sertifyer.id?widget.applicationModel.applicant.getFullname():widget.applicationModel.sertifyer.getFullname(),message: _controller.text,sender_id: currentuser.value.id,receiver_id:  widget.isadmin==true?_con.certificationApplicationModel.applicant.id:_con.certificationApplicationModel.sertifyer.id,application_id: _con.certificationApplicationModel.id,date: DateTime.now().millisecondsSinceEpoch),_scrollController);
                  _controller.clear();
                  double contentHeight = MediaQuery.of(context).size.height > 700 ? MediaQuery.of(context).size.height * 0.89 : MediaQuery.of(context).size.height * 0.85;

                  // _scrollController.jumpTo(length * contentHeight);
                },
                icon: Icon(
                  Icons.send,
                  color: Theme.of(context).accentColor,
                  size: 30,
                ),
              ),
              border: UnderlineInputBorder(borderSide: BorderSide.none),
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide.none),
            ),
          ),
        ),
        ),),
      appBar: AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back_ios, color: Theme.of(context).hintColor),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        // actions: [
        //
        //
        //   CircleAvatar(
        //
        //     backgroundImage: NetworkImage(widget.applicationModel.applicant.getProfilePic()),
        //   )
        // ],
        centerTitle: true,
        title: Text(
        widget.isadmin==true?  widget.applicationModel.applicant.getFullname(): widget.applicationModel.sertifyer.getFullname(),
          style: Theme.of(context).textTheme.headline6.merge(TextStyle(letterSpacing: 1.3)),
        ),

      ),
      body: MessagesBody(),
    );
  }


 String  getDate(DateTime dateTime){

    final time_f = new DateFormat('hh:mm');
    final f = new DateFormat('yyyy-MM-dd');
    final date_f = new DateFormat('yyyy-MM-dd');

    return f.format(dateTime)==f.format(DateTime.now())?time_f.format(dateTime):DateFormat.yMEd().add_jms().format(dateTime);
  }

  MessagesBody(

      ){

    var users = FirebaseFirestore.instance.collection('messages').doc(_con.certificationApplicationModel.id.toString()).collection("chats").orderBy('date',descending: false).snapshots();



    return StreamBuilder<QuerySnapshot>(
      stream: users,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }
        scroll();
        return new ListView(
          controller:_scrollController ,
          children: snapshot.data.docs.map((DocumentSnapshot document) {
            MessageModel message=new MessageModel.fromJson(document.data());

            if(message.receiver_id==currentuser.value.id&&message.read==false){

               _con.UpdateMessage(document.id,{"read":true});
            }

          length=  snapshot.data.docs.length;


            DateTime date = new DateTime.fromMillisecondsSinceEpoch(message.date);
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: message.sender_id==currentuser.value.id? ChatBubble(
                clipper: ChatBubbleClipper1(type: BubbleType.sendBubble),
                alignment: Alignment.topRight,
                margin: EdgeInsets.only(top: 20),
                backGroundColor: Theme.of(context).accentColor,
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.7,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        message.message,
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(height: 10.0,),
                      Text(
                        getDate(date),
                        style: TextStyle(color: Colors.white.withOpacity(0.6),fontSize: 13.0),
                      ),
                      Icon(message.read?Icons.done_all_outlined:Icons.done,color: Colors.white,)
                    ],
                  ),
                ),
              ) :
              ChatBubble(
                clipper: ChatBubbleClipper1(type: BubbleType.receiverBubble),
                backGroundColor: Theme.of(context).primaryColorLight,
                margin: EdgeInsets.only(top: 20),
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.7,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        message.message,
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(height: 10.0,),
                      Text(
                        getDate(date),
                        style: TextStyle(color: Colors.white.withOpacity(0.6),fontSize: 13.0),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }


  body(MessageModel messageModel){

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: messageModel.sender_id==currentuser.value.id? ChatBubble(
          clipper: ChatBubbleClipper1(type: BubbleType.sendBubble),
          alignment: Alignment.topRight,
          margin: EdgeInsets.only(top: 20),
          backGroundColor: Colors.blue,
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7,
            ),
            child: Text(
              messageModel.message,
              style: TextStyle(color: Colors.white),
            ),
          ),
        )
        :
        ChatBubble(
          clipper: ChatBubbleClipper1(type: BubbleType.receiverBubble),
          backGroundColor: Color(0xffE7E7ED),
          margin: EdgeInsets.only(top: 20),
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7,
            ),
            child: Text(
         messageModel.message,
              style: TextStyle(color: Colors.black),
            ),
          ),
        ),
    );
  }

 scroll(){

   SchedulerBinding.instance.addPostFrameCallback((_) {
     _scrollController.animateTo(
       _scrollController.position.maxScrollExtent,
       duration: const Duration(milliseconds: 100),
       curve: Curves.ease,
     );
   });
 }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: _con.scaffoldKey,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              widget.isadmin==true?  widget.applicationModel.applicant.getFullname(): widget.applicationModel.sertifyer.getFullname(),
              style: TextStyle(color: AppColor.darkGrey, fontSize: 15),
            ),
            Text("@ Order"+_con.certificationApplicationModel.id.toString(),style: TextStyle(color: AppColor.darkGrey, fontSize: 13))
          ],
        ),
        iconTheme: IconThemeData(color: Colors.blue),
        backgroundColor: Colors.white,
        // actions: <Widget>[
        //   IconButton(
        //       icon: Icon(Icons.info, color: AppColor.primary),
        //       onPressed: () {
        //         Navigator.pushNamed(context, '/ConversationInformation');
        //       })
        // ],
      ),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: EdgeInsets.only(bottom: 50),
                child: _chatScreenBody(),
              ),
            ),
            _bottomEntryField()
          ],
        ),
      ),
    );
  }


  BorderRadius getBorder(bool myMessage) {
    return BorderRadius.only(
      topLeft: Radius.circular(20),
      topRight: Radius.circular(20),
      bottomRight: myMessage ? Radius.circular(0) : Radius.circular(20),
      bottomLeft: myMessage ? Radius.circular(20) : Radius.circular(0),
    );
  }

  Widget _bottomEntryField() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Divider(
            thickness: 0,
            height: 1,
          ),
          TextField(
            onSubmitted: (val) async {
            },
            controller: _controller,
            decoration: InputDecoration(
              contentPadding:
              EdgeInsets.symmetric(horizontal: 10, vertical: 13),
              alignLabelWithHint: true,
              hintText: 'Start with a message...',
              suffixIcon:
              IconButton(icon: Icon(Icons.send,color: Theme.of(context).accentColor,), onPressed: (){

                _con.addMessage(new MessageModel(id: _con.certificationApplicationModel.id,sender: currentuser.value.id==widget.applicationModel.sertifyer.id?widget.applicationModel.sertifyer.getFullname():widget.applicationModel.applicant.getFullname(),receiver: currentuser.value.id==widget.applicationModel.sertifyer.id?widget.applicationModel.applicant.getFullname():widget.applicationModel.sertifyer.getFullname(),message: _controller.text,sender_id: currentuser.value.id,receiver_id:  widget.isadmin==true?_con.certificationApplicationModel.applicant.id:_con.certificationApplicationModel.sertifyer.id,application_id: _con.certificationApplicationModel.id,date: DateTime.now().millisecondsSinceEpoch),_scrollController);
                _controller.clear();
                double contentHeight = MediaQuery.of(context).size.height > 700 ? MediaQuery.of(context).size.height * 0.89 : MediaQuery.of(context).size.height * 0.85;
              }),
              // fillColor: Colors.black12, filled: true
            ),
          ),
        ],
      ),
    );
  }







  Widget _chatScreenBody() {

    var users = FirebaseFirestore.instance.collection('messages').doc(_con.certificationApplicationModel.id.toString()).collection("chats").orderBy('date',descending: false).snapshots();

    return StreamBuilder<QuerySnapshot>(
        stream: users,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Text(
                'No message found',
                style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
              ),
            );
          }
          scroll();

         return ListView(
           controller:_scrollController ,
           children: snapshot.data.docs.map((DocumentSnapshot document) {
             MessageModel message=new MessageModel.fromJson(document.data());

             if(message.receiver_id==currentuser.value.id&&message.read==false){

               _con.UpdateMessage(document.id,{"read":true});
             }

             length=  snapshot.data.docs.length;


             DateTime date = new DateTime.fromMillisecondsSinceEpoch(message.date);

             return Padding(
               padding: const EdgeInsets.all(8.0),
               child: chatMessage(message)
             );
           }).toList(),
         );


        });

  }

  Widget chatMessage(MessageModel message) {
    if (message == null) {
      return Container();
    }
    if (message.sender_id == currentuser.value.id)
      return _message(message, true);
    else
      return _message(message, false);
  }

  Widget _message(MessageModel chat, bool myMessage) {
    DateTime date = new DateTime.fromMillisecondsSinceEpoch(chat.date);

    return Column(
      crossAxisAlignment:
      myMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      mainAxisAlignment:
      myMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            SizedBox(
              width: 15,
            ),
            myMessage
                ? SizedBox()
                : CircleAvatar(
              backgroundColor: Colors.transparent,
              // backgroundImage: customAdvanceNetworkImage(userImage),
            ),
            Expanded(
              child: Container(
                alignment:
                myMessage ? Alignment.centerRight : Alignment.centerLeft,
                margin: EdgeInsets.only(
                  right: myMessage ? 10 : (MediaQuery.of(context).size.width / 4),
                  top: 20,
                  left: myMessage ? (MediaQuery.of(context).size.width / 4) : 10,
                ),
                child: Stack(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: getBorder(myMessage),
                        color: myMessage
                            ? TwitterColor.dodgetBlue
                            : TwitterColor.mystic,
                      ),
                      child: Text(
                       chat.message,
                        style: TextStyle(
                          fontSize: 16,
                          color: myMessage ? TwitterColor.white : Colors.black,
                        ),

                      ),
                    ),


                    // Positioned(
                    //   top: 0,
                    //   bottom: 0,
                    //   right: 0,
                    //   left: 0,
                    //   child: InkWell(
                    //     borderRadius: getBorder(myMessage),
                    //     onLongPress: () {
                    //       var text = ClipboardData(text: chat.message);
                    //       Clipboard.setData(text);
                    //       _scaffoldKey.currentState.hideCurrentSnackBar();
                    //       _scaffoldKey.currentState.showSnackBar(
                    //         SnackBar(
                    //           backgroundColor: TwitterColor.white,
                    //           content: Text(
                    //             'Message copied',
                    //             style: TextStyle(color: Colors.black),
                    //           ),
                    //         ),
                    //       );
                    //     },
                    //     child: SizedBox(),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ],
        ),
      myMessage?  Padding(
          padding: EdgeInsets.only(right: 10, left: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                Helper.getChatTime(date),
                style: Theme.of(context).textTheme.caption.copyWith(fontSize: 12),
              ),
              SizedBox(width: 5,),
              chat.sender_id==currentuser.value.id?Container(

                  decoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle
                  ),
                  child: Center(child: (Icon(chat.read?Icons.done_all:Icons.done,size: 13.0,color:Colors.white,)))):SizedBox(height: 0,width: 0,)
            ],
          ),
        ):Padding(
        padding: EdgeInsets.only(right: 10, left: 10),
        child: Text(
          Helper.getChatTime(date),
          style: Theme.of(context).textTheme.caption.copyWith(fontSize: 12),
        ),
      )
      ],
    );
  }
}
