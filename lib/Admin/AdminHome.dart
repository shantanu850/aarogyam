import 'dart:convert';
import 'package:aarogyam/Admin/AllPayments.dart';
import 'package:aarogyam/Admin/PatientRecords.dart';
import 'package:aarogyam/Admin/TestSamplesAll.dart';
import 'package:aarogyam/Admin/ViewTestSample.dart';
import 'package:aarogyam/Screens/mainAppBar.dart';
import 'package:aarogyam/Widgets/DashboardItems.dart';
import 'package:aarogyam/drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'DoctorRecord.dart';

class AdminHome extends StatefulWidget {
  final userType;
  const AdminHome({Key key, this.userType}) : super(key: key);
  @override
  _AdminHomeState createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  SharedPreferences preferences;
  String Sname="";
  getUser()async{
    preferences = await SharedPreferences.getInstance();
    setState(() {
      Sname = preferences.getString("userName");
    });
  }
  Map data = {
    "TotalDoctors": "0",
    "TotalPatient": "0",
    "TotalPayments": "0",
    "TotalTestSamples": "0"
  };
  Future getData()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getString('token'));
    http.Response response = await http.get("http://www.notoutindia.com/aarogyam/api/GetDashboardNumbers",headers:{
      "Authorization":prefs.getString('token'),
    });
    Map _data = jsonDecode(response.body);
    print(_data);
    setState(() {
      data = _data;
    });
    return jsonDecode(response.body);
  }
  Future<bool> pop()async{
    return Future<bool>.value(false);
  }
  @override
  void initState() {
    getUser();
    getData();
    //GetDashboardNumbers
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: pop,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          bottom: PreferredSize(
            preferredSize: Size(width,8), child:Container(),
          ),
          title: Text("Welcome $Sname",),
          elevation: 0,
          actions: [
            IconButton(icon: Icon(Icons.qr_code), onPressed: ()async{
              SharedPreferences prefs = await SharedPreferences.getInstance();
              scanner.scan().then((value) => {
              http.get(
                  "http://www.notoutindia.com/aarogyam/api/TestSamples?Id=$value",
                  headers:{
                    "Authorization":prefs.getString('token'),
                  }).then((value2) => {
                print("Patient Id : ${jsonDecode(value2.body)[0]['PatientId'].toString()}"),
                http.post("http://www.notoutindia.com/aarogyam/api/GetPatient?Id=${jsonDecode(value2.body)[0]['PatientId'].toString()}").then((value3) => {
                  print(value3.statusCode),
                  if(value3.statusCode==200||value3.statusCode==201){
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            ViewTestSample(
                              snapshot: jsonDecode(value2.body)[0],
                              patentSnapshot: jsonDecode(value3.body),)))
                  }
                })
              })
              });
            })
          ],
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
                  child: MainAppBar()),
              Container(
                color: Colors.white,
                height:width,
                padding: EdgeInsets.symmetric(vertical:5,horizontal:10),
                child: GridView.count(
                  physics: NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  childAspectRatio: 1.2,
                  mainAxisSpacing: 0,
                  crossAxisSpacing: 0,
                  children: [
                    DashboardItems(
                      onTap:(){
                        Navigator.push(context, MaterialPageRoute(builder:(context)=>PatRecord()));
                      },
                      isImage: false,
                      isIcon: true,
                      icon: SvgPicture.asset('assets/doctor.svg',height:40,width:40,color:Colors.white,),
                      backgroundImage: "assets/doc.webp",
                      color: Colors.deepOrange,
                      borderRadious: 10,
                      isCustomText: true,
                      customText: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("Total Patient",style: TextStyle(color: Colors.white,fontSize:18,fontWeight: FontWeight.bold),),
                          Text("${data['TotalPatient']}+",style: TextStyle(color: Colors.white,fontSize:28,fontWeight: FontWeight.bold),),
                        ],
                      ),
                    ),
                    DashboardItems(
                      onTap:(){
                        Navigator.push(context, MaterialPageRoute(builder:(context)=>DocRecord()));
                      },
                      isImage: false,
                      isIcon: true,
                      icon: Icon(Icons.person_outline_outlined,color: Colors.white,size:50,),
                      backgroundImage: "assets/doc.webp",
                      color: Colors.deepOrange,
                      borderRadious: 10,
                      isCustomText: true,
                      customText: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("Total Doctors",style: TextStyle(color: Colors.white,fontSize:18,fontWeight: FontWeight.bold),),
                          Text("${data['TotalDoctors']}+",style: TextStyle(color: Colors.white,fontSize:28,fontWeight: FontWeight.bold),),
                        ],
                      ),
                    ),
                    DashboardItems(
                      onTap:(){
                        Navigator.push(context, MaterialPageRoute(builder:(context)=>AllPayments()));
                      },
                      isImage: false,
                      isIcon: true,
                      icon: SvgPicture.asset('assets/medicine.svg',height:40,width:40,color:Colors.white,),
                      backgroundImage: "assets/doc.webp",
                      color: Colors.deepOrange,
                      text: "My Doctors",
                      borderRadious: 10,
                      isCustomText: true,
                      customText: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("Total Sold Medicines",style: TextStyle(color: Colors.white,fontSize:14,fontWeight: FontWeight.bold),),
                          Text("${data['TotalPayments']}+",style: TextStyle(color: Colors.white,fontSize:28,fontWeight: FontWeight.bold),),
                        ],
                      ),
                    ),
                    DashboardItems(
                      onTap:(){
                        Navigator.push(context, MaterialPageRoute(builder:(context)=>TestSampleAll()));
                      },
                      isImage: false,
                      isIcon: true,
                      icon: SvgPicture.asset('assets/test-tube.svg',height:40,width:40,color:Colors.white,),
                      backgroundImage: "assets/doc.webp",
                      color: Colors.deepOrange,
                      text: "My Doctors",
                      borderRadious: 10,
                      isCustomText: true,
                      customText: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("Total Tests",style: TextStyle(color: Colors.white,fontSize:18,fontWeight: FontWeight.bold),),
                          Text("${data['TotalTestSamples']}+",style: TextStyle(color: Colors.white,fontSize:28,fontWeight: FontWeight.bold),),
                        ],
                      ),
                    ),
                  ],
                )
              ),
             /* Container(
                color: Colors.white,
                padding: EdgeInsets.all(20),
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                child: ListView(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (
                            context) => PatRecord()));
                      },
                      child: Container(
                        margin: EdgeInsets.all(5),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.white70, width: 1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 5,
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            subtitle:Text("Patient",
                              style: TextStyle(color: Colors.deepOrange,fontSize: 24,fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                              maxLines: 2,),
                            title: Container(
                              height: 180,
                              decoration: BoxDecoration(
                                image: DecorationImage(image: AssetImage("assets/pat.webp"),fit: BoxFit.cover)
                              ),
                              alignment: Alignment.center,
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (
                            context) => DocRecord()));
                      },
                      child: Container(
                        margin: EdgeInsets.all(5),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.white70, width: 1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 5,
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            subtitle:Text("Doctor",
                              style: TextStyle(color: Colors.deepOrange,fontSize: 24,fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                              maxLines: 2,),
                            title: Container(
                              height: 180,
                              decoration: BoxDecoration(
                                  image: DecorationImage(image: AssetImage("assets/doc.webp"),fit: BoxFit.cover)
                              ),
                              alignment: Alignment.center,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),*/
            ],
          ),
        ),
      ),
    );
  }
}
