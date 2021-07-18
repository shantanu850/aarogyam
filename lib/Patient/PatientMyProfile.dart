import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:aarogyam/drawer.dart';

class PatientMyProfile extends StatefulWidget {
  final snapshot;
  const PatientMyProfile({Key key, this.snapshot}) : super(key: key);
  @override
  _PatientMyProfileState createState() => _PatientMyProfileState();
}

class _PatientMyProfileState extends State<PatientMyProfile> {
  /*getData(id)async{
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
  }*/
  final List<String> titles = ["booked", "Collected", "Payment","Complete",];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.snapshot['Name']}"),
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
           /* Padding(
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
                                                  snap.data[index]['Disease'])
                                                  .length,
                                              itemBuilder: (context, ind) {
                                                return Text(jsonDecode(snap
                                                    .data[index]['Disease'])[ind]['Name'],
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
                          height:200,
                          alignment: Alignment.center,
                          child: Text("No Records Found"),
                        );
                      }
                    }else{
                      return Container(
                        height:200,
                        alignment: Alignment.center,
                        child: Text("Loading...."),
                      );
                    }
                  }
              ),
            ),*/
            SizedBox(height:80,)
          ],
        ),
      ),
     /* bottomNavigationBar: Padding(
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
      ),*/
    );
  }
}
