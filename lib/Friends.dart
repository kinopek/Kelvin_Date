import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Functions.dart';
import 'const.dart';

class Friends extends StatelessWidget {
  final String id;
  final String groupChatId;

  // Konstrukor czatu z podaniem id i avaterem rozmówcy i nickiem.
  Friends({Key key, @required this.id, @required this.groupChatId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(
          'Add a friend',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: mainColor,
        centerTitle: false,
      ),
      body: new FriendsScreen(id: id, groupChatId: groupChatId),
    );
  }
}

class FriendsScreen extends StatefulWidget {
  final String id;
  final String groupChatId;

  // Konstrukor czatu z podaniem id i avaterem rozmówcy i nickiem.
  FriendsScreen({Key key, @required this.id, @required this.groupChatId})
      : super(key: key);

  @override
  State createState() =>
      new FriendsScreenState(id: id, groupChatId: groupChatId);
}

class FriendsScreenState extends State<FriendsScreen> {
  final String id;
  final String groupChatId;

  // Konstrukor czatu z podaniem id i avaterem rozmówcy i nickiem.
  FriendsScreenState({Key key, @required this.id, @required this.groupChatId});

  bool isLoading = false;
  File avatarImageFile;
  String photoUrl;
  String nickname;
  String aboutMe;

  @override
  void initState() {
    super.initState();
    readLocal();
  }

  // Pobranie z lokalnej pamięci danych użytkownika zalogowanego.
  void readLocal() async {
    await Firestore.instance
        .collection("users")
        .document(id)
        .get()
        .then((value) {
      print("ID: " + id.toString());
      print("LOCAL: " + value.data.toString());
      photoUrl = value.data['photoUrl'];
      nickname = value.data['nickname'];
      aboutMe = value.data['aboutMe'];
    });
    // Force refresh input
    print("nickname: " + nickname.toString());
    setState(() {});
  }

  void addFriends() async {
    print("group id: " + groupChatId.toString());
    Firestore.instance
        .collection("messages")
        .document(groupChatId)
        .get()
        .then((value) {
      if (value.data['invite'] == false) {
        var documentReference =
            Firestore.instance.collection('messages').document(groupChatId);
        Firestore.instance.runTransaction((transaction) async {
          await transaction.set(
            documentReference,
            {'friends': false, 'invite': true, 'uid': id},
          );
        });
        Functions.toast("Invite sent!");
        Navigator.pop(context);
      } else if (value.data['invite'] == true) {
        if (value.data['uid'] != id) {
          var documentReference =
              Firestore.instance.collection('messages').document(groupChatId);
          Firestore.instance.runTransaction((transaction) async {
            await transaction.set(
              documentReference,
              {
                'friends': true,
                'invite': false,
              },
            );
          });
          Functions.toast("Friendship accepted!");
          Navigator.pop(context);
        } else {
          Functions.toast("You have already sent a request : (");
        }
      }
    });
  }

  // Budowanie UI.
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        SingleChildScrollView(
          child: Column(
            children: <Widget>[
              // Avatar
              Container(
                child: Center(
                  child: Stack(
                    children: <Widget>[
                      (avatarImageFile == null)
                          ? (photoUrl != ''
                              ? Material(
                                  child: CachedNetworkImage(
                                    placeholder: (context, url) => Container(
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.0,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                mainColor),
                                      ),
                                      width: 90.0,
                                      height: 90.0,
                                      padding: EdgeInsets.all(20.0),
                                    ),
                                    imageUrl: photoUrl != null
                                        ? photoUrl
                                        : 'images/img_not_available.jpeg',
                                    width: 90.0,
                                    height: 90.0,
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(45.0)),
                                  clipBehavior: Clip.hardEdge,
                                )
                              : Icon(
                                  Icons.account_circle,
                                  size: 90.0,
                                  color: secondaryColor,
                                ))
                          : Material(
                              child: Image.file(
                                avatarImageFile,
                                width: 90.0,
                                height: 90.0,
                                fit: BoxFit.cover,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(45.0)),
                              clipBehavior: Clip.hardEdge,
                            ),
                    ],
                  ),
                ),
                width: double.infinity,
                margin: EdgeInsets.all(20.0),
              ),

              // Input
              Column(
                children: <Widget>[
                  // Username
                  Container(
                    child: Text(
                      'Nickname',
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          color: mainColor),
                    ),
                    margin: EdgeInsets.only(left: 10.0, bottom: 5.0, top: 10.0),
                  ),
                  Container(
                    child: Text(
                      nickname != null ? nickname : 'Loading',
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          color: mainColor),
                    ),
                    margin: EdgeInsets.only(left: 30.0, right: 30.0),
                  ),

                  // About me
                  Container(
                    child: Text(
                      'About me',
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          color: mainColor),
                    ),
                    margin: EdgeInsets.only(left: 10.0, top: 30.0, bottom: 5.0),
                  ),
                  Container(
                    child: Text(
                      aboutMe != null ? aboutMe : 'Loading',
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          color: mainColor),
                    ),
                    margin: EdgeInsets.only(left: 30.0, right: 30.0),
                  ),
                ],
                crossAxisAlignment: CrossAxisAlignment.start,
              ),

              // Button
              Container(
                child: FlatButton(
                  onPressed: addFriends,
                  child: Text(
                    'Add Friend',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  color: mainColor,
                  highlightColor: secondaryColor,
                  splashColor: Colors.transparent,
                  textColor: Colors.white,
                  padding: EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 10.0),
                ),
                margin: EdgeInsets.only(top: 50.0, bottom: 50.0),
              ),
            ],
          ),
          padding: EdgeInsets.only(left: 15.0, right: 15.0),
        ),

        // Loading
        Positioned(
          child: isLoading
              ? Container(
                  child: Center(
                    child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(mainColor)),
                  ),
                  color: Colors.white.withOpacity(0.8),
                )
              : Container(),
        ),
      ],
    );
  }
}
