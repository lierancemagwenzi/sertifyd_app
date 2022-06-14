import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:horizon/testing/pages1/Register.dart';


class LoginPage1 extends StatefulWidget {

  @override
  _LoginPage1State createState() => _LoginPage1State();
}

class _LoginPage1State extends State<LoginPage1> {

  double height;
  double width;

  @override
  Widget build(BuildContext context) {

    height=MediaQuery.of(context).size.height;
    width=MediaQuery.of(context).size.width;


    return Scaffold(

body: Stack(
  children: [
        Column(children: [

      Stack(
        children: [
          Container(
            height: height*0.4,
            width: width,
            decoration: new BoxDecoration(
                color: Color(0xff0562a7),
               image: DecorationImage(image: AssetImage("assets/images/sky.jpeg"),fit: BoxFit.cover)
            ),


          ),

          Container(
            height: height*0.4,
            width: width,
            decoration: new BoxDecoration(
                color: Color(0xff0562a7).withOpacity(0.6),

            ),


          ),

         Positioned(child: HeaderText(),top: height*0.1,left: 20.0, )

        ],
      ),
      Expanded(child: Container(

        color: Colors.white,
        width: width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [


          _divider(),

            InkWell(


              onTap: (){

                Navigator.pushReplacement(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => RegisterScreen(
                        )));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account ?",style: Theme.of(context).textTheme.headline6.copyWith(color: Color(0xffa4a7a6),fontSize: 14.0),),
                  SizedBox(width: 10.0,),
                  Text("Sign Up",style: Theme.of(context).textTheme.headline6.copyWith(color: Color(0xff2eafe1),fontSize: 14.0,fontWeight: FontWeight.bold),),
                ],
              ),
            ),
SizedBox(height: 40.0,)

        ],),
      ))

    ],),

    Align(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              // height: height*0.4,
              child: Stack(
                children: [
                  Card(
                    elevation: 10.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Container(

                      // height: height*0.45,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(children: [

                          Row(
                            children: [
                              Text("Login",style: Theme.of(context).textTheme.headline5.copyWith(color:  Color(0xff2eafe1),fontWeight: FontWeight.bold),),
                            ],
                          ),
                          SizedBox(height: 10,),
SizedBox(height: 10.0,),
                          TextInput("+27820000000", Icon(
                            Icons.phone,
                            color: Color(0xffa4a7a6),
                          ), true),
                          SizedBox(height: 30.0,),

TextInput("****************", Icon(
  Icons.lock,
  color: Color(0xffa4a7a6),
), true),

                          SizedBox(height: 20,),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [   Text("Forgot Password?",style: Theme.of(context).textTheme.headline6.copyWith(color: Color(0xff2eafe1),fontSize: 14.0),),],),
                          SizedBox(height: 20,),
                          _submitButton(),

                          SizedBox(height: 20,),
                        ],),
                      ),
                    ),

                  ),
    //           Positioned(
    //       bottom: 0.0,left: 0.0,right: 0.0,
    //             child: Row(
    //               mainAxisAlignment: MainAxisAlignment.center,
    //               children: [
    //                 Center(
    //                   child: Container(
    // width: 100.0,
    // height: 100.0,
    // decoration: BoxDecoration(
    // color: Colors.white,
    // shape: BoxShape.circle
    // ),
    //                     child: Center(
    //                       child: Container(
    //                         width: 80.0,
    //                           height: 80.0,
    //                           decoration: BoxDecoration(
    //                               color: Color(0xff2eafe1),
    //                               shape: BoxShape.circle
    //                           ),child: Icon(Icons.arrow_forward,size: 50.0,color: Colors.white,),
    //                       ),
    //                     ),
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           )
                ],
              ),
            ),
          ],
        ),
      ),
    )
  ],
),

    );
  }

  HeaderText() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal:8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text("Welcome Back",style: Theme.of(context).textTheme.headline5.copyWith(color:  Color(0xff2eafe1),fontWeight: FontWeight.bold),),
            ],
          ),
          SizedBox(height: 10,),
          Row(
            children: [
              Text("Sign In to continue",style: Theme.of(context).textTheme.headline5.copyWith(color:  Colors.white,fontWeight: FontWeight.normal,fontSize: 14.0),),
            ],
          ),
        ],),
    );
  }

  Widget _divider() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
                color: Colors.grey,
              ),
            ),
          ),
          Text('or'),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
                color: Colors.grey,

              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }


  Widget _submitButton() {
    return InkWell(

      onTap: (){

      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(15)),
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
                colors: [Color(0xff0562a7),Color(0xff0562a7)])),
        child: Text(
          'Sign In',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }


  TextInput(String hint,Icon prefix,bool ispassword){
    return    TextFormField(
      obscureText: ispassword,
      decoration: InputDecoration(
          prefixIcon: prefix,
          border: OutlineInputBorder(
            // width: 0.0 produces a thin "hairline" border
              borderRadius: BorderRadius.all(Radius.circular(90.0)),
              borderSide: BorderSide(color: Color(0xffa4a7a6))
            //borderSide: const BorderSide(),
          ),
          enabledBorder: OutlineInputBorder(
// width: 0.0 produces a thin "hairline" border
              borderRadius: BorderRadius.all(Radius.circular(90.0)),
              borderSide: BorderSide(color: Color(0xffa4a7a6))
            //borderSide: const BorderSide(),
          ),
          focusedBorder: OutlineInputBorder(
            // width: 0.0 produces a thin "hairline" border
              borderRadius: BorderRadius.all(Radius.circular(90.0)),
              borderSide: BorderSide(color: Color(0xffa4a7a6))
            //borderSide: const BorderSide(),
          ),
          hintStyle: TextStyle(color: Color(0xffa4a7a6),fontFamily: "WorkSansLight"),
          filled: true,
          fillColor: Colors.white24,
          hintText: hint),
    );
  }



}
