import 'package:flutter/cupertino.dart';
import 'package:toast/toast.dart';

void showToast(String value, BuildContext context) {
    Toast.show(value, context, duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
}