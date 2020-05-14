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
import 'package:kelvindate/Functions.dart';
import 'package:kelvindate/Users.dart';
import 'package:kelvindate/const.dart';
import 'fire.dart';
import 'geolocation.dart';
import 'register.dart';
import 'forgot.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kelvindate/SplashPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';


class LogingState extends State
{
  TextEditingController emailInputController;
  TextEditingController pwdInputController;
  // Dodane zmienne
  SharedPreferences prefs; // Przechowuje dane zalogowanego użytkownika
  FirebaseUser currentUser; // Zmienna do pobierania adnych użytkownika.
  bool isLoading = false; // bool do włączania/wyłączania animacji - jeszcze nie użytye.
  bool isLoggedIn = false;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance; // instancja firebase Auth

  @override
  initState() {
    // Odnośniki do pól tekstowych.
    emailInputController = new TextEditingController();
    pwdInputController = new TextEditingController();
    super.initState();
    isSignedIn();
  }

  // Funkcja sprawdzająca czy użytkownik jest zalogowany - do poprawki, bo nie działa jeszcze.
  void isSignedIn() async {
    this.setState(() {
      isLoading = true;
    });

    // Pobranie danych z lokalnej pamięci.
    prefs = await SharedPreferences.getInstance();

    // Pobranie zalogowanego użytkownika.
    currentUser = await firebaseAuth.currentUser();

    // Jak użytkownik jest zalogowany, to go przerzucamy gdzieś tam - to jest do poprawienia, bo inny materialpageroute zrobię.
    if (currentUser != null) {
      isLoggedIn = true;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Users(currentUserId: prefs.getString('id'))),
      );
    }
    else {
      isLoggedIn = false;
    }
      this.setState(() {
      isLoading = false;
    });
  }

  // Funkcja logowania.
  Future<Null> handleSignIn() async{
    // Pobranie danych zalogowanego użytkownika.
    prefs = await SharedPreferences.getInstance();

    this.setState(() {
      isLoading = true;
    });



    // pobranie obiektu użykownika po zalogowaniu go mailem i hasłem.
    FirebaseUser firebaseUser = (await FirebaseAuth.instance.signInWithEmailAndPassword(email: emailInputController.text,password: pwdInputController.text)).user;
    if (firebaseUser != null) {


      currentUser = await Fire.authentic ( prefs,    emailInputController,   pwdInputController );


      Functions.toast("Sign in success");
      this.setState(() {
        isLoading = false;
      });

      // To jest dobry page route do powrotu po zalogowaniu.
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => SplashPage()),(_) => false);
    } else {
      Functions.toast("Sign in fail");
      this.setState(() {
        isLoading = false;
      });
    }
  }

  // Budowanie UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        title: Text('KelvinDate'),
      ),
      body: Center(
          child: Column(
              children: <Widget>
              [
                Container(
                  padding: EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 10.0),
                  child: Text('Login with email and password:',
                      style: TextStyle(
                          color: mainColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 20
                      )
                  ),
                ),
            Container(
              padding: EdgeInsets.fromLTRB(30.0, 5.0, 30.0, 5.0),
              child: TextFormField(
            decoration: InputDecoration
              (
                labelText: 'Your e-mail:',
                icon: Icon(Icons.person),
             hintText: 'What mail you registered with?',
             ),
             controller: emailInputController,
             onChanged: (val) {
               final trimVal = val.trim();
               if (val != trimVal)
                 setState(() {
                   val=val.trim();
                   emailInputController.text = trimVal;
                   emailInputController.selection = TextSelection.fromPosition(TextPosition(offset: trimVal.length));
                 });
             },

        onSaved: (String value) {
          // This optional block of code can be used to run
          // code when the user saves the form.
        },
        validator: (String value) {
          return value.contains('@') ? 'Use the @ char. It is an email' : null;
        },
            ),
            ),
                Container(
                  padding: EdgeInsets.fromLTRB(30.0, 5.0, 30.0, 5.0),
                  child: TextFormField(
                  decoration: InputDecoration
                    (
                    labelText: 'Your Password:',
                    icon: Icon(Icons.lock),
                    hintText: 'Please enter your password',
                  ),
                  controller: pwdInputController,
                  onChanged: (val) {
                    final trimVal = val.trim();
                    if (val != trimVal)
                      setState(() {
                        val=val.trim();
                        pwdInputController.text = trimVal;
                        pwdInputController.selection = TextSelection.fromPosition(TextPosition(offset: trimVal.length));
                      });
                  },

                  onSaved: (String value) {
                    // This optional block of code can be used to run
                    // code when the user saves the form.
                  },
                  validator: (String value)
                  {
                  },
                ),
                ),
                FlatButton(
                  onPressed: handleSignIn,
                  child: Text(
                    'Log In!',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  color: mainColor,
                  highlightColor: secondaryColor,
                  splashColor: Colors.transparent,
                  textColor: Colors.white,
                  padding: EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 10.0),
                ),
                FlatButton(
                  child: Text(
                      'Create new account',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      color:secondaryColor,
                    )
                  ),
                  onPressed: ()
                {
                  Navigator.push
                    (
                      context,
                      MaterialPageRoute(builder: (context) => Register())
                  );
                },
                  highlightColor: Colors.white,
                ),
                FlatButton(child: Text('Recover password',
                    style: TextStyle(
                  decoration: TextDecoration.underline,
                      color:secondaryColor,
                )), onPressed: ()
                {
                  Navigator.push
                    (
                      context,
                      MaterialPageRoute(builder: (context) => Forgot())
                  );
                },
                highlightColor: Colors.white,
                )
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