import 'dart:convert';

import 'package:flutter/material.dart';
import 'PatientDoctorView.dart';
import 'package:http/http.dart' as http;
class PatientSearchDoctor extends SearchDelegate{
  final List<Map> listData;
  PatientSearchDoctor(this.listData);
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
    var list2 = query.isEmpty ? recentData : listData.where((element) => element['ClinicName'].toString().toLowerCase().contains(query)).toList();
    var finalList = list+list2;
    return ListView.builder(
        itemCount:list.length,
        itemBuilder:(context,index){
          return Card(
            child: (list[index]['type']==0)?ListTile(
              onTap: ()async{
                http.Response value = await http.post("http://www.notoutindia.com/aarogyam/api/GetDoctor?Id=${list[index]['Id']}");
                if(value.statusCode == 200 || value.statusCode == 201){
                  Navigator.pushReplacement(context, MaterialPageRoute(builder:(context)=>PatientViewDoctor(snapshot:jsonDecode(value.body),)));
                }
              },
              title: RichText(
                text:TextSpan(
                    text:(list[index]['Name']!=null)?list[index]['Name'].substring(0,query.length):"",
                    style: TextStyle(color: Colors.grey[800],fontWeight:FontWeight.bold),
                    children: [
                      TextSpan(
                          text:(list[index]['Name']!=null)?list[index]['Name'].substring(query.length):"",
                          style: TextStyle(color: Colors.grey,fontWeight:FontWeight.normal)
                      )
                    ]
                ),
              ),
              subtitle:Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Doctor : "+list[index]['ClinicName'], style: TextStyle(color: Colors.grey,fontWeight:FontWeight.normal),),
                  Text("Time : "+list[index]['Time'], style: TextStyle(color: Colors.grey,fontWeight:FontWeight.normal),),
                ],
              ),
            ):ListTile(
              onTap: ()async{
                http.Response value = await http.post("http://www.notoutindia.com/aarogyam/api/GetDoctor?Id=${list[index]['Id']}");
                if(value.statusCode == 200 || value.statusCode == 201){
                  Navigator.pushReplacement(context, MaterialPageRoute(builder:(context)=>PatientViewDoctor(snapshot:jsonDecode(value.body),)));
                }
              },
              title: RichText(
                text:TextSpan(
                    text:(list[index]['Name']!=null)?list[index]['Name'].substring(0,query.length):"",
                    style: TextStyle(color: Colors.grey[800],fontWeight:FontWeight.bold),
                    children: [
                      TextSpan(
                          text:(list[index]['Name']!=null)?list[index]['Name'].substring(query.length):"",
                          style: TextStyle(color: Colors.grey,fontWeight:FontWeight.normal)
                      )
                    ]
                ),
              ),
            ),
          );
        }
    );
  }
}