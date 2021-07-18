import 'dart:convert';
import 'package:aarogyam/Admin/DoctorRegister.dart';
import 'package:aarogyam/Admin/ViewDoctor.dart';
import 'package:aarogyam/SearchDoctor.dart';
import 'package:aarogyam/drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:aarogyam/search.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';

class DocRecord extends StatefulWidget {
  @override
  _DocRecordState createState() => _DocRecordState();
}

class _DocRecordState extends State<DocRecord> {
  List<Map> searchList=[];
  List<Map> recentData=[];
  DateTime date2,date1;
  List data;
  Future f;
  initState(){
    f = getData();
    getKeywords();
    super.initState();
  }
  Future getData()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getString('token'));
    http.Response response = await http.get("http://www.notoutindia.com/aarogyam/api/Doctors",headers:{
      "Authorization":prefs.getString('token'),
    });
    if (response.statusCode == 200||response.statusCode == 201) {
      print(response.body);
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load album');
    }
  }
  getDataRange(d1,d2)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    http.Response rr = await http.post("http://www.notoutindia.com/aarogyam/api/Doctors?FromDate=$d1&ToDate=$d2",
      headers: {
        "Authorization":prefs.getString('token'),
      },
    );
    if(rr.statusCode==200||rr.statusCode==201){
      return jsonDecode(rr.body);
    }else{
      throw Exception('Failed to load album');
    }
  }
  getKeywords()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    http.Response response = await http.get("http://www.notoutindia.com/aarogyam/api/Doctors",headers:{
      "Authorization":prefs.getString('token'),
    });
    jsonDecode(response.body).forEach((element) {
      searchList.add({
        "type":1,
        "Name":element['Name'],
        "ClinicName":"",
        "Time":"",
        "Id":element["Id"],
      });
      element['Clinics'].forEach((item){
        searchList.add({
          "type":0,
          "Name":item['ClinicName'],
          "ClinicName":element["Name"],
          "Time":item['TimeFrom'].toString()+" To "+item['TimeTo'].toString(),
          "Id":element["Id"],
        });
      });
    });
    return searchList;
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
     drawer: Drawer(
       child:CustomDrawer()
     ),
      appBar: AppBar(
        title:Text("Doctors Record"),
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: Size(width,2), child: SizedBox(),
        ),
        actions: [
          IconButton(icon: Icon(Icons.search), onPressed: (){
            showSearch(context: context, delegate:SearchDoctor(searchList));
          })
        ],
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
                                  f = getDataRange(date1, date2);
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
              FutureBuilder(
                  future: f,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.waiting) {
                      if(snapshot.hasData) {
                        return ListView.builder(
                            itemCount: snapshot.data.length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Card(
                                  elevation: 4,
                                  child: Container(
                                    margin: EdgeInsets.all(4),
                                    child: ListTile(
                                      onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ViewDoctor(snapshot: snapshot
                                                        .data[index],)));
                                      },
                                      title: Text(
                                          "${snapshot.data[index]['Name']}"),
                                      subtitle: Column(
                                        mainAxisAlignment: MainAxisAlignment
                                            .start,
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start,
                                        children: [
                                          Text("  Qualification : " + snapshot
                                              .data[index]['Degree']),
                                          Text("  Specialization : " + snapshot
                                              .data[index]['Specialization']),
                                          Text("  Mobile No : " +
                                              snapshot
                                                  .data[index]['PhoneNumber']),
                                          ListTile(
                                            contentPadding: EdgeInsets.zero,
                                            title: Text("Clinics"),
                                            subtitle: ListView.builder(
                                              shrinkWrap: true,
                                              itemCount: snapshot.data[index]['Clinics'].length,
                                              itemBuilder: (context, inx) {
                                                return Text("${inx+1}) " + snapshot.data[index]['Clinics'][inx]['ClinicName']);
                                              }
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }
                        );
                      }else{
                        return Container(
                            height: width-100,
                            alignment: Alignment.center,
                            margin: EdgeInsets.all(20),
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
                                      Container(color:Colors.black,height:5,width:width*0.6,margin:EdgeInsets.only(top:5,left:10,right:5,bottom: 5),),
                                      Container(color:Colors.black,height:5,width:width*0.6,margin:EdgeInsets.only(top:5,left:10,right:5,bottom: 5),),
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
            ],
          ),
        )
            ),
     floatingActionButton: FloatingActionButton(
       onPressed: (){
         Navigator.push(context, MaterialPageRoute(builder: (context)=>DocReg()));
       },
       child: Icon(Icons.add,color: Colors.white,),
     ),
    );
  }
}
