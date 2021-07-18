import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:aarogyam/Admin/ViewTestSample.dart';

class ScanResult extends StatefulWidget {
  final data;
  const ScanResult({Key key, this.data}) : super(key: key);
  @override
  _ScanResultState createState() => _ScanResultState();
}

class _ScanResultState extends State<ScanResult> {
  @override
  void initState() {
    getData();
    super.initState();
  }
  getData()async{
    print("Scan Result : ${widget.data}");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    http.get(
        "http://www.notoutindia.com/aarogyam/api/TestSamples?Id=${widget.data}",
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
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.data}"),
      ),
    );
  }
}
