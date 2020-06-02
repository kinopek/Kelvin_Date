import 'dart:async';
import 'dart:math' show Random, asin, cos, min, sqrt;
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'const.dart';
import 'settings.dart';
import 'chat.dart';

// Okno z listą użytkowników do czatowania.
class UsersState extends State {
  UsersState({Key key, @required this.currentUserId});
  int sortOrder = 0;
  SharedPreferences prefs;
  // zmienne jakieś.
  final String currentUserId;
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool isLoading = false;

  // Menu w prawym górnym rogu.
  List<Choice> choices = const <Choice>[
    const Choice(title: 'Settings', icon: Icons.settings, value: 5),
    const Choice(title: 'Log out', icon: Icons.exit_to_app, value: 6),
  ];
//Menu sortowania
  List<Choice> sorten = const <Choice>[
    const Choice(title: 'Sort by Name', icon: Icons.person, value: 0),
    const Choice(title: 'Sort by id', icon: Icons.account_balance, value: 1),
    const Choice(title: 'Sort by photo', icon: Icons.photo_camera, value: 2),
    const Choice(
        title: 'Sort by creation date', icon: Icons.date_range, value: 3),
  ];

  @override
  void initState() {
    super.initState();
    registerNotification();
    configLocalNotification();
  }

  // Nie działające jeszcze powiadomienia o nowych wiadomościach - chyba, bo nie sprawdzałem.
  void registerNotification() {
    firebaseMessaging.requestNotificationPermissions();

    firebaseMessaging.configure(onMessage: (Map<String, dynamic> message) {
      print('onMessage: $message');
      Platform.isAndroid
          ? showNotification(message['notification'])
          : showNotification(message['aps']['alert']);
      return;
    }, onResume: (Map<String, dynamic> message) {
      print('onResume: $message');
      return;
    }, onLaunch: (Map<String, dynamic> message) {
      print('onLaunch: $message');
      return;
    });

    firebaseMessaging.getToken().then((token) {
      print('token: $token');
      Firestore.instance
          .collection('users')
          .document(currentUserId)
          .updateData({'pushToken': token});
    }).catchError((err) {
      Fluttertoast.showToast(msg: err.message.toString());
    });
  }

  // Do sprawdzenia razem z powyższą funkcją.
  void configLocalNotification() {
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // Kiknięcie w coś w menu.
  Future<void> onItemMenuPress(Choice choice) async {
    if (choice.title == 'Log out') {
      FirebaseAuth.instance.signOut();
      prefs = await SharedPreferences.getInstance();

      if (prefs != null) {
        await prefs.clear();
      }
      Navigator.pushReplacementNamed(context, "/login");
    } else if (choice.title == 'Sort by Name') {
      setState((sortBy(0)));
      build;
    } else if (choice.title == 'Sort by id') {
      setState((sortBy(1)));
    } else if (choice.title == 'Sort by photo') {
      setState((sortBy(2)));
    } else if (choice.title == 'Sort by creation date') {
      setState((sortBy(3)));
    } else {
      // Otworzenie edycji użytkownika.
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Settings()));
    }
  }

  // Powiadomienie - do przetestowania.
  void showNotification(message) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      Platform.isAndroid
          ? 'com.dfa.flutterchatdemo'
          : 'com.duytq.flutterchatdemo',
      'Flutter chat demo',
      'your channel description',
      playSound: true,
      enableVibration: true,
      importance: Importance.Max,
      priority: Priority.High,
    );
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    print(message);
//    print(message['body'].toString());
//    print(json.encode(message));

    await flutterLocalNotificationsPlugin.show(0, message['title'].toString(),
        message['body'].toString(), platformChannelSpecifics,
        payload: json.encode(message));

