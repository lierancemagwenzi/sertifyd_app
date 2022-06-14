import 'package:flutter/material.dart';
import 'package:horizon/src/controllers/ChatHelperController.dart';
import 'package:horizon/src/elements/EmptyMessagesWidget.dart';
import 'package:horizon/src/elements/customWidgets.dart';
import 'package:horizon/src/elements/rippleButton.dart';
import 'package:horizon/src/elements/title_text.dart';
import 'package:horizon/src/helper/Helper.dart';
import 'package:horizon/src/helper/light_color.dart';
import 'package:horizon/src/helper/text_styles.dart';
import 'package:horizon/src/model/ChatModel.dart';
import 'package:horizon/src/repositories/user_repository.dart';
import 'package:intl/intl.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

class ChatsScreen extends StatefulWidget {

  @override
  _ChatsScreenState createState() => _ChatsScreenState();
}

class _ChatsScreenState extends StateMVC<ChatsScreen> {



  ChatHelperController _con;
  _ChatsScreenState() : super(ChatHelperController()) {
    _con = controller;


  }

  var formatter = new DateFormat("yyyy-MM-dd HH:mm:ss");


  @override
  void initState() {


_con.listenforAllchats();
    super.initState();
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


            // _con.listenForChats();
          },
          child: Text(
            "Messages",
            style: Theme.of(context).textTheme.headline6.merge(TextStyle(letterSpacing: 1.3)),
          ),
        ),

      ),

  body:  _con.conversations.length<1?RefreshIndicator(

    onRefresh: ()async{
    _con.listenforAllchats();
    },
    child: ListView(
    children: [
    EmptyMessagesWidget(),
    ],
    ),
    ):RefreshIndicator(


    onRefresh: ()async{
_con.listenforAllchats();    },

    child: _body()
    ));
  }

  String  getDate(DateTime dateTime){

    final time_f = new DateFormat('hh:mm');
    final f = new DateFormat('yyyy-MM-dd');
    final date_f = new DateFormat('yyyy-MM-dd');

    return f.format(dateTime)==f.format(DateTime.now())?time_f.format(dateTime):DateFormat.yMEd().add_jms().format(dateTime);
  }



  Widget _body() {

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


  Widget _userCard( ChatModel lastMessage) {
    if(lastMessage.created_at.contains("Z")&&lastMessage.created_at.contains("T")){
      formatter= new DateFormat("yyyy-MM-ddTHH:mm:ssZ");
    }
    else{
      formatter=new DateFormat("yyyy-MM-dd HH:mm:ss");
    }
    DateTime date = formatter.parse(lastMessage.created_at);

    return Container(
      color: lastMessage.receiver_id==currentuser.value.id?Theme.of(context).scaffoldBackgroundColor:Colors.white,
      child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 10),
          onTap: () {

            Navigator.pushNamed(context, '/Messaging',arguments: lastMessage.order_id);
            // _con.findAdminApplication(lastMessage.application_id, context);

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
                  lastMessage.receiver_id==currentuser.value.id?lastMessage.from:lastMessage.to,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  overflow: TextOverflow.ellipsis,
                ),
              ),


            ],
          ),
          subtitle: customText(
            getLastMessage(lastMessage.message) ?? '@${lastMessage.created_at}',
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
