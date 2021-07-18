import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:recase/recase.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:aarogyam/Customloder.dart';
import 'package:aarogyam/custom_dropdown_formfield.dart';
import 'package:aarogyam/Admin/PatientRecords.dart';

class PatReg extends StatefulWidget {
  @override
  _PatRegState createState() => _PatRegState();
}
class Data {
  final String massage;
  final String status;
  final Map data;

  Data({this.massage, this.status, this.data});

  factory Data.fromJson(json) {
    return Data(
      massage:json["Message"],
      status:json["Status"],
      data:json["PostOffice"],
    );
  }
}
class _PatRegState extends State<PatReg> {
  String gender="",blood="",quali="",lab="",name,lname,city,mob,age,email,addr,dise,comments,pin;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  TextEditingController nameCont = TextEditingController();
  TextEditingController lnameCont = TextEditingController();
  TextEditingController mobCont = TextEditingController();
  TextEditingController emailCont = TextEditingController();
  TextEditingController diseCont = TextEditingController();
  TextEditingController pinCont = TextEditingController();
  TextEditingController addrCont = TextEditingController();

  Future f;
  bool adding;
  @override
  void initState() {
    adding = false;
    f = fetchAlbum(110001);
    super.initState();
  }
  DateTime date1;
  Future fetchAlbum(pin) async {
    final response = await http.get('https://api.postalpincode.in/pincode/$pin');
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load album');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        title: Text("Patient Registration ",style: TextStyle(color: Colors.white),),
      ),
      body: Container(
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal:15,vertical:5),
                child: TextFormField(
                  autofocus: false,
                  controller: nameCont,
                  decoration: InputDecoration(
                    border: new OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(5),
                      ),
                    ),
                    hintText: "Name",
                  ),
                  validator: (val) {
                    if (val==null) {
                      return 'Can not be empty';
                    } else {
                      return null;
                    }
                  },
                  keyboardType: TextInputType.name,
                ),
              ),//name
              Container(
                margin: EdgeInsets.symmetric(horizontal:15,vertical:5),
                child: TextFormField(
                  autofocus: false,
                  decoration: InputDecoration(
                    border: new OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(5),
                      ),
                    ),
                    hintText: "Last Name",
                  ),
                  controller: lnameCont,
                  validator: (val) {
                    if (val==null) {
                      return 'Can not be empty';
                    } else {
                      return null;
                    }
                  },
                  keyboardType: TextInputType.name,
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal:15,vertical:5),
                child: TextFormField(
                  autofocus: false,
                  maxLength: 10,
                  buildCounter: (BuildContext context, { int currentLength, int maxLength, bool isFocused }) => null,
                  decoration: InputDecoration(
                    border: new OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(5),
                      ),
                    ),
                    hintText: "Mobile No",
                  ),
                  validator: (val) {
                    if (val.length!=10) {
                      return 'Can not be empty';
                    } else {
                      return null;
                    }
                  },
                  keyboardType: TextInputType.phone,
                  controller: mobCont,
                ),
              ),//mobile
              Container(
                margin: EdgeInsets.symmetric(horizontal:15,vertical:5),
                child: TextFormField(
                  autofocus: false,
                  decoration: InputDecoration(
                    border: new OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(5),
                      ),
                    ),
                    hintText: "Email ID",
                  ),
                  controller: emailCont,
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
                  keyboardType: TextInputType.emailAddress,
                ),
              ),//email
              Container(
                margin: EdgeInsets.symmetric(horizontal:15,vertical:5),
                child: TextFormField(
                  autofocus: false,
                  decoration: InputDecoration(
                    border: new OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(5),
                      ),
                    ),
                    hintText: "Disease",
                  ),
                  controller: diseCont,
                  validator: (val) {
                    if (val.length==0) {
                      return 'Can not be empty';
                    } else {
                      return null;
                    }
                  },
                  keyboardType: TextInputType.text,
                ),
              ),//dieases
              Container(
                margin: EdgeInsets.symmetric(horizontal:15,vertical:5),
                child: TextFormField(
                  autofocus: false,
                  decoration: InputDecoration(
                    border: new OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(5),
                      ),
                    ),
                    hintText: "Address",
                  ),
                  controller: addrCont,
                  validator: (val) {
                    if (val==null) {
                      return 'Can not be empty';
                    } else {
                      return null;
                    }
                  },
                  keyboardType: TextInputType.text,
                ),
              ),//address
              Container(
                margin: EdgeInsets.symmetric(horizontal:15,vertical:5),
                child: TextFormField(
                  autofocus: false,
                  decoration: InputDecoration(
                    border: new OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(5),
                      ),
                    ),
                    hintText: "Pin",
                  ),
                  onChanged:(value){
                    pin = value;
                    setState(() {
                      city="";
                      f = fetchAlbum(value);
                    });
                  },
                  controller: pinCont,
                  validator: (val) {
                    if (val.length!=6) {
                      return 'Invalid Pin';
                    } else {
                      return null;
                    }
                  },
                  keyboardType: TextInputType.number,
                ),
              ),
              FutureBuilder(
                future: f,
                builder:(BuildContext context,snapshot){
                  if (snapshot.connectionState!=ConnectionState.waiting) {
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal:15,vertical:5),
                      child: (snapshot.data[0]['Status']=='Success')?DropDownFormField(
                        hintText: 'City',
                        value: city,
                        onSaved: (value) {
                          //setState(() {
                          city = value;
                          //  });
                        },
                        onChanged: (value) {
                          // setState(() {
                          city = value;
                          // });
                        },
                        dataSource:snapshot.data[0]['PostOffice'],
                        textField: 'Name',
                        valueField: 'Name',
                      ):Text("Invalid Pincode"),
                    );
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
              GestureDetector(
                onTap: (){
                  DatePicker.showDatePicker(context,
                      showTitleActions: true,
                      minTime: DateTime(1900, 1, 12),
                      maxTime: DateTime(2100, 1, 12),
                      onConfirm: (date) {
                        date1 = date;
                        //  dateCont.text="${date1.day.toString()+"/"+date1.month.toString()+"/"+date1.year.toString()}";
                      },
                      currentTime: DateTime.now(), locale: LocaleType.en);
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal:15,vertical:5),
                  child: TextFormField(
                    autofocus: false,
                    enabled: false,
                    decoration: InputDecoration(
                      border: new OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(5),
                        ),
                      ),
                      hintText:(date1!=null)?"${date1.day.toString()+"/"+date1.month.toString()+"/"+date1.year.toString()}":"Select DOB",
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ),//age
              Container(
                margin: EdgeInsets.symmetric(horizontal:15,vertical:5),
                child: DropDownFormField(
                  hintText: 'Gender',
                  value: gender,
                  onSaved: (value) {
                    //setState(() {
                    gender = value;
                    //  });
                  },
                  onChanged: (value) {
                    //setState(() {
                    gender = value;
                    // });
                  },
                  dataSource: [
                    {
                      "display": "Male",
                      "value": "male",
                    },
                    {
                      "display": "Female",
                      "value": "female",
                    },
                    {
                      "display": "Others",
                      "value": "other",
                    },
                  ],
                  textField: 'display',
                  valueField: 'value',
                ),
              ),//gender
              Container(
                color: Colors.white,
                margin: EdgeInsets.symmetric(horizontal:15,vertical:5),
                child: DropDownFormField(
                  hintText: 'Blood Group',
                  value: blood,
                  onChanged: (value) {
                    setState(() {
                    blood = value;
                    });
                  },
                  dataSource: [
                    {
                      "display": "A+",
                      "value": "a+",
                    },
                    {
                      "display": "B+",
                      "value": "b+",
                    },
                    {
                      "display": "O+",
                      "value": "o+",
                    },
                    {
                      "display": "A-",
                      "value": "a-",
                    },
                    {
                      "display": "B-",
                      "value": "b-",
                    },
                    {
                      "display": "O-",
                      "value": "o-",
                    },
                    {
                      "display": "AB+",
                      "value": "ab+",
                    },
                    {
                      "display": "AB-",
                      "value": "ab-",
                    },
                  ],
                  textField: 'display',
                  valueField: 'value',
                ),
              ),//bgroup
              Container(
                margin: EdgeInsets.symmetric(horizontal:15,vertical:5),
                child: DropDownFormField(
                  hintText: 'Marital Status',
                  value: quali,
                  onChanged: (value) {
                    setState(() {
                    quali = value;
                    });
                  },
                  dataSource: [
                    {
                      "display": "Married",
                      "value": "married",
                    },
                    {
                      "display": "UnMarried",
                      "value": "unmarried",
                    },
                  ],
                  textField: 'display',
                  valueField: 'value',
                ),
              ),//maried
              (adding!=true)?GestureDetector(
                //[core/no-app] No Firebase App '[DEFAULT]' has been created - call
                onTap: ()async{
                  Firebase.initializeApp();
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  print(prefs.getString('token'));
                  if(_formKey.currentState.validate()) {
                    setState(() {
                      adding = true;
                    });
                    http.post("http://www.notoutindia.com/aarogyam/api/CreatePatient",
                        headers: {
                          "Authorization":prefs.getString('token'),
                          "Content-Type": "application/json",
                        },
                        body:jsonEncode({
                          "Name":nameCont.text.sentenceCase+" "+lnameCont.text.sentenceCase,
                          "Email":emailCont.text,
                          "PhoneNumber":mobCont.text,
                          "Address":addrCont.text,
                          "DOB":date1.toString(),
                          "MaritalStatus":quali,
                          "City": city,
                          "PinCode":pinCont.text,
                          "BloodGroup":blood,
                          "Gender":gender,
                          "Disease":diseCont.text,
                          "CreatedDate":DateTime.now().toString(),
                          "CreatedBy":prefs.getString('userId'),
                          "UpdatedBy":prefs.getString('userId'),
                        })
                    ).then((value) => {
                      print(jsonDecode(value.body)['message']),
                      if(jsonDecode(value.body)['message']=="Unable to register the user."){
                        setState(() {
                          adding = false;
                        }),
                        _scaffoldKey.currentState.showSnackBar(SnackBar(content:Text(jsonDecode(value.body)['message'])))
                      }else{
                        setState(() {
                          adding = false;
                        }),
                        FirebaseAuth.instance.createUserWithEmailAndPassword(email: emailCont.text, password: "password"),
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>PatRecord()))
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
                child: ColorLoader(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