//    await flutterLocalNotificationsPlugin.show(
//        0, 'plain title', 'plain body', platformChannelSpecifics,
//        payload: 'item x');
  }

  // Kliknięcie powrotu.
  Future<bool> onBackPress() {
    openDialog();
    return Future.value(false);
  }

  // Otwarcie pytania czy chcesz wyjść z aplikacji.
  Future<Null> openDialog() async {
    switch (await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            contentPadding:
                EdgeInsets.only(left: 0.0, right: 0.0, top: 0.0, bottom: 0.0),
            children: <Widget>[
              Container(
                color: mainColor,
                margin: EdgeInsets.all(0.0),
                padding: EdgeInsets.only(bottom: 10.0, top: 10.0),
                height: 100.0,
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Icon(
                        Icons.exit_to_app,
                        size: 30.0,
                        color: Colors.white,
                      ),
                      margin: EdgeInsets.only(bottom: 10.0),
                    ),
                    Text(
                      'Exit app',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Are you sure to exit app?',
                      style: TextStyle(color: Colors.white70, fontSize: 14.0),
                    ),
                  ],
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, 0);
                },
                child: Row(
                  children: <Widget>[
                    Container(
                      child: Icon(
                        Icons.cancel,
                        color: mainColor,
                      ),
                      margin: EdgeInsets.only(right: 10.0),
                    ),
                    Text(
                      'CANCEL',
                      style: TextStyle(
                          color: mainColor, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, 1);
                },
                child: Row(
                  children: <Widget>[
                    Container(
                      child: Icon(
                        Icons.check_circle,
                        color: mainColor,
                      ),
                      margin: EdgeInsets.only(right: 10.0),
                    ),
                    Text(
                      'YES',
                      style: TextStyle(
                          color: mainColor, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ],
          );
        })) {
      case 0:
        break;
      case 1:
        exit(0);
        break;
    }
  }

  // Budowanie UI listy użytkowników.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Users',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: mainColor,
        centerTitle: false,
        actions: <Widget>[
          PopupMenuButton<Choice>(
            onSelected: onItemMenuPress,
            itemBuilder: (BuildContext context) {
              return choices.map((Choice choice) {
                return PopupMenuItem<Choice>(
                    value: choice,
                    child: Row(
                      children: <Widget>[
                        Icon(
                          choice.icon,
                          color: mainColor,
                        ),
                        Container(
                          width: 10.0,
                        ),
                        Text(
                          choice.title,
                        ),
                      ],
                    ));
              }).toList();
            },
          ),
          PopupMenuButton<Choice>(
            onSelected: onItemMenuPress,
            itemBuilder: (BuildContext context) {
              return sorten.map((Choice choice) {
                return PopupMenuItem<Choice>(
                    value: choice,
                    child: Row(
                      children: <Widget>[
                        Icon(
                          choice.icon,
                          color: mainColor,
                        ),
                        Container(
                          width: 10.0,
                        ),
                        Text(
                          choice.title,
                        ),
                      ],
                    ));
              }).toList();
            },
          ),
        ],
      ),
      body: WillPopScope(
        child: Stack(
          children: <Widget>[
            // List

            Container(
              child: StreamBuilder(
                stream: dataShot(sortOrder),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(mainColor),
                      ),
                    );
                  } else {
                    snapshot.data.documents;
                    return ListView.builder(
                      padding: EdgeInsets.all(10.0),
                      itemBuilder: (context, index) =>
                          buildItem(context, snapshot.data.documents[index]),
                      itemCount: snapshot.data.documents.length,
                    );
                  }
                },
              ),
            ),

            // Loading
            Positioned(
              child: isLoading
                  ? Container(
                      child: Center(
                        child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(mainColor)),
                      ),
                      color: Colors.white.withOpacity(0.8),
                    )
                  : Container(),
            )
          ],
        ),
        onWillPop: onBackPress,
      ),
    );
  }

