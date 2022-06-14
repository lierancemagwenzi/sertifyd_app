import 'package:flutter/material.dart';
import 'package:horizon/src/controllers/ChatHelperController.dart';
import 'package:horizon/src/helper/Helper.dart';
import 'package:horizon/src/helper/light_color.dart';
import 'package:horizon/src/model/ApplicationModel.dart';
import 'package:horizon/src/model/ChatModel.dart';
import 'package:horizon/src/repositories/chat_repository.dart';
import 'package:horizon/src/repositories/user_repository.dart';
import 'package:intl/intl.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ChatScreen extends StatefulWidget {


  int  id;
  ChatScreen({Key key, this.id}) : super(key: key);


  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends StateMVC<ChatScreen> {
  ScrollController _scrollController=ScrollController();


  ChatHelperController _con;
  _ChatScreenState() : super(ChatHelperController()) {
    _con = controller;


  }

  @override
  void initState() {
_con.listenForApplication(widget.id,_scrollController);
    super.initState();
  }
  var formatter = new DateFormat("yyyy-MM-dd HH:mm:ss");

  TextEditingController _controller=new TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(


        key: _con.scaffoldKey,
        appBar: AppBar(
          title:_con.certificationApplicationModel==null?SizedBox(height: 0,width: 0,): Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
               currentuser.value.id==_con.certificationApplicationModel.sertifyer.id?  _con.certificationApplicationModel.applicant.getFullname(): _con.certificationApplicationModel.sertifyer.getFullname(),
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
        body: _con.certificationApplicationModel==null?Center(child: CircularProgressIndicator()):SafeArea(
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
        )
    )
    ;
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
            controller: _con.controller,
            decoration: InputDecoration(
              contentPadding:
              EdgeInsets.symmetric(horizontal: 10, vertical: 13),
              alignLabelWithHint: true,
              hintText: 'Start with a message...',
              hintStyle: TextStyle(color: Theme.of(context).accentColor,fontSize: 13),
              suffixIcon:
              IconButton(icon: Icon(Icons.send,color: Theme.of(context).accentColor,), onPressed: (){
                _con.SendMessage(new ChatModel(message: _con.controller.text,user_id: currentuser.value.id,receiver_id:getclient(),order_id: _con.certificationApplicationModel.id).toMap(),_scrollController);

                // _con.addMessage(new MessageModel(id: _con.certificationApplicationModel.id,sender: currentuser.value.id==widget.applicationModel.sertifyer.id?widget.applicationModel.sertifyer.getFullname():widget.applicationModel.applicant.getFullname(),receiver: currentuser.value.id==widget.applicationModel.sertifyer.id?widget.applicationModel.applicant.getFullname():widget.applicationModel.sertifyer.getFullname(),message: _controller.text,sender_id: currentuser.value.id,receiver_id:  widget.isadmin==true?_con.certificationApplicationModel.applicant.id:_con.certificationApplicationModel.sertifyer.id,application_id: _con.certificationApplicationModel.id,date: DateTime.now().millisecondsSinceEpoch),_scrollController);
                // _controller.clear();
                double contentHeight = MediaQuery.of(context).size.height > 700 ? MediaQuery.of(context).size.height * 0.89 : MediaQuery.of(context).size.height * 0.85;
              }),
              // fillColor: Colors.black12, filled: true
            ),
          ),
        ],
      ),
    );
  }



  int getclient(){

    if(_con.certificationApplicationModel.sertifyer.id==currentuser.value.id){
      return _con.certificationApplicationModel.applicant_id;
    }
    else{
      return _con.certificationApplicationModel.sertifyer.id;
    }

  }
  Widget _chatScreenBody() {

    return  1==1?ScrollablePositionedList.builder(
      itemCount: messages.value.length,
      itemBuilder: (BuildContext context,int index){

        return chatMessage(messages.value[index]);},
      itemScrollController: _con.itemScrollController,
      itemPositionsListener: _con.itemPositionsListener,
    ):ListView.builder(
      controller: _scrollController,
    itemCount: messages.value.length,
    itemBuilder: (BuildContext context,int index){

    return chatMessage(messages.value[index]);});

  }

  Widget chatMessage(ChatModel message) {
    if (message == null) {
      return Container();
    }
    if (message.user_id == currentuser.value.id)
      return _message(message, true);
    else
      return _message(message, false);
  }

  Widget _message(ChatModel chat, bool myMessage) {

    if(chat.created_at.contains("Z")&&chat.created_at.contains("T")){
     formatter= new DateFormat("yyyy-MM-ddTHH:mm:ssZ");
    }
    else{
      formatter=new DateFormat("yyyy-MM-dd HH:mm:ss");
    }

    DateTime date = formatter.parse(chat.created_at);
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
