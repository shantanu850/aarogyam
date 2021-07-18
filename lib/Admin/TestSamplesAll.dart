import 'dart:convert';
import 'package:aarogyam/Admin/ViewTestSample.dart';
import 'package:aarogyam/drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:aarogyam/Admin/ViewPatent.dart';
import 'package:shimmer/shimmer.dart';

class TestSampleAll extends StatefulWidget {
  @override
  _TestSampleAllState createState() => _TestSampleAllState();
}

class _TestSampleAllState extends State<TestSampleAll> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  DateTime date1,date2;
  Future f;
  getData()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    http.Response rr = await http.post("http://www.notoutindia.com/aarogyam/api/TestSamples",
        headers: {
          "Authorization":prefs.getString('token'),
        },
    );
    if (rr.statusCode==200||rr.statusCode==201){
      return jsonDecode(rr.body);
    }else{
      return [];
    }
  }
  getPatient(id)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    http.Response rr = await http.get("http://www.notoutindia.com/aarogyam/api/GetPatient?Id=$id",
        headers: {
          "Authorization":prefs.getString('token'),
        },
    );
    if (rr.statusCode==200||rr.statusCode==201){
      return jsonDecode(rr.body);
    }else{
      return [];
    }
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
  final List<String> titles = ["booked", "Collected", "Payment","Complete",];
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("All Tests"),
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: Size(width,2), child: SizedBox(),
        ),
      ),
      drawer: Drawer(
          child: CustomDrawer()
      ),
      body:Container(
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
                child: FutureBuilder(
                    future: getData(),
                    builder: (context, snap) {
                      if (snap.connectionState != ConnectionState.waiting) {
                        if(snap.hasData) {
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
                                      onTap: () {
                                        _scaffoldKey.currentState.showSnackBar(
                                            SnackBar(content: Text(
                                                "Wait finding Corresponding Patient ......."),));
                                        http.post(
                                            "http://www.notoutindia.com/aarogyam/api/GetPatient?Id=${snap
                                                .data[index]['PatientId']}")
                                            .then((value) =>
                                        {
                                          if(value.statusCode == 200 ||
                                              value.statusCode == 201){
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ViewTestSample(
                                                          snapshot: snap
                                                              .data[index],
                                                          patentSnapshot: jsonDecode(
                                                              value.body),)))
                                          } else
                                            {
                                              _scaffoldKey.currentState
                                                  .showSnackBar(SnackBar(
                                                content: Text(
                                                    "Corresponding Patient Not Found . Try Again !"),))
                                            }
                                        });
                                      },
                                      subtitle: Column(
                                        children: [
                                          Container(
                                            child: StepProgressView(
                                              icons: [
                                                Icons.assignment,
                                                Icons.collections_bookmark_sharp,
                                                Icons.monetization_on_outlined,
                                                Icons.assignment_turned_in,
                                              ],
                                              width: MediaQuery
                                                  .of(context)
                                                  .size
                                                  .width,
                                              curStep: (jsonDecode(
                                                  snap.data[index]['Status']) < 4)
                                                  ? jsonDecode(
                                                  snap.data[index]['Status']) + 1
                                                  : 4,
                                              color: Colors.green,
                                              titles: titles,
                                            ),
                                          ),
                                        ],
                                      ),
                                      title: ListTile(
                                        trailing: IconButton(
                                          icon: Icon(Icons.person_outline),
                                          onPressed: () {
                                            _scaffoldKey.currentState
                                                .showSnackBar(SnackBar(
                                              content: Text(
                                                  "Wait finding Corresponding Patient ......."),));
                                            http.post("http://www.notoutindia.com/aarogyam/api/GetPatient?Id=${snap.data[index]['PatientId']}")
                                                .then((value) =>
                                            {
                                              if(value.statusCode == 200 ||
                                                  value.statusCode == 201){
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            ViewPatent(
                                                                snapshot: jsonDecode(
                                                                    value.body))))
                                              } else
                                                {
                                                  _scaffoldKey.currentState
                                                      .showSnackBar(SnackBar(
                                                    content: Text(
                                                        "Corresponding Patient Not Found . Try Again !"),))
                                                }
                                            });
                                          },
                                        ),
                                        title: Text(
                                          "Test Id : ${snap.data[index]['Id']}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),),
                                        subtitle: Column(
                                          mainAxisAlignment: MainAxisAlignment
                                              .start,
                                          crossAxisAlignment: CrossAxisAlignment
                                              .start,
                                          children: [
                                            FutureBuilder(
                                                future: getPatient(snap.data[index]['PatientId']),
                                                builder: (context, snapshotpat) {
                                                  if (snapshotpat.connectionState !=
                                                      ConnectionState.waiting) {
                                                    if(snapshotpat.hasError) {
                                                      return RichText(
                                                          text: TextSpan(
                                                              children: <
                                                                  TextSpan>[
                                                                TextSpan(
                                                                    text: "${snapshotpat.data['Name']}",
                                                                    style: TextStyle(
                                                                        fontWeight: FontWeight
                                                                            .normal,
                                                                        color: Colors
                                                                            .black))
                                                              ],
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight: FontWeight
                                                                      .bold),
                                                              text: "Patient : ")
                                                      );
                                                    }else{
                                                      return RichText(
                                                          text: TextSpan(
                                                              children: <TextSpan>[
                                                                TextSpan(
                                                                    text: "${snap
                                                                        .data[index]['PatientId']}",
                                                                    style: TextStyle(
                                                                        fontWeight: FontWeight
                                                                            .normal,
                                                                        color: Colors
                                                                            .black))
                                                              ],
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight: FontWeight
                                                                      .bold),
                                                              text: "Patient : ")
                                                      );
                                                    }
                                                  } else {
                                                    return RichText(
                                                        text: TextSpan(
                                                            children: <TextSpan>[
                                                              TextSpan(
                                                                  text: "${snap
                                                                      .data[index]['PatientId']}",
                                                                  style: TextStyle(
                                                                      fontWeight: FontWeight
                                                                          .normal,
                                                                      color: Colors
                                                                          .black))
                                                            ],
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight: FontWeight
                                                                    .bold),
                                                            text: "Patient : ")
                                                    );
                                                  }
                                                }
                                            ),
                                            RichText(
                                                text: TextSpan(
                                                    children: <TextSpan>[
                                                      TextSpan(text: DateFormat(
                                                          "dd-MM-yyyy")
                                                          .format(DateFormat(
                                                          "yyyy-MM-dd hh:mm:ss")
                                                          .parse(snap
                                                          .data[index]['CreatedDate']))
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
                                                    text: "Test Date : ")
                                            ),
                                            Text("Tests", style: TextStyle(
                                                color: Colors
                                                    .black,
                                                fontWeight: FontWeight
                                                    .bold),),
                                            ListView.builder(
                                              shrinkWrap: true,
                                              physics: NeverScrollableScrollPhysics(),
                                              itemCount: jsonDecode(
                                                  snap.data[index]['Disease'])['disease']
                                                  .length,
                                              itemBuilder: (context, ind) {
                                                return Text(jsonDecode(snap.data[index]['Disease'])['disease'][ind]['Name'],
                                                  style: TextStyle(
                                                      fontSize: 12),);
                                              },
                                            ),
                                            Text("Medicines", style: TextStyle(
                                                color: Colors
                                                    .black,
                                                fontWeight: FontWeight
                                                    .bold),),
                                            ListView.builder(
                                              shrinkWrap: true,
                                              physics: NeverScrollableScrollPhysics(),
                                              itemCount: jsonDecode(
                                                  snap.data[index]['Disease'])['medicines']
                                                  .length,
                                              itemBuilder: (context, ind) {
                                                return Text(jsonDecode(snap.data[index]['Disease'])['medicines'][ind]['Name'],
                                                  style: TextStyle(
                                                      fontSize: 12),);
                                              },
                                            ),
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
                                        Container(
                                          alignment: Alignment.center,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              CircleAvatar(radius:15,),
                                              CircleAvatar(radius:15,),
                                              CircleAvatar(radius:15,),
                                              CircleAvatar(radius:15,),
                                            ],
                                          ),
                                        )
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
class StepProgressView extends StatelessWidget {

