import 'dart:convert';
import 'dart:typed_data';
import 'package:aarogyam/drawer.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:aarogyam/Screens/Payments.dart';
import 'package:intl/intl.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as IMG;
import 'package:aarogyam/Screens/Invoice.dart';
class ViewTestSample extends StatefulWidget {
  final snapshot;
  final patentSnapshot;
  const ViewTestSample({Key key, this.snapshot, this.patentSnapshot}) : super(key: key);
  @override
  _ViewTestSampleState createState() => _ViewTestSampleState();
}

class _ViewTestSampleState extends State<ViewTestSample> {
  Uint8List resizeImage(Uint8List data) {
    Uint8List resizedData = data;
    IMG.Image img = IMG.decodeImage(data);
    IMG.Image resized = IMG.copyResize(img,width:100,height:100);
    resizedData = IMG.encodeJpg(resized,quality:50);
    return resizedData;
  }
  Uint8List image;
  getDoctor(id)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    http.Response rr = await http.get("http://www.notoutindia.com/aarogyam/api/GetDoctor?Id=$id",
      headers: {
        "Authorization":prefs.getString('token'),
      },
    );
    return jsonDecode(rr.body);
  }
  @override
  void initState() {
    if(widget.snapshot['QRCode']!="QR") {
      image =
          Uint8List.fromList(jsonDecode(widget.snapshot['QRCode']).cast<int>());
    }
    super.initState();
  }
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Sample Test"),
        //title:Text(widget.patentSnapshot['Name']),
      ),
      drawer: Drawer(
        child: CustomDrawer()
      ),
      body:Container(
        child: ListView(
          children: [
            Container(
              padding: EdgeInsets.all(20),
              child: Table(
                border: TableBorder.all(width: 1.0,color: Colors.grey),
                children: [
                  TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Test Id"),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("${widget.snapshot['Id']}"),
                        )
                      ]
                  ),
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Created On"),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("${DateFormat("dd-MM-yyyy").format(DateFormat("yyyy-MM-dd hh:mm:ss").parse(widget.snapshot ['CreatedDate'])).toString()}"),
                    )
                  ]
                  ),
                  TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Created By"),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("${widget.snapshot['CreatedBy']}"),
                        )
                      ]
                  ),
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Doctor"),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      alignment: Alignment.centerLeft,
                      child: FutureBuilder(
                          future: getDoctor(widget.snapshot['DoctorId']),
                          builder: (context, snapshotdoc) {
                            if(snapshotdoc.connectionState!=ConnectionState.waiting) {
                              return Text("${snapshotdoc.data['Name']}",textAlign:TextAlign.justify,);
                            }else{
                              return Text( "${widget.snapshot['DoctorId']}",
                              textAlign:TextAlign.justify,
                              );
                            }
                          }
                      ),
                    ),
                  ]
                  ),TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Sample Taken By"),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("${widget.snapshot['SampleTakenBy']}"),
                    )
                  ]
                  ),TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Updated On"),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("${DateFormat("dd-MM-yyyy").format(DateFormat("yyyy-MM-dd hh:mm:ss").parse(widget.snapshot['UpdatedDate'])).toString()}"),
                    )
                  ]
                  ),
                ],
              ),
            ),
            Container(
              child: ListTile(
                title: Text("All Tests"),
                subtitle: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount:jsonDecode(widget.snapshot['Disease'])['disease'].length,
                    itemBuilder: (context,index){
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("${index+1}) ${jsonDecode(widget.snapshot['Disease'])['disease'][index]['Name']}"),
                      );
                    }
                ),
              ),
            ),
            Container(
              child: ListTile(
                title: Text("All Medicines"),
                subtitle: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount:jsonDecode(widget.snapshot['Disease'])['medicines'].length,
                    itemBuilder: (context,index){
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("${index+1}) ${jsonDecode(widget.snapshot['Disease'])['medicines'][index]['Name']}"),
                      );
                    }
                ),
              ),
            ),
            (widget.snapshot['QRCode']!="QR")?Container(
              height:200,
              margin: EdgeInsets.all(10),
              alignment: Alignment.center,
              child:Image.memory(image,fit:BoxFit.cover,height:200,)
            ):Container(
              child: FlatButton(
                onPressed: ()async{
                  Uint8List _code = await scanner.generateBarCode(widget.snapshot['Id']);
                  _code = resizeImage(_code);
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  http.post("http://www.notoutindia.com/aarogyam/api/UpdateTestSample",
                      headers: {
                        "Authorization":prefs.getString('token'),
                      },
                      body:jsonEncode({
                        'Id':widget.snapshot['Id'],
                        'PatientId': widget.snapshot['PatientId'].toString(),
                        'DoctorId': widget.snapshot['DoctorId'].toString(),
                        'Disease': widget.snapshot['Disease'].toString(),
                        'TestNameId':widget.snapshot['TestNameId'].toString(),
                        'SampleTakenDate': widget.snapshot['SampleTakenDate'].toString(),
                        'SampleTakenBy': widget.snapshot['SampleTakenBy'].toString(),
                        'CreatedDate': widget.snapshot['CreatedDate'].toString(),
                        'CreatedBy': widget.snapshot['CreatedBy'].toString(),
                        "QRCode":jsonEncode(_code).toString(),
                        "Status":widget.snapshot['Status'].toString(),
                        "ReportDate":DateTime.now().toString(),
                        "SampleReportId":"1",
                        "UpdatedDate": DateTime.now().toString(),
                        "UpdatedBy": "1",
                      })
                  ).then((value) => {
                    if(value.statusCode==200||value.statusCode==201){
                      _scaffoldKey.currentState.showSnackBar(
                          SnackBar(content: Text(jsonDecode(value.body)['message'].toString()))),
                    }else{
                      print(value.body),
                      _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(jsonDecode(value.body)['message'].toString()))),
                      setState(() {
                        //paying =false;
                      })
                    }
                  });
                },
                child: Text("Generate QR"),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom:4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: (){
                //Navigator.of(context).push(MaterialPageRoute(builder: (context)=>TestSample(snapshot:widget.snapshot)));
              },
              child: Card(
                color: Colors.red,
                child: Container(
                  height: 56,
                  width: MediaQuery.of(context).size.width*0.5-10,
                  alignment: Alignment.center,
                  child: Text("Upload Result",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                ),
              ),
            ),
            (widget.snapshot['Status'].toString()!="4")?GestureDetector(
              onTap: (){
                print(widget.snapshot['Status']);
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Payments(snapshot:widget.snapshot,patentSnapshot:widget.patentSnapshot)));
              },
              child: Card(
                color: Colors.green,
                child: Container(
                  height: 56,
                  width: MediaQuery.of(context).size.width*0.5-10,
                  alignment: Alignment.center,
                  child: Text("Bill Payments",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold)),
                ),
              ),
            ):GestureDetector(
              onTap: ()async{
                SharedPreferences prefs = await SharedPreferences.getInstance();
                http.get("http://www.notoutindia.com/aarogyam/api/GetPayments?PatientId=${widget.patentSnapshot['Id']}&TestSampleId=${widget.snapshot['Id']}",
                  headers: {
                    "Authorization":prefs.getString('token'),
                  },
                ).then((value) => {
                Navigator.push(context,MaterialPageRoute(builder:(context)=>Invoice(goBackHome:false,snapshot1:widget.snapshot,snapshot2: widget.patentSnapshot,data:{"trId":jsonDecode(value.body)[0]["TransactionId"].toString(),"getway":jsonDecode(value.body)[0]["Method"].toString(),"fees":jsonDecode(value.body)[0]["Amount"].toString()})))
                });
              },
              child: Card(
                color: Colors.green,
                child: Container(
                  height: 56,
                  width: MediaQuery.of(context).size.width*0.5-10,
                  alignment: Alignment.center,
                  child: Text("View Invoice",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
