
// Copyright 2018-present the Flutter authors. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'package:Shrine/globals.dart' as prefix0;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:Shrine/app.dart';
import 'package:Shrine/services/newservices.dart';
import 'globals.dart';
import 'services/services.dart';

void main(){
  runApp(
      new MaterialApp(
    home: new MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  void initState() {
    //checknetonpage(context);
   // StreamLocation sl = new StreamLocation();
   // sl.startStreaming(10);
    platform.setMethodCallHandler(_handleMethod);
  }
  static const platform = const MethodChannel('location.spoofing.check');
  String address="";
  Future<dynamic> _handleMethod(MethodCall call) async {
    switch(call.method) {

      case "locationAndInternet":
      // print(call.arguments["internet"].toString()+"akhakahkahkhakha");
      // Map<String,String> responseMap=call.arguments;
      prefix0.locationThreadUpdatedLocation=true;
        if(call.arguments["TimeSpoofed"].toString()=="Yes"){
          timeSpoofed=true;

        }

        String long=call.arguments["longitude"].toString();
        String lat=call.arguments["latitude"].toString();
        assign_lat=double.parse(lat);
        assign_long=double.parse(long);
        address=await getAddressFromLati(lat, long);
        print(call.arguments["mocked"].toString());

          globalstreamlocationaddr=address;

        break;

        return new Future.value("");
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body:new Builder(
        builder: (BuildContext context) {
          return new SplashScreen(
            seconds: 2,
            navigateAfterSeconds: new ShrineApp(),
            title: new Text('',style: TextStyle(fontSize: 32.0),),
            loaderColor: Colors.blueGrey[100],
            image:   Image.asset('assets/splash.gif'),
            backgroundColor: Colors.white,
            styleTextUnderTheLoader: new TextStyle(color: Colors.grey[500]),
            photoSize: MediaQuery.of(context).size.width*0.45
            /*onClick: ()=>print("Flutter Egypt"),*/
          );
        }),);
  }
}
