import 'dart:convert';
import 'dart:typed_data';
import 'package:aarogyam/Admin/ViewPatent.dart';
import 'package:aarogyam/Patient/OrderAddress.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:aarogyam/Customloder.dart';
import 'package:aarogyam/custom_dropdown_formfield.dart';
import 'package:aarogyam/drawer.dart';
import 'package:http/http.dart' as http;
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:image/image.dart' as IMG;

class CreateOrder extends StatefulWidget {
  const CreateOrder({Key key}) : super(key: key);
  @override
  _TestSampleState createState() => _TestSampleState();
}

class _TestSampleState extends State<CreateOrder> {
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
  initState(){
    super.initState();
    paying = false;
    getMedicines();
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
        title: Text("Order Medicines",style: TextStyle(color: Colors.white),),
      ),
      body: Container(
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
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
            Text("Total AmountTo be paid : $medSum"),
            (paying==false)?GestureDetector(
                onTap: ()async{
                  setState(() {
                    paying =true;
                  });
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  http.post("http://notoutindia.com/aarogyam/api/GetPatient?UserId=${prefs.getString("userId")}",).then((value1) => {
                        if(value1.statusCode==200||value1.statusCode==201){
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>OrderAddress(snapshot:jsonDecode(value1.body),medSum:medSum,mList: mList,)))
                        }else{
                          _scaffoldKey.currentState.showSnackBar(
                              SnackBar(content: Text(jsonDecode(value1.body)['message'].toString()))),
                          setState(() {
                            paying =false;
                          })
                        }
                      });
                    setState(() {
                      paying =false;
                    });
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
                  child: Text("Continue",style: TextStyle(color: Colors.white,fontSize:18,fontWeight: FontWeight.bold),),
                )
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
//>flutter build apk --no-tree-shake-icons