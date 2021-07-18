import 'dart:convert';
import 'package:aarogyam/Screens/Verify.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ForgptPassword extends StatefulWidget {
  @override
  _ForgptPasswordState createState() => _ForgptPasswordState();
}

class _ForgptPasswordState extends State<ForgptPassword> {
  String email;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  initState(){
    Firebase.initializeApp();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Reset Password"),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Form(
              key: _formKey,
              child: Padding(
                padding:
                const EdgeInsets.symmetric(vertical: 5.0,horizontal:20),
                child: TextFormField(
                  obscureText: false,
                  decoration: new InputDecoration(
                    prefixIcon: new Icon(Icons.email,
                        color: Colors.grey),
                    labelText: 'Email',
                    labelStyle: TextStyle(color: Colors.grey),
                    fillColor: Colors.white,
                    filled: true,
                    border: new OutlineInputBorder(
                        borderRadius:
                        new BorderRadius.circular(5.0),
                        borderSide: new BorderSide(
                          color: Colors.transparent,
                        )),
                    enabledBorder: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(5.0),
                        borderSide: new BorderSide(
                          color: Colors.grey,
                        )),
                    focusedBorder: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(5.0),
                        borderSide: new BorderSide(
                          color: Colors.red,
                        )),
                  ),
                  validator: (val) {
                    Pattern pattern =
                        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                    RegExp regex = new RegExp(pattern);
                    if (!regex.hasMatch(val)) {
                      return 'Email format is invalid';
                    } else {
                      return null;
                    }
                  },
                  onChanged: (value) {
                    email = value; //get the value entered by user.
                  },
                  keyboardType: TextInputType.emailAddress,
                  style: new TextStyle(
                    height: 1.0,
                    fontSize: 14,
                    color: Colors.grey,
                    fontFamily: "Poppins",
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: ()async{
                SharedPreferences prefs = await SharedPreferences
                    .getInstance();
                if(_formKey.currentState.validate()) {
                    http.post(
                        "http://www.notoutindia.com/aarogyam/api/VerifyEmail?EmailId=$email",
                        headers: {
                          "Authorization": prefs.getString('token'),
                        },
                    ).then((value) =>
                    {
                      if(jsonDecode(value.body)["IsExist"]){
                        Firebase.initializeApp(),
                        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Verify(phone:jsonDecode(value.body)["MobileNumber"],email:email)))
                      }else
                        {
                          _scaffoldKey.currentState.showSnackBar(
                              SnackBar(content: Text("Email Not Registered"),))
                        }
                    });
                }
              },
              child: Container(
                height: 56,
                width: MediaQuery.of(context).size.width*0.9,
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal:10,vertical:15),
                decoration: BoxDecoration(
                    color: Colors.deepOrange,
                    borderRadius: BorderRadius.all(Radius.circular(5))
                ),
                child: Text("Verify Email",style: TextStyle(color: Colors.white,fontSize:18,fontWeight: FontWeight.bold),),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
