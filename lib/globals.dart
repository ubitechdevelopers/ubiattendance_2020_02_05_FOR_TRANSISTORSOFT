import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';

import 'model/timeinout.dart';

Color color = Colors.teal.shade50;
Color splashcolor = Colors.teal.shade100;
Color textcolor = Colors.black54;

Color appcolor =  Colors.teal;
Color buttoncolor =  Colors.orangeAccent;
Color headingcolor =  Colors.orange;
Color iconcolor =  Colors.black45;

/*
String path="http://192.168.0.200/ubiattendance/index.php/Att_services/";
String internetConnectivityURL="http://192.168.0.200/ubiattendance/index.php/Att_services/isInternetConnected";
String path_hrm_india="http://192.168.0.200/ubiattendance/index.php/Att_services";
*/

/*
String path="http://192.168.0.200/ubiattinterns/index.php/Att_services/";
String internetConnectivityURL="http://192.168.0.200/ubiattinterns/index.php/Att_services/isInternetConnected";
String path_hrm_india="http://192.168.0.200/ubiattinterns/index.php/Att_services";
*/
/*
String path="https://sandbox.ubiattendance.com/index.php/Att_services/";

String path_hrm_india="https://sandbox.ubiattendance.com/index.php/Att_services/";
*/

String path="https://ubiattendance.ubihrm.com/index.php/Att_services/";
String internetConnectivityURL="https://ubiattendance.ubihrm.com/index.php/Att_services/isInternetConnected";
String path_hrm_india="https://ubiattendance.ubihrm.com/index.php/Att_services/";


//String path_hrm_india="https://ubitech.ubihrm.com/services/";

MarkTime mk1;
List<LocationData> list = new List();
String globalstreamlocationaddr="Location not fetched.";
bool stopstreamingstatus = false;
int timeOff=0,bulkAttn = 0,geoFence=0,payroll=0,tracking=0,visitpunch=0,department_permission = 0, designation_permission = 0, leave_permission = 0, shift_permission = 0, timeoff_permission = 1,punchlocation_permission = 1, employee_permission = 0, permission_module_permission = 0, report_permission = 0,flexi_permission=0,offline_permission=0 , designationid=0;
int globalalertcount = 0;
int visitImage = 0;
int attImage = 0;
int ableToMarkAttendance = 0;
var timeoutdate = "";
String departmentname = "";
int departmentid = 1;
int varCheckNet=0;
int areaId=0;
var assign_lat = 0.0;//These are user to store latitude got from javacode throughout the app
var assign_long = 0.0;//These are user to store latitude got from javacode throughout the app
var assigned_lat = 0.0;//These are user to store geofence latitude got from server throughout the app
var assigned_long = 0.0;//These are user to store geofence latitude got from server throughout the app
var assign_radius = 0.0;
var timeInPressedTime;
var timeOutPressedTime;
int userlimit = 0;
int registeruser = 0;
var timeWhenButtonPressed;
const cameraChannel = const MethodChannel('update.camera.status');
const facebookChannel= const MethodChannel('log.facebook.data');
bool fakeLocationDetected=false;
bool showTimeOutNotification=true;
bool selectimg = true;
bool showTimeInNotification=true;
bool showAppInbuiltCamera=false;
bool timeSpoofed=false;
bool globalCameraOpenedStatus=false;
bool locationThreadUpdatedLocation=false;
List responseJson = new List();
List responseEmplist = new List();
String referralLink="";
bool referralNotificationShown=false;
bool istooltiptimeinshown=false;
bool istooltiponeshown=false;
bool istooltiptwoshown=false;
bool istooltipthreeshown=false;
bool istooltipfourshown=false;
bool istooltipfiveshown=false;
String currentOrgStatus='';
double ab,cd,ef,gh;

bool timeInToolTipShown=false;
bool addEmpToolTipShown=false;
String PictureBase64Att = "";
String globalOrgTopic='';
String globalCountryTopic='';
String locationTrackingAddon="1";



/*
int total_dept = 0;
int total_abs = 0;
int total_pre = 0;
int total_emp = 0;
*/
