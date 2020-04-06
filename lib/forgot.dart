import 'geolocation.dart';
import 'package:flutter/material.dart';
import 'package:kelvindate/loging.dart';


class ForgotState extends State {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Password recovery'),
        backgroundColor: Colors.red,
      ),
      body: Center(
          child: Column(
              children: <Widget>
              [
                Text('You do not remember your own password? '),
                TextFormField(
                  decoration: InputDecoration
                    (
                    labelText: 'Your email:',
                    icon: Icon(Icons.person),
                    hintText: 'Please enter your email address',
                  ),

                  onSaved: (String value) {
                    // This optional block of code can be used to run
                    // code when the user saves the form.
                  },
                  validator: (String value) {
                    return !value.contains('@') ? 'please enter some @ character' : null;
                  },
                ),
                Text('We will send you an email with a new password soon. '),
                RaisedButton(child: Text('Yes, send a new one'), onPressed: () {
                  Navigator.push
                    (
                      context,
                      MaterialPageRoute(builder: (context) => GeolocationExample())
                  );

                },),
                RaisedButton(child: Text('I remember!'), onPressed: () {
                  Navigator.pop
                    (
                      context,
                      MaterialPageRoute(builder: (context) => Loging())
                  );

                },)
              ]
          )
      ),
    );
  }
}

  class  Forgot extends StatefulWidget
  {
  @override
  ForgotState createState() => new ForgotState();
  }




