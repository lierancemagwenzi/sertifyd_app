import 'package:country_list_pick/country_list_pick.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:horizon/src/controllers/LoginController.dart';
import 'package:horizon/src/model/CountryModel.dart';
import 'package:horizon/src/model/UserModel.dart';
import 'package:horizon/src/pages/Login.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:password_strength/password_strength.dart';
import 'package:email_validator/email_validator.dart';

class RegistrationScreen extends StatefulWidget {
  RegistrationScreen({Key key, this.title,this.message}) : super(key: key);

  final String title;

  String message;
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends StateMVC<RegistrationScreen> {

  LoginController _con;

  _RegistrationScreenState() : super(LoginController()) {
    _con = controller;
  }
bool hidepassword=true;
  final _formKey = GlobalKey<FormState>();
  double height;
  double width;
  String email;
  String password;

  String firstname;
  String lastname;
  String address;
  String country="South Africa";
String title="Mr";
  bool useemail=true;
  TextEditingController controller1=TextEditingController();

  PhoneNumber number = PhoneNumber(isoCode: 'ZA');
List<String>titles=["Mr","Mrs",'Ms',"Miss"];
  CountryModel countryModel;

bool checked=false;
  @override
  void initState() {

    if(widget.message!=null){

      Future.delayed(const Duration(seconds: 1), () {

        _con.scaffoldKey?.currentState?.showSnackBar(SnackBar(
          content: Text(widget.message??''),
        ));

      });
    }

    _con.listenForTerms();
    _con.listenForCountries();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    width=MediaQuery.of(context).size.width;
    height=MediaQuery.of(context).size.height;
    return WillPopScope(

      onWillPop: ()async{

        return false;
      },
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
            color: Colors.white,
            image: DecorationImage(image: AssetImage("assets/bg/backbg.png"),fit: BoxFit.cover)),
        child: Scaffold(
          key: _con.scaffoldKey,
          backgroundColor: Colors.transparent,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal:20.0),
            child: Stack(
              children: [
                SingleChildScrollView(

                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: height*0.15,),
                        Center(
                          child: Container(
                            height: 100,
                            width: width*0.5,
                            decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/logo/logoo.png"),fit: BoxFit.contain)),
                          ),
                        )
                        ,
                       useemail? _entryField("Email",(input) => email = input,(input) => ! EmailValidator.validate(input.trim()) ? " Enter a valid email" : null,):phoneField(),
                        InkWell(

                          onTap: (){


                            setState(() {

                              email='';
                              controller1.text='';
                              useemail=!useemail;

                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            alignment: Alignment.centerRight,
                            child: Text(useemail?'Use phone instead?':'Use email instead?',
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w500)),
                          ),
                        ),
                        _entryField("Firstname",(input) => firstname = input,(input) => input==null||input.trim().length<1? " Enter a valid first name" : null,),
                        _entryField("Lastname",(input) => lastname = input,(input) => input==null||input.trim().length<1? " Enter a valid last name" : null,),
                        TitleWidget(),
                        SizedBox(
                          height: 10.0,
                        ),
                        SizedBox(
                          height: 10.0,
                        ),

                        CountryWidget(),
                      SizedBox(
                        height: 10.0,
                      ),
                      _entryField("Address",(input) => address = input,(input) =>  input==null||input.trim().length<1 ? " Enter a valid address" : null,),


                      // Container(
                    //   width: double.infinity,
                    //   color: Colors.white,
                    //   child: Row(
                    //     children: [
                    //       CountryListPick(
                    //         appBar: AppBar(
                    //           backgroundColor: Theme.of(context).accentColor,
                    //           title: Text('Pick your country'),
                    //
                    //         ),
                    //         // if you need custome picker use this
                    //         // pickerBuilder: (context, CountryCode countryCode) {
                    //         //   return Row(
                    //         //     children: [
                    //         //       Image.asset(
                    //         //         countryCode.flagUri,
                    //         //         package: 'country_list_pick',
                    //         //       ),
                    //         //       Text(countryCode.code),
                    //         //       Text(countryCode.dialCode),
                    //         //     ],
                    //         //   );
                    //         // },
                    //         theme: CountryTheme(
                    //           isShowFlag: true,
                    //           isShowTitle: true,
                    //           isShowCode: true,
                    //           isDownIcon: true,
                    //           showEnglishName: false,
                    //         ),
                    //         initialSelection: '+27',
                    //
                    //         // or
                    //         // initialSelection: 'US'
                    //         onChanged: (CountryCode code) {
                    //           country=code.name;
                    //           print(code.name);
                    //           print(code.code);
                    //           print(code.dialCode);
                    //           print(code.flagUri);
                    //         },
                    //       ),
                    //     ],
                    //   ),
                    // ),




                        _passwordEntryField("Password",(input) => password = input,(input) => estimatePasswordStrength(input)<0.6?"password is too weak":null),
                        SizedBox(
                          height: 10.0,
                        ),


                        TermsWidget(),
                        SizedBox(
                          height: 30.0,
                        ),
                        _submitButton(),
                        SizedBox(
                          height: 30.0,
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [

                            InkWell(
                              onTap: (){
                                //
                                Navigator.pushReplacement(
                                    context,
                                    CupertinoPageRoute(
                                        builder: (context) => LoginScreen(
                                        )));
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Already have an account ?",style: Theme.of(context).textTheme.headline6.copyWith(color: Theme.of(context).accentColor,fontSize: 12.0),),
                                  SizedBox(width: 10.0,),
                                  Text("Sign In",style: Theme.of(context).textTheme.headline6.copyWith(fontSize: 12.0,fontWeight: FontWeight.bold,color: Theme.of(context).accentColor),),
                                ],
                              ),
                            ),
                            SizedBox(height: 40.0,)

                          ],)
                      ],),
                  ),
                ),
                _con.loading?Center(child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Theme.of(context).accentColor),)):SizedBox(height: 0,width: 0,)

              ],
            ),
          ),

        ),
      ),
    );
  }


  Widget _entryField(String title,onsaved,validator, {bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            style:  TextStyle(color: Colors.black,fontSize: 12),
              onSaved: onsaved,
              validator:validator,
              obscureText: isPassword?hidepassword:false,
              decoration:getInputDecoration(title,isPassword))
        ],
      ),
    );
  }
  Widget _passwordEntryField(String title,onsaved,validator,) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
              style: TextStyle(color: Colors.black,fontSize: 12.0),
              onSaved: onsaved,
              onChanged: (i){
                setState(() {

                  password=i;
                });

              },
              validator:validator,
              obscureText: hidepassword,
              decoration:getPasswordInputDecoration(title))
        ],
      ),
    );
  }
  Widget phoneField(){

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Phone",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12,color: Colors.black),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          color: Colors.white,
          child: InternationalPhoneNumberInput(
            onInputChanged: (PhoneNumber number) {
              email = number.phoneNumber;
              print(number.phoneNumber);
            },
            onInputValidated: (bool value) {
              print(value);
            },
            textStyle: TextStyle(color: Colors.black,fontSize: 12.0),
            inputDecoration: InputDecoration(
                border: InputBorder.none,
                fillColor: Colors.white,
                filled: true),
            ignoreBlank: false,
            autoFocusSearch: true,
            searchBoxDecoration:  InputDecoration(
                border: InputBorder.none,
                fillColor: Color(0xfff3f3f4),
                filled: true),
            selectorTextStyle: TextStyle(color: Colors.black),
            initialValue: number,
            textFieldController: controller1,
            inputBorder: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  getInputDecoration(String title,bool is_password){
    var Platform;
    return  InputDecoration(
        border: InputBorder.none,
        hintText: title,
        suffixIcon:is_password? InkWell(
            onTap: (){

              setState(() {

                hidepassword=!hidepassword;
              });
            },

            child: Icon(hidepassword?Icons.remove_red_eye:Icons.close,color: Theme.of(context).accentColor,)):null,
        hintStyle: TextStyle(color: Colors.grey.withOpacity(0.9),fontSize: 12),
        fillColor:  Colors.white,
        filled: true);
  }

  getPasswordInputDecoration(String title,){
    var Platform;
    return  InputDecoration(
        border: InputBorder.none,
        hintText: title,
        suffixIcon:password!=null&&password.length>0?InkWell(
            onTap: (){

              setState(() {

                hidepassword=!hidepassword;
              });
            },

            child: Icon(hidepassword?Icons.remove_red_eye:Icons.close,color: Theme.of(context).accentColor,)):null,
        hintStyle: TextStyle(color: Colors.grey.withOpacity(0.9),fontSize: 12),
        fillColor:  Colors.white,
        filled: true);
  }
  void _submit() {

    if(_con.loading){

      return ;
    }
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      print("validated");

      if(!checked){


        _con.scaffoldKey?.currentState?.showSnackBar(SnackBar(
          content: Text("Agree to terms and conditions to proceed"),
        ));
      }

      else{

        if(countryModel==null){

   _con.scaffoldKey?.currentState?.showSnackBar(SnackBar(
            content: Text("Please select a country"),
          ));

   return;
        }

        _con.RegisterUser(new UserModel(firstname: firstname,lastname: lastname,password: password,mobile: email,country_id: countryModel.id,address: address,title: title),context);
      }


    }

    else{print("incorrect form");}
  }
  Widget _submitButton() {
    return InkWell(
      onTap: (){
        _submit();
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
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
                colors: [Theme.of(context).accentColor,Theme.of(context).accentColor])),
        child: Text(
          'Register',
          style: TextStyle(fontSize: 14, color: Colors.white),
        ),
      ),
    );
  }


  TermsWidget(){
    return Row(children: [


        SizedBox(width: 10.0,),InkWell(

        onTap: (){
          _modalBottomSheetMenu();

        },
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
                text: 'I agree to the',
                style:  Theme.of(context).textTheme.headline5.copyWith(color: Theme.of(context).accentColor,fontWeight: FontWeight.bold,fontSize: 12.0),
                children: [
                  TextSpan(
                    text: ' Terms & conditions',

                    style: TextStyle(color:  Theme.of(context).accentColor, fontSize: 14,decoration: TextDecoration.underline,decorationThickness: 2.0),
                  ),

                ]),
          ),
        ),
      SizedBox(width: 10.0,),
      InkWell(
        onTap: (){
          setState(() {
            checked=!checked;
          });
        },
        child:   Container(
          decoration: BoxDecoration(shape: BoxShape.circle, color:  Theme.of(context).accentColor),
          child: checked
              ? Center(
                child: Icon(
            Icons.check,
            size: 20.0,
            color: Colors.white,
          ),
              )
              : Icon(
              Icons.check_box_outline_blank,
              size: 20.0,
              color:  Theme.of(context).accentColor),
        ),
      )


    ],);
  }
  TitleWidget(){

    return   Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        SizedBox(height: 10,),
        Text(
          "Title",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12,color: Colors.black),
        ),
        SizedBox(height: 10,),
        FormField<String>(
          builder: (FormFieldState<String> state) {
            return InputDecorator(
              decoration: InputDecoration(
                  border: InputBorder.none,
                  fillColor: Colors.white,
                  filled: true),
              isEmpty: title == null,
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: title,
                  isDense: true,
                  onChanged: (String newValue) {
                    setState(() {
                      title = newValue;
                      state.didChange(newValue);
                    });
                  },
                  items: titles.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value,style: TextStyle(color: Colors.black),),
                    );
                  }).toList(),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _customDropDownExample(
      BuildContext context, CountryModel item, String itemDesignation) {
    if (item == null) {
      return Container();
    }

    return Container(
      child: (item.id == null)
          ? ListTile(
        contentPadding: EdgeInsets.all(0),
        leading: CircleAvatar(),
        title: Text("No item selected"),
      )
          : ListTile(
        contentPadding: EdgeInsets.all(0),

        title: Text(item.name),

      ),
    );
  }

  Widget _customPopupItemBuilderExample(
      BuildContext context, CountryModel item, bool isSelected) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      decoration: !isSelected
          ? null
          : BoxDecoration(
        border: Border.all(color: Theme.of(context).primaryColorLight),
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
      ),
      child: ListTile(
        selected: isSelected,
        title: Text(item.name),

      ),
    );
  }

  Widget _customPopupItemBuilderExample2(
      BuildContext context, CountryModel item, bool isSelected) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      decoration: !isSelected
          ? null
          : BoxDecoration(
        border: Border.all(color: Theme.of(context).primaryColorLight),
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
      ),
      child: ListTile(
        selected: isSelected,
        title: Text(item.name),

      ),
    );
  }
  CountryWidget(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // SizedBox(height: 15,),

        Text(
          "Country",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12,color: Colors.black),
        ),
        SizedBox(height: 10,),

        FormField<String>(
          builder: (FormFieldState<String> state) {
            return InputDecorator(
              decoration: InputDecoration(
                  border: InputBorder.none,
                  fillColor: Colors.white,
                  filled: true),
              isEmpty: countryModel == null,
              child:      DropdownButtonHideUnderline(

                child: new DropdownButton<CountryModel>(
                  value: countryModel,
                  isDense: true,
                  style: TextStyle(color: Colors.white),
                  dropdownColor: Colors.white,
                  hint: Text("Country",style: TextStyle(color: Colors.black,fontSize: 16.0),),
                  onChanged: (CountryModel newValue) {
                    setState(() {
                      countryModel = newValue;
                    });
                  },
                  items: _con.countries.map((CountryModel p) {
                    return new DropdownMenuItem<CountryModel>(
                      value: p,
                      child: new Text(
                        p.name,
                        style: new TextStyle(color: Colors.black,fontSize: 16.0),
                      ),
                    );
                  }).toList(),
                ),
              ),
            );
          },
        ),
        // Container(
        //   width: width,
        //   color: Color(0xfff3f3f4),
        //   child: Row(
        //     children: [
        //       SizedBox(width: 10.0,),
        //       DropdownButtonHideUnderline(
        //
        //         child: new DropdownButton<BusinessCategory>(
        //           value: businessCategory,
        //           isDense: true,
        //           style: TextStyle(color: Colors.white),
        //           dropdownColor: Colors.white,
        //           hint: Text("Business Category",style: TextStyle(color: Colors.black,fontSize: 16.0),),
        //           onChanged: (BusinessCategory newValue) {
        //             setState(() {
        //               businessCategory = newValue;
        //             });
        //           },
        //           items: _con.business_categories.map((BusinessCategory p) {
        //             return new DropdownMenuItem<BusinessCategory>(
        //               value: p,
        //               child: new Text(
        //                 p.name,
        //                 style: new TextStyle(color: Colors.black,fontSize: 16.0),
        //               ),
        //             );
        //           }).toList(),
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
      ],
    );
  }

  void _modalBottomSheetMenu(){
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        enableDrag: true,
isDismissible: false,
        builder: (builder){
          return new Container(
            height: MediaQuery.of(context).size.height*0.8,
            color: Colors.transparent, //could change this to Color(0xFF737373),
            //so you don't have to change MaterialApp canvasColor
            child: Scaffold(


              appBar: AppBar(
                centerTitle: true,
                leading: InkWell(

                    onTap: (){

                      Navigator.pop(context);
                    },

                    child: Icon(Icons.arrow_back_ios,color: Colors.white,size: 30,)),
                title: Text("Terms and Conditions",style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.bold),),


              ),body:


            ListView.separated(
                itemCount: _con.terms.length,
                separatorBuilder: (context, index) {
                  return Divider(color: Colors.grey,thickness: 2,);
                },
                itemBuilder: (BuildContext context,int index){

                  return Padding(
                    padding: const EdgeInsets.only(bottom:8.0),
                    child: ListTile(
                      subtitle:Text(_con.terms[index].body,style: TextStyle(color: Colors.black,fontSize: 12,fontWeight: FontWeight.normal),),

                      title:Text(_con.terms[index].title,style: TextStyle(color: Colors.black,fontSize: 12,fontWeight: FontWeight.bold),)
                    ),
                  );
                }
            )

              ,            ),
          );
        }
    );
  }
}
