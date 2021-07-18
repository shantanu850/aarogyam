import 'package:aarogyam/Patient/PatentHome.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TermsAndCond extends StatefulWidget {
  @override
  _TermsAndCondState createState() => _TermsAndCondState();
}

class _TermsAndCondState extends State<TermsAndCond> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Terms & Conditions"),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Text("Terms and Conditions agreements act as a legal contract between you (the company) who has the website or mobile app and the user who access your website and mobile app.Having a Terms and Conditions agreement is completely optional. No laws require you to have one. Not even the super-strict and wide-reaching General Data Protection Regulation (GDPR). It's up to you to set the rules and guidelines that the user must agree to. You can think of your Terms and Conditions agreement as the legal agreement where you maintain your rights to exclude users from your app in the event that they abuse your app, where you maintain your legal rights against potential app abusers, and so on."),
      ),
      bottomNavigationBar: GestureDetector(
        onTap: ()async{
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setBool("terms", true);
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>PatentHome()));
        },
        child: Container(
          height: 56,
          margin: EdgeInsets.all(10),
          color: Colors.deepOrange,
          alignment: Alignment.center,
          child: Text("Accept Terms and Conditions",style: TextStyle(color: Colors.white),),
        ),
      ),
    );
  }
}
