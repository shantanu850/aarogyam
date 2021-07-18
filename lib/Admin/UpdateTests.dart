import 'dart:convert';
import 'package:aarogyam/Customloder.dart';
import 'package:http/http.dart' as http;
import 'package:aarogyam/Admin/Medicines.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../custom_dropdown_formfield.dart';

class UpdateTest extends StatefulWidget {
  @required final data;
  const UpdateTest({Key key, this.data}) : super(key: key);
  @override
  _CreateMedicineState createState() => _CreateMedicineState();
}

class _CreateMedicineState extends State<UpdateTest> {
  TextEditingController nameController = TextEditingController();
  TextEditingController labRateController = TextEditingController();
  TextEditingController rateController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = new GlobalKey<FormState>();
  String category;
  List<dynamic> data = [];
  bool submitting;
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
    labRateController.text = widget.data['LabRate'].toString();
    rateController.text = widget.data['NormalRate'].toString();
    nameController.text = widget.data['Name'].toString();
    category = widget.data['CategoryID'];
    getCategories();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Update Test"),
        //title:Text("${widget.data['Name']}")
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
                    labelText: "Lab Rate",
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
                    labelText: "Normal Rate",
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
            http.post("http://www.notoutindia.com/aarogyam/api/UpdateTest",
                headers: {
                  "Authorization":prefs.getString('token'),
                  "Content-Type": "application/json",
                },
                body:jsonEncode({
                  "Id":widget.data['Id'].toString(),
                  "CategoryID":category.toString(),
                  "Name":nameController.text,
                  "NormalRate":rateController.text,
                  "LabRate":labRateController.text,
                  "UpdatedDate":DateTime.now().toString(),
                  "UpdatedBy":prefs.getString('userId'),
                })
            ).then((value) => {
              setState(() {
                submitting = false;
              }),
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Medicines()))
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
          child: ColorLoader()
      ),
    );
  }
}
