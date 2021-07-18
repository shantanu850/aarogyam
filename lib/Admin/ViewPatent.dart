import 'dart:convert';
import 'package:aarogyam/Admin/TestSample.dart';
import 'package:aarogyam/Admin/UpdatePatent.dart';
import 'package:aarogyam/Admin/ViewTestSample.dart';
import 'package:aarogyam/drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:aarogyam/Screens/RstPassword.dart';
import 'package:shimmer/shimmer.dart';

class ViewPatent extends StatefulWidget {
  final snapshot;
  const ViewPatent({Key key, this.snapshot}) : super(key: key);
  @override
  _ViewPatentState createState() => _ViewPatentState();
}

class _ViewPatentState extends State<ViewPatent> {
  getData(id)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    http.Response rr = await http.post("http://www.notoutindia.com/aarogyam/api/TestSamples?PatientId=$id",
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
  final List<String> titles = ["booked", "Collected", "Payment","Complete",];
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("${widget.snapshot['Name']}"),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) =>
            [
              PopupMenuItem(
                value: 1,
                child: Text(
                  "Pass. Reset",
                  style: TextStyle(color: Colors.blue,
                      fontWeight: FontWeight.w700),
                ),
              ),
            ],
            icon: Icon(Icons.more_vert),
            offset: Offset(0, 100),
            onSelected: (i) {
              if (i == 1) {
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>RstPass(snapshot:widget.snapshot)));
              }
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: CustomDrawer()
      ),
      body:Container(
        child: ListView(
          shrinkWrap: true,
          children: [
            Container(
              child: Container(
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Table(
                      columnWidths: {
                        0: FlexColumnWidth(1),
                        1: FlexColumnWidth(9),
                      },
                      children: [
                        TableRow(children: [
                          Icon(Icons.phone_outlined,color: Colors.white,size:18,),
                          //Text("Phone No",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
                          Text(" ${widget.snapshot['PhoneNumber']}",style: TextStyle(fontWeight: FontWeight.normal,color: Colors.white,fontSize:18),)
                        ]
                        ),
                        TableRow(children: [
                          Icon(Icons.email_outlined,color: Colors.white,size:18,),
                          //Text("Email",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
                          Text(" ${widget.snapshot['Email']}",style: TextStyle(fontWeight: FontWeight.normal,color: Colors.white,fontSize:18),)
                        ]
                        ),
                        TableRow(children: [
                          Icon(Icons.home_work_outlined,color: Colors.white,size:18,),
                          //Text("Address",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
                          Container(
                              width: MediaQuery.of(context).size.width*0.7,
                              child: Text(" ${widget.snapshot['Address']}",style:TextStyle(fontWeight: FontWeight.normal,color: Colors.white,fontSize: 18),))
                        ]
                        ),
                        TableRow(children: [
                          Icon(Icons.airline_seat_individual_suite_outlined,color: Colors.white,size:18,),
                          //Text("Disease",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
                          Text(" ${widget.snapshot['Disease']}",style: TextStyle(fontWeight: FontWeight.normal,color: Colors.white,fontSize:18),)
                        ]
                        ),
                      ],
                    ),
                    Divider(indent:5,endIndent:5,color: Colors.white70,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(children: [
                          Text("Blood Group",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
                          Text("${widget.snapshot['BloodGroup'].toString().toUpperCase()}",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white,fontSize:30),)
                        ]
                        ),
                        Column(children: [
                          Text("Gender",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
                          Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: (widget.snapshot['Gender']=='male')?SvgPicture.asset("assets/male-gender.svg",color:Colors.white,height:25,width: 25,):SvgPicture.asset("assets/woman.svg",color:Colors.white,height:25,width: 25,),
                          ),
                          //Text("${widget.snapshot['Gender']}",style: TextStyle(fontWeight: FontWeight.normal,color: Colors.white),)
                        ]
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left:10.0),
              child: Text("All Tests",style: TextStyle(fontWeight: FontWeight.bold),),
            ),
            Container(
              //height:MediaQuery.of(context).size.height-120,
              child: FutureBuilder(
                  future: getData(widget.snapshot['Id']),
                  builder: (context, snap) {
                    if (snap.connectionState != ConnectionState.waiting) {
                      if(snap.data.length>0) {
                        return ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: snap.data.length,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: EdgeInsets.all(10.0),
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  elevation: 4,
                                  child: Container(
                                    padding: EdgeInsets.all(10.0),
                                    child: ListTile(
                                      title: Text(
                                        "Test ID : ${snap.data[index]['Id']}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),),
                                      subtitle: Padding(
                                        padding: EdgeInsets.only(
                                            left: 8.0, top: 4.0),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment
                                              .start,
                                          crossAxisAlignment: CrossAxisAlignment
                                              .start,
                                          children: [
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
                                            RichText(
                                                text: TextSpan(
                                                    children: <TextSpan>[
                                                      TextSpan(
                                                          text: widget
                                                              .snapshot['CreatedBy'],
                                                          style: TextStyle(
                                                            fontWeight: FontWeight
                                                                .normal,
                                                            color: Colors
                                                                .black,))
                                                    ],
                                                    style: TextStyle(
                                                        color: Colors
                                                            .black,
                                                        fontWeight: FontWeight
                                                            .bold),
                                                    text: "Created By : ")),
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
                                            Container(
                                              child: StepProgressView(
                                                icons: [
                                                  Icons.assignment,
                                                  Icons
                                                      .collections_bookmark_sharp,
                                                  Icons
                                                      .monetization_on_outlined,
                                                  Icons.assignment_turned_in,
                                                ],
                                                width: MediaQuery
                                                    .of(context)
                                                    .size
                                                    .width,
                                                curStep: (jsonDecode(snap
                                                    .data[index]['Status']) < 4)
                                                    ? jsonDecode(snap
                                                    .data[index]['Status']) + 1
                                                    : 4,
                                                color: Colors.green,
                                                titles: titles,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ViewTestSample(
                                                        snapshot: snap
                                                            .data[index],
                                                        patentSnapshot: widget
                                                            .snapshot)));
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
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom:4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>TestSample(snapshot:widget.snapshot)));
              },
              child: Card(
                color: Colors.red,
                child: Container(
                  height: 56,
                  width: MediaQuery.of(context).size.width*0.5-10,
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.add,color: Colors.white,),
                      Text("  Test Sample",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                    ],
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>UpdatePatent(snapshot:widget.snapshot)));
              },
              child: Card(
                color: Colors.blue,
                child: Container(
                  height: 56,
                  width: MediaQuery.of(context).size.width*0.5-10,
                  alignment: Alignment.center,
                  child: Text("Edit",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ],
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
        padding: EdgeInsets.only(top: 32.0, left: 24.0, right: 24.0,),
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
      list.add(Text(text, style: TextStyle(color: _activeColor,fontSize: 12),textAlign:TextAlign.center,));
    });
    return list;
  }
}