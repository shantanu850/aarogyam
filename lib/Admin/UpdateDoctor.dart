import 'dart:convert';
import 'package:aarogyam/Customloder.dart';
import 'package:aarogyam/Admin/DoctorRecord.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:recase/recase.dart';
import 'package:aarogyam/custom_dropdown_formfield.dart';

class UpdateDoctor extends StatefulWidget {
  final snapshot;
  const UpdateDoctor({Key key, this.snapshot}) : super(key: key);
  @override
  _DocRegState createState() => _DocRegState();
}

class _DocRegState extends State<UpdateDoctor> {
  String quali="",name,mob,spc,email="",addr,Cname,lname;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  TextEditingController qualiCont = TextEditingController();
  TextEditingController nameCont = TextEditingController();
  TextEditingController mobCont = TextEditingController();
  TextEditingController spcCont = TextEditingController();
  TextEditingController emailCont = TextEditingController();
  TextEditingController addrCont = TextEditingController();
  TextEditingController caddrCont = TextEditingController();
  TextEditingController cnameCont = TextEditingController();
  TextEditingController lnameCont = TextEditingController();
  TextEditingController pinCont = TextEditingController();
  Future f;
  String city="",pin="";
  bool testCheck;
  @override
  void initState() {
    testCheck= false;
    f = fetchAlbum(widget.snapshot['PinCode']);
    city = widget.snapshot['City'];
    pinCont.text = widget.snapshot['PinCode'];
    qualiCont.text = widget.snapshot['Degree'];
    nameCont.text = widget.snapshot['Name'].toString().split(" ")[0];
    mobCont.text = widget.snapshot['PhoneNumber'];
    spcCont.text = widget.snapshot['Specialization'];
    emailCont.text = widget.snapshot['Email'];
    addrCont.text = widget.snapshot['Address'];
    cnameCont.text = widget.snapshot['ClinicName'];
    caddrCont.text = widget.snapshot['ClinicAddress'];
    lnameCont.text = (widget.snapshot['Name'].toString().split(" ").length>1)?widget.snapshot['Name'].toString().split(" ")[1]:"Last Name";
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
        title: Text("Update Doctor",style: TextStyle(color: Colors.white),),
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
                      labelText:"First Name"
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
                  keyboardType: TextInputType.text,
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal:15,vertical:5),
                child: TextFormField(
                  buildCounter: (BuildContext context, { int currentLength, int maxLength, bool isFocused }) => null,
                  autofocus: false,
                  decoration: InputDecoration(
                      border: new OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(5),
                        ),
                      ),
                      labelText:"Mobile No"
                  ),
                  controller: mobCont,
                  validator: (val) {
                    if (val==null) {
                      return 'Can not be empty';
                    } else {
                      return null;
                    }
                  },
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
                      labelText:"Email"
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
              ),
              /*Container(
                margin: EdgeInsets.symmetric(horizontal:15,vertical:5),
                child: TextFormField(
                  autofocus: false,
                  decoration: InputDecoration(
                      border: new OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(5),
                        ),
                      ),
                      labelText:"Clinic Name"
                  ),
                  controller: cnameCont,
                  validator: (val) {
                    if (val==null) {
                      return 'Can not be empty';
                    } else {
                      return null;
                    }
                  },
                  keyboardType: TextInputType.name,
                ),
              ),*/
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
                  decoration: InputDecoration(
                      border: new OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(5),
                        ),
                      ),
                      labelText:"Address"
                  ),
                  controller: addrCont,
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
              /*Container(
                margin: EdgeInsets.symmetric(horizontal:15,vertical:5),
                child: TextFormField(
                  autofocus: false,
                  decoration: InputDecoration(
                      border: new OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(5),
                        ),
                      ),
                      labelText:"Clinic Address"
                  ),
                  controller: caddrCont,
                  validator: (val) {
                    if (val==null) {
                      return 'Can not be empty';
                    } else {
                      return null;
                    }
                  },
                  keyboardType: TextInputType.streetAddress,
                ),
              ),*/
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
                    labelText: "Qualification",
                  ),
                  validator: (val) {
                    if (val==null) {
                      return 'Can not be empty';
                    } else {
                      return null;
                    }
                  },
                  controller: qualiCont,
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
                    labelText: "Specialization",
                  ),
                  validator: (val) {
                    if (val==null) {
                      return 'Can not be empty';
                    } else {
                      return null;
                    }
                  },
                  controller: spcCont,
                ),
              ),
              (testCheck==false)?GestureDetector(
                onTap: ()async{
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  if(_formKey.currentState.validate()) {
                    setState(() {
                      testCheck = true;
                    });
                    Map m ={
                      "Id" :widget.snapshot['Id'].toString(),
                      "UserId" :widget.snapshot['UserId'].toString(),
                      "Clinics":widget.snapshot['Clinics'],
                      "Name":nameCont.text.sentenceCase+" "+lnameCont.text.sentenceCase,
                      "Email":emailCont.text,
                      "Password":"123456",
                      "PhoneNumber":mobCont.text,
                      //"ClinicAddress":caddrCont.text,
                      "Address":addrCont.text,
                      "Specialization":spcCont.text,
                      "Degree":qualiCont.text,
                      "City":city,
                      "PinCode":pinCont.text,
                      "UpdatedDate":DateTime.now().toString(),
                      "UpdatedBy":prefs.getString('userId').toString(),
                    };
                    print(m);
                    http.Response responce = await http.post(
                        "http://www.notoutindia.com/aarogyam/api/UpdateDoctor",
                        headers: {
                          "Authorization":prefs.getString('token'),
                        },
                        body:jsonEncode({
                          "Id" :widget.snapshot['Id'].toString(),
                          "UserId" :widget.snapshot['UserId'].toString(),
                          "Clinics":widget.snapshot['Clinics'],
                          "Name":nameCont.text.sentenceCase+" "+lnameCont.text.sentenceCase,
                          "Email":emailCont.text,
                          "Password":"123456",
                          "PhoneNumber":mobCont.text,
                          //"ClinicAddress":caddrCont.text,
                          "Address":addrCont.text,
                          "Specialization":spcCont.text,
                          "Degree":qualiCont.text,
                          "City":city,
                          "PinCode":pinCont.text,
                          "UpdatedDate":DateTime.now().toString(),
                          "UpdatedBy":prefs.getString('userId').toString(),
                        })).whenComplete(() =>
                    {
                      setState(() {
                        testCheck = false;
                      }),
                    });
                    if(responce.statusCode==200||responce.statusCode==201){
                     // _scaffoldKey.currentState.showSnackBar(SnackBar(content:Text(jsonDecode(responce.body)['message'])));
                      Navigator.pushReplacement(context,MaterialPageRoute(builder:(context)=>DocRecord()));
                    }else{
                      _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(jsonDecode(responce.body)['message']),));
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
                  child: ColorLoader()
              ),
            ],
          ),
        ),
      ),
    );
  }
}
