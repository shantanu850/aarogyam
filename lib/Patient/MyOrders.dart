import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:aarogyam/drawer.dart';
import 'package:shimmer/shimmer.dart';
import 'PatientViewTestSample.dart';

class MyOrders extends StatefulWidget {
  @override
  _PatientMyTestState createState() => _PatientMyTestState();
}

class _PatientMyTestState extends State<MyOrders> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  DateTime date1,date2;
  String localId;
  Future f;
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
      print(prefs.getString('userId'));
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
    await getId();
    http.Response rr = await http.post("http://www.notoutindia.com/aarogyam/api/GetOrders?PatientId=${prefs.getString('userId')}",
      headers: {
        "Authorization":prefs.getString('token'),
      },
    );
    if(rr.statusCode==200||rr.statusCode==201) {
      return jsonDecode(rr.body);
    }else{
      return [];
    }
  }
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
  //final List<String> titles = ["booked", "Collected", "Payment","Complete",];
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        title: Text("My Orders"),
        bottom: PreferredSize(
          preferredSize: Size(0,2), child: SizedBox(),
        ),
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
              Container(
                child: FutureBuilder(
                    future: f,
                    builder: (context, snap) {
                      if (snap.connectionState != ConnectionState.waiting) {
                        print(snap.data);
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
                                      title: Text("Expected Delivery : ${snap.data[index]['DeliveryDate']}"),
                                      subtitle: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Amount : ${snap.data[index]['TotalAmount']}"),
                                          Text("Orderd On : ${snap.data[index]['CreatedDate']}"),
                                          Text("Status : ${snap.data[index]['Status']}"),
                                          Text("City : ${snap.data[index]['City']}"),
                                          Text("PinCode : ${snap.data[index]['PinCode']}"),
                                          Text("Landmark : ${snap.data[index]['Landmark']}"),
                                          Text("District : ${snap.data[index]['District']}"),
                                          Text("Address : ${snap.data[index]['Address']}"),
                                          Text("MedicineIds", style: TextStyle(
                                              color: Colors
                                                  .black,
                                              fontWeight: FontWeight
                                                  .bold),),
                                          ("${snap.data[index]['MedicineIds']}"!="null")?ListView.builder(
                                            shrinkWrap: true,
                                            physics: NeverScrollableScrollPhysics(),
                                            itemCount: jsonDecode(snap.data[index]['MedicineIds']).length,
                                            itemBuilder: (context, ind) {
                                              print("tada ${snap.data[index]['MedicineIds'].toString()}");
                                              return Text(jsonDecode(snap.data[index]['MedicineIds'])[ind]['Name'],
                                                style: TextStyle(
                                                    fontSize: 12),);
                                            },
                                          ):Container(child: Text("Error While Loading medicines"),),
                                        ],
                                      ),
                                    )
                                  ),
                                );
                              }
                          );
                        }else{
                          return Container(
                              height: width-100,
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
                                        Container(color:Colors.black,height:5,width:width*0.6,margin:EdgeInsets.only(top:5,left:10,right:5,bottom: 5),),
                                        Container(color:Colors.black,height:5,width:width*0.6,margin:EdgeInsets.only(top:5,left:10,right:5,bottom: 5),),
                                        /*Container(
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
                                        )*/
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
