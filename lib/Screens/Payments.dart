import 'dart:convert';
import 'dart:io';
import 'package:aarogyam/Customloder.dart';
import 'package:aarogyam/drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'invoice.dart';

class Payments extends StatefulWidget {
  final snapshot;
  final patentSnapshot;
  const Payments({Key key, this.snapshot, this.patentSnapshot}) : super(key: key);
  @override
  _PaymentsState createState() => _PaymentsState();
}
class _PaymentsState extends State<Payments> {
  int selectindex = 0;
  List methods=[
    "cash",
    "google pay",
    "paytm",
    "phonepe",
    "upi",
    "online"
  ];
  List l = [
    Card(
      elevation: 5,
      child: Container(
        height: 250,
        width: 250,
        child: Column(
          children: [
            Image(image: AssetImage("assets/cash.png"),height:80,width: 80,fit:BoxFit.cover,),
          ],
        ),
      ),
    ),
    Card(
      elevation: 5,
      child: Container(
        height: 250,
        width: 250,
        child: Column(
          children: [
            Image(image: AssetImage("assets/gpay.webp"),height:80,width: 80,fit:BoxFit.cover,),
          ],
        ),
      ),
    ),
    Card(
      elevation: 5,
      child: Container(
        height: 250,
        width: 250,
        child: Column(
          children: [
            Image(image: AssetImage("assets/paytm.png"),height:80,width: 80,fit:BoxFit.cover,),
          ],
        ),
      ),
    ),
    Card(
      elevation: 5,
      child: Container(
        height: 250,
        width: 250,
        child: Column(
          children: [
            Image(image: AssetImage("assets/phone-pe.png"),height:80,width: 80,fit:BoxFit.cover,),
          ],
        ),
      ),
    ),
    Card(
      elevation: 5,
      child: Container(
        height: 250,
        width: 250,
        child: Column(
          children: [
            Image(image: AssetImage("assets/upi.webp"),height:80,width: 80,fit:BoxFit.cover,),
          ],
        ),
      ),
    ),
    Card(
      elevation: 5,
      child: Container(
        height: 250,
        width: 250,
        child: Column(
          children: [
            Image(image: AssetImage("assets/bank.png"),height:80,width: 80,fit:BoxFit.cover,),
          ],
        ),
      ),
    ),
  ];
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("${widget.patentSnapshot['Name']}"),
      ),
      drawer: Drawer(
        child: CustomDrawer(),
      ),
      body: Container(
        child:ListView(
          shrinkWrap: true,
          children: [
            Container(
              margin: EdgeInsets.all(10),
              child: GridView.builder(
                itemCount:l.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    child: Stack(
                      children: [
                        Container(
                          margin:EdgeInsets.all(8),
                          child: GestureDetector(
                              onTap: (){
                                setState(() {
                                  selectindex = index;
                                });
                              },
                              child:l[index]
                          ),
                        ),
                        (selectindex==index)?Container(
                            decoration: BoxDecoration(
                                border: Border.all(width:5,color: Colors.green),
                                borderRadius: BorderRadius.all(Radius.circular(10))
                            ),
                            alignment: Alignment.topRight,
                            child: Icon(CupertinoIcons.check_mark_circled_solid,color: Colors.green,size:30,)):Container(),
                      ],
                    ),
                  );
                },
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:3),
              ),
            ),
            (selectindex!=0)?PaymentComplete(snapshot:widget.snapshot,method:methods[selectindex],patentSnapshot:widget.patentSnapshot,scaffoldKey:_scaffoldKey,):PaymentCompleteCash(snapshot:widget.snapshot,method:methods[selectindex],patentSnapshot:widget.patentSnapshot,scaffoldKey:_scaffoldKey,),
          ],
        ),
      ),
    );
  }
}

