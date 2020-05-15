import 'package:flutter/material.dart';
//import 'package:fluttertoast/fluttertoast.dart';
import 'package:kelvindate/SplashPage.dart';
//import 'package:kelvindate/geolocation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Functions.dart';
//import 'loging.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'fire.dart';
import 'const.dart';

class RegisterState extends State {
  // Kontrolery do przechowywanis odniesień do danych formularza.
  TextEditingController loginInputController;
  TextEditingController emailInputController;
  TextEditingController pwdInputController;
  TextEditingController confirmPwdInputController;
  //final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();
  static Fire f = new Fire();

  SharedPreferences prefs;



  @override
  initState() {
    loginInputController = new TextEditingController();
    emailInputController = new TextEditingController();
    pwdInputController = new TextEditingController();
    confirmPwdInputController = new TextEditingController();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Register'),
          backgroundColor: mainColor,
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 10.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Your login',
                    icon: Icon(Icons.person),
                    hintText: 'What username do you want to use?',
                  ),
                  controller: loginInputController,
                  onChanged: (val) {
                    final trimVal = val.trim();
                    if (val != trimVal)
                      setState(() {
                        val = val.trim();
                        loginInputController.text = trimVal;
                        loginInputController.selection =
                            TextSelection.fromPosition(
                                TextPosition(offset: trimVal.length));
                      });
                  },
                  onSaved: (String value) {
                    // This optional block of code can be used to run
                    // code when the user saves the form.
                  },
                  validator: (String value) {
                    return value.contains('@')
                        ? 'Do not use the @ character. It is not an email'
                        : null;
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 10.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Your email',
                    icon: Icon(Icons.person),
                    hintText: 'Please enter your email address',
                  ),
                  controller: emailInputController,
                  onChanged: (val) {
                    final trimVal = val.trim();
                    if (val != trimVal)
                      setState(() {
                        val = val.trim();
                        emailInputController.text = trimVal;
                        emailInputController.selection =
                            TextSelection.fromPosition(
                                TextPosition(offset: trimVal.length));
                      });
                  },
                  onSaved: (String value) {
                    // This optional block of code can be used to run
                    // code when the user saves the form.
                  },
                  validator: (String value) {
                    return !value.contains('@')
                        ? 'please enter some @ character'
                        : null;
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 10.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Your password',
                    icon: Icon(Icons.lock),
                    hintText: 'At least 6 characters, please!',
                  ),
                  controller: pwdInputController,
                  onChanged: (val) {
                    final trimVal = val.trim();
                    if (val != trimVal)
                      setState(() {
                        val = val.trim();
                        pwdInputController.text = trimVal;
                        pwdInputController.selection =
                            TextSelection.fromPosition(
                                TextPosition(offset: trimVal.length));
                      });
                  },
                  onSaved: (String value) {
                    // This optional block of code can be used to run
                    // code when the user saves the form.
                  },
                  validator: (String value) {
                    return 'true';
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 10.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Password once again',
                    icon: Icon(Icons.lock),
                    hintText: 'We just want to be sure',
                  ),
                  controller: confirmPwdInputController,
                  onChanged: (val) {
                    final trimVal = val.trim();
                    if (val != trimVal)
                      setState(() {
                        val = val.trim();
                        confirmPwdInputController.text = trimVal;
                        confirmPwdInputController.selection =
                            TextSelection.fromPosition(
                                TextPosition(offset: trimVal.length));
                      });
                  },
                  onSaved: (String value) {
                    // This optional block of code can be used to run
                    // code when the user saves the form.
                  },
                  validator: (String value) {
                    return 'true';
                  },
                ),
              ),
              FlatButton(
                child: Text(
                  'Create account!',
                  style: TextStyle(fontSize: 16.0),
                ),
                color: mainColor,
                highlightColor: secondaryColor,
                splashColor: Colors.transparent,
                textColor: Colors.white,
                padding: EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 10.0),
                onPressed: () {
                  if (pwdInputController.text ==
                      confirmPwdInputController.text) {
                    FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                        email: emailInputController.text,
                        password: pwdInputController.text)
                        .then((currentUser) => f.createUserRecord(loginInputController.text, emailInputController.text, currentUser.user.uid.toString())
                        .then((result) => {

                      Fire.authentic ( prefs, emailInputController, pwdInputController, loginInputController ),

                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SplashPage()),
                              (_) => false),
                      loginInputController.clear(),
                      emailInputController.clear(),
                      pwdInputController.clear(),
                      confirmPwdInputController.clear()
                    })
                        .catchError((e) => Functions.toast( e.message)))
                        .catchError((err) => Functions.toast( err.message));
                  }
                  else
                  {
                    Functions.toast("The passwords do not match");
                  }
                },
              ),
            ],
          ),
        ));
  }
}



class Register extends StatefulWidget {
  @override
  RegisterState createState() => new RegisterState();
}