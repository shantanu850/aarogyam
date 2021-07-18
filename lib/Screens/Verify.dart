import 'dart:convert';
import 'package:aarogyam/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'exception_Handaler.dart';

class Verify extends StatefulWidget {
  final phone;
  final email;
  const Verify({Key key, this.phone, this.email}) : super(key: key);
  @override
  _VerifyState createState() => _VerifyState();
}

class _VerifyState extends State<Verify> {
  String verificationId,code;
  PageController _controller = PageController(
    initialPage: 0,
  );
  final formKeyReg = GlobalKey<FormState>();
  double borderRadius = 10;
  String phno,otp;
  int _state;
  final _auth = FirebaseAuth.instance;
  AuthResultStatus _status;
  TextEditingController mobCont = TextEditingController();
  bool codeSent = false;
  initState(){
    phno = "+91"+widget.phone;
    mobCont.text = "+91"+widget.phone;
    Firebase.initializeApp();
    super.initState();
  }
  showError(BuildContext context,message) {
    // Create button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    setState(() {
      _state = 2;
    });
    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Error"),
      content: Text(message.toString()),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
  Future<AuthResultStatus> signIn(AuthCredential authCreds) async{
    try{
      UserCredential authResult = await _auth.signInWithCredential(authCreds);
      if(authResult != null){
          Navigator.push(context, MaterialPageRoute(builder:(context)=>UpdatePassword(data:widget.email,)));
      }
    }catch(e){
      print('Exception @createAccount: $e');
      showError(context,e.message);
      setState(() {
        _state = 0;
      });
      _status = AuthExceptionHandler.handleException(e);
    }
    return _status;
  }
  signInWithOTP(smsCode,verId) {
    AuthCredential authCreds = PhoneAuthProvider.getCredential(verificationId: verId, smsCode: smsCode);
    signIn(authCreds);
  }
  Future<void> verifyPhone(phoneNo) async {
    final PhoneVerificationCompleted verified = (AuthCredential authResult) {
      signIn(authResult);
    };
    final PhoneVerificationFailed verificationfailed =
        (FirebaseAuthException authException) {
      showError(context, authException.message);
      print('${authException.message}');
    };

    final PhoneCodeSent smsSent = (String verId, [int forceResend]) {
      this.verificationId = verId;
      setState(() {
        this.codeSent = true;
      });
    };

    final PhoneCodeAutoRetrievalTimeout autoTimeout = (String verId) {
      this.verificationId = verId;
    };
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNo,
        timeout: Duration(seconds: 120),
        verificationCompleted: verified,
        verificationFailed: verificationfailed,
        codeSent: smsSent,
        codeAutoRetrievalTimeout: autoTimeout);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
          controller: _controller,
          physics:NeverScrollableScrollPhysics(),
          children:[
            Container(
              alignment: Alignment.topCenter,
              child: Form(
                key: formKeyReg,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Container(
                        height:250,
                        margin: EdgeInsets.only(bottom:20),
                        child: Image(image:AssetImage("assets/student.jpg"),)),
                    Center(child: Text("Verify Your Phone No",style: TextStyle(color: Colors.deepOrange,fontWeight: FontWeight.bold,fontSize:18),)),
                    SizedBox(height:2,),
                    Center(child: Text("We have send you an OTP",style: TextStyle(color: Colors.blueGrey),)),
                    Padding(
                      padding: EdgeInsets.only(top:20,left: 20,right: 20,bottom:5),
                      child: TextFormField(
                        enabled: false,
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: 'Phone Number',
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color:Colors.grey,width:1),
                              borderRadius: BorderRadius.all(Radius.circular(borderRadius))
                          ),
                        ),
                        controller: mobCont,
                      ),
                    ),
                    Container(
                      height: 76,
                      padding: EdgeInsets.symmetric(horizontal:20,vertical:10),
                      child: GestureDetector(
                        onTap: (){
                            verifyPhone(phno).then((value) =>
                                _controller.animateToPage(
                                    1, duration: Duration(seconds:1),
                                    curve: Curves.bounceIn)
                            );

                        },
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.deepOrange,
                            borderRadius: BorderRadius.circular(borderRadius),
                          ),
                          child: Text("CONTINUE",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              alignment: Alignment.topCenter,
              child: ListView(
                shrinkWrap: true,
                children: [
                  Container(
                      height: 250,
                      margin: EdgeInsets.only(bottom:20),
                      child: Image(image:AssetImage("assets/student.jpg"),)),
                  Center(child: Text("Enter OTP",style: TextStyle(color: Colors.deepOrange,fontWeight: FontWeight.bold,fontSize:18),)),
                  Center(child: Text("We have send you an OTP",style: TextStyle(color: Colors.blueGrey),)),
                  Container(
                    margin: EdgeInsets.only(top:10),
                    padding:EdgeInsets.symmetric(vertical: 5.0,horizontal:20),
                    child: TextFormField(
                      decoration: new InputDecoration(
                        labelText: 'OTP',
                        labelStyle: TextStyle(color: Colors.grey),
                        fillColor: Colors.white,
                        filled: true,
                        border: new OutlineInputBorder(
                            borderRadius:
                            new BorderRadius.circular(borderRadius),
                            borderSide: new BorderSide(
                              color: Colors.grey,
                            )),
                        enabledBorder: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(borderRadius),
                            borderSide: new BorderSide(
                              color: Colors.grey,
                            )),
                        focusedBorder: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(borderRadius),
                            borderSide: new BorderSide(
                              color:Colors.blue,
                            )),
                      ),
                      validator: (val) {
                        if(val==null){
                          return 'Cant be null';
                        }else{
                          return null;
                        }
                      },
                      onChanged: (value) {
                        otp = value; //get the value entered by user.
                      },
                      keyboardType: TextInputType.number,
                      style: new TextStyle(
                        height: 1.0,
                        color: Colors.black,
                        fontFamily: "Poppins",
                      ),
                    ),
                  ),
                  Container(
                    height: 76,
                    padding: EdgeInsets.symmetric(horizontal:20,vertical:10),
                    child: GestureDetector(
                      onTap: (){
                        signInWithOTP(otp,verificationId);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.deepOrange,
                          borderRadius: BorderRadius.circular(borderRadius),
                        ),
                        child: Text("CONTINUE",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ]
      ),
    );
  }
}
class UpdatePassword extends StatefulWidget {
  final data;
  const UpdatePassword({Key key, this.data}) : super(key: key);
  @override
  _UpdatePasswordState createState() => _UpdatePasswordState();
}

