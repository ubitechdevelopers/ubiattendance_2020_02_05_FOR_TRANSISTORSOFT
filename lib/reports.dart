import 'package:flutter/material.dart';
import 'drawer.dart';
import 'today_attendance_report.dart';
import 'late_comers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'settings.dart';
import 'earlyLeavers.dart';
import 'timeoff_list.dart';
import 'cust_date_report.dart';
import 'attendance_report_yes.dart';
import 'last_seven_days.dart';
import 'departmentwise_att.dart';
import 'thismonth.dart';
import 'visits_list.dart';
import 'home.dart';
import 'package:url_launcher/url_launcher.dart';
import 'payment.dart';
import 'profile.dart';
import 'designation_att.dart';
import 'Employeewise_att.dart';
import  'globals.dart';
import 'package:Shrine/services/services.dart';
import 'flexi_report.dart';
import 'notifications.dart';
import 'Outsidegeofance.dart';
import 'Bottomnavigationbar.dart';

class Reports extends StatefulWidget {
  @override
  _Reports createState() => _Reports();
}
class _Reports extends State<Reports> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int _currentIndex = 1;
  String _orgName='';
  String buystatus = "";
  String trialstatus = "";
  String orgmail = "";
  String admin_sts = "0";

  @override
  void initState() {
    super.initState();
    checkNetForOfflineMode(context);
    appResumedFromBackground(context);
    checknetonpage(context);

    getOrgName();

  }
  getOrgName() async{
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _orgName= prefs.getString('org_name') ?? '';
      buystatus = prefs.getString('buysts') ?? '';
      trialstatus = prefs.getString('trialstatus') ?? '';
      orgmail = prefs.getString('orgmail') ?? '';
      admin_sts = prefs.getString('sstatus') ?? '';
    });
  }
  @override
  Widget build(BuildContext context) {
    return getmainhomewidget();
  }
  void showInSnackBar(String value) {
    final snackBar = SnackBar(
        content: Text(value,textAlign: TextAlign.center,));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
  getmainhomewidget(){
    //  print('99999999999999' + _orgName.toString());
    return new Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            new Text(_orgName, style: new TextStyle(fontSize: 20.0)),
            /*  Image.asset(
                    'assets/logo.png', height: 40.0, width: 40.0),*/
          ],
        ),
        leading: IconButton(icon:Icon(Icons.arrow_back),onPressed:(){
          Navigator.pop(context);}),
        backgroundColor: Colors.teal,
      ),

      bottomNavigationBar: Bottomnavigationbar(),
      endDrawer: new AppDrawer(),
      body:
      Container(
        padding: EdgeInsets.only(left: 2.0,right: 2.0),
        child: Column(
          children: <Widget>[
            SizedBox(height: 8.0),
            Text('Reports',
              style: new TextStyle(fontSize: 22.0, color: Colors.teal,),),
            SizedBox(height: 5.0),
            new Expanded(
              child: getReportsWidget(),
            )
          ],
        ),
      ),
    );
  }
  loader(){
    return new Container(
      child: Center(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Image.asset(
                  'assets/spinner.gif', height: 80.0, width: 80.0),
            ]),
      ),
    );
  }

  launchMap(String url) async{
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print( 'Could not launch $url');
    }
  }

  showDialogWidget(String loginstr){
    return showDialog(context: context, builder:(context) {

      return new AlertDialog(
        title: new Text(
          loginstr,
          style: TextStyle(fontSize: 15.0),),
        content: ButtonBar(
          children: <Widget>[
            FlatButton(
              child: Text('Later',style: TextStyle(fontSize: 13.0)),
              shape: Border.all(),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
              },
            ),
            RaisedButton(
              child: Text(
                'Pay Now', style: TextStyle(color: Colors.white,fontSize: 13.0),),
              color: Colors.orangeAccent,
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PaymentPage()),
                );
              },
            ),
          ],
        ),
      );
    }
    );
  }

  getReportsWidget(){
    return Container(
      child:
      ListView(
          padding: EdgeInsets.only(left: 5.0,right: 5.0),
          children: <Widget>[
            admin_sts =='1' ? SizedBox(height: 6.0):Center(),
            admin_sts =='1' ? new RaisedButton(
              child: Container(
                padding: EdgeInsets.only(top: 5.0,bottom: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Icon(Icons.access_alarm,size: 40.0,),
                    SizedBox(width: 15.0,),
                    Expanded(
//                            widthFactor: MediaQuery.of(context).size.width*0.10,
                      child:Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                              child: Text("Today's",style: TextStyle(fontWeight:FontWeight.bold,fontSize: 20.0),)
                          ),
                          Container(
                              child: Text("Show Today's Attendance ",style: TextStyle(fontSize: 15.0,),)
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.keyboard_arrow_right,size: 50.0,),
                  ],
                ),
              ),
              color: color,
              elevation: 4.0,
              splashColor: splashcolor,
              textColor: textcolor,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TodayAttendance()),
                );
              },
            ):Center(),

            admin_sts =='1' ? SizedBox(height: 6.0):Center(),
            admin_sts =='1' ? new RaisedButton(
              child: Container(
                padding: EdgeInsets.only(top: 5.0,bottom: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Icon(Icons.timer_off,size: 40.0,),
                    SizedBox(width: 15.0,),
                    Expanded(
//                            widthFactor: MediaQuery.of(context).size.width*0.10,
                      child:Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                              child: Text('Late Comers',style: TextStyle(fontWeight:FontWeight.bold,fontSize: 20.0),)
                          ),
                          Container(
                              child: Text('Get Late Comers List ',style: TextStyle(fontSize: 15.0,),)
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.keyboard_arrow_right,size: 50.0,),
                  ],
                ),
              ),
              color: color,
              elevation: 4.0,
              splashColor: splashcolor,
              textColor: textcolor,
              onPressed: () {
                if(trialstatus=="2"){
                  showDialogWidget("Upgrade to Premium plan to check Late Comer's records.");
                }else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LateComers()),
                  );
                }
              },
            ):Center(),

            admin_sts =='1' ? SizedBox(height: 6.0):Center(),
            admin_sts =='1' ? new RaisedButton(
              child: Container(
                padding: EdgeInsets.only(top: 5.0,bottom: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Icon(Icons.desktop_windows,size: 40.0,),
                    SizedBox(width: 15.0,),
                    Expanded(
//                            widthFactor: MediaQuery.of(context).size.width*0.10,
                      child:Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                              child: Text('Early Leavers',style: TextStyle(fontWeight:FontWeight.bold,fontSize: 20.0),)
                          ),
                          Container(
                              child: Text('Get Early Leavers List ',style: TextStyle(fontSize: 15.0,),)
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.keyboard_arrow_right,size: 50.0,),
                  ],
                ),
              ),
              color: color,
              elevation: 4.0,
              splashColor: splashcolor,
              textColor: textcolor,
              onPressed: () {
                if(trialstatus=="2"){
                  showDialogWidget("Upgrade to Premium plan to check Early Leavers records.");
                }else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EarlyLeavers()),
                  );
                }
              },
            ):Center(),
            admin_sts =='1' ? SizedBox(height: 6.0):Center(),
            admin_sts =='1' ? new RaisedButton(
              child: Container(
                padding: EdgeInsets.only(top: 5.0,bottom: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Icon(Icons.perm_contact_calendar,size: 40.0,),
                    SizedBox(width: 15.0,),
                    Expanded(
//                            widthFactor: MediaQuery.of(context).size.width*0.10,
                      child:Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                              child: Text('By Department',style: TextStyle(fontWeight:FontWeight.bold,fontSize: 20.0),)
                          ),
                          Container(
                              child: Text('Attendance by Department',style: TextStyle(fontSize: 15.0,),)
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.keyboard_arrow_right,size: 50.0,),
                  ],
                ),
              ),
              color: color,
              elevation: 4.0,
              splashColor: splashcolor,
              textColor: textcolor,
              onPressed: () {
                if(trialstatus=="2"){
                  showDialogWidget("Upgrade to Premium plan to check departmentwise attendance records.");
                }else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Departmentwise_att()),
                  );
                }
              },
            ):Center(),
            admin_sts =='1' ? SizedBox(height: 6.0):Center(),
            admin_sts =='1' ? new RaisedButton(
              child: Container(
                padding: EdgeInsets.only(top: 5.0,bottom: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Icon(Icons.perm_contact_calendar,size: 40.0,),
                    SizedBox(width: 15.0,),
                    Expanded(
//                            widthFactor: MediaQuery.of(context).size.width*0.10,
                      child:Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                              child: Text('By Designation',style: TextStyle(fontWeight:FontWeight.bold,fontSize: 20.0),)
                          ),
                          Container(
                              child: Text('Attendance by Designation',style: TextStyle(fontSize: 15.0,),)
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.keyboard_arrow_right,size: 50.0,),
                  ],
                ),
              ),
              color: color,
              elevation: 4.0,
              splashColor: splashcolor,
              textColor: textcolor,
              onPressed: () {
                if(trialstatus=="2"){
                  showDialogWidget("Upgrade to Premium plan to check designationwise attendance records.");
                }else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Designation_att()),
                  );
                }
              },
            ):Center(),

            admin_sts =='1' ? SizedBox(height: 6.0):Center(),
            admin_sts =='1' ? new RaisedButton(
              child: Container(
                padding: EdgeInsets.only(top: 5.0,bottom: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Icon(Icons.perm_contact_calendar,size: 40.0,),
                    SizedBox(width: 15.0,),
                    Expanded(
//                            widthFactor: MediaQuery.of(context).size.width*0.10,
                      child:Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                              child: Text('By Employee',style: TextStyle(fontWeight:FontWeight.bold,fontSize: 20.0),)
                          ),
                          Container(
                              child: Text('Attendance by Employee',style: TextStyle(fontSize: 15.0,),)
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.keyboard_arrow_right,size: 50.0,),
                  ],
                ),
              ),
              color: color,
              elevation: 4.0,
              splashColor: splashcolor,
              textColor: textcolor,
              onPressed: () {
                if(trialstatus=="2"){
                  showDialogWidget("Upgrade to Premium plan to check Employeewise attendance records.");
                }else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EmployeeWise_att()),
                  );
                }
              },
            ):Center(),


            (flexi_permission ==1 && admin_sts=='1') ? SizedBox(height: 6.0):Center(),
            (flexi_permission ==1 && admin_sts=='1') ? new RaisedButton(
              child: Container(
                padding: EdgeInsets.only(top: 5.0,bottom: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Icon(Icons.av_timer,size: 40.0,),
                    SizedBox(width: 15.0,),
                    Expanded(
// widthFactor: MediaQuery.of(context).size.width*0.10,
                      child:Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                              child: Text('Flexi Time',style: TextStyle(fontWeight:FontWeight.bold,fontSize: 20.0),)
                          ),
                          Container(
                              child: Text('Unplanned Shift Attendance',style: TextStyle(fontSize: 15.0,),)
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.keyboard_arrow_right,size: 50.0,),
                  ],
                ),
              ),
              color: color,
              elevation: 4.0,
              splashColor: splashcolor,
              textColor: textcolor,
              onPressed: () {
                if(trialstatus=="2"){
                  showDialogWidget("Upgrade to Premium plan to check Flexi Time attendance records.");
                }else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FlexiReport()),
                  );
                }
              },
            ):Center(),

            (flexi_permission ==1 && admin_sts=='1') ? SizedBox(height: 6.0):Center(),
            (flexi_permission ==1 && admin_sts=='1') ? new RaisedButton(
              child: Container(
                padding: EdgeInsets.only(top: 5.0,bottom: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Icon(Icons.my_location,size: 40.0,),
                    SizedBox(width: 15.0,),
                    Expanded(
// widthFactor: MediaQuery.of(context).size.width*0.10,
                      child:Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                              child: Text('Outside the fence',style: TextStyle(fontWeight:FontWeight.bold,fontSize: 20.0),)
                          ),
                          Container(
                              child: Text('Outside the geo fence',style: TextStyle(fontSize: 15.0,),)
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.keyboard_arrow_right,size: 50.0,),
                  ],
                ),
              ),
              color: color,
              elevation: 4.0,
              splashColor: splashcolor,
              textColor: textcolor,
              onPressed: () {
                if(trialstatus=="2"){
                  showDialogWidget("Upgrade to plan for this report");
                }else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Outsidegeofance()),
                  );
                }
              },
            ):Center(),


      (visitpunch==1 && admin_sts=='1')?SizedBox(height: 6.0):Center(),
            (visitpunch==1 && admin_sts=='1')?
            new RaisedButton(
              child: Container(
                padding: EdgeInsets.only(top: 5.0,bottom: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Icon(Icons.location_on,size: 40.0,),
                    SizedBox(width: 15.0,),
                    Expanded(
//                            widthFactor: MediaQuery.of(context).size.width*0.10,
                      child:Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                              child: Text('Punched Visits',style: TextStyle(fontWeight:FontWeight.bold,fontSize: 20.0),)
                          ),
                          Container(
                              child: Text('List of punched visits ',style: TextStyle(fontSize: 15.0,),)
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.keyboard_arrow_right,size: 50.0,),
                  ],
                ),
              ),
              color: color,
              elevation: 4.0,
              splashColor: splashcolor,
              textColor: textcolor,
              onPressed: () {
                if(trialstatus=="2"){
                  showDialogWidget("Upgrade to Premium plan to check Visited Locations records.");
                }else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => VisitList()),
                  );
                }
              },
            ):Center(),

            (timeOff==1 && admin_sts=='1')?SizedBox(height: 6.0):Center(),
            (timeOff==1 && admin_sts=='1')? new RaisedButton(
              child: Container(
                padding: EdgeInsets.only(top: 5.0,bottom: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Icon(Icons.group,size: 40.0,),
                    SizedBox(width: 15.0,),
                    Expanded(
//                            widthFactor: MediaQuery.of(context).size.width*0.10,
                      child:Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                              child: Text('Time Off',style: TextStyle(fontWeight:FontWeight.bold,fontSize: 20.0),)
                          ),
                          Container(
                              child: Text('Get Employees Time Off List ',style: TextStyle(fontSize: 15.0,),)
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.keyboard_arrow_right,size: 50.0,),
                  ],
                ),
              ),
              color: color,
              elevation: 4.0,
              splashColor:splashcolor,
              textColor: textcolor,
              onPressed: () {
                if(trialstatus=="2"){
                  showDialogWidget("Upgrade to Premium plan to check Employee's Timeoff records.");
                }else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TimeOffList()),
                  );
                }
              },
            ):Center(),

            (admin_sts =='1' ||  admin_sts =='2') ? SizedBox(height: 6.0):Center(),
            (admin_sts =='1'||  admin_sts =='2') ? new RaisedButton(
              child: Container(
                padding: EdgeInsets.only(top: 5.0,bottom: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Icon(Icons.perm_contact_calendar,size: 40.0,),
                    SizedBox(width: 15.0,),
                    Expanded(
//                            widthFactor: MediaQuery.of(context).size.width*0.10,
                      child:Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                              child: Text('Custom Date',style: TextStyle(fontWeight:FontWeight.bold,fontSize: 20.0),)
                          ),
                          Container(
                              child: Text('Get Specific Days Attendance',style: TextStyle(fontSize: 15.0,),)
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.keyboard_arrow_right,size: 50.0,),
                  ],
                ),
              ),
              color: color,
              elevation: 4.0,
              splashColor: splashcolor,
              textColor: textcolor,
              onPressed: () {
                if(trialstatus=="2"){
                  showDialogWidget("Upgrade to Premium plan to check Get Specific Days Attendance records.");
                }else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CustomDateAttendance()),
                  );
                }
              },
            ):Center(),

            admin_sts =='1'  ? SizedBox(height: 6.0):Center(),
            admin_sts =='1' ? new RaisedButton(
              child: Container(
                padding: EdgeInsets.only(top: 5.0,bottom: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Icon(Icons.perm_contact_calendar,size: 40.0,),
                    SizedBox(width: 15.0,),
                    Expanded(
//                            widthFactor: MediaQuery.of(context).size.width*0.10,
                      child:Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                              child: Text("Yesterday's ",style: TextStyle(fontWeight:FontWeight.bold,fontSize: 20.0),)
                          ),
                          Container(
                              child: Text("Get Yesterday's List",style: TextStyle(fontSize: 15.0,),)
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.keyboard_arrow_right,size: 50.0,),
                  ],
                ),
              ),
              color: color,
              elevation: 4.0,
              splashColor: splashcolor,
              textColor: textcolor,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => YesAttendance()),
                );
              },
            ):Center(),
            admin_sts =='1' ? SizedBox(height: 6.0):Center(),
            admin_sts =='1' ? new RaisedButton(
              child: Container(
                padding: EdgeInsets.only(top: 5.0,bottom: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Icon(Icons.perm_contact_calendar,size: 40.0,),
                    SizedBox(width: 15.0,),
                    Expanded(
//                            widthFactor: MediaQuery.of(context).size.width*0.10,
                      child:Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                              child: Text('Last 7 Days',style: TextStyle(fontWeight:FontWeight.bold,fontSize: 20.0),)
                          ),
                          Container(
                              child: Text('Get Last 7 Days Attendance',style: TextStyle(fontSize: 15.0,),)
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.keyboard_arrow_right,size: 50.0,),
                  ],
                ),
              ),
              color: color,
              elevation: 4.0,
              splashColor:splashcolor,
              textColor: textcolor,
              onPressed: () {
                if(trialstatus=="2"){
                  showDialogWidget("Upgrade to Premium plan to check last 7 days attendance records.");
                }else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LastSeven()),
                  );
                }
              },
            ):Center(),

            admin_sts =='1' ? SizedBox(height: 6.0):Center(),
            admin_sts =='1' ? new RaisedButton(
              child: Container(
                padding: EdgeInsets.only(top: 5.0,bottom: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Icon(Icons.perm_contact_calendar,size: 40.0,),
                    SizedBox(width: 15.0,),
                    Expanded(
//                            widthFactor: MediaQuery.of(context).size.width*0.10,
                      child:Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                              child: Text('Last 30 Days',style: TextStyle(fontWeight:FontWeight.bold,fontSize: 20.0),)
                          ),
                          Container(
                              child: Text('Get Last 30 Days Attendance',style: TextStyle(fontSize: 15.0,),)
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.keyboard_arrow_right,size: 50.0,),
                  ],
                ),
              ),
              color: color,
              elevation: 4.0,
              splashColor: splashcolor,
              textColor: textcolor,
              onPressed: () {
                if(trialstatus=="2"){
                  showDialogWidget("Upgrade to Premium plan to check last 30 days attendance records.");
                }else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ThisMonth()),
                  );
                }
              },
            ):Center(),

          ]),
    );
  }
}



