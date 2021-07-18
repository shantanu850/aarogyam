import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class RstPass extends StatefulWidget {
  final snapshot;
  const RstPass({Key key, this.snapshot}) : super(key: key);
  @override
  _RstPassState createState() => _RstPassState();
}

class _RstPassState extends State<RstPass> {
  String pass,confpass;
  bool view;
  initState(){
    view = true;
    super.initState();
  }
  showError(BuildContext context,message) {
    // Create button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      },
    );
    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Password Changed"),
      content: Text(message.toString()),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Reset Password For ${widget.snapshot['Name']}"),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal:15,vertical:5),
              child: TextField(
                obscureText: view,
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
                obscureText: view,
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
            GestureDetector(
              onTap: ()async{
                if(pass==confpass) {
                  SharedPreferences prefs = await SharedPreferences
                      .getInstance();
                  http.post(
                      "http://www.notoutindia.com/aarogyam/api/UpdatePassword",
                      headers: {
                        "Authorization": prefs.getString('token'),
                      },
                      body: jsonEncode({
                        "Email":widget.snapshot['Email'],
                        "Password": pass,
                        "UpdatedDate": DateTime.now().toString(),
                        "UpdatedBy": prefs.getString('userId'),
                      })
                  ).then((value) => {
                    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(jsonDecode(value.body)['message']),)),
                    showError(context,jsonDecode(value.body)['message'])
                  });
                }else{
                  _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Password & Confirm Password didnt matched ")));
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
            ),
          ],
        ),
      ),
    );
  }
}
