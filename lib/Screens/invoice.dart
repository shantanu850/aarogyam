import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:aarogyam/Admin/AdminHome.dart';
import 'package:aarogyam/Screens/ViewImage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:recase/recase.dart';

class Invoice extends StatefulWidget {
  final snapshot1;
  final snapshot2;
  final data;
  final url;
  final bool goBackHome;
  const Invoice({Key key, this.snapshot1, this.snapshot2, this.data,this.goBackHome = true, this.url}) : super(key: key);@override
  _InvoiceState createState() => _InvoiceState();
}

class _InvoiceState extends State<Invoice> {
  Future<bool> pop()async{
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>AdminHome()));
    return Future<bool>.value(!widget.goBackHome);
  }
  final pdf = pw.Document();
  Uint8List uint8list;
  Uint8List image;
  getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load('assets/$path');
    final file = File('${(await getTemporaryDirectory()).path}/$path');
    await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    setState(() {
      uint8list = file.readAsBytesSync();
    });
    return file;
  }
  genPdf(){
    pdf.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Container(
              padding: pw.EdgeInsets.symmetric(horizontal:20),
              child:pw.ListView(
                children: [
                  pw.Container(
                      child:pw.Column(
                        mainAxisAlignment: pw.MainAxisAlignment.start,
                        crossAxisAlignment: pw.CrossAxisAlignment.center,
                        children: [
                          pw.Image(PdfImage.file(pdf.document,bytes:uint8list),height:100),
                        ],
                      )
                  ),
                  pw.Container(
                    decoration: pw.BoxDecoration(
                        border:pw.BoxBorder(color: PdfColors.black,width:2)                    ),
                    padding: pw.EdgeInsets.all(10),
                    margin: pw.EdgeInsets.all(10),
                    child: pw.Table(
                      //border: TableBorder.all(width: 1.0,color: Colors.grey),
                      children: [
                        pw.TableRow(
                            children: [
                              pw.Text("Name",style: pw.TextStyle(fontWeight: pw.FontWeight.bold),),
                              pw.Text("${widget.snapshot2['Name']}")
                            ]
                        ),
                        pw.TableRow(children: [
                          pw.Text("Phone No",style: pw.TextStyle(fontWeight: pw.FontWeight.bold),),
                          pw.Text("${widget.snapshot2['PhoneNumber']}")
                        ]
                        ),
                        pw.TableRow(children: [
                          pw.Text("Email",style: pw.TextStyle(fontWeight: pw.FontWeight.bold),),
                          pw.Text("${widget.snapshot2['Email']}")
                        ]
                        ),pw.TableRow(children: [
                          pw.Text("Gender",style: pw.TextStyle(fontWeight: pw.FontWeight.bold),),
                          pw.Text("${widget.snapshot2['Gender']}")
                        ]
                        ),
                        pw.TableRow(children: [
                          pw.Text("Disease",style: pw.TextStyle(fontWeight: pw.FontWeight.bold),),
                          pw.Text("${widget.snapshot2['Disease']}")
                        ]
                        ),
                      ],
                    ),
                  ),
                  pw.Container(
                    decoration: pw.BoxDecoration(
                        border:pw.BoxBorder(color: PdfColors.black,width:2)                    ),
                    padding: pw.EdgeInsets.all(5),
                    margin: pw.EdgeInsets.symmetric(horizontal: 10,vertical:2),
                    child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: pw.CrossAxisAlignment.center,
                      children: [
                        pw.Text("Tests",style: pw.TextStyle(fontWeight: pw.FontWeight.bold),),
                        pw.Text("Price (Rs.)",style: pw.TextStyle(fontWeight: pw.FontWeight.bold),),
                      ],
                    ),
                  ),
                  pw.Container(
                    decoration: pw.BoxDecoration(
                        border:pw.BoxBorder(color: PdfColors.black,width:2)
                    ),
                    padding: pw.EdgeInsets.all(5),
                    margin: pw.EdgeInsets.all(10),
                    alignment: pw.Alignment.center,
                    child: pw.ListView.builder(
                        itemCount:jsonDecode(widget.snapshot1['Disease'])['disease'].length,
                        itemBuilder: (context,index){
                          return pw.Column(
                            children: [
                              pw.Container(
                                child: pw.Row(
                                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                                  children: [
                                    pw.Text("${index+1}) ${jsonDecode(widget.snapshot1['Disease'])['disease'][index]['Name']}"),
                                    pw.Text("${jsonDecode(widget.snapshot1['Disease'])['disease'][index]['NormalRate']}",textAlign: pw.TextAlign.left,),
                                  ],
                                ),
                              ),
                              pw.SizedBox(height:10,),
                              pw.Divider(height:1,indent:10,endIndent:10),
                              pw.SizedBox(height:10,),
                            ],
                          );
                        }
                    ),
                  ),
                  pw.Container(
                    decoration: pw.BoxDecoration(
                        border:pw.BoxBorder(color: PdfColors.black,width:2)
                    ),
                    padding: pw.EdgeInsets.all(5),
                    margin: pw.EdgeInsets.all(10),
                    alignment: pw.Alignment.center,
                    child: pw.ListView.builder(
                        itemCount:jsonDecode(widget.snapshot1['Disease'])['medicines'].length,
                        itemBuilder: (context,index){
                          return pw.Column(
                            children: [
                              pw.Container(
                                child: pw.Row(
                                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                                  children: [
                                    pw.Text("${index+1}) ${jsonDecode(widget.snapshot1['Disease'])['medicines'][index]['Name']}"),
                                    pw.Text("${jsonDecode(widget.snapshot1['Disease'])['medicines'][index]['NormalRate']}",textAlign: pw.TextAlign.left,),
                                  ],
                                ),
                              ),
                              pw.SizedBox(height:10,),
                              pw.Divider(height:1,indent:10,endIndent:10),
                              pw.SizedBox(height:10,),
                            ],
                          );
                        }
                    ),
                  ),
                  pw.Container(
                    decoration: pw.BoxDecoration(
                        border:pw.BoxBorder(color: PdfColors.black,width:2)                    ),
                    padding: pw.EdgeInsets.all(5),
                    margin: pw.EdgeInsets.symmetric(horizontal: 10,vertical:2),
                    child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: pw.CrossAxisAlignment.center,
                      children: [
                        pw.Text("Total",style: pw.TextStyle(fontWeight: pw.FontWeight.bold),),
                        pw.Text("${"Rs."+" "+widget.data['fees']}",style: pw.TextStyle(fontWeight: pw.FontWeight.bold),),
                      ],
                    ),
                  ),
                  pw.Container(
                    decoration: pw.BoxDecoration(
                        border:pw.BoxBorder(color: PdfColors.black,width:2)                    ),
                    padding: pw.EdgeInsets.only(top:50,left: 5,right: 5,bottom: 5),
                    margin: pw.EdgeInsets.symmetric(horizontal: 10,vertical:2),
                    child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: pw.CrossAxisAlignment.center,
                      children: [
                        pw.Text("Signature",style: pw.TextStyle(fontWeight: pw.FontWeight.normal),),
                        pw.Text("Signature",style: pw.TextStyle(fontWeight: pw.FontWeight.normal),),
                      ],
                    ),
                  ),
                  pw.Container(
                    margin: pw.EdgeInsets.all(20),
                    height: 200,
                    width: 200,
                    alignment: pw.Alignment.center,
                    child: (image!=null)?pw.Image(PdfImage.file(pdf.document,bytes:image),fit:pw.BoxFit.cover,height:200,width:200):pw.Text("QR Not Available",style: pw.TextStyle(fontWeight: pw.FontWeight.normal),)
                  ),
                  pw.SizedBox(height:5,),
                  pw.Text("Scan the QR from Aarogyam get more details")
                ],
              )
          ); // Center
        }));
  }
  @override
  void initState() {
    print(widget.data);
    print(widget.snapshot1);
    print(widget.snapshot2);
    print(widget.goBackHome);
   setState(() {
      if(widget.snapshot1['QRCode']!="QR") {
        image = Uint8List.fromList(jsonDecode(widget.snapshot1['QRCode']).cast<int>());
      }
    });
    getImageFileFromAssets("logo_small.jpeg");
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop:pop,
      child: Scaffold(
        appBar: AppBar(
          leadingWidth: 10,
          leading: Container(),
         title: Text("Invoice"),
         // title: Text("${widget.snapshot2['Name'].toString().sentenceCase}"),
          actions: [
            IconButton(
              icon: Icon(Icons.print),
              onPressed: ()async{
                await genPdf();
                await Printing.sharePdf(bytes: pdf.save(), filename: '${widget.snapshot2['Name']} ${widget.snapshot1['Id']}.pdf');
              },
            ),
            IconButton(
              icon: Icon(Icons.image_outlined),
              onPressed: (){
                print(widget.snapshot1);
                Navigator.push(context, MaterialPageRoute(builder: (context)=>ViewImage(url:widget.url)));
              },
            ),
          ],
        ),
        body: Container(
          child: ListView(
              shrinkWrap: true,
              children: [
                Container(
                  child:Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset('assets/logo_small.jpeg',height: 100,),
                    ],
                  )
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[700])
                  ),
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.all(10),
                  child: Table(
                    //border: TableBorder.all(width: 1.0,color: Colors.grey),
                    children: [
                      TableRow(
                          children: [
                            Text("Name",style: TextStyle(fontWeight: FontWeight.bold),),
                            Text("${widget.snapshot2['Name']}")
                          ]
                      ),
                      TableRow(children: [
                        Text("Phone No",style: TextStyle(fontWeight: FontWeight.bold),),
                        Text("${widget.snapshot2['PhoneNumber']}")
                      ]
                      ),
                      TableRow(children: [
                        Text("Email",style: TextStyle(fontWeight: FontWeight.bold),),
                        Text("${widget.snapshot2['Email']}")
                      ]
                      ),TableRow(children: [
                        Text("Gender",style: TextStyle(fontWeight: FontWeight.bold),),
                        Text("${widget.snapshot2['Gender']}")
                      ]
                      ),
                      TableRow(children: [
                        Text("Disease",style: TextStyle(fontWeight: FontWeight.bold),),
                        Text("${widget.snapshot2['Disease']}")
                      ]
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[700])
                  ),
                  padding: EdgeInsets.all(5),
                  margin: EdgeInsets.symmetric(horizontal: 10,vertical:2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("Tests",style: TextStyle(fontWeight: FontWeight.bold),),
                      Text("Price (Rs.)",style: TextStyle(fontWeight: FontWeight.bold),),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[700])
                  ),
                  padding: EdgeInsets.all(5),
                  margin: EdgeInsets.all(10),
                  alignment: Alignment.center,
                  child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount:jsonDecode(widget.snapshot1['Disease'])['disease'].length,
                        itemBuilder: (context,index){
                          return Column(
                            children: [
                              Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                          width:(MediaQuery.of(context).size.width*0.6)-16,
                                          child: Text("${index+1}) ${jsonDecode(widget.snapshot1['Disease'])['disease'][index]['Name']}")),
                                      Container(
                                        padding:EdgeInsets.only(right:10),
                                          width:(MediaQuery.of(context).size.width*0.4)-16,
                                          child: Text("${jsonDecode(widget.snapshot1['Disease'])['disease'][index]['NormalRate']}",textAlign: TextAlign.end,)),
                                    ],
                                ),
                              ),
                              SizedBox(height:10,),
                              Divider(height:1,indent:20,endIndent:20,color: Colors.grey,)
                            ],
                          );
                        }
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[700])
                  ),
                  padding: EdgeInsets.all(5),
                  margin: EdgeInsets.all(10),
                  alignment: Alignment.center,
                  child: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount:jsonDecode(widget.snapshot1['Disease'])['medicines'].length,
                      itemBuilder: (context,index){
                        return Column(
                          children: [
                            Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                      width:(MediaQuery.of(context).size.width*0.6)-16,
                                      child: Text("${index+1}) ${jsonDecode(widget.snapshot1['Disease'])['medicines'][index]['Name']}")),
                                  Container(
                                      padding:EdgeInsets.only(right:10),
                                      width:(MediaQuery.of(context).size.width*0.4)-16,
                                      child: Text("${jsonDecode(widget.snapshot1['Disease'])['medicines'][index]['NormalRate']}",textAlign: TextAlign.end,)),
                                ],
                              ),
                            ),
                            SizedBox(height:10,),
                            Divider(height:1,indent:20,endIndent:20,color: Colors.grey,)
                          ],
                        );
                      }
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[700])
                  ),
                  padding: EdgeInsets.all(5),
                  margin: EdgeInsets.symmetric(horizontal: 10,vertical:2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("Total",style: TextStyle(fontWeight: FontWeight.bold),),
                      Text("${"Rs."+ widget.data['fees']}",style: TextStyle(fontWeight: FontWeight.bold),),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[700])
                  ),
                  padding: EdgeInsets.only(top:100,left: 5,right: 5,bottom: 5),
                  margin: EdgeInsets.symmetric(horizontal: 10,vertical:2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("Signature",style: TextStyle(fontWeight: FontWeight.normal),),
                      Text("Signature",style: TextStyle(fontWeight: FontWeight.normal),),
                    ],
                  ),
                ),
                Container(
                    height: 200,
                    alignment: Alignment.center,
                    child:(widget.snapshot1['QRCode']!="QR"&&image!=null)?Image.memory(image):Text("QR not Available")
                ),
              ],
          ),
        ),
        bottomNavigationBar: (widget.goBackHome==true)?GestureDetector(
          onTap: (){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>AdminHome()));
          },
          child: Container(
            margin: EdgeInsets.all(10),
            height: 56,
            color: Colors.deepOrange,
            alignment: Alignment.center,
            child: Text("BACK TO HOME",style: TextStyle(color: Colors.white,fontSize: 22,fontWeight: FontWeight.bold),),
          ),
        ):Container(
          height: 0,
        ),
      ),
    );
  }
}
