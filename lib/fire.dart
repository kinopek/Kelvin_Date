import 'dart:async';
import 'dart:collection';
//import 'dart:html';
import 'dart:math' show cos, sqrt, asin;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
//import 'package:english_words/english_words.dart';
import 'package:geocoder/geocoder.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Fire extends State
{
  final databaseReference = FirebaseDatabase.instance.reference();

  static Future<FirebaseUser>  authentic (SharedPreferences prefs,   TextEditingController emailInputController,  TextEditingController pwdInputController ) async
  {
    FirebaseUser currentUser;
    // pobranie obiektu użykownika po zalogowaniu go mailem i hasłem.
    FirebaseUser firebaseUser = (await FirebaseAuth.instance.signInWithEmailAndPassword(email: emailInputController.text,password: pwdInputController.text)).user;
    if (firebaseUser != null) {

    }
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
    return  currentUser;
  }

  void createRecord(var uid, var a, var b)
  {
    String id = new DateTime.now().millisecondsSinceEpoch.toString();
    databaseReference.child('users').child(uid).child(id).set({
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


  Coordinates getCoordinates(String id )
  {


    Coordinates c;//= databaseReference.child('users').equalTo(id);
    return c;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return null;
  }


}