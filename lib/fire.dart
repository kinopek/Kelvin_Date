import 'dart:async';

//import 'dart:collection';
//import 'dart:html';
import 'dart:math' show cos, sqrt, asin;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Fire extends State {
  final databaseReference = FirebaseDatabase.instance.reference();

  static Future<FirebaseUser> authentic(
      SharedPreferences prefs,
      String email,
      String password,
      String login) async {
    FirebaseUser currentUser;
    // pobranie obiektu użykownika po zalogowaniu go mailem i hasłem.
    FirebaseUser firebaseUser = (await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: email,
                password: password))
        .user;
    if (firebaseUser != null) {
      if (login != null) // jeśli podano login (a dzieje się to wyłącznie przy rejestracji) to powinno podstawić za displayname
      {
        UserUpdateInfo u;
        u.displayName = login;
        firebaseUser.updateProfile(u);
      }

      // Sprawdzamy czy w cloud firestore są już dane naszego użytkownika.
      final QuerySnapshot result = await Firestore.instance
          .collection('users')
          .where('id', isEqualTo: firebaseUser.uid)
          .getDocuments();
      final List<DocumentSnapshot> documents = result.documents;

      if (documents.length == 0) {
        // Wrzucenie na serwer danych, jeżeli ich tam jeszcze nie ma.
        createFStoreUser(firebaseUser);
        // Pobranie do lokalnej pamięci danych usera.
        currentUser = firebaseUser;
        await prefs.setString('id', currentUser.uid);
        await prefs.setString('nickname', currentUser.displayName);
        await prefs.setString('photoUrl', currentUser.photoUrl);
      } else {
        // Pobranie do lokalnej pamięci danych usera bez tworzenia go w bazie, bo już istnieje.
        userToLocal(documents, prefs);
      }
    }
    return currentUser;
  }

  static void createRecord(var uid, var a, var b) {
    Firestore.instance.collection('coordinates').document(uid).setData({
      'latitude': a,
      'longitude': b,
      'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
    });
  }

  static void createFStoreUser(FirebaseUser firebaseUser) {
    Firestore.instance.collection('users').document(firebaseUser.uid).setData({
      'nickname': firebaseUser.displayName,
      'photoUrl': firebaseUser.photoUrl,
      'id': firebaseUser.uid,
      'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
      'chattingWith': null
    });
  }

  static Future<Coordinates> getCoordinates(String id) async {
    final QuerySnapshot result = await Firestore.instance
        .collection('coordinates')
        .where('id', isEqualTo: id)
        .getDocuments();
    final List<DocumentSnapshot> documents = result.documents;

    Coordinates c =
        new Coordinates(documents[0]['latitude'], documents[0]['longitude']);
    return c;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return null;
  }

  static Future<void> userToLocal(
      List<DocumentSnapshot> documents, SharedPreferences prefs) async {
    await prefs.setString('id', documents[0]['id']);
    await prefs.setString('nickname', documents[0]['nickname']);
    await prefs.setString('photoUrl', documents[0]['photoUrl']);
    await prefs.setString('aboutMe', documents[0]['aboutMe']);
  }
}
