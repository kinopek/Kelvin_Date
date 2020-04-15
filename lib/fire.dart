import 'dart:async';
import 'dart:collection';
//import 'dart:html';
import 'dart:math' show cos, sqrt, asin;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
//import 'package:english_words/english_words.dart';
import 'package:geocoder/geocoder.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';


class Fire extends State
{
  final databaseReference = FirebaseDatabase.instance.reference();

  void createRecord(var a, var b)
  {
    String id = new DateTime.now().millisecondsSinceEpoch.toString();
    databaseReference.child(id).set({
      'latitude': a,
      'longitude':  b
    });
  }

  Future createUserRecord(var login,var email, var uid)
  {
    databaseReference.child('users').child(uid).set({
      'login': login,
      'email':  email
    });
  }


  Coordinates getCoordinates( )
  {
    Coordinates c;
    return c;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return null;
  }


}