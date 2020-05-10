import 'package:kelvindate/const.dart';

import 'geolocation.dart';
import 'package:flutter/material.dart';
import 'package:kelvindate/loging.dart';
import 'const.dart';

class ForgotState extends State {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Password recovery'),
        backgroundColor: mainColor,
      ),
      body: Center(
          child: Column(children: <Widget>[
        Container(
          padding: EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 10.0),
          child: Text('Enter your email address',
              style: TextStyle(
                  color: mainColor, fontWeight: FontWeight.bold, fontSize: 20)),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(30.0, 5.0, 30.0, 5.0),
          child: TextFormField(
            decoration: InputDecoration(
              labelText: 'Your email',
              icon: Icon(Icons.person),
              hintText: 'Please enter your email address',
            ),
            onChanged: (val) {
              final trimVal = val.trim();
              if (val != trimVal)
                setState(() {
                  val = val.trim();
                  // pwdInputController.text = trimVal;
                  // pwdInputController.selection = TextSelection.fromPosition(TextPosition(offset: trimVal.length));
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
          padding: EdgeInsets.fromLTRB(30.0, 5.0, 30.0, 5.0),
          child: Text(
              'We will send you an email with a link to reset your password.'),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(30.0, 5.0, 30.0, 5.0),
          child: FlatButton(
            child: Text('Reset password',
              style: TextStyle(fontSize: 16.0),
            ),
            color: mainColor,
            highlightColor: secondaryColor,
            splashColor: Colors.transparent,
            textColor: Colors.white,
            padding: EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 10.0),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => GeolocationExample()));
            },
          ),
        ),
      ])),
    );
  }
}

class Forgot extends StatefulWidget {
  @override
  ForgotState createState() => new ForgotState();
}
