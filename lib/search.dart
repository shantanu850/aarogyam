import 'package:aarogyam/Admin/ViewDoctor.dart';
import 'package:flutter/material.dart';

import 'Admin/ViewPatent.dart';

class Search extends SearchDelegate{
  final List<Map> listData;
  final type;
  Search(this.listData, this.type);
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
          return ListTile(
            onTap: ()async{
              if(type==3){
                Navigator.pushReplacement(context, MaterialPageRoute(builder:(context)=>ViewPatent(snapshot:list[index],)));
              }
              if(type==2){
                Navigator.pushReplacement(context, MaterialPageRoute(builder:(context)=>ViewDoctor(snapshot:list[index],)));
              }
            },
            title: RichText(
              text:TextSpan(
                text:(list[index]['Name']!=null)?list[index]['Name'].substring(0,query.length):"",
                style: TextStyle(color: Colors.grey,fontWeight:FontWeight.normal),
                  children: [
                    TextSpan(
                        text:(list[index]['Name']!=null)?list[index]['Name'].substring(query.length):"",
                        style: TextStyle(color: Colors.grey)
                    )
                  ]
              ),
            )
          );
        }
    );
  }
}