import 'dart:convert';
import 'package:aarogyam/Admin/CreateMedicine.dart';
import 'package:aarogyam/Admin/UpdateMedicine.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';
import '../drawer.dart';

class Medicines extends StatefulWidget {
  @override
  _MedicinesState createState() => _MedicinesState();
}

class _MedicinesState extends State<Medicines> {
  List<Map> searchList = [];
  getTests()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    http.Response responce = await http.get("http://www.notoutindia.com/aarogyam/api/GetMedicines",headers: {
      "Authorization":prefs.getString('token'),
    });
    return jsonDecode(responce.body);
  }
  getKeywords()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    http.Response response = await http.get("http://www.notoutindia.com/aarogyam/api/GetMedicines",headers:{
      "Authorization":prefs.getString('token'),
    });
    jsonDecode(response.body).forEach((element) {
      searchList.add(element);
    });
    return searchList;
  }
  initState(){
    getKeywords();
    super.initState();
  }
  Future f;
  RefreshController _refreshController =
  RefreshController(initialRefresh: false);

  void _onRefresh() async{
    setState(() {
      f = getTests();
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
        onPressed: () {
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>CreateMedicine()));
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Text("All Medicines"),
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: Size(width,2), child: SizedBox(),
        ),
        actions: [
          IconButton(icon: Icon(Icons.search), onPressed: (){
            showSearch(context: context, delegate:SearchMedicine(searchList,0));
          })
        ],
      ),
      drawer: Drawer(
          child: CustomDrawer()
      ),
      body: Container(
        child:FutureBuilder(
            future: getTests(),
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.waiting) {
                if(snapshot.hasData) {
                  return SmartRefresher(
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
                    child: ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical:2.0,horizontal:8),
                          child: Card(
                            elevation: 5,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListTile(
                                title: Text("${snapshot.data[index]["Name"]}"),
                                subtitle: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("  Normal Rate : ₹ ${snapshot
                                        .data[index]["NormalRate"]}"),
                                    Text("  Lab Rate : ₹ ${snapshot
                                        .data[index]["LabRate"]
                                        .toString()
                                        .replaceAll("?", "")}"),
                                  ],
                                ),
                                trailing: PopupMenuButton(
                                  itemBuilder: (context) =>
                                  [
                                    PopupMenuItem(
                                      value: 1,
                                      child: Text(
                                        "Update",
                                        style: TextStyle(color: Colors.blue,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                  ],
                                  icon: Icon(Icons.more_vert),
                                  offset: Offset(0, 10),
                                  onSelected: (i) {
                                    if (i == 1) {
                                      Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(builder: (context) =>
                                              UpdateMedicine(
                                                data: snapshot.data[index],)));
                                    }
                                  },
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
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
                               // Container(color:Colors.black,height:5,width:width*0.6,margin:EdgeInsets.only(top:5,left:10,right:5,bottom: 5),),
                               // Container(color:Colors.black,height:5,width:width*0.6,margin:EdgeInsets.only(top:5,left:10,right:5,bottom: 5),),
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
    );
  }
}

class SearchMedicine extends SearchDelegate{
  final List<Map> listData;
  final type;
  SearchMedicine(this.listData, this.type);
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(icon: Icon(Icons.close), onPressed:(){
        query = "";
      })
    ];
  }
  List recentData =[];
  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,),
        onPressed:(){
          close(context, null);
        }
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Card(
      child: Text(""),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    var list = query.isEmpty ? recentData : listData.where((element) => element['Name'].toString().toLowerCase().contains(query)).toList();
    return ListView.builder(
        itemCount:list.length,
        itemBuilder:(context,index){
          return Padding(
            padding: const EdgeInsets.all(2.0),
            child: Card(
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text("${list[index]["Name"]}"),
                  subtitle: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("  Normal Rate : ${list[index]["NormalRate"]}"),
                      Text("  Lab Rate : ${list[index]["LabRate"]
                          .toString()
                          .replaceAll("?", "")}"),
                    ],
                  ),
                  trailing: PopupMenuButton(
                    itemBuilder: (context) =>
                    [
                      PopupMenuItem(
                        value: 1,
                        child: Text(
                          "Update",
                          style: TextStyle(color: Colors.blue,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                    icon: Icon(Icons.more_vert),
                    offset: Offset(0, 10),
                    onSelected: (i) {
                      if (i == 1) {
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) =>
                                UpdateMedicine(
                                  data: list[index],)));
                      }
                    },
                  ),
                ),
              ),
            ),
          );
        }
    );
  }
}