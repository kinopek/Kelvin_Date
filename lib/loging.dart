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
import 'package:kelvindate/Users.dart';
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
      // Sprawdzamy czy w cloud firestore są już dane naszego użytkownika.
      final QuerySnapshot result = await Firestore.instance.collection('users').where('id', isEqualTo: firebaseUser.uid).getDocuments();
      final List<DocumentSnapshot> documents = result.documents;
      if (documents.length == 0) {
        // Wrzucenie na serwer danych, jeżeli ich tam jeszcze nie ma.
        Firestore.instance.collection('users').document(firebaseUser.uid).setData({
          'nickname': firebaseUser.displayName,
          'photoUrl': firebaseUser.photoUrl,
          'id': firebaseUser.uid,
          'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
          'chattingWith': null
        });

        // Pobranie do lokalnej pamięci danych usera.
        currentUser = firebaseUser;
        await prefs.setString('id', currentUser.uid);
        await prefs.setString('nickname', currentUser.displayName);
        await prefs.setString('photoUrl', currentUser.photoUrl);
      } else {
        // Pobranie do lokalnej pamięci danych usera bez tworzenia go w bazie, bo już istnieje.
        await prefs.setString('id', documents[0]['id']);
        await prefs.setString('nickname', documents[0]['nickname']);
        await prefs.setString('photoUrl', documents[0]['photoUrl']);
        await prefs.setString('aboutMe', documents[0]['aboutMe']);
      }
      Fluttertoast.showToast(msg: "Sign in success");
      this.setState(() {
        isLoading = false;
      });

      // To jest dobry page route do powrotu po zalogowaniu.
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => SplashPage()),(_) => false);
    } else {
      Fluttertoast.showToast(msg: "Sign in fail");
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
                labelText: 'Your email:',
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
          return value.contains('@') ? 'Do use the @ char. It is an email' : null;
        },
            ),
                TextFormField(
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
                RaisedButton(child: Text('Log In!'), onPressed: ()
                {
                  handleSignIn();
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