class PaymentComplete extends StatefulWidget {
  final snapshot;
  final patentSnapshot;
  final scaffoldKey;
  final method;
  const PaymentComplete({Key key, this.snapshot, this.method, this.patentSnapshot, this.scaffoldKey}) : super(key: key);
  @override
  _PaymentCompleteState createState() => _PaymentCompleteState();
}
class _PaymentCompleteState extends State<PaymentComplete> {
  String transitionid,accNo,mob,status;
  List l;
  double fees;
  bool paying;
  File imageFile;
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  @override
  void initState() {
    paying = false;
    fees = 0.0;
    List _data = [];
    jsonDecode(widget.snapshot['Disease'])["disease"].forEach((element) {
      fees = fees + double.parse(element['NormalRate'].toString().replaceAll("?", "").replaceAll(",", ""));
    });
    jsonDecode(widget.snapshot['Disease'])["medicines"].forEach((element) {
      fees = fees + double.parse(element['NormalRate'].toString().replaceAll("?", "").replaceAll(",", ""));
    });
    print(fees);
    setState(() {
      l = _data;
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Form(
        key: _formKey,
        child: ListView(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal:15,vertical:5),
              child: TextFormField(
                enabled: false,
                decoration: InputDecoration(
                    border: new OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(5),
                      ),
                    ),
                    labelText:"${widget.patentSnapshot['Name']}"
                ),
                onChanged:(value){
                  transitionid = value;
                },
                validator: (val) {
                  if (val!=null) {
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
                decoration: InputDecoration(
                    border: new OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(5),
                      ),
                    ),
                    labelText:"Transaction ID"
                ),
                onChanged:(value){
                  transitionid = value;
                },
                validator: (val) {
                  if (val!=null) {
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
                decoration: InputDecoration(
                    border: new OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(5),
                      ),
                    ),
                    labelText:"Account No"
                ),
                onChanged:(value){
                  accNo = value;
                },
                validator: (val) {
                  if (val!=null) {
                    return 'Can not be empty';
                  } else {
                    return null;
                  }
                },
                keyboardType: TextInputType.number,
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal:15,vertical:5),
              child: TextFormField(
                enabled: false,
                decoration: InputDecoration(
                    border: new OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(5),
                      ),
                    ),
                    labelText:"Fees : $fees"
                ),
                onChanged:(value){
                  transitionid = value;
                },
                validator: (val) {
                  if (val!=null) {
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
                enabled: false,
                decoration: InputDecoration(
                    border: new OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(5),
                      ),
                    ),
                    labelText:"Mobile No : ${widget.patentSnapshot['PhoneNumber']}"
                ),
                onChanged:(value){
                  transitionid = value;
                },
                validator: (val) {
                  if (val!=null) {
                    return 'Can not be empty';
                  } else {
                    return null;
                  }
                },
                keyboardType: TextInputType.name,
              ),
            ),
            GestureDetector(
              onTap: ()async{
                var image = await ImagePicker.pickImage(source: ImageSource.gallery,imageQuality:50);
                setState(() {
                  imageFile = image;
                });
              },
              child: (imageFile==null)?Container(
                margin: EdgeInsets.all(15),
                padding: EdgeInsets.all(10),
                height: 60,
                decoration: BoxDecoration(
                    color: Colors.deepOrange,
                    borderRadius: BorderRadius.all(Radius.circular(5))
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_a_photo_outlined,color: Colors.white,),
                    SizedBox(width:5,),
                    Text("Upload Transaction Image",style: TextStyle(fontWeight: FontWeight.bold,color:Colors.white),),
                  ],
                ),
              ):Container(
                height:400,
                margin: EdgeInsets.all(15),
                child: (imageFile!=null)?
                Image(image:FileImage(imageFile),fit:BoxFit.cover):
                SizedBox(),
              ),
            ),
            (paying!=true)?GestureDetector(
              onTap: ()async{
                if(imageFile!=null) {
                  setState(() {
                    paying = true;
                  });
                  SharedPreferences prefs = await SharedPreferences
                      .getInstance();
                  var uri = Uri.parse(
                      "http://www.notoutindia.com/aarogyam/api/UploadImage");
                  var request = http.MultipartRequest('POST', uri)
                    ..files.add(await http.MultipartFile.fromPath(
                        'fileToUpload', imageFile.path));
                  request.headers.addAll({
                    "Authorization": prefs.getString('token'),
                  });
                  var value = await request.send();
                  String imageUrl;
                  print(value.statusCode);
                  if (value.statusCode == 200 || value.statusCode == 201) {
                    value.stream.transform(utf8.decoder).listen((url) {
                      imageUrl = jsonDecode(url)['ImageURL'];
                      print(imageUrl);
                      print(url);
                      print(imageUrl);
                      http.post(
                          "http://www.notoutindia.com/aarogyam/api/CreatePayment",
                          headers: {
                            "Authorization": prefs.getString('token'),
                            "Content-Type": "application/json",
                          },
                          body: jsonEncode({
                            "PatientId": widget.patentSnapshot['Id'],
                            "TestSampleId": widget.snapshot['Id'],
                            "Amount": fees.toString(),
                            "Method": widget.method,
                            "AccountNumber": accNo.toString(),
                            "MobileNumber": widget.patentSnapshot['PhoneNumber'],
                            "TransactionId": transitionid.toString(),
                            "PaymentDate": DateTime.now().toString(),
                            "PaymentTakenBy": prefs.getString('userId'),
                            "StatusID": "4",
                            "CreatedDate": DateTime.now().toString(),
                            "CreatedBy": prefs.getString('userId'),
                            "ImageURL": imageUrl
                          })
                      ).then((value) =>
                      {
                        if (value.statusCode == 200 || value.statusCode == 201) {
                          http.post(
                              "http://www.notoutindia.com/aarogyam/api/UpdateTestSample",
                              body: jsonEncode({
                                'Id': widget.snapshot['Id'],
                                'PatientId': widget.snapshot['PatientId'],
                                'DoctorId': widget.snapshot['DoctorId'],
                                'Disease': widget.snapshot['Disease'],
                                'TestNameId': widget.snapshot['TestNameId'],
                                'SampleTakenDate': widget
                                    .snapshot['SampleTakenDate'],
                                'SampleTakenBy': widget.snapshot['SampleTakenBy'],
                                'CreatedDate': widget.snapshot['CreatedDate'],
                                'CreatedBy': widget.snapshot['CreatedBy'],
                                "UpdatedDate": widget.snapshot['UpdatedDate'],
                                "UpdatedBy": widget.snapshot['UpdatedBy'],
                                "QRCode": widget.snapshot['QRCode'],
                                "Status": "4",
                                "ReportDate": widget.snapshot['ReportDate'],
                                "SampleReportId": widget
                                    .snapshot['SampleReportId'],
                              })
                          ).whenComplete(() =>
                          {
                            Navigator.push(
                                context, MaterialPageRoute(builder: (context) =>
                                Invoice(snapshot1: widget.snapshot,
                                    snapshot2: widget.patentSnapshot,
                                    data: {
                                      "trId":transitionid.toString(),
                                      "getway": widget.method,
                                      "fees": fees.toString()
                                    }))),
                          }),
                        } else
                          {
                            widget.scaffoldKey.currentState.showSnackBar(
                                SnackBar(content: Text("Failed"))),
                            setState(() {
                              paying = false;
                            }),
                          }
                      });
                    });
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
          ],
        ),
      ),
    );
  }
}

