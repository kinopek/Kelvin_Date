//import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'users.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  initState() {
    /*FirebaseAuth.instance
    .currentUser()
        .then((currentUser) => {
      if (currentUser == null)
        {Navigator.pushReplacementNamed(context, "/login")}
      else
        {
        Navigator.pushReplacementNamed(context, "/home")
        }
    })
        .catchError((err) => print(err));
    */

    FirebaseAuth.instance.onAuthStateChanged.listen((FirebaseUser user) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (user != null) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Users(
                  currentUserId: prefs.getString('id'),
                )));
      } else {
        Navigator.pushReplacementNamed(context, "/login");
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Text("Loading..."),
        ),
      ),
    );
  }
}