class _UpdatePasswordState extends State<UpdatePassword> {
  String pass,confpass,email;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  initState(){
    email = widget.data;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Reset Password"),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal:15,vertical:5),
              child: TextField(
                decoration: InputDecoration(
                  border: new OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(5),
                    ),
                  ),
                  hintText: "New Password",
                ),
                onChanged: (v){
                  pass = v;
                },
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal:15,vertical:5),
              child: TextField(
                decoration: InputDecoration(
                  border: new OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(5),
                    ),
                  ),
                  hintText: "Confirm New Password",
                ),
                onChanged: (v){
                  confpass = v;
                },
              ),
            ),
            GestureDetector(
              onTap: ()async{
                  if (pass == confpass) {
                      SharedPreferences prefs = await SharedPreferences
                          .getInstance();
                      http.post(
                          "http://www.notoutindia.com/aarogyam/api/UpdatePassword",
                          headers: {
                            "Authorization": prefs.getString('token'),
                          },
                          body: jsonEncode({
                            "Email": email,
                            "Password": pass,
                            "UpdatedDate": DateTime.now().toString(),
                            "UpdatedBy": email,
                          })
                      ).then((value) =>
                      {
                        _scaffoldKey.currentState.showSnackBar(
                            SnackBar(content: Text(
                                jsonDecode(value.body)['message']),)),
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MyHomePage()))
                      });
                  } else {
                    _scaffoldKey.currentState.showSnackBar(SnackBar(
                        content: Text(
                            "Password & Confirm Password didnt matched ")));
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
                child: Text("Reset Password",style: TextStyle(color: Colors.white,fontSize:18,fontWeight: FontWeight.bold),),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
