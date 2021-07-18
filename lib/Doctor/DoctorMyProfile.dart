import 'package:flutter/material.dart';
class DoctorMyProfile extends StatefulWidget {
  final snapshot;
  const DoctorMyProfile({Key key, this.snapshot}) : super(key: key);
  @override
  _DoctorMyProfileState createState() => _DoctorMyProfileState();
}

class _DoctorMyProfileState extends State<DoctorMyProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.snapshot['Name']),
      ),
      body: Container(
        child: ListView(
          shrinkWrap: true,
          children: [
            Container(
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.all(Radius.circular(10)),
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
                        Icon(Icons.account_balance,color: Colors.white,size:18,),
                        Text(" ${widget.snapshot['Degree']}",style: TextStyle(fontWeight: FontWeight.normal,color: Colors.white,fontSize:18),)
                      ]
                      ),
                      TableRow(children: [
                        Icon(Icons.account_balance,color: Colors.white,size:18,),
                        Text(" ${widget.snapshot['Specialization']}",style: TextStyle(fontWeight: FontWeight.normal,color: Colors.white,fontSize:18),)
                      ]
                      ),
                      TableRow(children: [
                        Icon(Icons.phone_outlined,color: Colors.white,size:18,),
                        Text(" ${widget.snapshot['PhoneNumber']}",style: TextStyle(fontWeight: FontWeight.normal,color: Colors.white,fontSize:18),)
                      ]
                      ),
                      TableRow(children: [
                        Icon(Icons.email_outlined,color: Colors.white,size:18,),
                        Text(" ${widget.snapshot['Email']}",style: TextStyle(fontWeight: FontWeight.normal,color: Colors.white,fontSize:18),)
                      ]
                      ),
                      TableRow(children: [
                        Icon(Icons.home_work_outlined,color: Colors.white,size:18,),
                        Container(
                            width: MediaQuery.of(context).size.width*0.7,
                            child: Text(" ${widget.snapshot['Address']}, ${widget.snapshot['City']}, ${widget.snapshot['PinCode']}",style:TextStyle(fontWeight: FontWeight.normal,color: Colors.white,fontSize: 18),))
                      ]
                      ),
                    ],
                  ),

                ],
              ),
            ),
            Container(
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                padding: EdgeInsets.only(left:20.0,right:20.0,bottom:20.0,top:8),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left:0.0,right:8.0,bottom:8.0,top:0),
                        child: Text("Clinic ",style: TextStyle(color: Colors.white,fontSize:22),),
                      ),
                      ListView.builder(
                          shrinkWrap: true,
                          itemCount: widget.snapshot['Clinics'].length,
                          itemBuilder: (context, inx) {
                            return ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text("${inx+1}) " + widget.snapshot['Clinics'][inx]['ClinicName'],style: TextStyle(color: Colors.white),),
                              subtitle: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Address " + widget.snapshot['Clinics'][inx]['ClinicAddress'],style: TextStyle(color: Colors.white),),
                                  Text("Time " + widget.snapshot['Clinics'][inx]['TimeFrom'] +" To " + widget.snapshot['Clinics'][inx]['TimeTo'],style: TextStyle(color: Colors.white),),
                                ],
                              ),
                              /*trailing: IconButton(
                                icon: Icon(Icons.update),
                                onPressed: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>UpdateClinic(snapshot:widget.snapshot,index:inx,)));
                                },
                              ),*/
                            );
                          }
                      ),
                      /* Table(
                          columnWidths: {
                            0: FlexColumnWidth(1),
                            1: FlexColumnWidth(9),
                          },
                          children: [
                            TableRow(children: [
                              Icon(Icons.home_work_outlined,color: Colors.white,size:18,),
                              Container(
                                  width: MediaQuery.of(context).size.width*0.7,
                                  child: Text(" ${widget.snapshot['ClinicName']}",style:TextStyle(fontWeight: FontWeight.normal,color: Colors.white,fontSize: 18),))
                            ]
                            ),
                            TableRow(children: [
                              Icon(Icons.home_work_outlined,color: Colors.white,size:18,),
                              Container(
                                  width: MediaQuery.of(context).size.width*0.7,
                                  child: Text(" ${widget.snapshot['ClinicAddress']}, ${widget.snapshot['City']}, ${widget.snapshot['PinCode']}",style:TextStyle(fontWeight: FontWeight.normal,color: Colors.white,fontSize: 18),))
                            ]
                            ),
                          ]
                      )*/
                    ]
                )
            )
          ],
        ),
      ),
    /*  bottomNavigationBar: GestureDetector(
        onTap: (){
          Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) =>
                      UpdateDoctor(
                          snapshot: widget.snapshot)));
        },
        child: Container(
          height: 56,
          margin: EdgeInsets.all(10),
          color: Colors.green,
          child: Text("EDIT",style:TextStyle(color: Colors.white,fontSize:22,fontWeight: FontWeight.bold),),
          alignment: Alignment.center,
        ),
      ),*/
    );
  }
}
