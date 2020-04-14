import 'package:flutter/material.dart';
import 'loging.dart';




class RegisterState extends State
{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
        backgroundColor: Colors.red,
      ),
      body: Center(
          child: Column(
              children: <Widget>
              [
                TextFormField(
                  decoration: InputDecoration
                    (
                    labelText: 'Your Login:',
                    icon: Icon(Icons.person),
                    hintText: 'What username will you use?',
                  ),

                  onSaved: (String value) {
                    // This optional block of code can be used to run
                    // code when the user saves the form.
                  },
                  validator: (String value) {
                    return value.contains('@') ? 'Do not use the @ character. It is not an email' : null;
                  },
                ),

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

                TextFormField(
                  decoration: InputDecoration
                    (
                    labelText: 'Your Password:',
                    icon: Icon(Icons.lock),
                    hintText: 'Please enter the passord for your account',
                  ),

                  onSaved: (String value) {
                    // This optional block of code can be used to run
                    // code when the user saves the form.
                  },
                  validator: (String value)
                  {
                  },
                ),

                TextFormField(
                  decoration: InputDecoration
                    (
                    labelText: 'Password once again:',
                    icon: Icon(Icons.lock),
                    hintText: 'We just want to be sure',
                  ),

                  onSaved: (String value) {
                    // This optional block of code can be used to run
                    // code when the user saves the form.
                  },
                  validator: (String value)
                  {
                  },
                ),

                RaisedButton(child: Text('Create account!'), onPressed: ()
                {
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


class  Register extends StatefulWidget
{
  @override
  RegisterState createState() => new RegisterState();
}