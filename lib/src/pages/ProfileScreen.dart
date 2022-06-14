import 'package:flutter/material.dart';
import 'package:horizon/src/pages/profile.dart';

class ProfileScreen extends StatefulWidget {

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
backgroundColor: Colors.white,

      body: ProfileWidget(),
    );
  }
}
