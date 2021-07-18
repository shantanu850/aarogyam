import 'dart:convert';
import 'package:aarogyam/Customloder.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
class ChangePass extends StatefulWidget {
  @override
  _ChangePassState createState() => _ChangePassState();
}

class _ChangePassState extends State<ChangePass> {
  String email = "",phone="",name="",id="";
  getUser()async{
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    setState(() {
      email = _preferences.getString("userEmail");
      phone = _preferences.getString("userPhone");
      name = _preferences.getString("userName");
      id = _preferences.getString("userId");
    });
  }
  bool changing;
  initState(){
    getUser();
    changing = false;
    super.initState();
  }
  String pass,confpass,oldpass;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Reset Password"),
      ),
      body: Container(
        alignment: Alignment.center,
        child: ListView(
          shrinkWrap: true,
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal:15,vertical:5),
              child: TextField(
              //  obscureText: view,
                decoration: InputDecoration(
                /*  suffix: IconButton(
                 //   icon:(view!=false)?Icon(CupertinoIcons.eye_solid,size:20,color:Colors.grey,):Icon(CupertinoIcons.eye_slash_fill,size:20,color:Colors.grey,),
                    onPressed: (){
                      setState(() {
                   //     view = !view;
                      });
                    },
                  ),*/
                  border: new OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(5),
                    ),
                  ),
                  hintText: "Old Password",
                ),
                onChanged: (v){
                  oldpass = v;
                },
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal:15,vertical:5),
              child: TextField(
                obscureText: true,
                decoration: InputDecoration(
                  border: new OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(5),
                    ),
                  ),
                  hintText: "New Password",
                ),
                onChanged: (v){
                  pass = v;
                },
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal:15,vertical:5),
              child: TextField(
                obscureText: true,
                decoration: InputDecoration(
                  border: new OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(5),
                    ),
                  ),
                  hintText: "Confirm New Password",
                ),
                onChanged: (v){
                  confpass = v;
                },
              ),
            ),
            (changing!=true)?GestureDetector(
              onTap: ()async{
                if(oldpass!=null) {
                  if (pass == confpass) {
                    setState(() {
                      changing = true;
                    });
                    SharedPreferences prefs = await SharedPreferences
                        .getInstance();
                    http.post(
                        "http://www.notoutindia.com/aarogyam/api/VerifyPassword",
                        headers: {
                          "Authorization": prefs.getString('token'),
                        },
                        body: jsonEncode({
                          "Password": oldpass,
                          "Id": prefs.getString('userId'),
                        })
                    ).then((value1) =>
                    {
                      if( jsonDecode(value1.body)['IsMatched']==true){
                        http.post(
                        "http://www.notoutindia.com/aarogyam/api/UpdatePassword",
                        headers: {
                          "Authorization": prefs.getString('token'),
                        },
                        body: jsonEncode({
                          "Email": email,
                          "Password": pass,
                          "UpdatedDate": DateTime.now().toString(),
                          "UpdatedBy": prefs.getString('userId'),
                        })
                    ).then((value) =>
                    {
                      setState(() {
                        changing = false;
                      }),
                      _scaffoldKey.currentState.showSnackBar(
                          SnackBar(content: Text(
                              jsonDecode(value.body)['message']),)),
                      Navigator.pop(context)
                    }),
                      }else{
                        setState(() {
                          changing = false;
                        }),
                        _scaffoldKey.currentState.showSnackBar(
                            SnackBar(content: Text("Old Password Not Matched"),)),
                      }
                    });
                  } else {
                    setState(() {
                      changing = false;
                    });
                    _scaffoldKey.currentState.showSnackBar(SnackBar(
                        content: Text(
                            "Password & Confirm Password didn't matched ")));
                  }
                }else{
                  _scaffoldKey.currentState.showSnackBar(SnackBar(
                      content: Text("Verify Old Password")));
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
                child: Text("Reset Password",style: TextStyle(color: Colors.white,fontSize:18,fontWeight: FontWeight.bold),),
              ),
            ):Container(
                height: 56,
                width: MediaQuery.of(context).size.width*0.9,
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal:10,vertical:15),
                decoration: BoxDecoration(
                    color: Colors.deepOrange,
                    borderRadius: BorderRadius.all(Radius.circular(5))
                ),
                child: ColorLoader()
            ),
          ],
        ),
      ),
    );
  }
}
