import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:horizon/testing/pages1/Login.dart';

class RegisterScreen extends StatefulWidget {

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  double height;
  double width;
bool checked=false;
  @override
  Widget build(BuildContext context) {

    height=MediaQuery.of(context).size.height;
    width=MediaQuery.of(context).size.width;


    return Scaffold(

      body: SafeArea(        child: Stack(
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


                ],
              ),
              Expanded(child: Container(

                color: Colors.white,
                width: width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [

                    // _divider(),
                    //
                    // InkWell(
                    //
                    //   onTap: (){
                    //
                    //     Navigator.pushReplacement(
                    //         context,
                    //         CupertinoPageRoute(
                    //             builder: (context) => LoginPage1(
                    //             )));
                    //   },
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.center,
                    //     children: [
                    //       Text("Already have an account ?",style: Theme.of(context).textTheme.headline6.copyWith(color: Color(0xffa4a7a6),fontSize: 14.0),),
                    //       SizedBox(width: 10.0,),
                    //       Text("Sign In",style: Theme.of(context).textTheme.headline6.copyWith(color: Color(0xff2eafe1),fontSize: 14.0,fontWeight: FontWeight.bold),),
                    //     ],
                    //   ),
                    // ),
                    // SizedBox(height: 20.0,)
                  ],),
              ))

            ],),

            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(

                  child: Column(
                    mainAxisSize: MainAxisSize.min,

                    children: [
                      Container(
                        // height: height*0.75,
                        child: Stack(
                          children: [
                            Card(
                              elevation: 10.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: Container(

                                // height: height*0.7,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SingleChildScrollView(

                                    child: Column(children: [

                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Signup",style: Theme.of(context).textTheme.headline5.copyWith(color:  Color(0xff2eafe1),fontWeight: FontWeight.bold),),
                                          InkWell(

                                            onTap: (){

                                              Navigator.pushReplacement(
                                                  context,
                                                  CupertinoPageRoute(
                                                      builder: (context) => LoginPage1(
                                                      )));
                                            },
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [

                                                Text("Sign In",style: Theme.of(context).textTheme.headline6.copyWith(color: Color(0xff2eafe1),fontSize: 14.0,fontWeight: FontWeight.bold),),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: height*0.05,),
                                      TextInput("+27820000000", Icon(
                                        Icons.phone,
                                        color: Color(0xffa4a7a6),
                                      ), true),
                                      SizedBox(height: height*0.05,),
                                      TextInput("First name", Icon(
                                        Icons.person,
                                        color: Color(0xffa4a7a6),
                                      ), true),
                                      SizedBox(height: height*0.05,),
                                      TextInput("Last name", Icon(
                                        Icons.person,
                                        color: Color(0xffa4a7a6),
                                      ), true),


                                      SizedBox(height: height*0.05,),
                                      TextInput("****************", Icon(
                                        Icons.lock,
                                        color: Color(0xffa4a7a6),
                                      ), true),

                                      SizedBox(height: height*0.05,),
                                      TermsWidget(),    SizedBox(height: height*0.05,),

                                      _submitButton(),

                                      SizedBox(height: height*0.06,),
                                    ],),
                                  ),
                                ),
                              ),

                            ),
                            // Positioned(
                            //   bottom: 0.0,left: 0.0,right: 0.0,
                            //   child: Row(
                            //     mainAxisAlignment: MainAxisAlignment.center,
                            //     children: [
                            //       Center(
                            //         child: Container(
                            //           width: 100.0,
                            //           height: 100.0,
                            //           decoration: BoxDecoration(
                            //               color: Colors.white,
                            //               shape: BoxShape.circle
                            //           ),
                            //           child: Center(
                            //             child: Container(
                            //               width: 80.0,
                            //               height: 80.0,
                            //               decoration: BoxDecoration(
                            //                   color: Color(0xff2eafe1),
                            //                   shape: BoxShape.circle
                            //               ),child: Icon(Icons.arrow_forward,size: 50.0,color: Colors.white,),
                            //             ),
                            //           ),
                            //         ),
                            //       ),
                            //     ],
                            //   ),
                            // )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
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
          'Sign Up',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  TermsWidget(){

    return Row(children: [

      InkWell(

        onTap: (){

          setState(() {
            checked=!checked;
          });
        },
        child:   Container(

          decoration: BoxDecoration(shape: BoxShape.circle, color: Color(0xff2eafe1)),
          child: checked
              ? Icon(
            Icons.check,
            size: 30.0,
            color: Colors.white,
          )
              : Icon(
            Icons.check_box_outline_blank,
            size: 30.0,
            color: Color(0xff2eafe1),
          ),
        ),


      ),SizedBox(width: 10.0,),RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
            text: 'I agree to the',
            style:  Theme.of(context).textTheme.headline5.copyWith(color:  Color(0xff78828a),fontWeight: FontWeight.bold,fontSize: 16.0),
            children: [
              TextSpan(
                text: ' Terms & conditions',

                style: TextStyle(color: Color(0xff0562a7), fontSize: 16,decoration: TextDecoration.underline,decorationThickness: 2.0),
              ),

            ]),
      )
    ],);
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
