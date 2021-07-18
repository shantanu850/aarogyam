import 'dart:convert';
import 'package:aarogyam/Admin/DoctorRecord.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:recase/recase.dart';
import 'package:aarogyam/custom_dropdown_formfield.dart';

class DocReg extends StatefulWidget {
  @override
  _DocRegState createState() => _DocRegState();
}

class _DocRegState extends State<DocReg> {
  String quali="",name,mob,spc,email,addr,Cname,lname;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = new GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController addrController = TextEditingController();
  TextEditingController mobController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController spcController = TextEditingController();
  TextEditingController lnameController = TextEditingController();
  TextEditingController qualiCont = TextEditingController();
  TextEditingController pinCont = TextEditingController();
  bool testCheck,testCheck2;
  Future f;
  String city="",pin="";
  @override
  void initState() {
    testCheck= false;
    testCheck2 = false;
    f = fetchAlbum(712148);
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
  List<Map> clinics = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Doctor Registration ",style: TextStyle(color: Colors.white),),
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
                    border:OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(5),
                      ),
                    ),
                    hintText: "First Name",
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
                    hintText: "Last Name",
                  ),
                  controller: lnameController,
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
                  maxLength: 10,
                  autofocus: false,
                  buildCounter: (BuildContext context, { int currentLength, int maxLength, bool isFocused }) => null,
                  decoration: InputDecoration(
                    border: new OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(5),
                      ),
                    ),
                    hintText: "Mobile No",
                  ),
                  validator: (val) {
                    if (val.length<10) {
                      return 'Can not be less than 10';
                    } else {
                      return null;
                    }
                  },
                  controller: mobController,
                  keyboardType: TextInputType.phone,
               //   autovalidateMode:AutovalidateMode.always,
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
                    hintText: "Email ID",
                  ),
                  validator: (val) {
                    Pattern pattern =
                        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                    RegExp regex = new RegExp(pattern);
                    if (!regex.hasMatch(val)) {
                      return 'Email format is invalid';
                    } else {
                      return null;
                    }
                  },
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
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
                  decoration: InputDecoration(
                    border: new OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(5),
                      ),
                    ),
                    hintText: "Address",
                  ),
                  validator: (val) {
                    if (val==null) {
                      return 'Can not be empty';
                    } else {
                      return null;
                    }
                  },
                  controller: addrController,
                ),
              ),
              /*ListTile(
                title: Text("Add Clinic"),
                trailing:IconButton(
                  icon: Icon(Icons.add),
                  onPressed: (){
                    setState(() {
                      clinics.add({

                      });
                    });
                  },
                ),
              ),
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: clinics.length,
                  itemBuilder:(_,index){
                    List name=[],addr=[];
                    return Column(
                      children: [
                        ListTile(title: Text("Clinic ${index+1}"),trailing:IconButton(
                          icon: Icon(Icons.remove),
                          onPressed: (){
                            setState(() {
                              clinics.removeAt(index);
                            });
                          },
                        ),),
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
                              hintText: "Clinic Name",
                            ),
                            keyboardType: TextInputType.name,
                            validator: (val) {
                              if (val==null) {
                                return 'Can not be empty';
                              } else {
                                return null;
                              }
                            },
                            onChanged: (v){
                              name.insert(index,v);
                              clinics[index] = {
                                "ClinicName":name[index],
                                "ClinicAddress":addr[index]
                              };
                              print(clinics);
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
                              hintText: "Clinic Address",
                            ),
                            validator: (val) {
                              if (val==null) {
                                return 'Can not be empty';
                              } else {
                                return null;
                              }
                            },
                            onChanged: (v){
                              addr.insert(index,v);
                              clinics[index] = {
                                "ClinicName":name[index],
                                "ClinicAddress":addr[index]
                              };
                              print(clinics);
                            },
                          ),
                        ),
                      ],
                    );
                  }
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
                    hintText: "Specializations",
                  ),
                  validator: (val) {
                    if (val==null) {
                      return 'Can not be empty';
                    } else {
                      return null;
                    }
                  },
                  controller: spcController,
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
                    hintText: "Qualification",
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
                margin: EdgeInsets.all(5),
                child: Row(
                  children: [
                    Checkbox(
                      value: testCheck2,
                      onChanged:(v){
                        setState(() {
                          testCheck2 = v;
                        });
                      },
                    ),
                    SizedBox(width: 5),
                    Text("I, accept terms & conditions")
                  ],
                ),
              ),
              testCheck2?GestureDetector(
                onTap: ()async{
                  Firebase.initializeApp();
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  print(prefs.getString('token'));
                  if(_formKey.currentState.validate()) {
                    http.post("http://www.notoutindia.com/aarogyam/api/CreateDoctor",
                      headers: {
                        "Authorization":prefs.getString('token'),
                        "Content-Type": "application/json",
                      },
                      body:jsonEncode({
                        "Clinics":[],
                        "Name":nameController.text.sentenceCase+" "+lnameController.text.sentenceCase,
                        "Email":emailController.text,
                        "PhoneNumber":mobController.text,
                        "Address":addrController.text,
                        "Specialization":spcController.text,
                        "Degree":qualiCont.text,
                        "City":city,
                        "PinCode":pinCont.text,
                        "CreatedDate":DateTime.now().toString(),
                        "CreatedBy":prefs.getString('userId'),
                      })
                    ).then((value) => {
                      print(jsonDecode(value.body)['message']),
                      if(jsonDecode(value.body)['message']=="Unable to register the user."){
                        _scaffoldKey.currentState.showSnackBar(SnackBar(content:Text(jsonDecode(value.body)['message'])))
                      }else{
                        FirebaseAuth.instance.createUserWithEmailAndPassword(email: emailController.text, password: "password"),
                        _scaffoldKey.currentState.showSnackBar(SnackBar(content:Text(jsonDecode(value.body)['message']))),
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>DocRecord()))
                      }
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
                child: Text("Accept Terms & Conditions",style: TextStyle(color: Colors.white,fontSize:18,fontWeight: FontWeight.bold),),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