/*
  Row sortButtons()
  {
    return Row(
      children: <Widget>[
      FlatButton(
        onPressed: sortBy(0),
        child: Text(
          'Sort by Name',
          style: TextStyle(fontSize: 13.0),
        ),
        color: mainColor,
        highlightColor: secondaryColor,
        splashColor: Colors.transparent,
        textColor: Colors.white,
        padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
      ),
        FlatButton(
          onPressed: sortBy(1),
          child: Text(
            'Sort by id',
            style: TextStyle(fontSize: 13.0),
          ),
          color: mainColor,
          highlightColor: secondaryColor,
          splashColor: Colors.transparent,
          textColor: Colors.white,
          padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
        ),
        FlatButton(
          onPressed: sortBy(2),
          child: Text(
            'Sort by photo',
            style: TextStyle(fontSize: 13.0),
          ),
          color: mainColor,
          highlightColor: secondaryColor,
          splashColor: Colors.transparent,
          textColor: Colors.white,
          padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
        ),
        FlatButton(
          onPressed: sortBy(3),
          child: Text(
            'Sort by creation',
            style: TextStyle(fontSize: 13.0),
          ),
          color: mainColor,
          highlightColor: secondaryColor,
          splashColor: Colors.transparent,
          textColor: Colors.white,
          padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
        ),
    ]);
  }
*/

  Widget buildItem(BuildContext context, DocumentSnapshot document) {
    if (document['id'] == currentUserId) {
      return Container();
    } else {
      return Container(
        child: FlatButton(
          child: Row(
            children: <Widget>[
              Material(
                child: document['photoUrl'] != null
                    ? CachedNetworkImage(
                        placeholder: (context, url) => Container(
                          child: CircularProgressIndicator(
                            strokeWidth: 10.0,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(secondaryColor),
                          ),
                          width: 50.0,
                          height: 50.0,
                          padding: EdgeInsets.all(1.0),
                        ),
                        imageUrl: document['photoUrl'],
                        width: 50.0,
                        height: 50.0,
                        fit: BoxFit.cover,
                      )
                    : Icon(
                        Icons.account_circle,
                        size: 50.0,
                        color: secondaryColor,
                      ),
                borderRadius: BorderRadius.all(Radius.circular(25.0)),
                clipBehavior: Clip.hardEdge,
              ),
              Flexible(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Text(
                          'Nickname: ${document['nickname']}',
                          style: TextStyle(color: Colors.white),
                        ),
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
                      ),
                      Container(
                        child: Text(
                          'About me: ${document['aboutMe'] ?? 'Not available'}',
                          style: TextStyle(color: Colors.white),
                        ),
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                      )
                    ],
                  ),
                  margin: EdgeInsets.only(left: 20.0),
                ),
              ),
            ],
          ),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Chat(
                          peerId: document.documentID,
                          peerAvatar: document['photoUrl'],
                          peerName: document['nickname'],
                        )));
          },
          color: mainColor,
          padding: EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 10.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        ),
        margin: EdgeInsets.only(bottom: 10.0, left: 5.0, right: 5.0),
      );
    }
  }

  sortBy(int i) {
    sortOrder = i;
  }

  Stream<QuerySnapshot> dataShot(int i) {
    if (i == 0)
      return Firestore.instance
          .collection('users')
          .orderBy('nickname')
          .snapshots();
    if (i == 1)
      return Firestore.instance.collection('users').orderBy('id').snapshots();
    if (i == 2)
      return Firestore.instance
          .collection('users')
          .orderBy('photoUrl')
          .snapshots();
    if (i == 3)
      return Firestore.instance
          .collection('users')
          .orderBy('createdAt')
          .snapshots();
    else
      return Firestore.instance
          .collection('users')
          .orderBy('nickname')
          .snapshots();
  }
}

class Users extends StatefulWidget {
  final String currentUserId;

  Users({Key key, @required this.currentUserId}) : super(key: key);

  @override
  UsersState createState() => new UsersState(currentUserId: currentUserId);
}

class Choice {
  const Choice({this.title, this.icon, this.value});
  final int value;
  final String title;
  final IconData icon;
}
