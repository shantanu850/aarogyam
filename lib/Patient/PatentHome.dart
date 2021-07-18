import 'package:aarogyam/Patient/PatientDoctors.dart';
import 'package:aarogyam/Patient/PatientMyTest.dart';
import 'package:aarogyam/Screens/mainAppBar.dart';
import 'package:aarogyam/Widgets/DashboardItems.dart';
import 'package:aarogyam/drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PatentHome extends StatefulWidget {
  final userType;
  const PatentHome({Key key, this.userType}) : super(key: key);
  @override
  _AdminHomeState createState() => _AdminHomeState();
}

class _AdminHomeState extends State<PatentHome> {
  SharedPreferences preferences;
  String email = "";
  getUser()async{
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences = _preferences;
      email = _preferences.getString("userName");
    });
  }
  Future<bool> pop()async{
    return Future<bool>.value(false);
  }
  @override
  void initState() {
    getUser();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: pop,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          bottom: PreferredSize(
            preferredSize: Size(width,8), child:Container(),
          ),
          title: Text("Welcome $email"),
        ),
        drawer: Drawer(
          child: CustomDrawer()
        ),
        body: Container(
          child: ListView(
            shrinkWrap: true,
            children: [
              Container(
                  color: Colors.white,
                  child: MainAppBar()
              ),
              Container(
                padding: EdgeInsets.only(top:10),
                margin: EdgeInsets.all(10),
                color: Colors.white,
                child: GridView.count(
                  shrinkWrap: true,
                  childAspectRatio:1.5,
                  physics: NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 0,
                  mainAxisSpacing: 0,
                  crossAxisCount: 2,
                  children: [
                    DashboardItems(
                      onTap:(){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>PatientDoctor()));
                      },
                      isImage: false,
                      isIcon: true,
                      icon: SvgPicture.asset('assets/doctor.svg',height:40,width:40,color:Colors.white,),
                      backgroundImage: "assets/doc.webp",
                      color: Colors.deepOrange,
                      text: "My Doctors",
                      borderRadious: 10,
                    ),
                    DashboardItems(
                      onTap:(){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>PatientMyTest()));
                      },
                      isImage: false,
                      isIcon: true,
                      icon: SvgPicture.asset('assets/test-tube.svg',height:40,width:40,color:Colors.white,),
                      backgroundImage: "assets/doc.webp",
                      color: Colors.deepOrange,
                      text: "My Tests",
                      borderRadious: 10,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );

  }
  showAlertDialog(BuildContext context) {
    // Create button
    Widget okButton = FlatButton(
      child: Text("Close"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    //if status = 4 open invoice
    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Are You Sure ?"),
      actions: [
        okButton,
        FlatButton(
          child: Text("Logout"),
          onPressed: () {

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
}
