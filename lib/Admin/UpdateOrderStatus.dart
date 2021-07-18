import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../Customloder.dart';
import '../custom_dropdown_formfield.dart';

class UpdateOrderStatus extends StatefulWidget {
  final snapshot;
  const UpdateOrderStatus({Key key, this.snapshot}) : super(key: key);
  @override
  _UpdateOrderStatusState createState() => _UpdateOrderStatusState();
}

class _UpdateOrderStatusState extends State<UpdateOrderStatus> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool adding;
  String drop_value;
  @override
  void initState() {
    adding = false;
    drop_value = widget.snapshot['Pending'];
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(),
      body: Container(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal:15,vertical:5),
              child:DropDownFormField(
                hintText: 'Status',
                value: drop_value,
                onSaved: (value) {
                  setState(() {
                    drop_value = value;
                  });
                },
                onChanged: (value) {
                  setState(() {
                    drop_value = value;
                  });
                },
                dataSource:[
                  {
                    "title":"Pending"
                  },
                  {
                    "title":"Shipped"
                  },
                  {
                    "title":"Delivered"
                  },
                  {
                    "title":"Canceled"
                  },
                ],
                textField: 'title',
                valueField: 'title',
              ),
            ),
            (adding!=true)?GestureDetector(
              onTap: ()async{
                  setState(() {
                    adding = true;
                  });
                  http.Response responce = await
                  http.post("http://www.notoutindia.com/aarogyam/api/UpdateOrder",
                      body:jsonEncode({
                        "Id":"${widget.snapshot['Id']}",
                        "PatientId":"${widget.snapshot['PatientId']}",
                        "MedicineCategoryId":"${widget.snapshot['MedicineCategoryId']}",
                        "MedicineIds":"${widget.snapshot['MedicineIds']}",
                        "PinCode":"${widget.snapshot['PinCode']}",
                        "HouseNumber":"${widget.snapshot['HouseNumber']}",
                        "City":"${widget.snapshot['City']}",
                        "District":"${widget.snapshot['District']}",
                        "Landmark":"${widget.snapshot['Landmark']}",
                        "Address":"${widget.snapshot['Address']}",
                        "PhoneNumber":"${widget.snapshot['PhoneNumber']}",
                        "AlternatePhone":"${widget.snapshot['AlternatePhone']}",
                        "TotalAmount":"${widget.snapshot['TotalAmount']}",
                        "DeliveryDate":DateTime.now().toString(),
                        "Email":"${widget.snapshot['Email']}",
                        "CreatedDate":"${widget.snapshot['CreatedDate']}",
                        "CreatedBy":"${widget.snapshot['CreatedBy']}",
                        "status":"${drop_value}"
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
                child: Text("Update Order",style: TextStyle(color: Colors.white,fontSize:18,fontWeight: FontWeight.bold),),
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
    );
  }
}
