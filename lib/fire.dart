import 'dart:async';
import 'dart:collection';
//import 'dart:html';
import 'dart:math' show cos, sqrt, asin;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
//import 'package:english_words/english_words.dart';
import 'package:geocoder/geocoder.dart';
import 'package:firebase_database/firebase_database.dart';


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