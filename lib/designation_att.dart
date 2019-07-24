// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:flutter/material.dart';
import 'package:Shrine/services/services.dart';
import 'outside_label.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'drawer.dart';
import 'Image_view.dart';
import 'package:flutter/scheduler.dart';

// This app is a stateful, it tracks the user's current choice.
class Designation_att extends StatefulWidget {
  @override
  _Designation_att createState() => _Designation_att();
}
TextEditingController today;String _orgName;
class _Designation_att extends State<Designation_att> with SingleTickerProviderStateMixin {
  TabController _controller;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String countP='-',countA='-',countL='-',countE='-';
  String desg='0';
  var formatter = new DateFormat('dd-MMM-yyyy');
  bool res = true;
  List<Map<String,String>> chartData;
  void showInSnackBar(String value) {
    final snackBar = SnackBar(
        content: Text(value,textAlign: TextAlign.center,));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
  getOrgName() async{
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _orgName= prefs.getString('org_name') ?? '';
    });
  }
  @override
  void initState() {
    super.initState();
    checkNetForOfflineMode(context);
    appResumedFromBackground(context);
    _controller = new TabController(length: 4, vsync: this);
    getOrgName();
    today = new TextEditingController();
    today.text = formatter.format(DateTime.now());
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: new Text(_orgName, style: new TextStyle(fontSize: 20.0)),
        backgroundColor: Colors.teal,
      ),
      endDrawer: new AppDrawer(),
      body: new ListView(
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          SizedBox(height:3.0),
          new Container(
            child: Center(child:Text("Designation Wise Attendance",style: TextStyle(fontSize: 22.0,color: Colors.black54,),),),
          ),
          Container(
            child: DateTimePickerFormField(
              dateOnly: true,
              format: formatter,
              controller: today,
              decoration: InputDecoration(
                prefixIcon: Padding(
                  padding: EdgeInsets.all(0.0),
                  child: Icon(
                    Icons.date_range,
                    color: Colors.grey,
                  ), // icon is 48px widget.
                ), // icon is 48px widget.
                labelText: 'Select Date',
              ),
              onChanged: (date) {
                setState(() {
                  if (date != null && date.toString()!='') {
                    res = true; //showInSnackBar(date.toString());
                    countP='(-)';
                    countA='(-)';
                    countE='(-)';
                    countL='(-)';
                  }
                  else
                    res = false;
                });
              },
              validator: (date) {
                if (date == null) {
                  return 'Please select date';
                }
              },
            ),
          ),
          getDesignations_DD(),

          /* res==true?new Container(
            padding: EdgeInsets.all(0.1),
            margin: EdgeInsets.all(0.1),
            child: new ListTile(
              title: new SizedBox(height: MediaQuery.of(context).size.height*0.27,

                child: new FutureBuilder<List<Map<String,String>>>(
                    future: getChartDataCDate(today.text),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data.length > 0) {
                          return new PieOutsideLabelChart.withRandomData(snapshot.data);
                        }
                      }
                      return new Center( child: CircularProgressIndicator());
                    }
                ),

                //  child: new PieOutsideLabelChart.withRandomData(),

                width: MediaQuery.of(context).size.width*1.0,),
            ),
          ):Container(
            height: MediaQuery.of(context).size.height*0.25,
            child: Center(
              child:Text('No Chart Available'),
            ),
          ),
          res==true?new Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text('Early Leavers(EL)',style: TextStyle(color:Colors.black87,fontSize: 12.0),),
              Text('Late Comers(LC)',style: TextStyle(color:Colors.black87,fontSize: 12.0),),
              Text('Absent(A)',style: TextStyle(color:Colors.black87,fontSize: 12.0),),
              Text('Present(P)',style: TextStyle(color:Colors.black87,fontSize: 12.0),),
            ],
          ):Center(),*/
          new Container(
            decoration: new BoxDecoration(color: Colors.black54),
            child: new TabBar(
              indicator: BoxDecoration(color: Colors.orangeAccent,),
              controller: _controller,
              tabs: [
                new Tab(
                  text: 'Present', //\n ('+countP+')
                ),
                new Tab(
                  text: 'Absent', //\n ('+countA+')
                ),
                new Tab(
                  text: 'Late ', //\n ('+countL+')
                ),
                new Tab(
                  text: 'Early ', //\n ('+countE+')
                ),
              ],
            ),
          ),
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 50.0,),
              Container(
                width: MediaQuery.of(context).size.width*0.46,
                child:Text('  Name',style: TextStyle(color: Colors.teal,fontWeight:FontWeight.bold,fontSize: 16.0),),
              ),
              SizedBox(height: 50.0,),
              Container(
                width: MediaQuery.of(context).size.width*0.22,
                child:Text('Time In',style: TextStyle(color: Colors.teal,fontWeight:FontWeight.bold,fontSize: 16.0),),
              ),
              SizedBox(height: 50.0,),
              Container(
                width: MediaQuery.of(context).size.width*0.22,
                child:Text('Time Out',style: TextStyle(color: Colors.teal,fontWeight:FontWeight.bold,fontSize: 16.0),),
              ),
            ],
          ),
          new Divider(height: 1.0,),
          res==true?new Container(
            height: MediaQuery.of(context).size.height*1,
            child: new TabBarView(
              controller: _controller,
              children: <Widget>[
                new Container(
                  height: MediaQuery.of(context).size.height*0.30,
                  //   shape: Border.all(color: Colors.deepOrange),
                  child: new ListTile(
                    title:
                    Container( height: MediaQuery.of(context).size.height*.45,
                      //width: MediaQuery.of(context).size.width*.99,
                      color: Colors.white,
                      //////////////////////////////////////////////////////////////////////---------------------------------
                      child: new FutureBuilder<List<Attn>>(
                        future: getCDateAttnDesgWise('present',today.text,desg),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            /*SchedulerBinding.instance.addPostFrameCallback((_) => setState(() {
                              countP=snapshot.data.length.toString();
                            }));*/
                            countP=snapshot.data.length.toString();
                            if(snapshot.data.length>0) {
                              return new ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return new Column(
                                        children: <Widget>[
                                          (index == 0)?
                                            Row(
                                                children: <Widget>[
                                                  SizedBox(height: 25.0,),
                                                  Container(
                                                    padding: EdgeInsets.only(left: 5.0),
                                                    child: Text("Total Present: ${countP}",style: TextStyle(color: Colors.orange,fontWeight: FontWeight.bold,fontSize: 16.0,),),
                                                  ),
                                                ]
                                            ):new Center(),
                                          (index == 0)?
                                            Divider(color: Colors.black26,):new Center(),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment
                                                .spaceAround,
                                            children: <Widget>[
                                              SizedBox(height: 40.0,),
                                              Container(
                                                width: MediaQuery
                                                    .of(context)
                                                    .size
                                                    .width * 0.46,
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment
                                                      .start,
                                                  children: <Widget>[
                                                    Text(snapshot.data[index].Name
                                                        .toString(), style: TextStyle(
                                                        color: Colors.black87,
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 16.0),),

                                                    InkWell(
                                                      child: Text('Time In: ' +
                                                          snapshot.data[index]
                                                              .CheckInLoc.toString(),
                                                          style: TextStyle(
                                                              color: Colors.black54,
                                                              fontSize: 12.0)),
                                                      onTap: () {
                                                        goToMap(
                                                            snapshot.data[index]
                                                                .LatitIn ,
                                                            snapshot.data[index]
                                                                .LongiIn);
                                                      },
                                                    ),
                                                    SizedBox(height:2.0),
                                                    InkWell(
                                                      child: Text('Time Out: ' +
                                                          snapshot.data[index]
                                                              .CheckOutLoc.toString(),
                                                        style: TextStyle(
                                                            color: Colors.black54,
                                                            fontSize: 12.0),),
                                                      onTap: () {
                                                        goToMap(
                                                            snapshot.data[index]
                                                                .LatitOut,
                                                            snapshot.data[index]
                                                                .LongiOut);
                                                      },
                                                    ),
                                                    SizedBox(height: 15.0,),


                                                  ],
                                                ),
                                              ),

                                              Container(
                                                  width: MediaQuery
                                                      .of(context)
                                                      .size
                                                      .width * 0.22,
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment
                                                        .center,
                                                    children: <Widget>[
                                                      Text(snapshot.data[index].TimeIn
                                                          .toString(),style: TextStyle(fontWeight: FontWeight.bold),),
                                                      Container(
                                                        width: 62.0,
                                                        height: 62.0,
                                                        child:InkWell(
                                                        child: Container(
                                                            decoration: new BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                image: new DecorationImage(
                                                                    fit: BoxFit.fill,
                                                                    image: new NetworkImage(
                                                                        snapshot
                                                                            .data[index]
                                                                            .EntryImage)
                                                                )

                                                            )),
                                                          onTap: (){
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(builder: (context) => ImageView(myimage: snapshot.data[index].EntryImage,org_name: _orgName)),
                                                            );
                                                          },
                                    ),
                                    ),

                                                    ],
                                                  )

                                              ),
                                              Container(
                                                  width: MediaQuery
                                                      .of(context)
                                                      .size
                                                      .width * 0.22,
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment
                                                        .center,
                                                    children: <Widget>[
                                                      Text(snapshot.data[index].TimeOut
                                                          .toString(),style: TextStyle(fontWeight: FontWeight.bold),),
                                                      Container(
                                                        width: 62.0,
                                                        height: 62.0,
                                                        child:InkWell(
                                                        child: Container(
                                                            decoration: new BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                image: new DecorationImage(
                                                                    fit: BoxFit.fill,
                                                                    image: new NetworkImage(
                                                                        snapshot
                                                                            .data[index]
                                                                            .ExitImage)
                                                                )
                                                            )),
                                                          onTap: (){
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(builder: (context) => ImageView(myimage: snapshot.data[index].ExitImage,org_name: _orgName)),
                                                            );
                                                          },
                                    ),
                                    ),

                                                    ],
                                                  )

                                              ),
                                            ],

                                          ),
                                          Divider(color: Colors.black26,),
                                        ]);}
                              );
                            }else{
                              return new Container(
                                  height: MediaQuery.of(context).size.height*0.30,
                                  child:Center(
                                    child: Container(
                                      width: MediaQuery.of(context).size.width*1,
                                      color: Colors.teal.withOpacity(0.1),
                                      padding:EdgeInsets.only(top:5.0,bottom: 5.0),
                                      child:Text("No one is present on this date ",style: TextStyle(fontSize: 18.0),textAlign: TextAlign.center,),
                                    ),
                                  )
                              );
                            }
                          }
                          else if (snapshot.hasError) {
                            return new Text("Unable to connect server");
                            //  return new Text("${snapshot.error}");
                          }

                          // By default, show a loading spinner
                          return new Center( child: CircularProgressIndicator());
                        },
                      ),
                      //////////////////////////////////////////////////////////////////////---------------------------------
                    ),
                  ),
                ),
                //////////////TABB 2 Start
                new Container(

                  height: MediaQuery.of(context).size.height*0.30,
                  //   shape: Border.all(color: Colors.deepOrange),
                  child: new ListTile(
                    title:
                    Container( height: MediaQuery.of(context).size.height*.45,
                      //width: MediaQuery.of(context).size.width*.99,
                      color: Colors.white,
                      //////////////////////////////////////////////////////////////////////---------------------------------
                      child: new FutureBuilder<List<Attn>>(
                        future: getCDateAttnDesgWise('absent',today.text,desg),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                           /* SchedulerBinding.instance.addPostFrameCallback((_) => setState(() {
                              countA=snapshot.data.length.toString();
                            }));*/
                            countA=snapshot.data.length.toString();
                            if(snapshot.data.length>0) {
                              return new ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return new Column(
                                      mainAxisAlignment: MainAxisAlignment
                                          .spaceAround,
                                      children: <Widget>[
                                        (index == 0)?
                                          Row(
                                              children: <Widget>[
                                                SizedBox(height: 25.0,),
                                                Container(
                                                  padding: EdgeInsets.only(left: 5.0),
                                                  child: Text("Total Absent: ${countA}",style: TextStyle(color: Colors.orange,fontWeight: FontWeight.bold,fontSize: 16.0,),),
                                                ),
                                              ]
                                          ):new Center(),
                                        (index == 0)?
                                          Divider(color: Colors.black26,):new Center(),
                                        Row(
                                        children: <Widget>[
                                        SizedBox(height: 40.0,),
                                        Container(
                                          width: MediaQuery
                                              .of(context)
                                              .size
                                              .width * 0.46,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment
                                                .start,
                                            children: <Widget>[
                                              Text(snapshot.data[index].Name
                                                  .toString(), style: TextStyle(
                                                  color: Colors.black87,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16.0),),
                                            ],
                                          ),
                                        ),

                                        Container(
                                            width: MediaQuery
                                                .of(context)
                                                .size
                                                .width * 0.22,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment
                                                  .center,
                                              children: <Widget>[
                                                Text(snapshot.data[index].TimeIn
                                                    .toString()),
                                              ],
                                            )

                                        ),
                                        Container(
                                            width: MediaQuery
                                                .of(context)
                                                .size
                                                .width * 0.22,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment
                                                  .center,
                                              children: <Widget>[
                                                Text(snapshot.data[index].TimeOut
                                                    .toString()),
                                              ],
                                            )

                                        ),
                                        ],
                                        ),
                                      ],

                                    );
                                  }
                              );
                            }else{
                              return new Container(
                                  height: MediaQuery.of(context).size.height*0.30,
                                  child:Center(
                                    child: Container(
                                      width: MediaQuery.of(context).size.width*1,
                                      color: Colors.teal.withOpacity(0.1),
                                      padding:EdgeInsets.only(top:5.0,bottom: 5.0),
                                      child:Text("No one is absent on this date ",style: TextStyle(fontSize: 18.0),textAlign: TextAlign.center,),
                                    ),
                                  )
                              );
                            }
                          }
                          else if (snapshot.hasError) {
                            return new Text("Unable to connect server");
                            // return new Text("${snapshot.error}");
                          }

                          // By default, show a loading spinner
                          return new Center( child: CircularProgressIndicator());
                        },
                      ),
                      //////////////////////////////////////////////////////////////////////---------------------------------
                    ),
                  ),

                ),

                /////////////TAB 2 Ends



                /////////////TAB 3 STARTS

                new Container(

                  height: MediaQuery.of(context).size.height*0.30,
                  //   shape: Border.all(color: Colors.deepOrange),
                  child: new ListTile(
                    title:
                    Container( height: MediaQuery.of(context).size.height*.45,
                      //width: MediaQuery.of(context).size.width*.99,
                      color: Colors.white,
                      //////////////////////////////////////////////////////////////////////---------------------------------
                      child: new FutureBuilder<List<Attn>>(
                        future: getCDateAttnDesgWise('latecomings',today.text,desg),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                          /*  SchedulerBinding.instance.addPostFrameCallback((_) => setState(() {
                              countL=snapshot.data.length.toString();
                            }));*/
                            countL=snapshot.data.length.toString();
                            if(snapshot.data.length>0) {
                              return new ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return new Column(
                                        children: <Widget>[
                                          (index == 0)?
                                            Row(
                                                children: <Widget>[
                                                  SizedBox(height: 25.0,),
                                                  Container(
                                                    padding: EdgeInsets.only(left: 5.0),
                                                    child: Text("Total Late Comers: ${countL}",style: TextStyle(color: Colors.orange,fontWeight: FontWeight.bold,fontSize: 16.0,),),
                                                  ),
                                                ]
                                            ):new Center(),
                                          (index == 0)?
                                            Divider(color: Colors.black26,):new Center(),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment
                                                .spaceAround,
                                            children: <Widget>[
                                              SizedBox(height: 40.0,),
                                              Container(
                                                width: MediaQuery
                                                    .of(context)
                                                    .size
                                                    .width * 0.46,
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment
                                                      .start,
                                                  children: <Widget>[
                                                    Text(snapshot.data[index].Name
                                                        .toString(), style: TextStyle(
                                                        color: Colors.black87,
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 16.0),),

                                                    InkWell(
                                                      child: Text('Time In: ' +
                                                          snapshot.data[index]
                                                              .CheckInLoc.toString(),
                                                          style: TextStyle(
                                                              color: Colors.black54,
                                                              fontSize: 12.0)),
                                                      onTap: () {
                                                        goToMap(
                                                            snapshot.data[index]
                                                                .LatitIn ,
                                                            snapshot.data[index]
                                                                .LongiIn);
                                                      },
                                                    ),
                                                    SizedBox(height:2.0),
                                                    InkWell(
                                                      child: Text('Time Out: ' +
                                                          snapshot.data[index]
                                                              .CheckOutLoc.toString(),
                                                        style: TextStyle(
                                                            color: Colors.black54,
                                                            fontSize: 12.0),),
                                                      onTap: () {
                                                        goToMap(
                                                            snapshot.data[index]
                                                                .LatitOut,
                                                            snapshot.data[index]
                                                                .LongiOut);
                                                      },
                                                    ),
                                                    SizedBox(height: 15.0,),


                                                  ],
                                                ),
                                              ),

                                              Container(
                                                  width: MediaQuery
                                                      .of(context)
                                                      .size
                                                      .width * 0.22,
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment
                                                        .center,
                                                    children: <Widget>[
                                                      Text(snapshot.data[index].TimeIn
                                                          .toString(),style: TextStyle(fontWeight: FontWeight.bold),),
                                                      Container(
                                                        width: 62.0,
                                                        height: 62.0,
                                                        child:InkWell(
                                                        child: Container(
                                                            decoration: new BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                image: new DecorationImage(
                                                                    fit: BoxFit.fill,
                                                                    image: new NetworkImage(
                                                                        snapshot
                                                                            .data[index]
                                                                            .EntryImage)
                                                                )
                                                            )),
                                                          onTap: (){
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(builder: (context) => ImageView(myimage: snapshot.data[index].EntryImage,org_name: _orgName)),
                                                            );
                                                          },
                                    ),
                                    ),

                                                    ],
                                                  )

                                              ),
                                              Container(
                                                  width: MediaQuery
                                                      .of(context)
                                                      .size
                                                      .width * 0.22,
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment
                                                        .center,
                                                    children: <Widget>[
                                                      Text(snapshot.data[index].TimeOut
                                                          .toString(),style: TextStyle(fontWeight: FontWeight.bold),),
                                                      Container(
                                                        width: 62.0,
                                                        height: 62.0,
                                                        child:InkWell(
                                                        child: Container(
                                                            decoration: new BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                image: new DecorationImage(
                                                                    fit: BoxFit.fill,
                                                                    image: new NetworkImage(
                                                                        snapshot
                                                                            .data[index]
                                                                            .ExitImage)
                                                                )
                                                            )),
                                                          onTap: (){
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(builder: (context) => ImageView(myimage: snapshot.data[index].ExitImage,org_name: _orgName)),
                                                            );
                                                          },
                                    ),
                                    ),

                                                    ],
                                                  )

                                              ),
                                            ],

                                          ),
                                          Divider(color: Colors.black26,),
                                        ]);}
                              );
                            }else{
                              return new Container(
                                  height: MediaQuery.of(context).size.height*0.30,
                                  child:Center(
                                    child: Container(
                                      width: MediaQuery.of(context).size.width*1,
                                      color: Colors.teal.withOpacity(0.1),
                                      padding:EdgeInsets.only(top:5.0,bottom: 5.0),
                                      child:Text("No late comers on this date ",style: TextStyle(fontSize: 18.0),textAlign: TextAlign.center,),
                                    ),
                                  )
                              );
                            }
                          }
                          else if (snapshot.hasError) {
                            return new Text("Unable to connect server");
                          }

                          // By default, show a loading spinner
                          return new Center( child: CircularProgressIndicator());
                        },
                      ),
                      //////////////////////////////////////////////////////////////////////---------------------------------
                    ),
                  ),
                ),
                /////////TAB 3 ENDS


                /////////TAB 4 STARTS
                new Container(


                  height: MediaQuery.of(context).size.height*0.30,
                  //   shape: Border.all(color: Colors.deepOrange),
                  child: new ListTile(
                    title:
                    Container( height: MediaQuery.of(context).size.height*.45,
                      //width: MediaQuery.of(context).size.width*.99,
                      color: Colors.white,
                      //////////////////////////////////////////////////////////////////////---------------------------------
                      child: new FutureBuilder<List<Attn>>(
                        future: getCDateAttnDesgWise('earlyleavings',today.text,desg),
                        builder: (context, snapshot) {
                         /* SchedulerBinding.instance.addPostFrameCallback((_) => setState(() {
                            countE=snapshot.data.length.toString();
                          }));*/

                          if (snapshot.hasData) {
                            countE=snapshot.data.length.toString();
                            if(snapshot.data.length>0) {
                              return new ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return new Column(
                                        children: <Widget>[
                                          (index == 0)?
                                            Row(
                                                children: <Widget>[
                                                  SizedBox(height: 25.0,),
                                                  Container(
                                                    padding: EdgeInsets.only(left: 5.0),
                                                    child: Text("Total Early Leavers: ${countE}",style: TextStyle(color: Colors.orange,fontWeight: FontWeight.bold,fontSize: 16.0,),),
                                                  ),
                                                ]
                                            ):new Center(),
                                          (index == 0)?
                                            Divider(color: Colors.black26,):new Center(),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment
                                                .spaceAround,
                                            children: <Widget>[
                                              SizedBox(height: 40.0,),
                                              Container(
                                                width: MediaQuery
                                                    .of(context)
                                                    .size
                                                    .width * 0.46,
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment
                                                      .start,
                                                  children: <Widget>[
                                                    Text(snapshot.data[index].Name
                                                        .toString(), style: TextStyle(
                                                        color: Colors.black87,
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 16.0),),

                                                    InkWell(
                                                      child: Text('Time In: ' +
                                                          snapshot.data[index]
                                                              .CheckInLoc.toString(),
                                                          style: TextStyle(
                                                              color: Colors.black54,
                                                              fontSize: 12.0)),
                                                      onTap: () {
                                                        goToMap(
                                                            snapshot.data[index]
                                                                .LatitIn ,
                                                            snapshot.data[index]
                                                                .LongiIn);
                                                      },
                                                    ),
                                                    SizedBox(height:2.0),
                                                    InkWell(
                                                      child: Text('Time Out: ' +
                                                          snapshot.data[index]
                                                              .CheckOutLoc.toString(),
                                                        style: TextStyle(
                                                            color: Colors.black54,
                                                            fontSize: 12.0),),
                                                      onTap: () {
                                                        goToMap(
                                                            snapshot.data[index]
                                                                .LatitOut,
                                                            snapshot.data[index]
                                                                .LongiOut);
                                                      },
                                                    ),
                                                    SizedBox(height: 15.0,),


                                                  ],
                                                ),
                                              ),

                                              Container(
                                                  width: MediaQuery
                                                      .of(context)
                                                      .size
                                                      .width * 0.22,
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment
                                                        .center,
                                                    children: <Widget>[
                                                      Text(snapshot.data[index].TimeIn
                                                          .toString(),style: TextStyle(fontWeight: FontWeight.bold),),
                                                      Container(
                                                        width: 62.0,
                                                        height: 62.0,
                                                        child:InkWell(
                                                        child: Container(
                                                            decoration: new BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                image: new DecorationImage(
                                                                    fit: BoxFit.fill,
                                                                    image: new NetworkImage(
                                                                        snapshot
                                                                            .data[index]
                                                                            .EntryImage)
                                                                )
                                                            )),
                                                          onTap: (){
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(builder: (context) => ImageView(myimage: snapshot.data[index].EntryImage,org_name: _orgName)),
                                                            );
                                                          },
                                    ),
                                    ),

                                                    ],
                                                  )

                                              ),
                                              Container(
                                                  width: MediaQuery
                                                      .of(context)
                                                      .size
                                                      .width * 0.22,
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment
                                                        .center,
                                                    children: <Widget>[
                                                      Text(snapshot.data[index].TimeOut
                                                          .toString(),style: TextStyle(fontWeight: FontWeight.bold),),
                                                      Container(
                                                        width: 62.0,
                                                        height: 62.0,
                                                        child:InkWell(
                                                        child: Container(
                                                            decoration: new BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                image: new DecorationImage(
                                                                    fit: BoxFit.fill,
                                                                    image: new NetworkImage(
                                                                        snapshot
                                                                            .data[index]
                                                                            .ExitImage)
                                                                )
                                                            )),
                                                          onTap: (){
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(builder: (context) => ImageView(myimage: snapshot.data[index].ExitImage,org_name: _orgName)),
                                                            );
                                                          },
                                    ),
                                    ),

                                                    ],
                                                  )

                                              ),
                                            ],

                                          ),
                                          Divider(color: Colors.black26,),
                                        ]);}
                              );
                            }else{
                              return new Container(
                                  height: MediaQuery.of(context).size.height*0.25,
                                  child:Center(
                                    child: Container(
                                      width: MediaQuery.of(context).size.width*1,
                                      color: Colors.teal.withOpacity(0.1),
                                      padding:EdgeInsets.only(top:5.0,bottom: 5.0),
                                      child:Text("No early leavers on this date",style: TextStyle(fontSize: 18.0),textAlign: TextAlign.center,),
                                    ),
                                  )
                              );
                            }
                          }
                          else if (snapshot.hasError) {
                            return new Text("Unable to connect server");
                          }

                          // By default, show a loading spinner
                          return new Center( child: CircularProgressIndicator());
                        },
                      ),
                      //////////////////////////////////////////////////////////////////////---------------------------------
                    ),
                  ),
                ),
                ///////////////////TAB 4 Ends
              ],
            ),
          ):Container(
            height: MediaQuery.of(context).size.height*0.25,
            child:Center(
              child: Text('Please select the date'),
            ),
          ),
        ],
      ),
    );
  }

  Widget getDesignations_DD() {
    String dc = "0";
    return new FutureBuilder<List<Map>>(
        future: getDesignationsList(1),// with -All- label
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            try {
              return new Container(
                //    width: MediaQuery.of(context).size.width*.45,
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Select Designation',
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(1.0),
                      child: Icon(
                        Icons.attach_file,
                        color: Colors.grey,
                      ), // icon is 48px widget.
                    ),
                  ),

                  child: new DropdownButton<String>(
                    isDense: true,
                    style: new TextStyle(
                        fontSize: 15.0,
                        color: Colors.black
                    ),
                    value: desg,
                    onChanged: (String newValue) {
                      setState(() {
                        //  showInSnackBar(newValue);
                        setState(() {
                          desg = newValue;
                          res = true;
                          print('state set----');
                          countP='-';
                          countA='-';
                          countE='-';
                          countL='-';
                        });
                      });
                    },
                    items: snapshot.data.map((Map map) {
                      return new DropdownMenuItem<String>(
                        value: map["Id"].toString(),
                        child: new SizedBox(
                            width: 200.0,
                            child: new Text(
                              map["Name"],
                            )
                        ),
                      );
                    }).toList(),

                  ),
                ),
              );
            }catch(e){
              return Text("EX: Unable to fetch designations");
            }
          } else if (snapshot.hasError) {
            return new Text("ER: Unable to fetch designations");
          }
          // return loader();
          return new Center(child: SizedBox(
            child: CircularProgressIndicator(strokeWidth: 2.2,),
            height: 20.0,
            width: 20.0,
          ),);
        });
  }


}
