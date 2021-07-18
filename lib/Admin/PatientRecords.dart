import 'dart:convert';
import 'package:aarogyam/Admin/ViewPatent.dart';
import 'package:aarogyam/drawer.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';
import 'PatientRegister.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:aarogyam/search.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:aarogyam/Admin/ViewTestSample.dart';

class PatRecord extends StatefulWidget {
  final title;
  const PatRecord({Key key, this.title = "Patient Records"}) : super(key: key);
  @override
  _PatRecordState createState() => _PatRecordState();
}
class _PatRecordState extends State<PatRecord> {
  List<Map> searchList=[];
  List<Map> recentData=[];
  DateTime date1,date2;
  Future f ;
  String Semail = "",Sphone="",Sname="";
  getUser()async{
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    setState(() {
      Semail = _preferences.getString("userEmail");
      Sphone = _preferences.getString("userPhone");
      Sname = _preferences.getString("userName");
    });
  }
  getData()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    http.Response response = await http.get("http://www.notoutindia.com/aarogyam/api/Patients",headers:{
      "Authorization":prefs.getString('token'),
     });
    jsonDecode(response.body).forEach((element) {
      searchList.add(element);
    });
    if(response.statusCode==200||response.statusCode==201){
      return jsonDecode(response.body);
    }else{
      return [];
    }
  }
  getDataRange(d1,d2)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    http.Response rr = await http.post("http://www.notoutindia.com/aarogyam/api/Patients?FromDate=$d1&ToDate=$d2",
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
  @override
  void initState() {
    f = getData();
    getUser();
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
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder:(BuildContext context)=>PatReg()));
        },
        child: Icon(Icons.add,color: Colors.white,),
      ),
      appBar: AppBar(
        title:Text(widget.title),
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: Size(width,2), child: SizedBox(),
        ),
        actions: [
          IconButton(icon:Icon(Icons.search_outlined), onPressed:(){
            showSearch(context: context, delegate:Search(searchList,3));
          }),
          IconButton(icon: Icon(Icons.qr_code), onPressed: ()async{
            SharedPreferences prefs = await SharedPreferences.getInstance();
            scanner.scan().then((value) => {
              http.get(
                  "http://www.notoutindia.com/aarogyam/api/TestSamples?Id=$value",
                  headers:{
                    "Authorization":prefs.getString('token'),
                  }).then((value2) => {
                print("Patient Id : ${jsonDecode(value2.body)[0]['PatientId'].toString()}"),
                http.post("http://www.notoutindia.com/aarogyam/api/GetPatient?Id=${jsonDecode(value2.body)[0]['PatientId'].toString()}").then((value3) => {
                  print(value3.statusCode),
                  if(value3.statusCode==200||value3.statusCode==201){
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            ViewTestSample(
                              snapshot: jsonDecode(value2.body)[0],
                              patentSnapshot: jsonDecode(value3.body),)))
                  }
                })
              })
            });
          })
        ],
      ),
      drawer: Drawer(
        child: CustomDrawer()
      ),
      body: Container(
          child:SmartRefresher(
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
                Container(
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
                                    f = getDataRange(date1,date2);
                                  });
                                  print('change $date');
                                }, onConfirm: (date) {
                                  print('confirm $date');
                                }, currentTime: DateTime.now(), locale: LocaleType.en);
                          },
                          icon: Icon(Icons.calendar_today),
                          label: Text((date2!=null)?date2.day.toString()+"/"+date2.month.toString()+"/"+date2.year.toString():'End Date', style: TextStyle(color: Colors.blueGrey),)
                      ),
                    ],
                  ),
                ),
                Container(
                  height:MediaQuery.of(context).size.height-120,
                  child: FutureBuilder(
                      future:f,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState != ConnectionState.waiting) {
                          if(snapshot.hasData) {
                            return ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: snapshot.data.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6.0, vertical: 2.0),
                                    child: Card(
                                      elevation: 4,
                                      child: Container(
                                        padding: EdgeInsets.all(4),
                                        child: ListTile(
                                          title: Text("${snapshot.data[index]['Name']}"),
                                          subtitle: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text("  Mobile No : " + snapshot.data[index]['PhoneNumber']),
                                              Text("  Disease : " + snapshot.data[index]['Disease']),
                                            ],
                                          ),
                                          onTap: () {
                                            Navigator.of(context).push(MaterialPageRoute(
                                                builder: (context) =>
                                                    ViewPatent(snapshot: snapshot.data[index],)));
                                          },
                                        ),
                                      ),
                                    ),
                                  );
                                }
                            );
                          }else{
                            return Container(
                                height: width-100,
                                margin: EdgeInsets.all(20),
                                alignment: Alignment.center,
                                child: Image.asset("assets/no-record-found.png")
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
                                          //Container(color:Colors.black,height:5,width:width*0.6,margin:EdgeInsets.only(top:5,left:10,right:5,bottom: 5),),
                                          //Container(color:Colors.black,height:5,width:width*0.6,margin:EdgeInsets.only(top:5,left:10,right:5,bottom: 5),),
                                         // Container(color:Colors.black,height:5,width:width*0.6,margin:EdgeInsets.only(top:5,left:10,right:5,bottom: 5),),
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
              ],
            ),
          )
      ),
    );
  }
}
