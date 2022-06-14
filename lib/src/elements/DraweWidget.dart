import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:horizon/src/model/UserModel.dart';
import 'package:horizon/src/pages/SertifyerApplication.dart';
import 'package:horizon/src/repositories/user_repository.dart';

import 'package:shared_preferences/shared_preferences.dart';

class DrawerWidget extends StatefulWidget {

  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {

  SharedPreferences prefrences;
double height;

  getPreferences() async {

    prefrences = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    getPreferences();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    height=MediaQuery.of(context).size.height;

    return Drawer(


child: ListView(
  children: [
    currentuser.value.id==0?Center(child: Container(
height: height*0.2,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).accentColor,
          // image: DecorationImage(
          //     fit: BoxFit.fill,
          //     image: AssetImage('assets/images/profile-bg.jpeg')
          // ),
        ),

        child: Center(child: Text("Sign In",style: Theme.of(context).textTheme.headline5.copyWith(color: Colors.white),)))):  UserAccountsDrawerHeader(
      accountName: Text(currentuser.value.getFullname()??'',style: Theme.of(context).textTheme.headline5.copyWith(color: Colors.white)),
      accountEmail: Text(currentuser.value.mobile??'',style: Theme.of(context).textTheme.headline5.copyWith(color: Colors.white,fontSize: 14.0),),
      currentAccountPicture: CircleAvatar(
        backgroundColor: Theme.of(context).primaryColorLight,
        child: ClipOval(

          child: Image.network(
            '',
            fit: BoxFit.cover,
            width: 90,
            height: 90,
          ),
        ),
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).accentColor,
        // image: DecorationImage(
        //     fit: BoxFit.fill,
        //     image: AssetImage('assets/images/profile-bg.jpeg')
        // ),
      ),
    ),
  currentuser.value.role!=null&& currentuser.value.role.name=='client'? Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
          ),
          borderRadius: BorderRadius.all(Radius.circular(5))
      ),
      child: ListTile(
          // leading: Icon(Icons.admin_panel_settings),
          title: Text('Become A Sertifyer'.toUpperCase(),style: TextStyle(color: Colors.black87,fontWeight:   FontWeight.bold)),
          subtitle: Text("Click to fill application",style: TextStyle(color: Colors.black87,fontWeight:   FontWeight.normal,fontSize: 14.0)),
          onTap: () async {
            await  Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (context) => SertifyerApplication(

                    )));
          },
        ),
    ),
  ):currentuser.value.role!=null&& currentuser.value.role.name=='Pending Sertifyer'?
  Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
          ),
          borderRadius: BorderRadius.all(Radius.circular(5))
      ),
      child: ListTile(
        title:Text(currentuser.value.role.name.toUpperCase(),style: TextStyle(color: Colors.black87,fontWeight:   FontWeight.bold)) ,
      ),
    ),
  ):


  Container(height: 0,width: 0,),
    ListTile(
      leading: Icon(Icons.home_filled),
      title: Text('Home',style: Theme.of(context).textTheme.headline5.copyWith(color: Colors.black87.withOpacity(0.5))),
      onTap: () {
        Navigator.pushNamed(context, '/Pages',arguments: 2);

      },
    ),
    ListTile(
      leading: Icon(Icons.person),
      title: Text('Account',style: Theme.of(context).textTheme.headline5.copyWith(color: Colors.black87.withOpacity(0.5)),),

      onTap: () => null,
    ),

    ListTile(
      leading: Icon(Icons.notifications),
      title: Text('Notifications',style: Theme.of(context).textTheme.headline5.copyWith(color: Colors.black87.withOpacity(0.5))),
    ),
    Divider(),
    ListTile(
      leading: Icon(Icons.settings),
      title: Text('Settings',style: Theme.of(context).textTheme.headline5.copyWith(color: Colors.black87.withOpacity(0.5))),
      onTap: () => null,
    ),

    Divider(color: Colors.grey,),
    ListTile(
      leading: Icon(Icons.share),
      title: Text('Share',style: Theme.of(context).textTheme.headline5.copyWith(color: Colors.black87.withOpacity(0.5))),
      onTap: () => null,
    ),
    ListTile(
      title: Text(   currentuser.value.id==0?'Sign In':'Logout',style: Theme.of(context).textTheme.headline5.copyWith(color: Colors.black87.withOpacity(0.5))),
      leading: Icon(Icons.logout),
      onTap: () {
        if(currentuser.value.id==0){
          Navigator.pushNamed(context, '/Login');
        }

        else{
          setState(() {
            currentuser.value=new UserModel(id: 0);
          });
          return prefrences.remove("logged_in");
        }


      },
    ),

  ],
),

    );
  }
}
