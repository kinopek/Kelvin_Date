import 'dart:async';
import 'dart:collection';
//import 'dart:html';
import 'dart:math' show cos, sqrt, asin;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
//import 'package:english_words/english_words.dart';
import 'package:geocoder/geocoder.dart';
import 'package:firebase_database/firebase_database.dart';
import 'fire.dart';
import 'geolocation.dart';
import 'register.dart';
import 'forgot.dart';


class LogingState extends State
{



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('KelvinDate'),
      ),
      body: Center(
          child: Column(
              children: <Widget>
              [
                Text('Welcome to KelvinDate' ),
                Text('Your Login:' ),
                Text('Your Password:' ),
                RaisedButton(child: Text('Log In!'), onPressed: ()
                {
                  Navigator.push
                    (
                      context,
                      MaterialPageRoute(builder: (context) => GeolocationExample())
                  );
                },),
                RaisedButton(child: Text('Do not have account?'), onPressed: ()
                {
                  Navigator.push
                    (
                      context,
                      MaterialPageRoute(builder: (context) => Register())
                  );
                },),
                RaisedButton(child: Text('Forgot password?'), onPressed: ()
                {
                  Navigator.push
                    (
                      context,
                      MaterialPageRoute(builder: (context) => Forgot())
                  );
                },)
              ]
          )
      ),
    );
  }
}


class Loging extends StatefulWidget {
  @override
  LogingState createState() => new LogingState();
}