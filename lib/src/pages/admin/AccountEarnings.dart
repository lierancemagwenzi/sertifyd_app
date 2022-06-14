import 'package:flutter/material.dart';
import 'package:horizon/src/pages/admin/Earnings.dart';

import 'PeriodsWidget.dart';

class AccountEarnings extends StatefulWidget {

  @override
  _AccountEarningsState createState() => _AccountEarningsState();
}

class _AccountEarningsState extends State<AccountEarnings> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(

          title: Text("Earnings",style: TextStyle(color: Colors.white,fontSize: 14.0,fontWeight: FontWeight.bold),),
          bottom: TabBar(
            labelStyle: TextStyle(color: Colors.white),
            unselectedLabelColor: Colors.black,
isScrollable: false,
            labelColor: Colors.white,
            tabs: [
              Tab(text: "Completed Orders",),
              Tab(text: "Earnings",),
            ],
          ),
        ),

          body: TabBarView(
            children: [
              PeriodsWidget(),
             EarningsWidget()
            ],
          )
      ),
    );
  }
}
