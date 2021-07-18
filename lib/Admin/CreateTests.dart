import 'dart:convert';
import 'package:aarogyam/Admin/Tests.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../Customloder.dart';
import '../custom_dropdown_formfield.dart';

class CreateTests extends StatefulWidget {
  @override
  _CreateTestsState createState() => _CreateTestsState();
}

class _CreateTestsState extends State<CreateTests> {
  TextEditingController nameController = TextEditingController();
  TextEditingController labRateController = TextEditingController();
  TextEditingController rateController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = new GlobalKey<FormState>();
  String category;
  bool submitting;
  List data = [];
  getCategories()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    http.Response responce = await http.get("http://www.notoutindia.com/aarogyam/api/GetCategories",headers: {
      "Authorization":prefs.getString('token'),
    });
    List _data = jsonDecode(responce.body);
    setState(() {
      data = _data;
    });
    return jsonDecode(responce.body);
  }
  @override
  void initState() {
    submitting = false;
    getCategories();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Create Test"),
      ),
      body: Container(
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal:15,vertical:5),
                child: DropDownFormField(
                  required: true,
                  hintText: 'Select Category',
                  value: category,
                  onSaved: (value) {
                    setState(() {
                      category = value;
                    });
                  },
                  onChanged: (value) {
                    setState(() {
                      category = value;
                    });
                  },
                  dataSource: data,
                  textField: 'Name',
                  valueField: 'Id',
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal:15,vertical:5),
                child: TextFormField(
                  autofocus: false,
                  decoration: InputDecoration(
                    border:OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(5),
                      ),
                    ),
                    hintText: "Name",
                  ),
                  controller: nameController,
                  validator: (val) {
                    if (val==null) {
                      return 'Can not be empty';
                    } else {
                      return null;
                    }
                  },
                  keyboardType: TextInputType.text,
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal:15,vertical:5),
                child: TextFormField(
                  autofocus: false,
                  decoration: InputDecoration(
                    border:OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(5),
                      ),
                    ),
                    hintText: "Lab Rate",
                  ),
                  controller: labRateController,
                  validator: (val) {
                    if (val==null) {
                      return 'Can not be empty';
                    } else {
                      return null;
                    }
                  },
                  keyboardType: TextInputType.text,
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal:15,vertical:5),
                child: TextFormField(
                  autofocus: false,
                  decoration: InputDecoration(
                    border:OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(5),
                      ),
                    ),
                    hintText: "Normal Rate",
                  ),
                  controller: rateController,
                  validator: (val) {
                    if (val==null) {
                      return 'Can not be empty';
                    } else {
                      return null;
                    }
                  },
                  keyboardType: TextInputType.text,
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: (!submitting)?GestureDetector(
        onTap: ()async{
          setState(() {
            submitting = true;
          });
          Firebase.initializeApp();
          SharedPreferences prefs = await SharedPreferences.getInstance();
          print(prefs.getString('token'));
          if(_formKey.currentState.validate()) {
            http.post("http://www.notoutindia.com/aarogyam/api/CreateTest",
                headers: {
                  "Authorization":prefs.getString('token'),
                  "Content-Type": "application/json",
                },
                body:jsonEncode({
                  "CategoryID":category.toString(),
                  "Name":nameController.text,
                  "NormalRate":rateController.text,
                  "LabRate":labRateController.text,
                  "CreatedDate":DateTime.now().toString(),
                  "CreatedBy":prefs.getString('userId'),
                })
            ).then((value) => {
              setState(() {
                submitting = false;
              }),
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Testss()))
            });
          }
        },
        child:Container(
          height: 56,
          width: MediaQuery.of(context).size.width*0.9,
          alignment: Alignment.center,
          margin: EdgeInsets.symmetric(horizontal:10,vertical:15),
          decoration: BoxDecoration(
              color: Colors.deepOrange,
              borderRadius: BorderRadius.all(Radius.circular(5))
          ),
          child: Text("SUBMIT",style: TextStyle(color: Colors.white,fontSize:18,fontWeight: FontWeight.bold),),
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
          child:ColorLoader()
      ),
    );
  }
}

