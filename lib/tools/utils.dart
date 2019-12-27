import 'package:flutter/cupertino.dart';
import 'package:toast/toast.dart';

void showToast(String value, BuildContext context) {
    Toast.show(value, context, duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
}

bool isFirst(String bothOwner, String user) {
  return bothOwner.startsWith(user);
}

String getYearMounthDate(int timeStamp) {
  DateTime time = new DateTime.fromMillisecondsSinceEpoch(timeStamp);
  String month = time.month.toString();
  String date = time.day.toString();
  return time.year.toString() + '-' + (month.length == 1 ? '0' : '') + month + '-' + (date.length == 1 ? '0' : '') + date;
}

//  dart里面weekday是从1开始自增的，1代表周一
List<String> dayMap = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
int oneDayMillSec = 24 * 3600 * 1000;

//  获得时间标签
String getIimeStringForChat(int timeStamp) {
    int currentTimeStamp = new DateTime.now().millisecondsSinceEpoch; 
    int currentDateStamp = DateTime.parse(getYearMounthDate(currentTimeStamp)).millisecondsSinceEpoch;
    int timeGap = currentDateStamp - timeStamp;
    String res = new RegExp(r"(\d{2}:\d{2}:\d{2})").stringMatch(DateTime.fromMillisecondsSinceEpoch(timeStamp).toString());
    String prefix = '';
    if (timeGap < 0) {
    } else if (timeGap < oneDayMillSec) {
        prefix = 'Yesterday   ';
    } else {
        double dayGap = timeGap / oneDayMillSec;
        prefix = (dayGap < 6 ? dayMap[new DateTime.fromMillisecondsSinceEpoch(currentDateStamp - (dayGap * oneDayMillSec).floor()).weekday] : getYearMounthDate(timeStamp)) + '   ';
    }
    return prefix + res;
}