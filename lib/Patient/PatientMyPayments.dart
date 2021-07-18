import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:aarogyam/drawer.dart';
import 'package:shimmer/shimmer.dart';

import 'InvoiceViewPatient.dart';

class PatientMyPayments extends StatefulWidget {
  @override
  _PatientMyPaymentsState createState() => _PatientMyPaymentsState();
}

class _PatientMyPaymentsState extends State<PatientMyPayments> {
  DateTime date1,date2;
  Future f;
  String localId;
  ///getting Id from userId
  Future<String> getId()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    http.Response rr = await http.post("http://www.notoutindia.com/aarogyam/api/GetPatient?UserId=${prefs.getString('userId')}",
      headers: {
        "Authorization":prefs.getString('token'),
      },
    );
    if(rr.statusCode==200||rr.statusCode==201) {
      print(jsonDecode(rr.body)['Id']);
      setState(() {
        localId = jsonDecode(rr.body)['Id'];
      });
      return jsonDecode(rr.body)['Id'];
    }else{
      return "";
    }
  }
  getData()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getString('userId'));
    await getId();
    http.Response rr = await http.post("http://www.notoutindia.com/aarogyam/api/GetPayments?PatientId=$localId",
      headers: {
        "Authorization":prefs.getString('token'),
      },
    );
    if(rr.statusCode==200||rr.statusCode==201) {
      return jsonDecode(rr.body);
    }else{
      print(jsonDecode(rr.body));
      return [];
    }
  }
  getDataRange(d1,d2)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    http.Response rr = await http.post("http://www.notoutindia.com/aarogyam/api/GetPayments?FromDate=$d1&ToDate=$d2&PatientId=$localId",
      headers: {
        "Authorization":prefs.getString('token'),
      },
    );
    if(rr.statusCode==200||rr.statusCode==201){
      return jsonDecode(rr.body);
    }else{
      return [];
    }
  }
  final List<String> titles = ["booked", "Collected", "Payment","Complete",];
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  void initState() {
    f = getData();
    super.initState();
  }
  RefreshController _refreshController =
  RefreshController(initialRefresh: false);

  void _onRefresh() async{
    setState(() {
      f = getData();
    });
    await Future.delayed(Duration(milliseconds: 1000));
    _refreshController.refreshCompleted();
  }

  void _onLoading() async{

    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    if(mounted)

    _refreshController.loadComplete();
  }
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: Size(width,2), child: SizedBox(),
        ),
        title: Text("My Payments"),
      ),
      drawer: Drawer(
          child: CustomDrawer()
      ),
      body:Container(
        child: SmartRefresher(
          enablePullDown: true,
          enablePullUp: true,
          header: WaterDropMaterialHeader(color: Colors.white,backgroundColor: Colors.deepOrange,),
          footer: CustomFooter(
            builder: (BuildContext context,LoadStatus mode){
              Widget body ;
              if(mode==LoadStatus.idle){
                body =  Text("pull up load");
              }
              else if(mode==LoadStatus.loading){
                body =  CupertinoActivityIndicator();
              }
              else if(mode == LoadStatus.failed){
                body = Text("Load Failed!Click retry!");
              }
              else if(mode == LoadStatus.canLoading){
                body = Text("release to load more");
              }
              else{
                body = Text("No more Data");
              }
              return Container(
                height: 55.0,
                child: Center(child:body),
              );
            },
          ),
          controller: _refreshController,
          onRefresh: _onRefresh,
          onLoading: _onLoading,
          child: ListView(
            shrinkWrap: true,
            children: [
              /*Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    FlatButton.icon(
                        textColor: Colors.blueGrey,
                        color: Colors.white,
                        onPressed: () {
                          DatePicker.showDatePicker(context,
                              showTitleActions: true,
                              minTime: DateTime(2000, 3, 5),
                              maxTime: DateTime(2100, 6, 7),
                              onChanged: (date) {
                                setState(() {
                                  date1 = date;
                                  f = getDataRange(date1, DateTime.now());
                                });
                                print('change $date');
                              }, onConfirm: (date) {
                                print('confirm $date');
                              },
                              currentTime: DateTime.now(), locale: LocaleType.en);
                        },
                        icon: Icon(Icons.calendar_today),
                        label: Text((date1!=null)?date1.day.toString()+"/"+date1.month.toString()+"/"+date1.year.toString():"Start Date",style: TextStyle(color: Colors.blueGrey),)),
                    FlatButton.icon(
                        textColor: Colors.blueGrey,
                        color: Colors.white,
                        onPressed: () {
                          DatePicker.showDatePicker(context,
                              showTitleActions: true,
                              minTime: DateTime(2000, 3, 5),
                              maxTime: DateTime(2100, 6, 7),
                              onChanged: (date) {
                                setState(() {
                                  date2 = date;
                                  f = getDataRange(date1, date2);
                                });
                              }, onConfirm: (date) {
                                print('confirm $date');
                              }, currentTime: DateTime.now(), locale: LocaleType.en);
                        },
                        icon: Icon(Icons.calendar_today),
                        label: Text((date2!=null)?date2.day.toString()+"/"+date2.month.toString()+"/"+date2.year.toString():'End Date', style: TextStyle(color: Colors.blueGrey),)
                    ),
                  ],
                ),
              ),*/
              Container(
                child: FutureBuilder(
                    future:f,
                    builder: (context, snap) {
                      if (snap.connectionState != ConnectionState.waiting) {
                        if(snap.data.length>0) {
                          return ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: snap.data.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  padding: EdgeInsets.all(8.0),
                                  child: Card(
                                    elevation: 4,
                                    child: ListTile(
                                      title: Text(
                                        "Payment ID : ${snap.data[index]['Id']}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),),
                                      trailing:RichText(
                                          text: TextSpan(
                                              children: <TextSpan>[
                                                TextSpan(text: snap
                                                    .data[index]['Amount'],
                                                    style: TextStyle(
                                                        fontWeight: FontWeight
                                                            .bold,
                                                        color: Colors
                                                            .green))
                                              ],
                                              style: TextStyle(
                                                  color: Colors.green,
                                                  fontWeight: FontWeight
                                                      .bold,
                                                  fontSize: 20),
                                              text: "₹ ")),
                                      subtitle: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8.0, top: 4.0),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment
                                              .start,
                                          crossAxisAlignment: CrossAxisAlignment
                                              .start,
                                          children: [
                                            Row(
                                              children: [
                                                Icon(Icons.list_alt, size: 15,),
                                                SizedBox(width: 4,),
                                                RichText(
                                                    text: TextSpan(
                                                        children: <TextSpan>[
                                                          TextSpan(text: snap
                                                              .data[index]['SampleTestID'],
                                                              style: TextStyle(
                                                                  fontWeight: FontWeight
                                                                      .normal,
                                                                  color: Colors
                                                                      .black))
                                                        ],
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight: FontWeight
                                                                .bold),
                                                        text: "SampleTest Id : ")),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.access_time, size: 15,),
                                                SizedBox(width: 4,),
                                                RichText(
                                                    text: TextSpan(
                                                        children: <TextSpan>[
                                                          TextSpan(text: snap
                                                              .data[index]['PaymentDate']
                                                              .toString(),
                                                              style: TextStyle(
                                                                  fontWeight: FontWeight
                                                                      .normal,
                                                                  color: Colors
                                                                      .black))
                                                        ],
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight: FontWeight
                                                                .bold),
                                                        text: "Payment Date : ")),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Icon(Icons.person, size: 15,),
                                                SizedBox(width: 4,),
                                                RichText(
                                                    text: TextSpan(
                                                        children: <TextSpan>[
                                                          TextSpan(text: "${snap
                                                              .data[index]['PaymentTakenBy']}",
                                                              style: TextStyle(
                                                                  fontWeight: FontWeight
                                                                      .normal,
                                                                  color: Colors
                                                                      .black))
                                                        ],
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight: FontWeight
                                                                .bold),
                                                        text: "Payment Taken By : ")),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Icon(Icons.money, size: 15,),
                                                SizedBox(width: 4,),
                                                RichText(
                                                    text: TextSpan(
                                                        children: <TextSpan>[
                                                          TextSpan(text: snap
                                                              .data[index]['Method'],
                                                              style: TextStyle(
                                                                  fontWeight: FontWeight
                                                                      .normal,
                                                                  color: Colors
                                                                      .black))
                                                        ],
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight: FontWeight
                                                                .bold),
                                                        text: "Payment Method : ")),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Icon(Icons
                                                    .transfer_within_a_station_sharp,
                                                  size: 15,),
                                                SizedBox(width: 4,),
                                                RichText(
                                                    text: TextSpan(
                                                        children: <TextSpan>[
                                                          TextSpan(text: snap
                                                              .data[index]['TransactionId'],
                                                              style: TextStyle(
                                                                  fontWeight: FontWeight
                                                                      .normal,
                                                                  color: Colors
                                                                      .black))
                                                        ],
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight: FontWeight
                                                                .bold),
                                                        text: "Transaction Id : ")),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      onTap: () async{
                                        SharedPreferences prefs = await SharedPreferences.getInstance();
                                        _scaffoldKey.currentState.showSnackBar(
                                            SnackBar(content: Text(
                                                "Wait generating invoice ......."),));
                                        http.post(
                                            "http://www.notoutindia.com/aarogyam/api/GetPatient?UserId=${prefs.getString('userId')}")
                                            .then((value) =>
                                        {
                                          if(value.statusCode == 200 ||
                                              value.statusCode == 201){
                                            http.post(
                                                "http://www.notoutindia.com/aarogyam/api/TestSamples?PatientId=${jsonDecode(
                                                    value.body)['Id']}&Id=${snap
                                                    .data[index]['SampleTestID']}")
                                                .then((value2) =>
                                            {
                                              if(value2.statusCode == 200 ||
                                                  value2.statusCode == 201){
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            InvoiceViewPatient(
                                                              snapshot1: jsonDecode(
                                                                  value2.body)[0],
                                                              snapshot2: jsonDecode(
                                                                  value.body),
                                                              data: {
                                                                "trId": snap
                                                                    .data[index]['TransactionId'],
                                                                "getway": snap
                                                                    .data[index]['Method'],
                                                                "fees": snap
                                                                    .data[index]['Amount'],
                                                              },
                                                              goBackHome:false,
                                                            )))
                                              } else
                                                {
                                                  _scaffoldKey.currentState.showSnackBar(SnackBar(
                                                    content: Text(
                                                        "Corresponding Test sample Not Found . Try Again !"),))
                                                }
                                            }),
                                          } else
                                            {_scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Corresponding User data Not Found . Try Again !"),))}
                                        });
                                      },
                                    ),
                                  ),
                                );
                              }
                          );
                        }else{
                          return Container(
                            height: width-100,
                            alignment: Alignment.center,
                            child: Image.asset("no-record-found.png")
                          );
                        }
                      }else{
                        return Container(
                          child: ListView.builder(
                            itemCount: 20,
                              shrinkWrap: true,
                              itemBuilder:(context,index){
                                return Container(
                                  margin: EdgeInsets.symmetric(horizontal:20,vertical:10),
                                  color:Colors.grey[200],
                                  child: Shimmer.fromColors(
                                    baseColor: Colors.white,
                                    highlightColor: Colors.grey,
                                    child: Container(
                                      margin: EdgeInsets.all(10),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(color:Colors.black,height:7,width:width*0.7,margin:EdgeInsets.all(5),),
                                          Container(color:Colors.black,height:5,width:width*0.6,margin:EdgeInsets.only(top:5,left:10,right:5,bottom: 5),),
                                          Container(color:Colors.black,height:5,width:width*0.5,margin:EdgeInsets.only(top:5,left:10,right:5,bottom: 5),),
                                          Container(color:Colors.black,height:5,width:width*0.6,margin:EdgeInsets.only(top:5,left:10,right:5,bottom: 5),),
                                          Container(color:Colors.black,height:5,width:width*0.6,margin:EdgeInsets.only(top:5,left:10,right:5,bottom: 5),),
                                          Container(color:Colors.black,height:5,width:width*0.6,margin:EdgeInsets.only(top:5,left:10,right:5,bottom: 5),),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                        ),
                        );
                      }
                    }
                ),
              ),
              SizedBox(height:80,)
            ],
          ),
        ),
      ),
    );
  }
}
