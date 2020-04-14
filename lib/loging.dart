import 'dart:async';
import 'dart:collection';
//import 'dart:html';
import 'dart:math' show cos, sqrt, asin;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
//import 'package:english_words/english_words.dart';
import 'package:geocoder/geocoder.dart';
import 'package:firebase_database/firebase_database.dart';
import 'fire.dart';
import 'geolocation.dart';
import 'register.dart';
import 'forgot.dart';
import 'fire.dart';


class LogingState extends State
{



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('Log In'),

      ),
      body: Center(
          child: Column(
              children: <Widget>
              [

                Text('Welcome to KelvinDate',
                    style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 30
                        )
                ),
           TextFormField(
            decoration: InputDecoration
              (
                labelText: 'Your Login:',
                icon: Icon(Icons.person),
             hintText: 'What username you registered with?',
             ),

        onSaved: (String value) {
          // This optional block of code can be used to run
          // code when the user saves the form.
        },
        validator: (String value) {
          return value.contains('@') ? 'Do not use the @ char. It is not an email' : null;
        },
            ),
                TextFormField(
                  decoration: InputDecoration
                    (
                    labelText: 'Your Password:',
                    icon: Icon(Icons.lock),
                    hintText: 'Please enter your password',
                  ),

                  onSaved: (String value) {
                    // This optional block of code can be used to run
                    // code when the user saves the form.
                  },
                  validator: (String value)
                  {
                  },
                ),
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