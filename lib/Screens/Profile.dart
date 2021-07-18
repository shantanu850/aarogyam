import 'package:aarogyam/Screens/ChangePass.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:aarogyam/main.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  showAlertDialog(BuildContext context) {
    // Create button
    Widget okButton = FlatButton(
      child: Text("Close"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Are You Sure ?"),
      actions: [
        okButton,
        FlatButton(
          child: Text("Logout"),
          onPressed: () async{
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setBool('user', false).then((value) => {
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>MyHomePage()))
            });
          },
        )
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
  String Semail = "",Sphone="",Sname="";
  getUser()async{
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    setState(() {
      Semail = _preferences.getString("userEmail");
      Sphone = _preferences.getString("userPhone");
      Sname = _preferences.getString("userName");
    });
  }
  @override
  void initState() {
    getUser();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: Container(
        padding: EdgeInsets.all(8),
        child: ListView(
          children: [
            Card(child:
            Container(
              child:ListTile(
                title:Text("$Sname") ,
                subtitle: Text("$Semail"),
              ),
            )
            ),
            Card(
              child: ListTile(
                leading: Icon(Icons.refresh),
                onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ChangePass()));
                },
                title:Text("Change Password") ,
              ),
            ),
            Card(
              child: ListTile(
                onTap: () {
                  showAlertDialog(context);
                },
                title: Text("Logout"),
                leading: Icon(Icons.logout, color: Colors.deepOrange),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
