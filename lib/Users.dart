import 'dart:async';
import 'dart:collection';
//import 'dart:html';
import 'dart:math' show cos, sqrt, asin;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
//import 'package:english_words/english_words.dart';
import 'package:geocoder/geocoder.dart';
import 'package:firebase_database/firebase_database.dart';
import 'fire.dart';
import 'package:flutter/widgets.dart';

class UsersState extends State {



  void ShowAllUsers()
  {

  }



  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
        appBar: AppBar(
          title: Text('User List'),
          backgroundColor: Colors.red,
        ),
        body: Center(
        child: Column(
        children: <Widget>
        [
        Text('Sample User '),

        ]

        )
        ),
        );
  }

}

class  Users extends StatefulWidget
{
  @override
  UsersState createState() => new UsersState();
}