  final double _width;
  final List<IconData> _icons;
  final List<String> _titles;
  final int _curStep;
  final Color _activeColor;
  final Color _inactiveColor = Colors.grey[100];
  final double lineWidth = 4.0;
  StepProgressView({Key key,
    @required List<IconData> icons,
    @required int curStep,
    List<String> titles,
    @required double width,
    @required Color color}) :
        _icons = icons,
        _titles = titles,
        _curStep = curStep,
        _width = width,
        _activeColor = color,
        assert(curStep > 0 == true && curStep <= icons.length),
        assert(width > 0),
        super(key: key);
  Widget build (BuildContext context) {
    return Container(
        padding: EdgeInsets.only(top: 10.0, left: 24.0, right: 24.0,),
        width: this._width,
        child: Column(
          children: <Widget>[

            Row(
              children: _iconViews(),
            ),

            SizedBox(height: 10,),

            if (_titles != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: _titleViews(),
              ),

          ],
        ));
  }
  List<Widget> _iconViews() {
    var list = <Widget>[];
    _icons.asMap().forEach((i, icon) {

      //colors according to state
      var circleColor = (i == 0 || _curStep > i + 1)
          ? _activeColor
          : _inactiveColor;

      var lineColor = _curStep > i + 1
          ? _activeColor
          : _inactiveColor;

      var iconColor = (i == 0 || _curStep > i + 1)
          ? _inactiveColor
          : _activeColor;

      list.add(

        //dot with icon view
        Container(
          width: 30.0,
          height: 30.0,
          padding: EdgeInsets.all(0),
          child: Icon(icon, color: iconColor,size: 15.0,),
          decoration: new BoxDecoration(
            color: circleColor,
            borderRadius: new BorderRadius.all(new Radius.circular(25.0)),
            border: new Border.all(
              color: _activeColor,
              width: 2.0,
            ),
          ),
        ),
      );

      //line between icons
      if (i != _icons.length - 1) {
        list.add(
            Expanded(
                child: Container(height: lineWidth, color: lineColor,)
            )
        );
      }
    });

    return list;
  }
  List<Widget> _titleViews() {
    var list = <Widget>[];
    _titles.asMap().forEach((i, text) {
      list.add(Text(text, style: TextStyle(color: _activeColor,fontSize:10)));
    });
    return list;
  }
}