class PaymentCompleteCash extends StatefulWidget {
  final snapshot;
  final scaffoldKey;
  final patentSnapshot;
  final method;
  const PaymentCompleteCash({Key key, this.snapshot, this.method, this.patentSnapshot, this.scaffoldKey}) : super(key: key);
  @override
  _PaymentCompleteCashState createState() => _PaymentCompleteCashState();
}
class _PaymentCompleteCashState extends State<PaymentCompleteCash> {
  String transitionid,accNo,mob,status;
  double fees;
  List l;
  bool paying;
  File imageFile;
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  @override
  void initState() {
    fees = 0.0;
    paying =false;
    List _data = [];
    jsonDecode(widget.snapshot['Disease'])["disease"].forEach((element) {
      fees = fees + double.parse(element['NormalRate'].toString().replaceAll("?", "").replaceAll(",", ""));
    });
    jsonDecode(widget.snapshot['Disease'])["medicines"].forEach((element) {
      fees = fees + double.parse(element['NormalRate'].toString().replaceAll("?", "").replaceAll(",", ""));
    });
    print(fees);
    setState(() {
      l = _data;
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Form(
        key: _formKey,
        child: ListView(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal:15,vertical:5),
              child: TextFormField(
                enabled: false,
                decoration: InputDecoration(
                    border: new OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(5),
                      ),
                    ),
                    labelText:"${widget.patentSnapshot['Name']}"
                ),
                onChanged:(value){
                  //transitionid = value;
                },
                validator: (val) {
                  if (val!=null) {
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
                enabled: false,
                decoration: InputDecoration(
                    border: new OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(5),
                      ),
                    ),
                    labelText:"Transaction ID"
                ),
                onChanged:(value){
                  transitionid = value;
                },
                validator: (val) {
                  if (val!=null) {
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
                enabled:false,
                decoration: InputDecoration(
                    border: new OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(5),
                      ),
                    ),
                    labelText:"Account No"
                ),
                onChanged:(value){
                  accNo = value;
                },
                validator: (val) {
                  if (val!=null) {
                    return 'Can not be empty';
                  } else {
                    return null;
                  }
                },
                keyboardType: TextInputType.number,
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal:15,vertical:5),
              child: TextFormField(
                enabled: false,
                decoration: InputDecoration(
                    border: new OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(5),
                      ),
                    ),
                    labelText:"Fees : $fees"
                ),
                onChanged:(value){
                  //fees = value;
                },
                validator: (val) {
                  if (val!=null) {
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
                enabled: false,
                decoration: InputDecoration(
                    border: new OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(5),
                      ),
                    ),
                    labelText:"Mobile No : ${widget.patentSnapshot['PhoneNumber']}"
                ),
                onChanged:(value){
                  // transitionid = value;
                },
                validator: (val) {
                  if (val!=null) {
                    return 'Can not be empty';
                  } else {
                    return null;
                  }
                },
                keyboardType: TextInputType.name,
              ),
            ),
            GestureDetector(
              onTap: ()async{
                var image = await ImagePicker.pickImage(source: ImageSource.gallery,imageQuality:50);
                setState(() {
                  imageFile = image;
                });
              },
              child: (imageFile==null)?Container(
                margin: EdgeInsets.all(15),
                padding: EdgeInsets.all(10),
                height: 60,
                decoration: BoxDecoration(
                    color: Colors.deepOrange,
                  borderRadius: BorderRadius.all(Radius.circular(5))
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_a_photo_outlined,color: Colors.white,),
                    SizedBox(width:5,),
                    Text("Upload Transaction Image",style: TextStyle(fontWeight: FontWeight.bold,color:Colors.white),),
                  ],
                ),
              ):Container(
              height:400,
                margin: EdgeInsets.all(15),
              child: (imageFile!=null)?
              Image(image:FileImage(imageFile),fit:BoxFit.cover):
              SizedBox(),
            ),
            ),
            (paying==false)?GestureDetector(
              onTap: ()async{
                if(imageFile!=null) {
                  setState(() {
                    paying = true;
                  });
                  SharedPreferences prefs = await SharedPreferences
                      .getInstance();
                  var uri = Uri.parse(
                      "http://www.notoutindia.com/aarogyam/api/UploadImage");
                  var request = http.MultipartRequest('POST', uri)
                    ..files.add(await http.MultipartFile.fromPath(
                        'fileToUpload', imageFile.path));
                  request.headers.addAll({
                    "Authorization": prefs.getString('token'),
                  });
                  var value = await request.send();
                  String imageUrl;
                  print(value.statusCode);
                  if (value.statusCode == 200 || value.statusCode == 201) {
                    value.stream.transform(utf8.decoder).listen((url) {
                      imageUrl = jsonDecode(url)['ImageURL'];
                      print(imageUrl);
                      print(url);
                    print(imageUrl);
                    http.post(
                        "http://www.notoutindia.com/aarogyam/api/CreatePayment",
                        headers: {
                          "Authorization": prefs.getString('token'),
                          "Content-Type": "application/json",
                        },
                        body: jsonEncode({
                          "PatientId": widget.patentSnapshot['Id'],
                          "TestSampleId": widget.snapshot['Id'],
                          "Amount": fees.toString(),
                          "Method": widget.method,
                          "AccountNumber": "0000000000",
                          "MobileNumber": widget.patentSnapshot['PhoneNumber'],
                          "TransactionId": "0000000000",
                          "PaymentDate": DateTime.now().toString(),
                          "PaymentTakenBy": prefs.getString('userId'),
                          "StatusID": "4",
                          "CreatedDate": DateTime.now().toString(),
                          "CreatedBy": prefs.getString('userId'),
                          "ImageURL": imageUrl
                        })
                    ).then((value) =>
                    {
                      if (value.statusCode == 200 || value.statusCode == 201) {
                        http.post(
                            "http://www.notoutindia.com/aarogyam/api/UpdateTestSample",
                            body: jsonEncode({
                              'Id': widget.snapshot['Id'],
                              'PatientId': widget.snapshot['PatientId'],
                              'DoctorId': widget.snapshot['DoctorId'],
                              'Disease': widget.snapshot['Disease'],
                              'TestNameId': widget.snapshot['TestNameId'],
                              'SampleTakenDate': widget
                                  .snapshot['SampleTakenDate'],
                              'SampleTakenBy': widget.snapshot['SampleTakenBy'],
                              'CreatedDate': widget.snapshot['CreatedDate'],
                              'CreatedBy': widget.snapshot['CreatedBy'],
                              "UpdatedDate": widget.snapshot['UpdatedDate'],
                              "UpdatedBy": widget.snapshot['UpdatedBy'],
                              "QRCode": widget.snapshot['QRCode'],
                              "Status": "4",
                              "ReportDate": widget.snapshot['ReportDate'],
                              "SampleReportId": widget
                                  .snapshot['SampleReportId'],
                            })
                        ).whenComplete(() =>
                        {
                          Navigator.push(
                              context, MaterialPageRoute(builder: (context) =>
                              Invoice(snapshot1: widget.snapshot,
                                  snapshot2: widget.patentSnapshot,
                                  data: {
                                    "trId":"0000000000",
                                    "getway": widget.method,
                                    "fees": fees.toString()
                                  }))),
                        }),
                      } else
                        {
                          widget.scaffoldKey.currentState.showSnackBar(
                              SnackBar(content: Text("Failed"))),
                          setState(() {
                            paying = false;
                          }),
                        }
                    });
                    });
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
          ],
        ),
      ),
    );
  }
}
