import 'dart:convert';
import 'package:aarogyam/Admin/Orders.dart';
import 'package:aarogyam/Admin/Tests.dart';
import 'package:aarogyam/Doctor/DoctorMyPatientsTestSample.dart';
import 'package:aarogyam/Doctor/DoctorMyProfile.dart';
import 'package:aarogyam/Patient/MyOrders.dart';
import 'package:aarogyam/Patient/PatientDoctors.dart';
import 'package:aarogyam/Patient/PatientMyTest.dart';
import 'package:http/http.dart' as http;
import 'package:aarogyam/Admin/AllPayments.dart';
import 'package:aarogyam/Admin/TestSamplesAll.dart';
import 'package:aarogyam/Doctor/DoctorHome.dart';
import 'package:aarogyam/Patient/PatentHome.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Admin/Medicines.dart';
import 'Patient/CreateOrder.dart';
import 'Patient/PatientMyPayments.dart';
import 'Patient/PatientMyProfile.dart';
import 'Admin/DoctorRecord.dart';
import 'Admin/PatientRecords.dart';
import 'Screens/Profile.dart';
import 'Admin/AdminHome.dart';
class CustomDrawer extends StatefulWidget{
  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}
class _CustomDrawerState extends State<CustomDrawer> {
  SharedPreferences preferences;
  String email = "";
  String type,userId;
  getUser()async{
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences = _preferences;
      email = _preferences.getString("userName");
      type =  _preferences.getString("UserType");
      userId =  _preferences.getString("userId");
    });
  }
  @override
  void initState() {
    getUser();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    if(type=="1"){
      return ListView(
        children: [
          GestureDetector(
            onTap:(){
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>AdminHome()));
            },
            child: Container(
              height: 115,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/logo.jpeg'),
                      fit: BoxFit.cover)
              ),
            ),
          ),
          ListTile(
            leading: CircleAvatar(
                child: Icon(Icons.person,color: Colors.white,)),
            title: Text("$email"),
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(builder:(context)=>ProfilePage()));
            },
          ),
          Divider(),
          ListTile(
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => AdminHome()));
            },
            title: Text("Home"),
            leading: Icon(Icons.home_outlined, color: Colors.deepOrange),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => PatRecord()));
            },
            title: Text("Patient"),
            leading: Icon(Icons.people_outline, color: Colors.deepOrange),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => DocRecord()));
            },
            title: Text("Doctor"),
            leading: SvgPicture.asset("assets/doctor.svg", color: Colors.deepOrange,height: 30,width: 30,),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => TestSampleAll()));
            },
            title: Text("Test Sample"),
            leading: SvgPicture.asset("assets/test-tube.svg", color: Colors.deepOrange,height: 30,width: 30),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => AllPayments()));
            },
            title: Text("Payments"),
            leading: SvgPicture.asset("assets/mobile-payment.svg", color: Colors.deepOrange,height: 30,width: 30),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => Testss()));
            },
            title: Text("Lab Tests"),
            leading: SvgPicture.asset("assets/test-tube.svg", color: Colors.deepOrange,height: 30,width: 30),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => Medicines()));
            },
            title: Text("Medicines"),
            leading: SvgPicture.asset("assets/medicine.svg", color: Colors.deepOrange,height: 30,width: 30),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => Orders()));
            },
            title: Text("Medicine Orders"),
            leading: SvgPicture.asset("assets/medicine.svg", color: Colors.deepOrange,height: 30,width: 30),
          ),
        ],
      );
    }else if(type=="2"){
      return ListView(
        children: [
          GestureDetector(
            onTap:(){
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>DoctorHome()));
            },
            child: Container(
              height: 115,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/logo.jpeg'),
                      fit: BoxFit.cover)
              ),
            ),
          ),
          ListTile(
            leading: CircleAvatar(
                child: Icon(Icons.person,color: Colors.white,)),
            title: Text("$email"),
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(builder:(context)=>ProfilePage()));
            },
          ),
          Divider(),
          ListTile(
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => DoctorHome()));
            },
            title: Text("Home"),
            leading: Icon(Icons.home_outlined, color: Colors.deepOrange),
          ),
          ListTile(
            onTap: ()async{
              SharedPreferences prefs = await SharedPreferences.getInstance();
              print(userId);
              http.post("http://www.notoutindia.com/aarogyam/api/GetDoctor?UserId=$userId",
                headers: {
                  "Authorization":prefs.getString('token'),
                },
              ).then((value) => {
                if(value.statusCode==200||value.statusCode==201){
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          DoctorMyProfile(snapshot: jsonDecode(value.body),)))
                }else{
                  print(jsonDecode(value.body))
                }
              });
            },
            title: Text("My Profile"),
            leading: Icon(Icons.person, color: Colors.deepOrange),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => DoctorMyPatientTestSample()));
            },
            title: Text("My Tests"),
            leading: Icon(Icons.people_outline, color: Colors.deepOrange),
          ),
        ],
      );
    }else{
     return ListView(
        children: [
          GestureDetector(
            onTap:(){
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>PatentHome()));
            },
            child: Container(
              height: 115,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/logo.jpeg'),
                      fit: BoxFit.cover)
              ),
            ),
          ),
          ListTile(
            leading: CircleAvatar(
                child: Icon(Icons.person,color: Colors.white,)),
            title: Text("$email"),
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(builder:(context)=>ProfilePage()));
            },
          ),
          Divider(),
          ListTile(
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => PatentHome()));
            },
            title: Text("Home"),
            leading: Icon(Icons.home_outlined, color: Colors.deepOrange),
          ),
          ListTile(
            onTap: ()async{
              SharedPreferences prefs = await SharedPreferences.getInstance();
              print(userId);
              http.post("http://www.notoutindia.com/aarogyam/api/GetPatient?UserId=$userId",
                headers: {
                  "Authorization":prefs.getString('token'),
                },
              ).then((value) => {
                if(value.statusCode==200||value.statusCode==201){
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          PatientMyProfile(snapshot: jsonDecode(value.body),
                          )),
                  ),
                }else{
                  print(jsonDecode(value.body))
                }
              });
            },
            title: Text("My Profile"),
            leading: Icon(Icons.person, color: Colors.deepOrange),
          ),
          ListTile(
            onTap: () async{
              Navigator.push(context, MaterialPageRoute(builder:(context)=>PatientDoctor()));
            },
            title: Text("Doctors"),
            leading: SvgPicture.asset("assets/doctor.svg", color: Colors.deepOrange,height: 30,width: 30),
          ),
          ListTile(
            onTap: () async{
              Navigator.push(context, MaterialPageRoute(builder:(context)=>PatientMyTest()));
            },
            title: Text("My Tests"),
            leading: SvgPicture.asset("assets/test-tube.svg", color: Colors.deepOrange,height: 30,width: 30),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => PatientMyPayments()));
            },
            title: Text("My Payments"),
            leading: SvgPicture.asset("assets/mobile-payment.svg", color: Colors.deepOrange,height: 30,width: 30),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => CreateOrder()));
            },
            title: Text("Order Medicines"),
            leading: SvgPicture.asset("assets/medicine.svg", color: Colors.deepOrange,height: 30,width: 30),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => MyOrders()));
            },
            title: Text("My Orders"),
            leading: SvgPicture.asset("assets/medicine.svg", color: Colors.deepOrange,height: 30,width: 30),
          ),
        ],
      );
    }
  }
}

