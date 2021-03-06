import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:Shrine/database_models/Save_Tempimage.dart';
import 'package:Shrine/genericCameraClass.dart';
import 'package:Shrine/globals.dart' as globals;
import 'package:Shrine/model/timeinout.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:geocoder/geocoder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image/image.dart';
import 'newservices.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart' as path_provider;
import 'package:path_provider/path_provider.dart';
class SaveImage {
  String base64Image;
  String base64Image1;

  static const platform = const MethodChannel('force.garbage.collection');
  Future<bool> saveTimeInOut(File imagefile, MarkTime mk) async {

    try {

      File imagei = imagefile;
      imageCache.clear();
      //imagei = await ImagePicker.pickImage(source: ImageSource.camera,maxWidth: 200.0,maxHeight: 200.0);
      if (imagei != null) {
        //// sending this base64image string +to rest api
        Dio dio = new Dio();
        String location = globals.globalstreamlocationaddr;

        String lat = globals.assign_lat.toString();
        String long = globals.assign_long.toString();
        print("global Address: " + location);
        print("global lat" + lat);
        print("global long" + long);
        print(mk.uid +
            " " +
            location +
            " " +
            mk.aid +
            " " +
            mk.act +
            " " +
            mk.shiftid +
            " " +
            mk.refid +
            " " +
            lat +
            " " +
            long);
        FormData formData = new FormData.from({
          "uid": mk.uid,
          "location": location,
          "aid": mk.aid,
          "act": mk.act,
          "shiftid": mk.shiftid,
          "refid": mk.refid,
          "latit": lat,
          "longi": long,
          "file": new UploadFileInfo(imagei, "image.png"),
          "FakeLocationStatus":mk.FakeLocationStatus
        });
        print("5");
        Response<String> response1 =
            await dio.post(globals.path + "saveImage", data: formData);
        //Response<String> response1=await dio.post("https://ubiattendance.ubihrm.com/index.php/services/saveImage",data:formData);
        //Response<String> response1=await dio.post("http://192.168.0.200/ubiattendance/index.php/services/saveImage",data:formData);
        //Response<String> response1 = await dio.post("https://ubitech.ubihrm.com/services/saveImage", data: formData);
        imagei.deleteSync();
        imageCache.clear();
        /*getTempImageDirectory();*/
        Map MarkAttMap = json.decode(response1.data);
        print(MarkAttMap["status"].toString());
        if (MarkAttMap["status"] == 1 || MarkAttMap["status"] == 2) {
          return true;
        }
        else
          return false;
      } else {
        print("6");
        return false;
      }
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  startTimeOutNotificationWorker() async{
    final prefs = await SharedPreferences.getInstance();
    String ShiftTimeOut=await prefs.getString("ShiftTimeOut")??"18:00:00";

    globals.cameraChannel.invokeMethod("startTimeOutNotificationWorker",{"ShiftTimeOut":ShiftTimeOut});
  }
  startTimeInNotificationWorker() async{
    final prefs = await SharedPreferences.getInstance();
    String ShiftTimeIn=await prefs.getString("ShiftTimeIn")??"10:00:00";
    String nextWorkingDay=await prefs.getString("nextWorkingDay");
    print("nextWorkingDay"+nextWorkingDay);
    globals.cameraChannel.invokeMethod("startTimeInNotificationWorker",{"ShiftTimeIn":ShiftTimeIn,"nextWorkingDay":nextWorkingDay});
  }

/********************************** for app camera ****************************************/




  Future<bool> saveTimeInOutImagePickerAppCamera(MarkTime mk,context) async {

    try{
      File imagei = null;
      var isNextDayAWorkingDay=0;
      var prefs=await SharedPreferences.getInstance();
      isNextDayAWorkingDay=prefs.getInt("isNextDayAWorkingDay")??0;

      imageCache.clear();
      if (globals.attImage == 1) {

        // globals.cameraChannel.invokeMethod("cameraOpened");
        imagei = await Navigator.push(context, new MaterialPageRoute(
          builder: (BuildContext context) => new TakePictureScreen(),
          fullscreenDialog: true,)
        );



        if (imagei != null) {
          //print("---------------actionb   ----->"+mk.act);
          globals.globalCameraOpenedStatus=false;
          if(mk.act=="TimeIn"&&globals.showTimeOutNotification){
            startTimeOutNotificationWorker();
          }
          else{
            if(globals.showTimeInNotification){
              startTimeInNotificationWorker();
            }
          }

          var currentTime=DateTime.now();
          int timeDifference=currentTime.difference(globals.timeWhenButtonPressed).inSeconds;
          print("--------------------------Time difference------>"+timeDifference.toString());
          if(timeDifference>120){
            return null;
          }

          List<int> imageBytes = await imagei.readAsBytes();
          String  PictureBase64 = base64.encode(imageBytes);

          /*
      final tempDir = await getTemporaryDirectory();
      String path = tempDir.path;
      int rand = new Math.Random().nextInt(10000);
      im.Image image1 = im.decodeImage(imagei.readAsBytesSync());
      imagei.deleteSync();
      im.Image smallerImage = im.copyResize(image1, 500); // choose the size here, it will maintain aspect ratio
      File compressedImage = new File('$path/img_$rand.jpg')..writeAsBytesSync(im.encodeJpg(smallerImage, quality: 50));
    */
          //// sending this base64image string +to rest api
          Dio dio = new Dio();
          String location = globals.globalstreamlocationaddr;

          String lat = globals.assign_lat.toString();
          String long = globals.assign_long.toString();
          print("saveImage?uid=" + mk.uid + "&location=" + location + "&aid=" +
              mk.aid + "&act=" + mk.act + "&shiftid=" + mk.shiftid + "&refid=" +
              mk.refid + "&latit=" + lat + "&longi=" + long);
          print("global Address: " + location);
          print("global lat" + lat);
          print("global long" + long);
          print(mk.uid + " " + location + " " + mk.aid + " " + mk.act + " " +
              mk.shiftid + " " + mk.refid + " " + lat + " " + long);
          FormData formData = new FormData.from({
            "uid": mk.uid,
            "location": location,
            "aid": mk.aid,
            "act": mk.act,
            "shiftid": mk.shiftid,
            "refid": mk.refid,
            "latit": lat,
            "longi": long,
            //"file": new UploadFileInfo(imagei, "image.png"),
            "FakeLocationStatus" : mk.FakeLocationStatus,
            "platform":'android'
          });
          print(formData);
          Response<String> response1 = await dio.post(
              globals.path + "saveImage", data: formData);
          print("Response from save image:"+response1.toString());
          //Response<String> response1=await dio.post("https://ubiattendance.ubihrm.com/index.php/services/saveImage",data:formData);
          //Response<String> response1=await dio.post("http://192.168.0.200/ubiattendance/index.php/services/saveImage",data:formData);
          //Response<String> response1 = await dio.post("https://ubitech.ubihrm.com/services/saveImage", data: formData);
          imagei.deleteSync();
          imageCache.clear();
          // globals.cameraChannel.invokeMethod("cameraClosed");
          /*getTempImageDirectory();*/
          Map MarkAttMap = json.decode(response1.data);
          print(MarkAttMap["status"].toString());
          if (MarkAttMap["status"] == 1 || MarkAttMap["status"] == 2) {
            globals.PictureBase64Att = PictureBase64;
            TempImage tempimage = new TempImage(null, int.parse(mk.uid),mk.act, MarkAttMap["insert_updateid"], PictureBase64, int.parse(mk.refid) , 'Attendance');
            tempimage.save();
            return true;
          }
          else
            return false;
        }
        else {
          globals.globalCameraOpenedStatus=false;
          print("6");
          return false;
        }
      }else{

        var currentTime=DateTime.now();
        int timeDifference=currentTime.difference(globals.timeWhenButtonPressed).inSeconds;
        print("--------------------------Time difference------>"+timeDifference.toString());
        if(timeDifference>120){
          return null;
        }

        Dio dio = new Dio();
        String location = globals.globalstreamlocationaddr;

        String lat = globals.assign_lat.toString();
        String long = globals.assign_long.toString();
        print("saveImage?uid=" + mk.uid + "&location=" + location + "&aid=" +
            mk.aid + "&act=" + mk.act + "&shiftid=" + mk.shiftid + "&refid=" +
            mk.refid + "&latit=" + lat + "&longi=" + long);
        print("global Address: " + location);
        print("global lat" + lat);
        print("global long" + long);
        print(mk.uid + " " + location + " " + mk.aid + " " + mk.act + " " +
            mk.shiftid + " " + mk.refid + " " + lat + " " + long);
        FormData formData = new FormData.from({
          "uid": mk.uid,
          "location": location,
          "aid": mk.aid,
          "act": mk.act,
          "shiftid": mk.shiftid,
          "refid": mk.refid,
          "latit": lat,
          "longi": long,
          "FakeLocationStatus":mk.FakeLocationStatus,
          "platform":'android'
          // "file": new UploadFileInfo(imagei, "image.png"),
        });
        print("5");
        Response<String> response1 = await dio.post(
            globals.path + "saveImage", data: formData);
        print(response1.toString());
        //Response<String> response1=await dio.post("https://ubiattendance.ubihrm.com/index.php/services/saveImage",data:formData);
        //Response<String> response1=await dio.post("http://192.168.0.200/ubiattendance/index.php/services/saveImage",data:formData);
        //Response<String> response1 = await dio.post("https://ubitech.ubihrm.com/services/saveImage", data: formData);
        /*imagei.deleteSync();
        imageCache.clear();*/
        /*getTempImageDirectory();*/
        Map MarkAttMap = json.decode(response1.data);
        print(MarkAttMap["status"].toString());
        if (MarkAttMap["status"] == 1 || MarkAttMap["status"] == 2)
          return true;
        else
          return false;
      }
    } catch (e) {
      print(e.toString());
      globals.globalCameraOpenedStatus=false;
      return false;
    }
  }













  ////////////////////////////////////////////////////////////////////////////////////////






  SendTempimage() async{
    TempImage imagedata = new TempImage.empty();
    List<TempImage> img = await imagedata.select();
    List<Map> jsonList = [];
    if (img.isNotEmpty) {
      for (int i = 0; i < img.length; i++) {

        jsonList.add({
          "Id": img[i].Id,
          "EmployeeId": img[i].EmployeeId,
          "Action": img[i].Action, // 0 for time in and 1 for time out
          "ActionId": img[i].ActionId,
          "PictureBase64": img[i].PictureBase64,
          "OrganizationId": img[i].OrganizationId,
          "Module": img[i].Module,

        });
      }
      var jsonList1 = json.encode(jsonList);
      FormData formData = new FormData.from({"data": jsonList1});
      Dio dioForSavingOfflineAttendance = new Dio();
      dioForSavingOfflineAttendance.post(globals.path + "SendTempimage", data: formData).then((responseAfterSendTempimage) async {
        var response = json.decode(responseAfterSendTempimage.toString());
        for (int i = 0; i < response.length; i++) {
          var map = response[i];
          map.forEach((localDbId, status) {
            TempImage imagedata = new TempImage.empty();
            print(status);
            imagedata.delete(int.parse(localDbId));
          });
        }
      });
    }
  }

  Future<bool> saveTimeInOutImagePicker(MarkTime mk,context) async {

 /*  int EmployeeId = 123;
    String Action = "AttendanceTimein";
    int ActionId = 12;
    int OrganizationId = 10;
    String PictureBase64 = "";
    imageCache.clear();
    File imagei = null;
    imagei = await ImagePicker.pickImage(source: ImageSource.camera, maxWidth: 200.0, maxHeight: 200.0);
    List<int> imageBytes = await imagei.readAsBytes();
    PictureBase64 = base64.encode(imageBytes);

    TempImage tempimage = new TempImage(
      null, EmployeeId,
      Action,
      ActionId,
      PictureBase64,
      OrganizationId,
      'Attendance',
    );

    print(tempimage.save());
    TempImage imagedata = new TempImage.empty();
    List<TempImage> img = await imagedata.select();
    print(img);
    for (int i = 0; i < img.length; i++) {
      print(img[i].Id);
      print(img[i].EmployeeId);
      print(img[i].Action);
      print(img[i].ActionId);
      print(img[i].PictureBase64);
      print(img[i].OrganizationId);
      print(img[i].Module);
    }
      print("Succesfull saveimage");
      return false;*/
    try{
      File imagei = null;
      var isNextDayAWorkingDay=0;
      var prefs=await SharedPreferences.getInstance();
      isNextDayAWorkingDay=prefs.getInt("isNextDayAWorkingDay")??0;

      imageCache.clear();
      if (globals.attImage == 1) {

        globals.cameraChannel.invokeMethod("cameraOpened");
        imagei = await ImagePicker.pickImage(source: ImageSource.camera, maxWidth: 200.0, maxHeight: 200.0);

        if (imagei != null) {
        //print("---------------actionb   ----->"+mk.act);
          globals.globalCameraOpenedStatus=false;
          if(mk.act=="TimeIn"&&globals.showTimeOutNotification){
            startTimeOutNotificationWorker();  
          }
          else{
            if(globals.showTimeInNotification){
              startTimeInNotificationWorker();
            }
          }
          
          var currentTime=DateTime.now();
          int timeDifference=currentTime.difference(globals.timeWhenButtonPressed).inSeconds;
          print("--------------------------Time difference------>"+timeDifference.toString());
           if(timeDifference>120){
                return null;
          }


          List<int> imageBytes = await imagei.readAsBytes();
          String  PictureBase64 = base64.encode(imageBytes);


          Dio dio = new Dio();
          String location = globals.globalstreamlocationaddr;

          String lat = globals.assign_lat.toString();
          String long = globals.assign_long.toString();
          print("saveImage?uid=" + mk.uid + "&location=" + location + "&aid=" +
              mk.aid + "&act=" + mk.act + "&shiftid=" + mk.shiftid + "&refid=" +
              mk.refid + "&latit=" + lat + "&longi=" + long);
          print("global Address: " + location);
          print("global lat" + lat);
          print("global long" + long);
          print(mk.uid + " " + location + " " + mk.aid + " " + mk.act + " " +
              mk.shiftid + " " + mk.refid + " " + lat + " " + long);
          FormData formData = new FormData.from({
            "uid": mk.uid,
            "location": location,
            "aid": mk.aid,
            "act": mk.act,
            "shiftid": mk.shiftid,
            "refid": mk.refid,
            "latit": lat,
            "longi": long,
           // "file": new UploadFileInfo(imagei, "image.png"),
            "FakeLocationStatus" : mk.FakeLocationStatus,
            "platform":'android'
          });
          print(formData);
          print(globals.path + "saveImage?uid=${ mk.uid}&location=${location}&aid=${mk.aid}&act=${mk.act}");
          Response<String> response1 = await dio.post(globals.path + "saveImage", data: formData);
          
          imagei.deleteSync();
          imageCache.clear();
          globals.cameraChannel.invokeMethod("cameraClosed");
          /*getTempImageDirectory();*/
          Map MarkAttMap = json.decode(response1.data);
          print("This is response");
          print(MarkAttMap);
          print(MarkAttMap["status"].toString());
          if (MarkAttMap["status"] == 1 || MarkAttMap["status"] == 2){

            /*** Save temp image in local database statrt here ***/
            globals.PictureBase64Att = PictureBase64;
            TempImage tempimage = new TempImage(null, int.parse(mk.uid),mk.act, MarkAttMap["insert_updateid"], PictureBase64, int.parse(mk.refid) , 'Attendance');
             tempimage.save();
             
            /*** Save temp image in local database end here ***/

            var prefs=await SharedPreferences.getInstance();
            String currentTime=DateTime.now().toString();
            print("saved time in time"+currentTime);
            if(mk.act=="TimeIn"){
              prefs.setString("TimeInTime", currentTime);
              print(currentTime+"currentTime");

            }
            else{
              prefs.remove("TimeInTime");
            }
            return true;
          }
          else
            return false;
        }
        else {
          globals.globalCameraOpenedStatus=false;
          print("6");
          return false;
        }
      }else{

        var currentTime=DateTime.now();
        int timeDifference=currentTime.difference(globals.timeWhenButtonPressed).inSeconds;
        print("--------------------------Time difference------>"+timeDifference.toString());
        if(timeDifference>120){
          return null;
        }

        Dio dio = new Dio();
        String location = globals.globalstreamlocationaddr;

        String lat = globals.assign_lat.toString();
        String long = globals.assign_long.toString();
        print("saveImage?uid=" + mk.uid + "&location=" + location + "&aid=" +
            mk.aid + "&act=" + mk.act + "&shiftid=" + mk.shiftid + "&refid=" +
            mk.refid + "&latit=" + lat + "&longi=" + long);
        print("global Address: " + location);
        print("global lat" + lat);
        print("global long" + long);
        print(mk.uid + " " + location + " " + mk.aid + " " + mk.act + " " +
            mk.shiftid + " " + mk.refid + " " + lat + " " + long);
        FormData formData = new FormData.from({
          "uid": mk.uid,
          "location": location,
          "aid": mk.aid,
          "act": mk.act,
          "shiftid": mk.shiftid,
          "refid": mk.refid,
          "latit": lat,
          "longi": long,
          "FakeLocationStatus":mk.FakeLocationStatus,
          "platform":'android'
         // "file": new UploadFileInfo(imagei, "image.png"),
        });
        print("5");
        Response<String> response1 = await dio.post(
            globals.path + "saveImage", data: formData);
        print(response1.toString());
        //Response<String> response1=await dio.post("https://ubiattendance.ubihrm.com/index.php/services/saveImage",data:formData);
        //Response<String> response1=await dio.post("http://192.168.0.200/ubiattendance/index.php/services/saveImage",data:formData);
        //Response<String> response1 = await dio.post("https://ubitech.ubihrm.com/services/saveImage", data: formData);
        /*imagei.deleteSync();
        imageCache.clear();*/
        /*getTempImageDirectory();*/
        Map MarkAttMap = json.decode(response1.data);
        print(MarkAttMap["status"].toString());
        if (MarkAttMap["status"] == 1 || MarkAttMap["status"] == 2)
          return true;
        else
          return false;
      }
    } catch (e) {
      print(e.toString());
      globals.globalCameraOpenedStatus=false;
      return false;
    }
  }


/*
  Future<File> testCompressAndGetFile(File file, String targetPath) async {
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path, targetPath,
      quality: 88,
      rotate: 180,
    );
    print(file.lengthSync());
    print(result.lengthSync());
    return result;
  } */




  Future<bool> saveTimeInOutImagePicker_old123(MarkTime mk,context) async {
    bool ready = false;
    String location = globals.globalstreamlocationaddr;

    String lat = globals.assign_lat.toString();
    String long = globals.assign_long.toString();

    try {
      ///////////////////////////
      StreamLocation sl = new StreamLocation();
      sl.startStreaming(5);
      Location _location = new Location();

      ////////////////////////////////suumitted block
      File imagei = null;
      globals.cameraChannel.invokeMethod("cameraOpened");
      imageCache.clear();
      if (globals.attImage == 1) {

        print("Pahunch gaya-----------------------------------------------");

        ImagePicker.pickImage(
            source: ImageSource.camera, maxWidth: 200.0, maxHeight: 200.0)
            .then((img) async {

          if (imagei != null) {
            globals.globalCameraOpenedStatus=false;
            _location.getLocation().then((res) {
              if (res.latitude != '') {
                var addresses = '';
                Geocoder.local
                    .findAddressesFromCoordinates(
                        Coordinates(res.latitude, res.longitude))
                    .then((add) {
                  print(
                      'Location taekn--------------------------------------------------');
                  print(res.latitude.toString() +
                      ' ' +
                      res.longitude.toString());
                  var first = add.first;
                  print("${first.addressLine}");
                  print(
                      'Location taekn--------------------------------------------------');
                  lat = res.latitude.toString();
                  long = res.longitude.toString();

                  //// sending this base64image string +to rest api
                  Dio dio = new Dio();

                  print("saveImage?uid=" +
                      mk.uid +
                      "&location=" +
                      location +
                      "&aid=" +
                      mk.aid +
                      "&act=" +
                      mk.act +
                      "&shiftid=" +
                      mk.shiftid +
                      "&refid=" +
                      mk.refid +
                      "&latit=" +
                      lat +
                      "&longi=" +
                      long);
                  FormData formData = new FormData.from({
                    "uid": mk.uid,
                    "location": location,
                    "aid": mk.aid,
                    "act": mk.act,
                    "shiftid": mk.shiftid,
                    "refid": mk.refid,
                    "latit": lat,
                    "longi": long,
                    "file": new UploadFileInfo(imagei, "image.png"),
                    "FakeLocationStatus":mk.FakeLocationStatus
                  });
                  print("5");
                  dio
                      .post(globals.path + "saveImage", data: formData)
                      .then((response1) {
                    globals.cameraChannel.invokeMethod("cameraClosed");
                    print('response1: '+response1.toString());
                    imagei.deleteSync();
                    imageCache.clear();
                    /*getTempImageDirectory();*/
                    Map MarkAttMap = json.decode(response1.data);
                    print('MarkAttMap["status"]: '+MarkAttMap["status"].toString());
                    if (MarkAttMap["status"] == 1 || MarkAttMap["status"] == 2)
                      return true;
                    else
                      return false;
                  }).catchError((err) {
                    print('Exception in setting data in saveImage' +
                        err.toString());
                    return true;
                  });
                });
              }
            });
            //*****
          } else {
            globals.globalCameraOpenedStatus=false;
            print("6");
            return false;
          }
        }).catchError((err) {
          print('Exception Occured in getting FILE' + err.toString());
          return true;
        });
      }

      ////////////////////////////////suumitted block/

      /*   */
      ///////////////////////////

    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<bool> saveTimeInOut1(
    File imagefile,
  ) async {
    try {
      File imagei = imagefile;
      imageCache.clear();
      //imagei = await ImagePicker.pickImage(source: ImageSource.camera,maxWidth: 200.0,maxHeight: 200.0);
      if (imagei != null) {
        Dio dio = new Dio();
        String location = "Dummy address"; // globals.globalstreamlocationaddr;
        //Map<String, double> _currentLocation = globals.list[globals.list.length-1];
        String lat = "1.0.20"; //_currentLocation["latitude"].toString();
        String long = "1.0.20"; //_currentLocation["longitude"].toString();
        //print("global Address: "+ location);
        print("global lat" + lat);
        print("global long" + long);
        //print(mk.uid+" "+location+ " "+mk.aid+" "+mk.act+" "+mk.shiftid+ " " +mk.refid+" "+lat+" "+long);
        FormData formData = new FormData.from({
          "uid": 4140,
          "location": location,
          "aid": 0,
          "act": "TimeIn",
          "shiftid": 48,
          "refid": 10,
          "latit": lat,
          "longi": long,
          "file": new UploadFileInfo(imagei, "image.png"),
        });
        print("5");
        Response<String> response1 =
            await dio.post(globals.path + "saveImage", data: formData);
        //Response<String> response1=await dio.post("https://ubiattendance.ubihrm.com/index.php/services/saveImage",data:formData);
        //Response<String> response1=await dio.post("http://192.168.0.200/ubiattendance/index.php/services/saveImage",data:formData);
        //Response<String> response1 = await dio.post("https://ubitech.ubihrm.com/services/saveImage", data: formData);
        imagei.deleteSync();
        imageCache.clear();
        /* getTempImageDirectory();*/
        Map MarkAttMap = json.decode(response1.data);
        print(MarkAttMap["status"].toString());
        if (MarkAttMap["status"] == 1 || MarkAttMap["status"] == 2)
          return true;
        else
          return false;
      } else {
        print("6");
        return false;
      }
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  /**************************** for app camera   **************************************************/





  Future<bool> saveTimeInOutQRAppCamera(MarkTime mk,context) async {

    try {
      File imagei = null;
      imageCache.clear();
      print("Testing of attendance");
      print(globals.attImage);
      if (globals.attImage == 1)
      {
        print("Testing of attendance123");
        //   globals.cameraChannel.invokeMethod("cameraOpened");
        imagei = await Navigator.push(context, new MaterialPageRoute(
          builder: (BuildContext context) => new TakePictureScreen(),
          fullscreenDialog: true,)
        );
        if (imagei != null) {
          //// sending this base64image string +to rest api
          Dio dio = new Dio();
          print(mk.uid);
          print(mk.location);
          print(mk.aid);
          print(mk.act);
          print(mk.shiftid);
          print(mk.refid);
          print(mk.latit);
          print(mk.longi);
          print(imagei.path);
          FormData formData = new FormData.from({
            "uid": mk.uid,
            "location": mk.location,
            "aid": mk.aid,
            "act": mk.act,
            "shiftid": mk.shiftid,
            "refid": mk.refid,
            "latit": mk.latit,
            "longi": mk.longi,
            "file": new UploadFileInfo(imagei, "image.png"),
            "FakeLocationStatus": mk.FakeLocationStatus,
            "platform":'android'
          });
          print("5");
          print(globals.path + "saveImage");
          Response<String> response1 =
          await dio.post(globals.path + "saveImage", data: formData);
          //Response<String> response1=await dio.post("https://ubiattendance.ubihrm.com/index.php/services/saveImage",data:formData);
          //Response<String> response1=await dio.post("http://192.168.0.200/ubiattendance/index.php/services/saveImage",data:formData);
          //Response<String> response1 = await dio.post("https://ubitech.ubihrm.com/services/saveImage", data: formData);
          // globals.cameraChannel.invokeMethod("cameraClosed");
          imagei.deleteSync();
          imageCache.clear();
          /*getTempImageDirectory();*/
          Map MarkAttMap = json.decode(response1.data);
          print(MarkAttMap["status"].toString());
          if (MarkAttMap["status"] == 1 || MarkAttMap["status"] == 2)
            return true;
          else
            return false;
        } else {
          print("6");
          return false;
        }
      }
      else
      {

        Dio dio = new Dio();
        FormData formData = new FormData.from({
          "uid": mk.uid,
          "location": mk.location,
          "aid": mk.aid,
          "act": mk.act,
          "shiftid": mk.shiftid,
          "refid": mk.refid,
          "latit": mk.latit,
          "longi": mk.longi,
          "FakeLocationStatus": mk.FakeLocationStatus,
          "platform":'android'
        });

        Response<String> response1 =
        await dio.post(globals.path + "saveImage", data: formData);
        //Response<String> response1=await dio.post("https://ubiattendance.ubihrm.com/index.php/services/saveImage",data:formData);
        //Response<String> response1=await dio.post("http://192.168.0.200/ubiattendance/index.php/services/saveImage",data:formData);
        //Response<String> response1 = await dio.post("https://ubitech.ubihrm.com/services/saveImage", data: formData);
        //  globals.cameraChannel.invokeMethod("cameraClosed");
        //imagei.deleteSync();
        // imageCache.clear();
        /*getTempImageDirectory();*/
        Map MarkAttMap = json.decode(response1.data);
        print(MarkAttMap["status"].toString());
        if (MarkAttMap["status"] == 1 || MarkAttMap["status"] == 2)
          return true;
        else
          return false;

      }
    } catch (e) {
      print(e.toString());
      return false;
    }
  }







  ////////////////////////////////////////////////////////////////////////////////////////////////




  Future<bool> saveTimeInOutQR(MarkTime mk,context) async {

    try {
      File imagei = null;
      imageCache.clear();
      print("Testing of attendance");
      print(globals.attImage);
      if (globals.attImage == 1)
      {
        print("Testing of attendance123");
        globals.cameraChannel.invokeMethod("cameraOpened");
        imagei = await ImagePicker.pickImage(source: ImageSource.camera, maxWidth: 200.0, maxHeight: 200.0);
        if (imagei != null) {
          //// sending this base64image string +to rest api
          Dio dio = new Dio();
          print(mk.uid);
          print(mk.location);
          print(mk.aid);
          print(mk.act);
          print(mk.shiftid);
          print(mk.refid);
          print(mk.latit);
          print(mk.longi);
          print(imagei.path);
          FormData formData = new FormData.from({
            "uid": mk.uid,
            "location": mk.location,
            "aid": mk.aid,
            "act": mk.act,
            "shiftid": mk.shiftid,
            "refid": mk.refid,
            "latit": mk.latit,
            "longi": mk.longi,
            "file": new UploadFileInfo(imagei, "image.png"),
            "FakeLocationStatus": mk.FakeLocationStatus,
             "platform":'android'
          });
          print("5");
          print(globals.path + "saveImage");
          Response<String> response1 =
          await dio.post(globals.path + "saveImage", data: formData);
          //Response<String> response1=await dio.post("https://ubiattendance.ubihrm.com/index.php/services/saveImage",data:formData);
          //Response<String> response1=await dio.post("http://192.168.0.200/ubiattendance/index.php/services/saveImage",data:formData);
          //Response<String> response1 = await dio.post("https://ubitech.ubihrm.com/services/saveImage", data: formData);
          globals.cameraChannel.invokeMethod("cameraClosed");
          imagei.deleteSync();
          imageCache.clear();
          /*getTempImageDirectory();*/
          Map MarkAttMap = json.decode(response1.data);
          print(MarkAttMap["status"].toString());
          if (MarkAttMap["status"] == 1 || MarkAttMap["status"] == 2)
            return true;
          else
            return false;
        } else {
          print("6");
          return false;
        }
      }
      else
      {

        Dio dio = new Dio();
        FormData formData = new FormData.from({
          "uid": mk.uid,
          "location": mk.location,
          "aid": mk.aid,
          "act": mk.act,
          "shiftid": mk.shiftid,
          "refid": mk.refid,
          "latit": mk.latit,
          "longi": mk.longi,
          "FakeLocationStatus": mk.FakeLocationStatus,
          "platform":'android'
        });

        Response<String> response1 =
        await dio.post(globals.path + "saveImage", data: formData);
        //Response<String> response1=await dio.post("https://ubiattendance.ubihrm.com/index.php/services/saveImage",data:formData);
        //Response<String> response1=await dio.post("http://192.168.0.200/ubiattendance/index.php/services/saveImage",data:formData);
        //Response<String> response1 = await dio.post("https://ubitech.ubihrm.com/services/saveImage", data: formData);
        globals.cameraChannel.invokeMethod("cameraClosed");
        //imagei.deleteSync();
        // imageCache.clear();
        /*getTempImageDirectory();*/
        Map MarkAttMap = json.decode(response1.data);
        print(MarkAttMap["status"].toString());
        if (MarkAttMap["status"] == 1 || MarkAttMap["status"] == 2)
          return true;
        else
          return false;

      }
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<bool> saveVisit(MarkVisit mk,context) async {
    // visit in function
    try {
      File imagei = null;
      imageCache.clear();
      globals.cameraChannel.invokeMethod("cameraOpened");
      if (globals.visitImage == 1) {
        imagei = await ImagePicker.pickImage(source: ImageSource.camera, maxWidth: 200.0, maxHeight: 200.0);

        if (imagei != null) {
          globals.globalCameraOpenedStatus=false;
          //// sending this base64image string +to rest api
          Dio dio = new Dio();
          String location = globals.globalstreamlocationaddr;

          String lat = globals.assign_lat.toString();
          String long = globals.assign_long.toString();
          /*print('-------------------------------');
        print(mk.uid+" "+mk.cid);
        print('-------------------------------');
        return false;*/
          FormData formData = new FormData.from({
            "uid": mk.uid,
            "location": location,
            "cid": mk.cid,
            "refid": mk.refid,
            "latit": lat,
            "longi": long,
            "file": new UploadFileInfo(imagei, "image.png"),
            "FakeLocationStatus":mk.FakeLocationStatus

          });
          print("5*");
          Response<String> response1;
          try {
            print('------------**');
            response1 =
                await dio.post(globals.path + "saveVisit", data: formData);
            print("----->save visit image* --->" + response1.toString());
          } catch (e) {
            print('------------*');
            print(e.toString());
            print('------------*');
          }
          globals.cameraChannel.invokeMethod("cameraClosed");
          imagei.deleteSync();
          imageCache.clear();
          /*getTempImageDirectory();*/
          Map MarkAttMap = json.decode(response1.data);
          print('------------1*');
          print(MarkAttMap["res"].toString());
          print('------------2*');
          if (MarkAttMap["res"].toString() == '1')
            return true;
          else
            return false;
        } else {
          globals.globalCameraOpenedStatus=false;
          print("6*");
          return false;
        }
      } else {
        // if image is optional at the time of marking visit

        Dio dio = new Dio();
        String location = globals.globalstreamlocationaddr;
        String lat = globals.assign_lat.toString();
        String long = globals.assign_long.toString();
        /*print('-------------------------------');
        print(mk.uid+" "+mk.cid);
        print('-------------------------------');
        return false;*/
        FormData formData = new FormData.from({
          "uid": mk.uid,
          "location": location,
          "cid": mk.cid,
          "refid": mk.refid,
          "latit": lat,
          "longi": long,
          "FakeLocationStatus":mk.FakeLocationStatus
          //   "file": new UploadFileInfo(imagei, "image.png"),@@@@@@@@@@@@@
        });
        print("5");
        Response<String> response1;
        try {
          print('------------');
          response1 =
              await dio.post(globals.path + "saveVisit", data: formData);
          print("----->save visit image --->" + response1.toString());
        } catch (e) {
          print('------------');
          print(e.toString());
          print('------------');
        }

        Map MarkAttMap = json.decode(response1.data);
        print('------------1');
        print(MarkAttMap["res"].toString());
        print('------------2');
        if (MarkAttMap["res"].toString() == '1')
          return true;
        else
          return false;
      }
    } catch (e) {
      print('7');
      globals.globalCameraOpenedStatus=false;
      print(e.toString());
      return false;
    }
  }

  /************************************for app camera ***************************************/


  Future<bool> saveVisitAppCamera(MarkVisit mk,context) async {
    // visit in function
    try {
      File imagei = null;
      imageCache.clear();
      //   globals.cameraChannel.invokeMethod("cameraOpened");
      if (globals.visitImage == 1) {
        imagei = await Navigator.push(context, new MaterialPageRoute(
          builder: (BuildContext context) => new TakePictureScreen(),
          fullscreenDialog: true,)
        );

        if (imagei != null) {
          globals.globalCameraOpenedStatus=false;
          //// sending this base64image string +to rest api
          Dio dio = new Dio();
          String location = globals.globalstreamlocationaddr;

          String lat = globals.assign_lat.toString();
          String long = globals.assign_long.toString();
          /*print('-------------------------------');
        print(mk.uid+" "+mk.cid);
        print('-------------------------------');
        return false;*/
          FormData formData = new FormData.from({
            "uid": mk.uid,
            "location": location,
            "cid": mk.cid,
            "refid": mk.refid,
            "latit": lat,
            "longi": long,
            "file": new UploadFileInfo(imagei, "image.png"),
            "FakeLocationStatus":mk.FakeLocationStatus

          });
          print("5*");
          Response<String> response1;
          try {
            print('------------**');
            response1 =
            await dio.post(globals.path + "saveVisit", data: formData);
            print("----->save visit image* --->" + response1.toString());
          } catch (e) {
            print('------------*');
            print(e.toString());
            print('------------*');
          }
          //  globals.cameraChannel.invokeMethod("cameraClosed");
          imagei.deleteSync();
          imageCache.clear();
          /*getTempImageDirectory();*/
          Map MarkAttMap = json.decode(response1.data);
          print('------------1*');
          print(MarkAttMap["res"].toString());
          print('------------2*');
          if (MarkAttMap["res"].toString() == '1')
            return true;
          else
            return false;
        } else {
          globals.globalCameraOpenedStatus=false;
          print("6*");
          return false;
        }
      } else {
        // if image is optional at the time of marking visit

        Dio dio = new Dio();
        String location = globals.globalstreamlocationaddr;
        String lat = globals.assign_lat.toString();
        String long = globals.assign_long.toString();
        /*print('-------------------------------');
        print(mk.uid+" "+mk.cid);
        print('-------------------------------');
        return false;*/
        FormData formData = new FormData.from({
          "uid": mk.uid,
          "location": location,
          "cid": mk.cid,
          "refid": mk.refid,
          "latit": lat,
          "longi": long,
          "FakeLocationStatus":mk.FakeLocationStatus
          //   "file": new UploadFileInfo(imagei, "image.png"),@@@@@@@@@@@@@
        });
        print("5");
        Response<String> response1;
        try {
          print('------------');
          response1 =
          await dio.post(globals.path + "saveVisit", data: formData);
          print("----->save visit image --->" + response1.toString());
        } catch (e) {
          print('------------');
          print(e.toString());
          print('------------');
        }

        Map MarkAttMap = json.decode(response1.data);
        print('------------1');
        print(MarkAttMap["res"].toString());
        print('------------2');
        if (MarkAttMap["res"].toString() == '1')
          return true;
        else
          return false;
      }
    } catch (e) {
      print('7');
      globals.globalCameraOpenedStatus=false;
      print(e.toString());
      return false;
    }
  }



  ////////////////////////////////////////////////


  /************************ for app camera *******************************************************/



  Future<bool> saveVisitOutAppCamera(
      empid, addr, visit_id, latit, longi, remark, refid,FakeLocationStatus,context) async {
    // visit in function
    try {
      File imagei = null;
      imageCache.clear();
      if (globals.visitImage == 1) {
        // globals.cameraChannel.invokeMethod("cameraOpened");
        imagei = await Navigator.push(context, new MaterialPageRoute(
          builder: (BuildContext context) => new TakePictureScreen(),
          fullscreenDialog: true,)
        );

        if (imagei != null) {
          globals.globalCameraOpenedStatus=false;
          //// sending this base64image string +to rest api
          Dio dio = new Dio();
          String location = globals.globalstreamlocationaddr;
          String lat = globals.assign_lat.toString();
          String long = globals.assign_long.toString();
          /*print('-------------------------------');
        print(mk.uid+" "+mk.cid);
        print('-------------------------------');
        return false;*/
          FormData formData = new FormData.from({
            "empid": empid,
            "visit_id": visit_id,
            "addr": addr,
            "latit": latit,
            "longi": longi,
            "remark": remark,
            "refid": refid,
            "file": new UploadFileInfo(imagei, "image.png"),
            "FakeLocationStatus":FakeLocationStatus
          });
          print("5");
          Response<String> response1;
          try {
            print('------------visit out----11');
            response1 =
            await dio.post(globals.path + "saveVisitOut", data: formData);
          } catch (e) {
            print('------------visit out--1');
            print(e.toString());
            print('------------visit out--2');
          }
          // globals.cameraChannel.invokeMethod("cameraClosed");
          imagei.deleteSync();
          imageCache.clear();
          /*getTempImageDirectory();*/
          Map MarkAttMap = json.decode(response1.data);
          print('visit out------------1');
          print(MarkAttMap["res"].toString());
          print('visit out------------2');
          if (MarkAttMap["res"].toString() == '1')
            return true;
          else
            return false;
        } else {
          print("6");
          globals.globalCameraOpenedStatus=false;
          return false;
        }
      } else {
        // if image is notmandatory while marking punchout
        Dio dio = new Dio();
        String location = globals.globalstreamlocationaddr;
        String lat = globals.assign_lat.toString();
        String long = globals.assign_long.toString();
        FormData formData = new FormData.from({
          "empid": empid,
          "visit_id": visit_id,
          "addr": addr,
          "latit": latit,
          "longi": longi,
          "remark": remark,
          "refid": refid,
          "FakeLocationStatus":FakeLocationStatus
        });
        print("5");
        Response<String> response1;
        try {
          print('------------visit out----11');
          response1 =
          await dio.post(globals.path + "saveVisitOut", data: formData);
        } catch (e) {
          print('------------visit out--1');
          print(e.toString());
          print('------------visit out--2');
        }
        /*getTempImageDirectory();*/
        Map MarkAttMap = json.decode(response1.data);
        print('visit out------------1');
        print(MarkAttMap["res"].toString());
        print('visit out------------2');
        if (MarkAttMap["res"].toString() == '1')
          return true;
        else
          return false;
      }
    } catch (e) {
      print('7');
      globals.globalCameraOpenedStatus=false;
      print(e.toString());
      return false;
    }
  }







  ////////////////////////////////////////////////////////////////////////////////////////////////



  Future<bool> saveVisitOut(
      empid, addr, visit_id, latit, longi, remark, refid,FakeLocationStatus,context) async {
    // visit in function
    try {
      File imagei = null;
      imageCache.clear();
      if (globals.visitImage == 1) {
        globals.cameraChannel.invokeMethod("cameraOpened");
        imagei = await ImagePicker.pickImage(source: ImageSource.camera, maxWidth: 200.0, maxHeight: 200.0);

        if (imagei != null) {
          globals.globalCameraOpenedStatus=false;
          //// sending this base64image string +to rest api
          Dio dio = new Dio();
          String location = globals.globalstreamlocationaddr;
          String lat = globals.assign_lat.toString();
          String long = globals.assign_long.toString();
          /*print('-------------------------------');
        print(mk.uid+" "+mk.cid);
        print('-------------------------------');
        return false;*/
          FormData formData = new FormData.from({
            "empid": empid,
            "visit_id": visit_id,
            "addr": addr,
            "latit": latit,
            "longi": longi,
            "remark": remark,
            "refid": refid,
            "file": new UploadFileInfo(imagei, "image.png"),
            "FakeLocationStatus":FakeLocationStatus
          });
          print("5");
          Response<String> response1;
          try {
            print('------------visit out----11');
            response1 =
                await dio.post(globals.path + "saveVisitOut", data: formData);
          } catch (e) {
            print('------------visit out--1');
            print(e.toString());
            print('------------visit out--2');
          }
          globals.cameraChannel.invokeMethod("cameraClosed");
          imagei.deleteSync();
          imageCache.clear();
          /*getTempImageDirectory();*/
          Map MarkAttMap = json.decode(response1.data);
          print('visit out------------1');
          print(MarkAttMap["res"].toString());
          print('visit out------------2');
          if (MarkAttMap["res"].toString() == '1')
            return true;
          else
            return false;
        } else {
          print("6");
          globals.globalCameraOpenedStatus=false;
          return false;
        }
      } else {
        // if image is notmandatory while marking punchout
        Dio dio = new Dio();
        String location = globals.globalstreamlocationaddr;
        String lat = globals.assign_lat.toString();
        String long = globals.assign_long.toString();
        FormData formData = new FormData.from({
          "empid": empid,
          "visit_id": visit_id,
          "addr": addr,
          "latit": latit,
          "longi": longi,
          "remark": remark,
          "refid": refid,
          "FakeLocationStatus":FakeLocationStatus
        });
        print("5");
        Response<String> response1;
        try {
          print('------------visit out----11');
          response1 =
              await dio.post(globals.path + "saveVisitOut", data: formData);
        } catch (e) {
          print('------------visit out--1');
          print(e.toString());
          print('------------visit out--2');
        }
        /*getTempImageDirectory();*/
        Map MarkAttMap = json.decode(response1.data);
        print('visit out------------1');
        print(MarkAttMap["res"].toString());
        print('visit out------------2');
        if (MarkAttMap["res"].toString() == '1')
          return true;
        else
          return false;
      }
    } catch (e) {
      print('7');
      globals.globalCameraOpenedStatus=false;
      print(e.toString());
      return false;
    }
  }

  /******************* for app camera ***************************/




  /////Start SAve flexi time in out//////
  Future<bool> saveFlexiAppCamera(MarkVisit mk,context) async {
    print('------------**v');
    // visit in function
    try {
      print('------------**vv');
      File imagei = null;
      imageCache.clear();
      //   if (globals.FlexiImage != 1) {
      print('------------**vvxx');
      //  globals.cameraChannel.invokeMethod("cameraOpened");
      imagei = await Navigator.push(context, new MaterialPageRoute(
        builder: (BuildContext context) => new TakePictureScreen(),
        fullscreenDialog: true,)
      );

      if (imagei != null) {
        globals.globalCameraOpenedStatus=false;
        print('------------**vvxxbb');
        //// sending this base64image string +to rest api
        Dio dio = new Dio();
        String location = globals.globalstreamlocationaddr;
        String lat = globals.assign_lat.toString();
        String long = globals.assign_long.toString();
        print('-------------------------------');
        print(mk.uid+" "+mk.cid);
        print('-------------------------------');
        //  return false;
        FormData formData = new FormData.from({
          "uid": mk.uid,
          "location": location,
          "cid": mk.cid,
          "refid": mk.refid,
          "latit": lat,
          "longi": long,
          "file": new UploadFileInfo(imagei, "image.png"),
          "FakeLocationStatus":mk.FakeLocationStatus
        });
        print("5*");
        Response<String> response1;
        try {
          print('------------**');
          response1 =
          await dio.post(globals.path + "saveFlexi", data: formData);
          print("----->save visit image* --->" + response1.toString());
        } catch (e) {
          print('------------*');
          print(e.toString());
          print('------------*');
        }
        //  globals.cameraChannel.invokeMethod("cameraClosed");
        imagei.deleteSync();
        imageCache.clear();
        /*getTempImageDirectory();*/
        Map MarkAttMap = json.decode(response1.data);
        print('------------1*');
        print(MarkAttMap["res"].toString());
        print('------------2*');
        if (MarkAttMap["res"].toString() == '1')
          return true;
        else
          return false;
      } else {
        print("6*");
        globals.globalCameraOpenedStatus=false;
        return false;
      }
//    }
      /*else {
      // if image is optional at the time of marking visit

      Dio dio = new Dio();
      String location = globals.globalstreamlocationaddr;
      Map<String, double> _currentLocation =
      globals.list[globals.list.length - 1];
      String lat = _currentLocation["latitude"].toString();
      String long = _currentLocation["longitude"].toString();
      /*print('-------------------------------');
      print(mk.uid+" "+mk.cid);
      print('-------------------------------');
      return false;*/
      FormData formData = new FormData.from({
        "uid": mk.uid,
        "location": location,
        "cid": mk.cid,
        "refid": mk.refid,
        "latit": lat,
        "longi": long,
        //   "file": new UploadFileInfo(imagei, "image.png"),@@@@@@@@@@@@@
      });
      print("5");
      Response<String> response1;
      try {
        print('------------');
        response1 =
        await dio.post(globals.path + "saveFlexiOut", data: formData);
        print("----->save visit image --->" + response1.toString());
      } catch (e) {
        print('------------');
        print(e.toString());
        print('------------');
      }

      Map MarkAttMap = json.decode(response1.data);
      print('------------1');
      print(MarkAttMap["res"].toString());
      print('------------2');
      if (MarkAttMap["res"].toString() == '1')
        return true;
      else
        return false;
    }*/
    } catch (e) {
      print('7--');
      globals.globalCameraOpenedStatus=false;
      print(e.toString());
      return false;
    }
  }









  //////////////////////////////////////////////////////////





  /////Start SAve flexi time in out//////
  Future<bool> saveFlexi(MarkVisit mk,context) async {
    print('------------**v');
    // visit in function
    try {
      print('------------**vv');
      File imagei = null;
      imageCache.clear();
      //   if (globals.FlexiImage != 1) {
      print('------------**vvxx');
      globals.cameraChannel.invokeMethod("cameraOpened");

      imagei = await ImagePicker.pickImage(source: ImageSource.camera, maxWidth: 200.0, maxHeight: 200.0);


      if (imagei != null) {
        globals.globalCameraOpenedStatus=false;
        print('------------**vvxxbb');
        //// sending this base64image string +to rest api
        Dio dio = new Dio();
        String location = globals.globalstreamlocationaddr;
        String lat = globals.assign_lat.toString();
        String long = globals.assign_long.toString();
        print('-------------------------------');
        print(mk.uid+" "+mk.cid);
        print('-------------------------------');
        //  return false;
        FormData formData = new FormData.from({
          "uid": mk.uid,
          "location": location,
          "cid": mk.cid,
          "refid": mk.refid,
          "latit": lat,
          "longi": long,
          "file": new UploadFileInfo(imagei, "image.png"),
          "FakeLocationStatus":mk.FakeLocationStatus
        });
        print("5*");
        Response<String> response1;
        try {
          print('------------**');
          response1 =
          await dio.post(globals.path + "saveFlexi", data: formData);
          print("----->save visit image* --->" + response1.toString());
        } catch (e) {
          print('------------*');
          print(e.toString());
          print('------------*');
        }
        globals.cameraChannel.invokeMethod("cameraClosed");
        imagei.deleteSync();
        imageCache.clear();
        /*getTempImageDirectory();*/
        Map MarkAttMap = json.decode(response1.data);
        print('------------1*');
        print(MarkAttMap["res"].toString());
        print('------------2*');
        if (MarkAttMap["res"].toString() == '1')
          return true;
        else
          return false;
      } else {
        print("6*");
        globals.globalCameraOpenedStatus=false;
        return false;
      }
//    }
      /*else {
      // if image is optional at the time of marking visit

      Dio dio = new Dio();
      String location = globals.globalstreamlocationaddr;
      Map<String, double> _currentLocation =
      globals.list[globals.list.length - 1];
      String lat = _currentLocation["latitude"].toString();
      String long = _currentLocation["longitude"].toString();
      /*print('-------------------------------');
      print(mk.uid+" "+mk.cid);
      print('-------------------------------');
      return false;*/
      FormData formData = new FormData.from({
        "uid": mk.uid,
        "location": location,
        "cid": mk.cid,
        "refid": mk.refid,
        "latit": lat,
        "longi": long,
        //   "file": new UploadFileInfo(imagei, "image.png"),@@@@@@@@@@@@@
      });
      print("5");
      Response<String> response1;
      try {
        print('------------');
        response1 =
        await dio.post(globals.path + "saveFlexiOut", data: formData);
        print("----->save visit image --->" + response1.toString());
      } catch (e) {
        print('------------');
        print(e.toString());
        print('------------');
      }

      Map MarkAttMap = json.decode(response1.data);
      print('------------1');
      print(MarkAttMap["res"].toString());
      print('------------2');
      if (MarkAttMap["res"].toString() == '1')
        return true;
      else
        return false;
    }*/
    } catch (e) {
      print('7--');
      globals.globalCameraOpenedStatus=false;
      print(e.toString());
      return false;
    }
  }

/****************  for app camera *****************/


  Future<bool> saveFlexiOutAppCamera(
      empid, addr, visit_id, latit, longi,  refid,FakeLocationStatus,context) async
  {
    // visit in function
    try {
      File imagei = null;
      imageCache.clear();
      // globals.cameraChannel.invokeMethod("cameraOpened");
      // if (globals.FlexiImage != 1) {
      imagei = await Navigator.push(context, new MaterialPageRoute(
        builder: (BuildContext context) => new TakePictureScreen(),
        fullscreenDialog: true,)
      );

      print(imagei);
      if (imagei != null)
      {
        globals.globalCameraOpenedStatus=false;
        //// sending this base64image string +to rest api
        Dio dio = new Dio();

        /*  String location = globals.globalstreamlocationaddr;
      String lat = globals.assign_lat.toString();
      String long = globals.assign_long.toString();*/
        /*print('-------------------------------');
    print(mk.uid+" "+mk.cid);
    print('-------------------------------');
    return false;*/
        print("Ubi attendance1");
        FormData formData = new FormData.from({
          "empid": empid,
          "visit_id": visit_id,
          "addr": addr,
          "latit": latit,
          "longi": longi,
          "refid": refid,
          "file": new UploadFileInfo(imagei, "image.png"),
          "FakeLocationStatus":FakeLocationStatus
        });
        // print("5"+empid+"--"+visit_id+"--"+addr+"--"+latit+"--"+longi+"--"+refid+"--");
        Response<String> response1;
        try {
          print('------------visit out----11');
          //  print( await dio.post(globals.path + "saveFlexiOut", data: formData));
          response1 = await dio.post(globals.path+"saveFlexiOut", data: formData);
          print(response1);
        } catch (e) {
          print('------------visit out--11');
          print(e.toString());
          print('------------visit out--2');
        }
        //  globals.cameraChannel.invokeMethod("cameraClosed");
        imagei.deleteSync();
        imageCache.clear();
        /*getTempImageDirectory();*/
        Map MarkAttMap = json.decode(response1.data);
        print('visit out------------1');
        print(MarkAttMap["res"].toString());
        print('visit out------------2');
        if (MarkAttMap["res"].toString() == '1')
          return true;
        else
          return false;
      } else {
        globals.globalCameraOpenedStatus=false;
        print("6");
        return false;
      }
      //   }
      /*else {
    // if image is notmandatory while marking punchout
    Dio dio = new Dio();
    String location = globals.globalstreamlocationaddr;
    Map<String, double> _currentLocation =
    globals.list[globals.list.length - 1];
    String lat = _currentLocation["latitude"].toString();
    String long = _currentLocation["longitude"].toString();
    FormData formData = new FormData.from({
      "empid": empid,
      "visit_id": visit_id,
      "addr": addr,
      "latit": latit,
      "longi": longi,
     // "remark": remark,
      "refid": refid
    });
    print("5");
    Response<String> response1;
    try {
      print('------------visit out----11');
      response1 =
      await dio.post(globals.path + "saveFlexiOut", data: formData);
    } catch (e) {
      print('------------visit out--1');
      print(e.toString());
      print('------------visit out--2');
    }
    /*getTempImageDirectory();*/
    Map MarkAttMap = json.decode(response1.data);
    print('visit out------------1');
    print(MarkAttMap["res"].toString());
    print('visit out------------2');
    if (MarkAttMap["res"].toString() == '1')
      return true;
    else
      return false;
  }*/
    } catch (e) {
      print('7');
      globals.globalCameraOpenedStatus=false;
      print(e.toString());
      return false;
    }
  }
/////End SAve flexi time in out//////






//////////////////////////////////////////////
  Future<bool> saveFlexiOut(
      empid, addr, visit_id, latit, longi,  refid,FakeLocationStatus,context) async
  {
    // visit in function
    try {
      File imagei = null;
      imageCache.clear();
      globals.cameraChannel.invokeMethod("cameraOpened");
      // if (globals.FlexiImage != 1) {
      imagei = await ImagePicker.pickImage(source: ImageSource.camera, maxWidth: 200.0, maxHeight: 200.0);

      print(imagei);
      if (imagei != null)
      {
        globals.globalCameraOpenedStatus=false;
        //// sending this base64image string +to rest api
        Dio dio = new Dio();

        /*  String location = globals.globalstreamlocationaddr;
      String lat = globals.assign_lat.toString();
      String long = globals.assign_long.toString();*/
        /*print('-------------------------------');
    print(mk.uid+" "+mk.cid);
    print('-------------------------------');
    return false;*/
        print("Ubi attendance1");
        FormData formData = new FormData.from({
          "empid": empid,
          "visit_id": visit_id,
          "addr": addr,
          "latit": latit,
          "longi": longi,
          "refid": refid,
          "file": new UploadFileInfo(imagei, "image.png"),
          "FakeLocationStatus":FakeLocationStatus
        });
       // print("5"+empid+"--"+visit_id+"--"+addr+"--"+latit+"--"+longi+"--"+refid+"--");
        Response<String> response1;
        try {
          print('------------visit out----11');
          //  print( await dio.post(globals.path + "saveFlexiOut", data: formData));
          response1 = await dio.post(globals.path+"saveFlexiOut", data: formData);
          print(response1);
        } catch (e) {
          print('------------visit out--11');
          print(e.toString());
          print('------------visit out--2');
        }
        globals.cameraChannel.invokeMethod("cameraClosed");
        imagei.deleteSync();
        imageCache.clear();
        /*getTempImageDirectory();*/
        Map MarkAttMap = json.decode(response1.data);
        print('visit out------------1');
        print(MarkAttMap["res"].toString());
        print('visit out------------2');
        if (MarkAttMap["res"].toString() == '1')
          return true;
        else
          return false;
      } else {
        globals.globalCameraOpenedStatus=false;
        print("6");
        return false;
      }
      //   }
      /*else {
    // if image is notmandatory while marking punchout
    Dio dio = new Dio();
    String location = globals.globalstreamlocationaddr;
    Map<String, double> _currentLocation =
    globals.list[globals.list.length - 1];
    String lat = _currentLocation["latitude"].toString();
    String long = _currentLocation["longitude"].toString();
    FormData formData = new FormData.from({
      "empid": empid,
      "visit_id": visit_id,
      "addr": addr,
      "latit": latit,
      "longi": longi,
     // "remark": remark,
      "refid": refid
    });
    print("5");
    Response<String> response1;
    try {
      print('------------visit out----11');
      response1 =
      await dio.post(globals.path + "saveFlexiOut", data: formData);
    } catch (e) {
      print('------------visit out--1');
      print(e.toString());
      print('------------visit out--2');
    }
    /*getTempImageDirectory();*/
    Map MarkAttMap = json.decode(response1.data);
    print('visit out------------1');
    print(MarkAttMap["res"].toString());
    print('visit out------------2');
    if (MarkAttMap["res"].toString() == '1')
      return true;
    else
      return false;
  }*/
    } catch (e) {
      print('7');
      globals.globalCameraOpenedStatus=false;
      print(e.toString());
      return false;
    }
  }
  /////End SAve flexi time in out//////
}
