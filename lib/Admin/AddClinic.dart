import 'dart:convert';
import 'package:aarogyam/Admin/ViewDoctor.dart';
import 'package:aarogyam/Customloder.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:http/http.dart' as http;
import 'package:aarogyam/Admin/Medicines.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../custom_dropdown_formfield.dart';

class AddClinic extends StatefulWidget {
  @required final snapshot;
  const AddClinic({Key key, this.snapshot}) : super(key: key);
  @override
  _CreateMedicineState createState() => _CreateMedicineState();
}

class _CreateMedicineState extends State<AddClinic> {
  TextEditingController nameController = TextEditingController();
  TextEditingController labRateController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = new GlobalKey<FormState>();
  List data = [];
  DateTime date1,date2;
  bool submitting;
  @override
  void initState() {
    data = widget.snapshot['Clinics'];
    print(data);
    submitting = false;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
          title:Text("Add Clinic")
      ),
      body: Container(
        alignment: Alignment.center,
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            children: [
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
                    labelText: "Name",
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
                    labelText: "Address ",
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
                child: FlatButton.icon(
                    textColor: Colors.blueGrey,
                    color: Colors.white,
                    onPressed: () {
                      DatePicker.showTimePicker(context,
                          showTitleActions: true,
                          //minTime: DateTime(2000, 3, 5),
                          //maxTime: DateTime(2100, 6, 7),
                          onChanged: (date) {
                            setState(() {
                              date1 = date;
                            });
                            print('change $date');
                          }, onConfirm: (date) {
                            print('confirm $date');
                          },
                          currentTime: DateTime.now(), locale: LocaleType.en);
                    },
                    icon: Icon(Icons.calendar_today),
                    label: Text((date1!=null)?"Start Time : "+date1.hour.toString()+":"+date1.minute.toString():"Start Date",style: TextStyle(color: Colors.blueGrey),)),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal:15,vertical:5),
                child: FlatButton.icon(
                    textColor: Colors.blueGrey,
                    color: Colors.white,
                    onPressed: () {
                      DatePicker.showTimePicker(context,
                          showTitleActions: true,
                          //minTime: DateTime(2000, 3, 5),
                          //maxTime: DateTime(2100, 6, 7),
                          onChanged: (date) {
                            setState(() {
                              date2 = date;
                            });
                            print('change $date');
                          }, onConfirm: (date) {
                            print('confirm $date');
                          }, currentTime: DateTime.now(), locale: LocaleType.en);
                    },
                    icon: Icon(Icons.calendar_today),
                    label: Text((date2!=null)?"End Time : "+date2.hour.toString()+":"+date2.minute.toString():'End Date', style: TextStyle(color: Colors.blueGrey),)
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: (!submitting)?GestureDetector(
        onTap: ()async{
          Firebase.initializeApp();
          SharedPreferences prefs = await SharedPreferences.getInstance();
          print(prefs.getString('token'));
          if(date2!=null&&date2!=null) {
            if (_formKey.currentState.validate()) {
              setState(() {
                submitting = true;
              });
              data.add({
                "ClinicName": nameController.text.toString(),
                "ClinicAddress": labRateController.text.toString(),
                "TimeFrom": date1.hour.toString() + ":" +
                    date1.minute.toString() + ":" + date1.second.toString(),
                "TimeTo": date2.hour.toString() + ":" +
                    date2.minute.toString() + ":" + date2.second.toString(),
              });
              http.post(
                  "http://www.notoutindia.com/aarogyam/api/UpdateDoctor",
                  headers: {
                    "Authorization": prefs.getString('token'),
                  },
                  body: jsonEncode({
                    "Id": widget.snapshot['Id'].toString(),
                    "UserId": widget.snapshot['UserId'].toString(),
                    "Clinics": data,
                    "Name": widget.snapshot['Name'],
                    "Email": widget.snapshot['Email'],
                    "Password": "123456",
                    "PhoneNumber": widget.snapshot['PhoneNumber'],
                    //"ClinicAddress":caddrCont.text,
                    "Address": widget.snapshot['Address'],
                    "Specialization": widget.snapshot['Specialization'],
                    "Degree": widget.snapshot['Degree'],
                    "City": widget.snapshot['City'],
                    "PinCode": widget.snapshot['PinCode'],
                    "UpdatedDate": DateTime.now().toString(),
                    "UpdatedBy": prefs.getString('userId').toString(),
                  })
              ).then((value) =>
              {
                setState(() {
                  submitting = false;
                }),
                Navigator.pushReplacement(context, MaterialPageRoute(
                    builder: (context) =>
                        ViewDoctor(snapshot: widget.snapshot,)))
              });
            }
          }else{
            _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Please Select Time")));
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
          child: ColorLoader()
      ),
    );
  }
}
