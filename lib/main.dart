import 'dart:convert';
import 'package:aarogyam/Screens/ForgotPassword.dart';
import 'package:aarogyam/Doctor/DoctorHome.dart';
import 'package:aarogyam/Patient/PatentHome.dart';
import 'package:aarogyam/Screens/TermsAndCond.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:aarogyam/Admin/AdminHome.dart';
import 'package:flutter/material.dart';
import 'Customloder.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aarogyam',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Loader(),
    );
  }
}
class Loader extends StatefulWidget {
  @override
  _LoaderState createState() => _LoaderState();
}

class _LoaderState extends State<Loader> {
  @override
  void initState() {
    load(context);
    super.initState();
  }
  void load(BuildContext context)async{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if(prefs.getBool('user')!=true) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MyHomePage()));
      }else{
        if(prefs.getString('UserType')=="1") {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => AdminHome()));
        }else if(prefs.getString('UserType')=="2"){
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => DoctorHome()));
        }else {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => PatentHome()));
        }
      }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.deepOrangeAccent,
        body:Container(
          alignment: Alignment.center,
          child:Text("Aarogyan",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 22),)
        ),
      bottomNavigationBar: Container(
        height: 100,
        alignment: Alignment.center,
        child: CircularProgressIndicator(
          backgroundColor: Colors.white,
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {
  final formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String email,password;
  bool loging;
  @override
  void initState() {
    loging = false;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body:Container(
        color: Colors.white,
        child: Center(
          child: Form(
            key:formKey,
            child: ListView(
              children: [
                Container(
                    child:Container(
                      height: 120,
                      margin: EdgeInsets.all(40),
                      decoration: BoxDecoration(
                          image: DecorationImage(image: AssetImage("assets/logo_small.jpeg"),
                            fit: BoxFit.fitWidth,
                          )
                      ),
                    )
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal:40),
                  child: Column(
                    children: [
                      Padding(
                        padding:
                        const EdgeInsets.symmetric(vertical: 5.0),
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
                      Padding(
                        padding:
                        const EdgeInsets.symmetric(vertical: 5.0),
                        child: TextFormField(
                          obscureText: true,
                          decoration: new InputDecoration(
                            prefixIcon: new Icon(Icons.lock,color: Colors.grey),
                            labelText: 'Password',
                            labelStyle: TextStyle(color: Colors.grey),
                            fillColor: Colors.white,
                            filled: true,
                            border: new OutlineInputBorder(
                                borderRadius:
                                new BorderRadius.circular(5.0),
                                borderSide: new BorderSide(
                                  color: Colors.grey,
                                )),
                            enabledBorder: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(5.0),
                                borderSide: new BorderSide(
                                  color: Colors.grey,
                                )
                            ),
                            focusedBorder: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(5.0),
                                borderSide: new BorderSide(
                                  color:Colors.deepOrangeAccent,
                                )),
                          ),
                          validator: (val) {
                            if(val.length<4){
                              return 'Password cant be less than 4';
                            }else{
                              return null;
                            }
                          },
                          onChanged: (value) {
                            password = value; //get the value entered by user.
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
                      (loging!=true)?GestureDetector(
                        onTap:()async{
                          print("clicked");
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          if(formKey.currentState.validate()){
                            setState(() {
                              loging = true;
                            });
                            print("clicked");
                          http.post(
                                'http://www.notoutindia.com/aarogyam/api/Login',
                                body:jsonEncode({
                                  "email":email,
                                  "password":password,
                                })).then((responce) => {
                              if(responce.statusCode == 200 || responce.statusCode == 201){
                                prefs.setBool('user', true).then((value) => {
                                  print(jsonDecode(responce.body)),
                                  prefs.setString('UserType', jsonDecode(responce.body)['UserType']),
                                  prefs.setString('userName', jsonDecode(responce.body)['Name']),
                                  prefs.setString('userNumber', jsonDecode(responce.body)['Contact Number']),
                                  prefs.setString('userEmail', jsonDecode(responce.body)['email']),
                                  prefs.setString('userId', jsonDecode(responce.body)['ID']),
                                  prefs.setString('token', jsonDecode(responce.body)['jwt'])
                                }).then((value) => {
                                  print(jsonDecode(responce.body)['message']),
                                  _scaffoldKey.currentState.showSnackBar(SnackBar(content:Text(jsonDecode(responce.body)['message']))),
                                  if(jsonDecode(responce.body)['UserType']=="1"){
                                    Navigator.push(context, MaterialPageRoute(
                                        builder: (context) => AdminHome())),
                                  }else if(jsonDecode(responce.body)['UserType']=="2"){
                                    Navigator.push(context, MaterialPageRoute(
                                        builder: (context) => DoctorHome())),
                                  }else{
                              if ( jsonDecode(responce.body)['Last_Login']!=null) {
                                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => PatentHome()))
                                  }else{
                                     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => TermsAndCond()))
                                  }
                                  },
                                setState(() {
                                loging = false;
                                })
                                })
                              }else{
                              setState(() {
                              loging = false;
                            }),
                                print(jsonDecode(responce.body)['message']),
                                _scaffoldKey.currentState.showSnackBar(SnackBar(content:Text(jsonDecode(responce.body)['message'])))
                              }
                            });
                          }
                        },
                        child: Container(
                          margin: EdgeInsets.only(top:20),
                          alignment: Alignment.center,
                          height:50,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [Colors.deepOrange,Colors.orange]
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child:(loging==false)?Text("Sign In",style:TextStyle(fontSize:20,color:Colors.white,fontWeight: FontWeight.bold),):ColorLoader(),
                        ),
                      ):Container(
                        margin: EdgeInsets.only(top:20),
                        alignment: Alignment.center,
                        height:50,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [Colors.deepOrange,Colors.orange]
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child:ColorLoader(
                          dotThreeColor: Colors.white,
                          dotTwoColor: Colors.white,
                          dotOneColor: Colors.white,
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ForgptPassword()));
                        },
                        child: Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.only(top:20,right:15),
                            child: Text("Forgot Password ?"
                              ,style: TextStyle(color:Colors.deepOrange),textAlign: TextAlign.right,
                            )),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
