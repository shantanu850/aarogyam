import 'dart:convert';
import 'dart:typed_data';
import 'package:aarogyam/Admin/ViewPatent.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:aarogyam/Customloder.dart';
import 'package:aarogyam/custom_dropdown_formfield.dart';
import 'package:aarogyam/drawer.dart';
import 'package:http/http.dart' as http;
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:image/image.dart' as IMG;

class TestSample extends StatefulWidget {
  final snapshot;
  const TestSample({Key key, this.snapshot}) : super(key: key);
  @override
  _TestSampleState createState() => _TestSampleState();
}

class _TestSampleState extends State<TestSample> {
  String disease="",doctor="";
  List dList=[],mList=[];
  bool  paying;
  List data=[],data1=[],dataMed=[];
  Uint8List resizeImage(Uint8List data) {
    Uint8List resizedData = data;
    IMG.Image img = IMG.decodeImage(data);
    IMG.Image resized = IMG.copyResize(img,width:100,height:100);
    resizedData = IMG.encodeJpg(resized,quality:50);
    return resizedData;
  }
  getTests()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    http.Response responce = await http.get("http://www.notoutindia.com/aarogyam/api/GetTestRates",headers: {
      "Authorization":prefs.getString('token'),
    });
    List _data = jsonDecode(responce.body);
    print(jsonDecode(responce.body));
    List dota = [];
    _data.forEach((element) {
      dota.add({
        'data':element,
        'Test':element['Name'],
        'NormalRate':double.parse(element['NormalRate'].toString().replaceAll("?","").replaceAll(",", ""))
      });
    });
    setState(() {
      data = dota;
    });
    return jsonDecode(responce.body);
  }
  getMedicines()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    http.Response responce = await http.get("http://www.notoutindia.com/aarogyam/api/GetMedicines",headers: {
      "Authorization":prefs.getString('token'),
    });
    List _data = jsonDecode(responce.body);
    print(jsonDecode(responce.body));
    List dota = [];
    _data.forEach((element) {
      dota.add({
        'data':element,
        'Test':element['Name'],
        'NormalRate':double.parse(element['NormalRate'].toString().replaceAll("?","").replaceAll(",", ""))
      });
    });
    setState(() {
      dataMed = dota;
    });
    return jsonDecode(responce.body);
  }
  Future getData()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getString('token'));
    http.Response response = await http.get("http://www.notoutindia.com/aarogyam/api/Doctors",headers:{
      "Authorization":prefs.getString('token'),
    });
    List _data = jsonDecode(response.body);
    print(_data);
    List dota = [];
    _data.forEach((element) {
      dota.add({
        'Name':element['Name'],
        'Id':element['Id'].toString(),
      });
    });
    setState(() {
      data1 = dota;
    });
    return jsonDecode(response.body);
  }
  initState(){
    super.initState();
    paying = false;
    getTests();
    getData();
    getMedicines();
    print(widget.snapshot['Id']);
  }
  double sum=0.0;
  double medSum = 0.0;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
          child: CustomDrawer()
      ),
      appBar: AppBar(
        title: Text("${widget.snapshot['Name']}",style: TextStyle(color: Colors.white),),
      ),
      body: Container(
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal:15,vertical:5),
                child: DropDownFormField(
                  hintText: 'Doctor',
                  value: doctor,
                  onChanged: (value) {
                    setState(() {
                      doctor = value;
                    });
                  },
                  dataSource: data1,
                  textField: 'Name',
                  valueField: 'Id',
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal:15,vertical:5),
                child: DropDownFormField(
                  hintText: 'Select Test',
                  value: disease,
                  onSaved: (value) {
                    setState(() {
                      //   disease = value['Test'];
                    });
                  },
                  onChanged: (value) {
                    setState(() {
                      dList.add(value);
                      print(dList);
                      sum = 0.0;
                      dList.forEach((element) {
                        sum = sum + double.parse(element['NormalRate'].toString().replaceAll("?", "").replaceAll(",", ""));
                      });
                      print(sum);
                    });
                  },
                  dataSource: data,
                  textField: 'Test',
                  valueField: 'data',
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal:15,vertical:5),
                child: DropDownFormField(
                  hintText: 'Select Medicine',
                  value: disease,
                  onSaved: (value) {
                    setState(() {
                      //   disease = value['Test'];
                    });
                  },
                  onChanged: (value) {
                    setState(() {
                      mList.add(value);
                      print(mList);
                      medSum = 0.0;
                      mList.forEach((element) {
                        medSum = medSum + double.parse(element['NormalRate'].toString().replaceAll("?", "").replaceAll(",", ""));
                      });
                      print(medSum);
                    });
                  },
                  dataSource: dataMed,
                  textField: 'Test',
                  valueField: 'data',
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: dList.length,
                itemBuilder: (context,index){
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal:8.0),
                    child: Card(
                      child: ListTile(
                        title:Text("${dList[index]['Name']}"),
                        subtitle:Text("${dList[index]['NormalRate'].toString().replaceAll("?", "").replaceAll(",", "")}") ,
                        trailing: IconButton(icon: Icon(Icons.close), onPressed:(){
                          setState(() {
                            dList.removeAt(index);
                            sum = 0.0;
                            dList.forEach((element) {
                              sum = sum + double.parse(element['NormalRate'].toString().replaceAll("?", "").replaceAll(",", ""));
                            });
                            print(sum);
                          });
                        }),
                      ),
                    ),
                  );
                },
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: mList.length,
                itemBuilder: (context,index){
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal:8.0),
                    child: Card(
                      child: ListTile(
                        title:Text("${mList[index]['Name']}"),
                        subtitle:Text("${mList[index]['NormalRate'].toString().replaceAll("?", "").replaceAll(",", "")}") ,
                        trailing: IconButton(icon: Icon(Icons.close), onPressed:(){
                          setState(() {
                            mList.removeAt(index);
                            medSum = 0.0;
                            mList.forEach((element) {
                              medSum = medSum + double.parse(element['NormalRate'].toString().replaceAll("?", "").replaceAll(",", ""));
                            });
                            print(medSum);
                          });
                        }),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 120,
        child: Column(
          children: [
            Text("Total AmountTo be paid : ${sum+medSum}"),
            (paying==false)?GestureDetector(
                onTap: ()async{
                  setState(() {
                    paying =true;
                  });
                  Uint8List code;
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  http.post(
                      "http://www.notoutindia.com/aarogyam/api/CreateTestSample",
                      headers: {
                        "Content-Type":"application/json",
                        "Authorization":prefs.getString('token'),
                      },
                      body:jsonEncode({
                        'PatientId': widget.snapshot['Id'].toString(),
                        'DoctorId': doctor.toString(),
                        'Disease': jsonEncode({"disease":dList,"medicines":mList,}).toString(),
                        'TestNameId':widget.snapshot['Id'].toString(),
                        'SampleTakenDate': DateTime.now().toString().toString(),
                        'SampleTakenBy': prefs.getString('userId').toString(),
                        'CreatedDate':DateTime.now().toString().toString(),
                        'CreatedBy': prefs.getString('userId'),
                        "UpdatedDate": DateTime.now().toString().toString(),
                        "UpdatedBy":prefs.getString('userId'),
                        "QRCode":"QR",
                        "Status":"2",
                        "ReportDate":DateTime.now().toString().toString(),
                        "SampleReportId":widget.snapshot['Id'],
                      })
                  ).then((value) async => {
                    print(jsonDecode(value.body)),
                    if(value.statusCode==200||value.statusCode==201){
                      code = await scanner.generateBarCode(jsonDecode(value.body)['CreatedId'].toString()),
                      code = resizeImage(code),
                      http.post("http://www.notoutindia.com/aarogyam/api/UpdateTestSample",
                          body:jsonEncode({
                            'Id':jsonDecode(value.body)['CreatedId'],
                            'PatientId': widget.snapshot['Id'].toString(),
                            'DoctorId': doctor.toString(),
                            'Disease': jsonEncode({"disease":dList,"medicines":mList,}).toString(),
                            'TestNameId':widget.snapshot['Id'].toString(),
                            'SampleTakenDate': DateTime.now().toString().toString(),
                            'SampleTakenBy': prefs.getString('userId').toString(),
                            'CreatedDate':DateTime.now().toString().toString(),
                            'CreatedBy': prefs.getString('userId'),
                            "UpdatedDate": DateTime.now().toString().toString(),
                            "UpdatedBy":prefs.getString('userId'),
                            "QRCode":code.toString(),
                            "Status":"2",
                            "ReportDate":DateTime.now().toString().toString(),
                            "SampleReportId":widget.snapshot['CreatedId'],
                          })
                      ).then((value1) => {
                        if(value1.statusCode==200||value1.statusCode==201){
                          Navigator.pushReplacement(context,MaterialPageRoute(builder:(context)=>ViewPatent(snapshot:widget.snapshot))),
                        }else{
                          _scaffoldKey.currentState.showSnackBar(
                              SnackBar(content: Text(jsonDecode(value1.body)['message'].toString()))),
                          setState(() {
                            paying =false;
                          })
                        }
                      })
                    }else{
                      setState(() {
                        paying =false;
                      }),
                      _scaffoldKey.currentState.showSnackBar(
                          SnackBar(content: Text(jsonDecode(value.body)['message'].toString())))
                    },
                    setState(() {
                      paying =false;
                    })
                  });
                },
                child: Container(
                  height: 56,
                  width: MediaQuery.of(context).size.width*0.9,
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(horizontal:10,vertical:15),
                  decoration: BoxDecoration(
                      color: Colors.deepOrange,
                      borderRadius: BorderRadius.all(Radius.circular(25))
                  ),
                  child: Text("GENERATE QR & SUBMIT",style: TextStyle(color: Colors.white,fontSize:18,fontWeight: FontWeight.bold),),
                )
            ):Container(
                height: 56,
                width: MediaQuery.of(context).size.width*0.9,
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal:10,vertical:15),
                decoration: BoxDecoration(
                    color: Colors.deepOrange,
                    borderRadius: BorderRadius.all(Radius.circular(25))
                ),
                child: ColorLoader()
            ),
          ],
        ),
      ),
    );
  }
}
//>flutter build apk --no-tree-shake-icons