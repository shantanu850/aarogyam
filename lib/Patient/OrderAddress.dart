import 'dart:convert';
import 'package:aarogyam/Customloder.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:aarogyam/custom_dropdown_formfield.dart';
import 'package:recase/recase.dart';
import 'package:aarogyam/Admin/PatientRecords.dart';

class OrderAddress extends StatefulWidget {
  final snapshot;
  final medSum;
  final mList;
  const OrderAddress({Key key, this.snapshot, this.medSum, this.mList}) : super(key: key);
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
class _PatRegState extends State<OrderAddress> {
  String name,lname,city,mob,email,addr,pin;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  Future f;
  bool adding;
  DateTime date1;
  TextEditingController mobCont = TextEditingController();
  TextEditingController alt_mobCont = TextEditingController();
  TextEditingController pinCont = TextEditingController();
  TextEditingController addrCont = TextEditingController();
  TextEditingController distCont = TextEditingController();
  TextEditingController hnoCont = TextEditingController();
  TextEditingController landCont = TextEditingController();
  @override
  void initState() {
    f = fetchAlbum(int.parse(widget.snapshot['PinCode']));
    mobCont.text = widget.snapshot['PhoneNumber'].toString();
    addrCont.text = widget.snapshot['Address'];
    pinCont.text = widget.snapshot['PinCode'].toString();
    city = widget.snapshot['City'].toString();
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
        title: Text("Confirm Address",style: TextStyle(color: Colors.white),),
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
                  buildCounter: (BuildContext context, { int currentLength, int maxLength, bool isFocused }) => null,
                  decoration: InputDecoration(
                    border: new OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(5),
                      ),
                    ),
                    labelText: "Alternet Mobile No",
                  ),
                  validator: (val) {
                    if (val==null) {
                      return 'Can not be empty';
                    } else {
                      return null;
                    }
                  },
                  keyboardType: TextInputType.phone,
                  controller: alt_mobCont,
                ),
              ),
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
                  controller: distCont,
                  decoration: InputDecoration(
                    border: new OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(5),
                      ),
                    ),
                    labelText: "District",
                  ),
                  validator: (val) {
                    if (val==null) {
                      return 'Can not be empty';
                    } else {
                      return null;
                    }
                  },
                  keyboardType: TextInputType.streetAddress,
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal:15,vertical:5),
                child: TextFormField(
                  autofocus: false,
                  controller: hnoCont,
                  decoration: InputDecoration(
                    border: new OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(5),
                      ),
                    ),
                    labelText: "House Number",
                  ),
                  validator: (val) {
                    if (val==null) {
                      return 'Can not be empty';
                    } else {
                      return null;
                    }
                  },
                  keyboardType: TextInputType.streetAddress,
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal:15,vertical:5),
                child: TextFormField(
                  autofocus: false,
                  controller: landCont,
                  decoration: InputDecoration(
                    border: new OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(5),
                      ),
                    ),
                    labelText: "LandMark",
                  ),
                  validator: (val) {
                    if (val==null) {
                      return 'Can not be empty';
                    } else {
                      return null;
                    }
                  },
                  keyboardType: TextInputType.streetAddress,
                ),
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
              (adding!=true)?GestureDetector(
                onTap: ()async{
                  if(_formKey.currentState.validate()) {
                    setState(() {
                      adding = true;
                    });
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    http.Response responce = await
                    http.post("http://www.notoutindia.com/aarogyam/api/CreateOrder",
                        body:jsonEncode({
                          "PatientId":"${prefs.getString("userId")}",
                          "MedicineCategoryId":"1",
                          "MedicineIds":jsonEncode(widget.mList),
                          "PinCode":"${pinCont.text}",
                          "HouseNumber":"${hnoCont.text}",
                          "City":"$city",
                          "District":"${distCont.text}",
                          "Landmark":"${landCont.text}",
                          "Address":"${addrCont.text}",
                          "PhoneNumber":"${mobCont.text}",
                          "AlternatePhone":"${alt_mobCont.text}",
                          "TotalAmount":"${widget.medSum}",
                          "DeliveryDate":DateTime.now().toString(),
                          "Email":"${prefs.getString("userEmail")}",
                          "CreatedDate":DateTime.now().toString(),
                          "CreatedBy":"${prefs.getString("userId")}",
                          "status":"Pending"
                        }));
                    if(responce.statusCode==200||responce.statusCode==201){
                      setState(() {
                        adding = false;
                      });
                      print("print : ${jsonDecode(responce.body)['message']}");
                      Navigator.pop(context);
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
                  child: Text("Place Order",style: TextStyle(color: Colors.white,fontSize:18,fontWeight: FontWeight.bold),),
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