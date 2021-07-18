import 'dart:convert';
import 'package:aarogyam/Customloder.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:aarogyam/custom_dropdown_formfield.dart';
import 'package:recase/recase.dart';
import 'package:aarogyam/Admin/PatientRecords.dart';

class UpdatePatent extends StatefulWidget {
  final snapshot;
  const UpdatePatent({Key key, this.snapshot}) : super(key: key);
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
class _PatRegState extends State<UpdatePatent> {
  String gender="",blood="",quali="",lab="",name,lname,city,mob,age,email,addr,dise,comments,password,pin;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  Future f;
  bool adding;
  DateTime date1;
  TextEditingController nameCont = TextEditingController();
  TextEditingController lnameCont = TextEditingController();
  TextEditingController mobCont = TextEditingController();
  TextEditingController emailCont = TextEditingController();
  TextEditingController diseCont = TextEditingController();
  TextEditingController pinCont = TextEditingController();
  TextEditingController addrCont = TextEditingController();
  TextEditingController dobCont = TextEditingController();
  @override
  void initState() {
    f = fetchAlbum(int.parse(widget.snapshot['PinCode']));
    nameCont.text = widget.snapshot['Name'].toString().split(" ")[0];
    lnameCont.text = (widget.snapshot['Name'].toString().split(" ").length>1)?widget.snapshot['Name'].toString().split(" ")[1]:"Last Name";
    mobCont.text = widget.snapshot['PhoneNumber'].toString();
    emailCont.text = widget.snapshot['Email'];
    diseCont.text = widget.snapshot['Disease'];
    addrCont.text = widget.snapshot['Address'];
    gender = widget.snapshot['Gender'];
    quali = widget.snapshot['MaritalStatus'];
    dobCont.text = widget.snapshot['DOB'].toString();
    blood = widget.snapshot['BloodGroup'].toString();
    pinCont.text = widget.snapshot['PinCode'].toString();
    city = widget.snapshot['City'].toString();
    date1 = DateTime.parse(widget.snapshot['DOB']);
    adding = false;
    super.initState();
  }

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
        title: Text("Update Details",style: TextStyle(color: Colors.white),),
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
                  decoration: InputDecoration(
                    border: new OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(5),
                      ),
                    ),
                    labelText: "First Name",
                  ),
                  controller: nameCont,
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
                    labelText: "Last Name",
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
                  buildCounter: (BuildContext context, { int currentLength, int maxLength, bool isFocused }) => null,
                  decoration: InputDecoration(
                    border: new OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(5),
                      ),
                    ),
                    labelText: "Mobile No",
                  ),
                  validator: (val) {
                    if (val==null) {
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
                    labelText: "Email ID",
                  ),
                  controller: emailCont,
                  validator: (val) {
                    if (val==null) {
                      return 'Can not be empty';
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
                    labelText: "Pin",
                  ),
                  controller: pinCont,
                  onChanged:(value){
                    setState(() {
                      city="";
                      pin = value;
                      f = fetchAlbum(value);
                    });
                  },
                  validator: (val) {
                    if (val==null) {
                      return 'Can not be empty';
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
                  print(snapshot.data);
                  if (snapshot.connectionState!=ConnectionState.waiting) {
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal:15,vertical:5),
                      child: (snapshot.data[0]['Status']=='Success')?DropDownFormField(
                        hintText: 'City',
                        value: city,
                        onSaved: (value) {
                          setState(() {
                            city = value;
                          });
                        },
                        onChanged: (value) {
                          setState(() {
                            city = value;
                          });
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
              Container(
                margin: EdgeInsets.symmetric(horizontal:15,vertical:5),
                child: TextFormField(
                  autofocus: false,
                  controller: addrCont,
                  decoration: InputDecoration(
                    border: new OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(5),
                      ),
                    ),
                    labelText: "Address",
                  ),
                  onChanged:(value){
                    addr = value;
                  },
                  validator: (val) {
                    if (val==null) {
                      return 'Can not be empty';
                    } else {
                      return null;
                    }
                  },
                  keyboardType: TextInputType.streetAddress,
                ),
              ),//address
              GestureDetector(
                onTap: (){
                  DatePicker.showDatePicker(context,
                      showTitleActions: true,
                      minTime: DateTime(1900, 1, 12),
                      maxTime: DateTime(2100, 1, 12),
                      onChanged: (date) {
                        setState(() {
                          date1 = date;
                         // dateCont.text="${date1.day.toString()+"/"+date1.month.toString()+"/"+date1.year.toString()}";
                        });
                        print('change $date');
                      }, onConfirm: (date) {
                        print('confirm $date');
                      },
                      currentTime: DateTime.now(), locale: LocaleType.en);
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal:15,vertical:5),
                  child: TextFormField(
                    controller: dobCont,
                    enabled: false,
                    autofocus: false,
                    decoration: InputDecoration(
                      border: new OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(5),
                        ),
                      ),
                      hintText:(date1!=null)?"${date1.day.toString()+"/"+date1.month.toString()+"/"+date1.year.toString()}":"Select DOB",
                    ),
                    onChanged:(value){
                      age = value;
                    },
                    validator: (val) {
                      if (val==null) {
                        return 'Can not be empty';
                      } else {
                        return null;
                      }
                    },
                    keyboardType: TextInputType.number,
                  ),
                ),
              ),//age
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
                    labelText: "Disease",
                  ),
                  controller: diseCont,
                  validator: (val) {
                    if (val==null) {
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
                child: DropDownFormField(
                  hintText: 'Gender',
                  value: gender,
                  onSaved: (value) {
                    setState(() {
                      gender = value;
                    });
                  },
                  onChanged: (value) {
                    setState(() {
                      gender = value;
                    });
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
                  onSaved: (value) {
                    setState(() {
                      blood = value;
                    });
                  },
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
                  onSaved: (value) {
                    setState(() {
                      quali = value;
                    });
                  },
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
                onTap: ()async{
                  if(_formKey.currentState.validate()) {
                    setState(() {
                      adding = true;
                    });
                    Map m = {
                      "Id": widget.snapshot['Id'].toString(),
                      "UserId": widget.snapshot['UserId'].toString(),
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
                      "UpdatedDate":DateTime.now().toString(),
                      //"UpdatedBy":prefs.getString('userId'),
                    };
                    print(m);
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                   http.Response responce = await http.post("http://www.notoutindia.com/aarogyam/api/UpdatePatient",
                       headers: {
                         "Authorization":prefs.getString('token'),
                       },
                      body:jsonEncode({
                        "Id": widget.snapshot['Id'].toString(),
                        "UserId": widget.snapshot['UserId'].toString(),
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
                        "UpdatedDate":DateTime.now().toString(),
                        "UpdatedBy":prefs.getString('userId'),
                    }));
                   if(responce.statusCode!=200||responce.statusCode!=201){
                     setState(() {
                       adding = false;
                     });
                     print("print : ${jsonDecode(responce.body)['message']}");
                     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>PatRecord()));
                   }else{
                     setState(() {
                       adding = false;
                     });
                     _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Error: ${jsonDecode(responce.body)['message']}"),));
                   }
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
                  child: Text("UPDATE",style: TextStyle(color: Colors.white,fontSize:18,fontWeight: FontWeight.bold),),
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