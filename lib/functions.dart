import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


 class Functions{

  static void toast(String s) {
    Fluttertoast.showToast(
        msg: s,
        //  toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }


}